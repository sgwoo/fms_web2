<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.user_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.tint.*, acar.doc_settle.*, acar.estimate_mng.*, card.*"%>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<jsp:useBean id="co_bean" class="acar.car_office.CarOffBean" scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getCar_gu().equals("")) base.setCar_gu(base.getReg_id());
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//fee_etc
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//이행보증보험
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	
	
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	if(pur.getDir_pur_yn().equals("Y") && emp2.getEmp_id().equals("")){
		emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	}
	
	
	
	//영업사원
	CarOffEmpBean coe_bean = cod.getCarOffEmpBean(emp2.getEmp_id());
		
	//출고영업소
	co_bean = cod.getCarOffBean(coe_bean.getCar_off_id());
	
	
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//사전계약관리
	CarOffPreBean cop_bean = cop_db.getCarOffPreRent(rent_l_cd);	
	
	int car_off_chk1 = 0;
	int car_off_chk2 = 0;
	
	//출고영업소 팩스번호, 사업자등록번호 입력 체크
	if(co_bean.getCar_off_fax().equals(""))						car_off_chk1 = 1;
	if(co_bean.getVen_code().equals("") && co_bean.getEnp_no().equals(""))		car_off_chk2 = 1;
	
	
	//용품	
	TintBean tint1 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "1");
	TintBean tint2 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "2");
	TintBean tint3 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "3");
	TintBean tint4 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "4");
	TintBean tint5 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "5");
	TintBean tint6 	= t_db.getCarTint(rent_mng_id, rent_l_cd, "6");
	
	
	//일정관리
	Hashtable est = a_db.getRentEst(rent_mng_id, rent_l_cd);
	
	//문서품의
	DocSettleBean doc = d_db.getDocSettle(doc_no);
	
	if(doc_no.equals("")){
		doc = d_db.getDocSettleCommi("4", rent_l_cd);
	}
	
	//영업담당자
	user_bean 	= umd.getUsersBean(base.getBus_id());
	
	//디폴트 임시운행보험료
		int b_ins_amt = 0;
		if(pur.getOne_self().equals("Y")){
			if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){
				//승용-일반-6인이하
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 100 && AddUtil.parseInt(ej_bean.getJg_a()) <= 402){
					b_ins_amt = 2000;
				}
				//승용-일반-6인이하-수입차
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 901 && AddUtil.parseInt(ej_bean.getJg_a()) <= 904){
					b_ins_amt = 2000;
				}
				//승용-다인승-10인이하
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 501 && AddUtil.parseInt(ej_bean.getJg_a()) <= 701){
					b_ins_amt = 2800;
				}
				//화물-소-1톤이하
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 801 && AddUtil.parseInt(ej_bean.getJg_a()) <= 803){
					b_ins_amt = 3100;
				}
				//화물-소-1톤~5톤이하
				if(AddUtil.parseInt(ej_bean.getJg_a()) >= 811 && AddUtil.parseInt(ej_bean.getJg_a()) <= 821){
					b_ins_amt = 2700;
				}
				//승합
				if(AddUtil.parseInt(ej_bean.getJg_a()) == 702){
					b_ins_amt = 3400;
				}
				//승합-스타리아11인승
				if(AddUtil.parseInt(ej_bean.getJg_a()) == 700){
					b_ins_amt = 3400;
				}
			}
		}	
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	//매출DC코드
	CodeBean[] codes = c_db.getCodeAll("0017");
	int c_size = codes.length;
	
	int scan_cnt = 0;
	
	String  file_path = "";
	String theURL = "https://fms3.amazoncar.co.kr/data/";	
	String file_ext=".pdf";	
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+""+rent_l_cd; 
			
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;       

	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
	
	// 임시운행보험료 2018.04.20
	Vector attach_vt_26 = new Vector();
	String content_seq_26 = content_seq;
	content_seq_26 += "126";
	attach_vt_26 = c_db.getAcarAttachFileListEqual(content_code, content_seq_26, 0);
	
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<style type=text/css>
<!-- 
.style1 {color: #666666}
.style2 {color: #515150; font-weight: bold;}
.style3 {color: #b3b3b3; font-size: 11px;}
.style4 {color: #737373; font-size: 11px;}
.style5 {color: #ef620c; font-weight: bold;}
.style6 {color: #4ca8c2; font-weight: bold;}
.style7 {color: #666666; font-size: 11px;}
-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	//리스트
	function list(){
		var fm = document.form1;			
		fm.action = 'pur_doc_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//탁송업체 조회
	function search_off()
	{
		var fm = document.form1;	
		window.open("/agent/cus0601/cus0602_frame.jsp?from_page=/agent/consignment/cons_i_c.jsp&t_wd="+fm.off_nm.value, "SERV_OFF", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//탁송업체 탁송료 조회
	function search_off_amt()
	{
		var fm = document.form1;
		if(fm.cons_st.value !== '2')		{ 	alert('탁송구분이 자체일때 조회하십시오.'); 	return; }
		if(fm.dlv_ext.value == '')		{ 	alert('출고지를 선택하십시오.'); 				return;	}
		if(fm.udt_st.value == '')		{	alert('인수지를 선택하십시오.'); 				return; }
		if(fm.off_id.value == '')		{	alert('탁송업체를 선택하십시오.'); 				return; }
		var o_url = "/agent/cons_cost/s_cons_cost.jsp?car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&off_id="+fm.off_id.value+"&off_nm="+fm.off_nm.value+"&dlv_ext="+fm.dlv_ext.value+"&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}	
	function search_base_consamt(){
		var fm = document.form1;
		if('<%=cm_bean.getDlv_ext()%>'== ''){ alert('기본출고지가 없습니다.'); return; }
		if(fm.udt_st.value == '')		{	alert('인수지를 선택하십시오.'); 				return; }
		if(fm.udt_st.value == '4')		{	alert('인수지가 고객인 경우 기본 탁송료가 조회되지 않습니다.');				return; }
		var o_url = "/agent/cons_cost/s_cons_cost_base.jsp?rent_l_cd=<%=rent_l_cd%>&car_comp_id=<%=cm_bean.getCar_comp_id()%>&car_cd=<%=cm_bean.getCode()%>&dlv_ext=<%=cm_bean.getDlv_ext()%>&udt_st="+fm.udt_st.value;
		window.open(o_url, "CONS_COST", "left=10, top=10, width=300, height=700, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//대차보증금승계조회
	function search_grt_suc()
	{
		var fm = document.form1;	
		window.open("s_grt_suc.jsp?from_page=/fms2/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");
	}		
			
	//납품지역 팝업
	function cng_rent_ext(){
		var fm = document.form1;		
		var width = 600;
		var firm_nm = '';				
		
		window.open("/agent/consignment/s_place.jsp?go_url=/agent/car_pur/pur_doc_i.jsp&st=&value=2&idx=0&s_kd=1&t_wd=<%=client.getFirm_nm()%>&req_id=<%=user_id%>", "PLACE", "left=10, top=10, width="+width+", height=400, scrollbars=yes, status=yes, resizable=yes");		
	}			
	
	//탁송료합계계산
	function set_cons_amt(){
		var fm = document.form1;
		fm.cons_amt3.value = parseDecimal(toInt(parseDigit(fm.cons_amt1.value)) + toInt(parseDigit(fm.cons_amt2.value))); 	
		
		if(fm.cons_st.value == '1' && toInt(parseDigit(fm.cons_amt1.value)) != toInt(parseDigit(fm.sd_c_amt.value))){
			fm.sd_c_amt.value 	= parseDecimal( toInt(parseDigit(fm.cons_amt1.value)) );		
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.sd_c_amt.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_c_amt.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));
			sum_car_f_amt();
			
			fm.off_nm.value = '';
			fm.off_id.value = '';
		}
		
		if(fm.cons_st.value == '2'){
			fm.sd_c_amt.value 	= '0';
			fm.sd_cs_amt.value 	= '0';
			fm.sd_cv_amt.value 	= '0';
			sum_car_f_amt();		
			
					
		}		
	}
	
	//차량대금잔액계산
	function set_con_amt(){
		var fm = document.form1;
		fm.jan_amt.value = parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.con_amt.value))); 	
		
		//친환경차 제조사 차량대금공제일 경우 구매보조금을 잔액 계산에 반영한다.->20170102 지급수단에서 처리한다.
		<%if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>
			<%if(car.getEcar_pur_sub_st().equals("1")){%>
				//fm.jan_amt.value = parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.ecar_pur_sub_amt.value)) - toInt(parseDigit(fm.con_amt.value))); 	
			<%}%>
		<%}%>		
	}

		
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;		
		
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
		
		fm.jan_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_f_amt.value)) - toInt(parseDigit(fm.con_amt.value)));
	}	
	
	//매출DC 합계
	function set_dc_amt(){
		var fm = document.form1;		
		
		fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_dc1_amt.value)) + toInt(parseDigit(fm.s_dc2_amt.value)) + toInt(parseDigit(fm.s_dc3_amt.value)) );		
		fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.dc_c_amt.value))));
		fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_c_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));
		
		sum_car_f_amt();
	}
	
	//소비자가대비 금액계산
	function setDc_per_amt(obj, idx){
		obj.value = obj.value;
		var fm = document.form1;
		
		if(idx == 1){
			if(obj==fm.s_dc1_per){
				fm.s_dc1_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc1_per.value) /100 ) );
			}else if(obj==fm.s_dc1_amt){
				fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 2){
			if(obj==fm.s_dc2_per){
				fm.s_dc2_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc2_per.value) /100) );
			}else if(obj==fm.s_dc2_amt){
				fm.s_dc2_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
		if(idx == 3){
			if(obj==fm.s_dc3_per){
				fm.s_dc3_amt.value 	= parseDecimal( Math.round(toInt(parseDigit(fm.car_f_amt.value)) * toFloat(fm.s_dc3_per.value) /100));
			}else if(obj==fm.s_dc3_amt){
				fm.s_dc3_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			}
		}
	}
	
	//매출DC
	function search_dc(){
		var fm = document.form1;
		window.open("/agent/lc_rent/search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value, "COMP_DC", "left=100, top=100, height=200, width=800, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//스캔등록
	function scan_reg(file_st){
		window.open("/agent/lc_rent/reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/car_pur/pur_doc_i.jsp&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=620, height=350, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//스캔관리 보기
	function view_scan(){
		window.open("/agent/lc_rent/scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	//날짜세팅
	function dt_set(){
		var fm = document.form1;
		fm.udt_est_dt.value = fm.dlv_est_dt.value;
		fm.reg_est_dt.value = fm.dlv_est_dt.value;
		fm.rent_est_dt.value = fm.dlv_est_dt.value;				
	}
	

	
	//내용 코드변환
  	function set_dc_re(idx){
		var fm = document.form1;
		if(idx == 1){
			if(fm.s_dc1_re.value == "1")				fm.s_dc1_re.value = '판매자정상조건';
    		else if(fm.s_dc1_re.value  == "2")      	fm.s_dc1_re.value = '장기재고';
    		else if(fm.s_dc1_re.value  == "3")      	fm.s_dc1_re.value = '전시차';
    		else if(fm.s_dc1_re.value  == "4")      	fm.s_dc1_re.value = '다량구매처우대';
    		else if(fm.s_dc1_re.value  == "5")      	fm.s_dc1_re.value = '캠페인';									    					
		}
		if(idx == 2){
			if(fm.s_dc2_re.value == "1")				fm.s_dc2_re.value = '판매자정상조건';
    		else if(fm.s_dc2_re.value  == "2")      	fm.s_dc2_re.value = '장기재고';
    		else if(fm.s_dc2_re.value  == "3")      	fm.s_dc2_re.value = '전시차';
    		else if(fm.s_dc2_re.value  == "4")      	fm.s_dc2_re.value = '다량구매처우대';
    		else if(fm.s_dc2_re.value  == "5")      	fm.s_dc2_re.value = '캠페인';									    					
		}
		if(idx == 3){
			if(fm.s_dc3_re.value == "1")				fm.s_dc3_re.value = '판매자정상조건';
    		else if(fm.s_dc3_re.value  == "2")      	fm.s_dc3_re.value = '장기재고';
    		else if(fm.s_dc3_re.value  == "3")      	fm.s_dc3_re.value = '전시차';
    		else if(fm.s_dc3_re.value  == "4")      	fm.s_dc3_re.value = '다량구매처우대';
    		else if(fm.s_dc3_re.value  == "5")      	fm.s_dc3_re.value = '캠페인';									    					
		}
  	}
		
		
	//등록
	function save(){
		var fm = document.form1;

		if(fm.dlv_est_dt.value  != ''  && fm.dlv_est_h.value  == '') 		fm.dlv_est_h.value 	= '00';		
		if(fm.reg_est_dt.value  != ''  && fm.reg_est_h.value  == '') 		fm.reg_est_h.value 	= '00';		
		if(fm.rent_est_dt.value != ''  && fm.rent_est_h.value == '') 		fm.rent_est_h.value = '00';
		
		if(<%=fee.getGrt_amt_s()+fee.getPp_s_amt()+fee.getIfee_s_amt()%>==0 && '<%=gins.getGi_st()%>'=='0' && '<%=cont_etc.getClient_guar_st()%>'=='2'){
			if(!confirm("채권확보가 모두 면제인 계약건입니다. 다시한번 채권확보 면제 여부를 확인해주세요"))	return;
		}
		
		
		
		<%if(base.getRent_st().equals("3")){%>
		if(toInt(parseDigit(fm.grt_suc_r_amt.value))>0 && fm.grt_suc_yn.value != '0'){
			fm.grt_suc_yn.value = '0';
		} 
		if(fm.grt_suc_yn.value == '')		{	alert('대차차량보증금 승계여부를 선택해주세요.'); 		fm.grt_suc_yn.focus(); 		return;		}
		if(fm.grt_suc_yn.value == '0' && fm.pp_st.value == '미결' && (fm.pp_est_dt.value == '' || fm.pp_etc.value == '')){
			alert('선수금 후불결제예정일 또는 후불처리사유를 입력하십시오.');  					fm.pp_etc.focus(); 		return;		}
		
		<%}else{%>		
		if(fm.pp_st.value == '미결' && (fm.pp_est_dt.value == '' || fm.pp_etc.value == '')){
			alert('선수금 후불결제예정일 또는 후불처리사유를 입력하십시오.');  					fm.pp_etc.focus(); 		return;		}
		<%}%>
					
		if(fm.gi_st.value == '미결' && (fm.gi_est_dt.value == '' || fm.gi_etc.value == '')){
			alert('보증보험 완결예정일 또는 미결사유를 입력하십시오.'); 						fm.gi_etc.focus(); 		return;		}
		
		if(fm.guar_end_st.value == '미결' && (fm.guar_est_dt.value == '' || fm.guar_etc.value == '')){
			alert('연대보증 완결예정일 또는 미결사유를 입력하십시오.'); 						fm.guar_etc.focus(); 		return;		}		
	
		if(fm.guar_end_st.value == '')	{	alert('연대보증 처리구분을 선택하여 주십시오.'); 			fm.guar_end_st.focus(); 	return;		}
		
		
		
		if(fm.dlv_ext.value == '')		{	alert('출고지를 입력하여 주십시오.'); 				fm.dlv_ext.focus(); 		return;		}
		if(fm.dlv_est_dt.value == '')		{	alert('출고예정일자를 입력하여 주십시오.'); 			fm.dlv_est_dt.focus(); 		return;		}
		if(fm.udt_st.value == '')		{	alert('인수지를 입력하여 주십시오.'); 				fm.udt_st.focus(); 		return;		}
		if(fm.udt_est_dt.value == '')		{	alert('인수예정일자를 입력하여 주십시오.'); 			fm.udt_est_dt.focus(); 		return;		}
		
		if(fm.cons_st.value == '')		{	alert('탁송구분을 입력하여 주십시오.'); 			fm.cons_st.focus(); 		return;		}
		
		//자체탁송
		if(fm.cons_st.value == '2'){
			if(toInt(parseDigit(fm.cons_amt1.value))==0){ alert('탁송료1을 입력하십시오.'); return;}
		//배달탁송	
		}else{
			//수입차아니면
			if('<%=ej_bean.getJg_w()%>'!='1'){
				if(toInt(parseDigit(fm.cons_amt1.value))==0){ alert('탁송료1을 입력하십시오.'); return;}
			}
		}
		
		if(fm.reg_est_dt.value == '')		{	alert('등록예정일을 입력하여 주십시오.'); 			fm.reg_est_dt.focus(); 		return;		}
		if(fm.rent_est_dt.value == '')		{	alert('납품예정일을 입력하여 주십시오.'); 			fm.rent_est_dt.focus(); 	return;		}
		if(fm.rent_ext.value == '')		{	alert('납품지역을 입력하여 주십시오.'); 			fm.rent_ext.focus(); 		return;		}
		if(fm.rpt_no.value == '')		{	alert('계출번호를 입력하여 주십시오.'); 			fm.rpt_no.focus(); 		return;		}
				
		if(	toInt(parseDigit(fm.s_dc1_amt.value))>0 && fm.s_dc1_re.value == ''){ alert('매출D/C 내용1을 입력하십시오.'); return; }
		if(	toInt(parseDigit(fm.s_dc2_amt.value))>0 && fm.s_dc2_re.value == ''){ alert('매출D/C 내용2을 입력하십시오.'); return; }
		if(	toInt(parseDigit(fm.s_dc3_amt.value))>0 && fm.s_dc3_re.value == ''){ alert('매출D/C 내용3을 입력하십시오.'); return; }		
		
		
		
		if(	toInt(parseDigit(fm.car_f_amt.value))==0){ alert('차가구입가격이 0원 입니다. 차가구입가격이 정상적으로 입력되지 않았습니다. 구입가격에 있는 수정버튼 클릭하여 수정하십시오.'); return; }				
		
		if(fm.jan_amt.value == '0')		{	alert('차량대금 잔액을 확인하여 주십시오.'); 			fm.jan_amt.focus(); 		return;		}
		if(fm.con_est_dt.value == '')		{	alert('지급처리요청일을 입력하여 주십시오.');			fm.con_est_dt.focus(); 		return;		}
		
		

		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		var com_tint = "";

		if(fm.com_tint[0].checked==true){		//제조사용품-없음
			com_tint = "없음";
			if(fm.com_film_st[1].checked==true || fm.com_film_st[2].checked==true){
				alert('필름-기본을 없음으로 하고, 필름-선택에서 해당하는 썬팅필름을 선택하십시오.'); return;
			}			
		}else if(fm.com_tint[1].checked==true){//제조사용품-썬팅
			com_tint = "썬팅";		
			if(fm.com_film_st[0].checked==true){
				alert('필름-기본의 루마 또은 모비스를 선택하십시오.'); return;
			}	
			
			<%if(tint1.getTint_no().equals("")){%>
				if(!confirm('제조사용품이 썬팅입니다. 계약관리-용품에 썬팅이 등록된 것이 없으니 입력하셔야 합니다.'))	return;
			<%}%>
					
		}else if(fm.com_tint[2].checked==true){//제조사용품-브랜드키드
			com_tint = "브랜드키드";		
			fm.com_film_st[0].checked=true;			
		}
		
		if(!confirm('제조사용품이 '+com_tint+' 맞습니까?'))			 return;
				
		<%}%>		
		
		if(fm.com_con_no.value == ''){
			if(fm.trf_st0.value == '' || fm.trf_st0.value == '1'){
				<%if(coe_bean.getCar_comp_id().equals("0004") || (!coe_bean.getCar_comp_id().equals("0004") && !coe_bean.getOne_self_yn().equals("Y"))){//GM||영업사원출고%>		
				if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){	alert('대금지출요청내역-계좌정보를 입력하십시오.'); 		fm.con_acc_no.focus(); 		return;		}
				<%}%>
			}	
		}
		
		//지급처리요청일로 부터 2일을 초과하여 납품예정이 잡혔을때 메시지와 표시
		if(getRentTime('d', fm.con_est_dt.value, fm.rent_est_dt.value) > 1){ 
			if(!confirm('납품예정일이 지급처리요청일로 부터 2일을 초과한 날입니다. \n\n팀장님의 구두결재를 받으십시오.'))			
				return;
		}
		
		<%if((cm_bean.getCar_comp_id().equals("0001")||cm_bean.getCar_comp_id().equals("0002")) && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null")){%>
		if(fm.rpt_no.value != '<%=pur_com.get("COM_CON_NO")%>'){	alert('특판계약번호와 입력한 계출번호가 틀립니다. 확인하십시오.'); 		fm.rpt_no.focus(); 		return;		}
		<%}%>		
		
		
		//20151116 신차인 경우 수동변속기 확인
		if(<%=base.getCar_gu()%> == '1'){
			if(fm.auto.value == 'M/T'){
				if(!confirm('수동변속기 차량입니다. 등록하시겠습니까?')){			
					return;
				}
			}
		}	
		
		//2018.04.20
		//임시운행보험료 영수증 체크
		<%if(coe_bean.getCar_off_id().equals("00631") || coe_bean.getCar_off_id().equals("00588")){ //20210525 현대 사직,총신대는 스캔없이 금액입력 필수%>
			if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0'){
				alert('임시운행보험료 금액 입력은 필수입니다.'); 
				return;
			}
		<%}else{%>
			var trf_amt_remove_comma = parseInt((fm.trf_amt5.value).replace(/,/g,""));
			if(trf_amt_remove_comma != undefined){
				if(trf_amt_remove_comma > 1){
					//if(<%=attach_vt_26.size()%><1){alert('임시운행보험료 영수증 스캔파일이 없습니다. \n스캔파일을 등록해주십시오.'); return; }
				}
			}
		<%}%>
		
		var dlv_chk = 0;
		//출고차량탁송구분별 점검
		//현대차-아산-상원물류-인수지(영남/광주/부산/대구/대전)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='아산' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='3'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//현대차-울산-상원물류-인수지(영남/대전)
		if(fm.car_comp_id.value=='0001' && fm.dlv_ext.value=='울산' && fm.off_id.value=='011372' && (fm.udt_st.value=='1'||fm.udt_st.value=='3')){
			dlv_chk = 1;
		}
		//기아차-화성-삼진특수-인수지(영남/광주/부산/대구)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='화성' && fm.off_id.value=='007751' && (fm.udt_st.value=='1'||fm.udt_st.value=='2'||fm.udt_st.value=='5'||fm.udt_st.value=='6')){
			dlv_chk = 1;
		}
		//기아차-광주-삼진특수-인수지(부산/대구)
		if(fm.car_comp_id.value=='0002' && fm.dlv_ext.value=='광주' && fm.off_id.value=='007751' && (fm.udt_st.value=='2'||fm.udt_st.value=='5')){
			dlv_chk = 1;
		}
		//신화로직스는 일단 가능하게  - 20210812
		if ( fm.off_id.value=='010265') {
			dlv_chk = 1;
		}
		//삼성차 제외
		if (fm.car_comp_id.value=='0003') {
			dlv_chk = 1;
		}
		
		if(fm.cons_st.value == '2' && dlv_chk==0){
			alert('자체탁송 불가능한 <출고지-인수지-탁송사>입니다. 확인하십시오.'); return;
		}
		
		if(confirm('등록 하시겠습니까?')){	
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='pur_doc_i_a.jsp';		
			fm.target='d_content';			
			fm.submit();
			
			link.getAttribute('href',originFunc);
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
	
	
	
	//제조사용품
	function cng_com_tint(idx){
		var fm = document.form1;
		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		if(idx==0){								//없음
			fm.com_film_st	[0].checked	=true;
		}else if(idx==1){							//썬팅
			fm.com_film_st	[1].checked	=true;
		}else if(idx==2){							//브랜드키드
			fm.com_film_st	[0].checked	=true;
		}				
		
		<%}%>
	}				
	
	//필름-기본
	function cng_com_film_st(idx){
		var fm = document.form1;
		<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
		
		if(idx==0){									//없음
			if(fm.com_tint[1].checked==true){
				alert('제조사용품이 썬팅으로 되어 있습니다. 루마/모비스/SKC 중 택일 하십시오.');
				fm.com_film_st	[1].checked	=true;
			}
		}else if(idx==1 || idx==2 || idx==3 || idx==4){							//루마||모비스||SKC||3M	
			if(fm.com_tint[1].checked==true){
			}else{
				alert('제조사용품이 썬팅으로 되어 있지 않습니다.');		
				fm.com_tint[1].checked=true;		
			}
		}
		
		<%}%>
	}	
	
	
	//특판배정관리
	function view_car_pur_com(com_con_no){
		var fm = document.form1;
		window.open("/fms2/pur_com/lc_rent_c.jsp?mode=view&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&com_con_no="+com_con_no, "PUR_COM", "left=0, top=0, width=900, height=600, resizable=yes, scrollbars=yes, status=yes");		
	}
	
	function tint_update(st){
		if(st == '1')	window.open("/agent/lc_rent/lc_c_u_tint1.jsp<%=valus%>&from_page2=pur_doc_i.jsp", "CHANGE_TINT", "left=100, top=100, width=950, height=650");
		else		window.open("/agent/lc_rent/lc_c_u_tint2.jsp<%=valus%>&st="+st+"&from_page2=pur_doc_i.jsp", "CHANGE_TINT", "left=100, top=100, width=950, height=650");	
	}
	
	function openHc(){
  		window.open('/acar/common/hyundai_confidentiality.jsp','_blank', 'width=800, height=600, menubars=no, scrollbars=auto');
 	}
	
	//수정
	function update_car_amt(){
		var st = 'car_amt';
		var height = 500;
		window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=50, top=50, width=1150, height="+height+", resizable=yes, scrollbars=yes, status=yes");
	}
	
//-->
</script>
</head>

<body leftmargin="15">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'> 
  <input type='hidden' name='gubun4' 		value='<%=gubun4%>'>
  <input type='hidden' name='st_dt' 		value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 		value='<%=end_dt%>'>   
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="car_nm" 		value="<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>">  
  <input type='hidden' name="doc_no" 		value="<%=doc_no%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="firm_nm" 		value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="gur_size" 		value="<%=gur_size%>">  
  <input type='hidden' name="file_st" 		value="">  
  <input type='hidden' name="car_comp_id"	value="<%=emp2.getCar_comp_id()%>">    
  <input type='hidden' name='auto_yn' value='<%=cm_bean.getAuto_yn()%>'>
  <input type='hidden' name='car_b' value='<%=cm_bean.getCar_b()%>'>
  <input type='hidden' name='opt' value='<%=car.getOpt()%>'>
     
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
        <td>
        	<table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > <span class=style5>차량대금지급요청</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:list()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif border=0 align=absmiddle></a></td></td>
	<tr> 	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=15%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>상호</td>
                    <td colspan="3">&nbsp;<%=client.getFirm_nm()%></td>
                    <td class=title width=10%>사업자번호</td>
                    <td width=15%>&nbsp;<%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%></td>
    		    </tr>	
                <tr> 
                    <td class=title width=10%>용도구분</td>
                    <td width=15%>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("3")){%>리스<%}%></td>
                    <td class=title width=10%>관리구분</td>
                    <td width=15%>&nbsp;<%String rent_way = fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></td>
                    <td class=title width=10%>이용기간</td>
                    <td width=15%>&nbsp;<%=fee.getCon_mon()%>개월</td>
                    <td class=title width=10%>월대여료</td>
                    <td width=15%>&nbsp;<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원</td>
    		    </tr>
    		    <%if(1!=1){%>
                <tr>
                    <td class=title>차명</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td class=title width=10%>영업담당자</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getBus_id2(),"USER")%></td>
                </tr>	
    		    <%//if(!car.getOpt().equals("")){%>
                <tr>
                    <td class=title>옵션</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                    <td class=title width=10%>관리담당자</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getMng_id(),"USER")%></td>
                </tr>	
    		  <%//}%>
    		  <%}%>
                <tr> 
                    <td class=title width=10%>최초영업자</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(base.getBus_id(),"USER")%></td>
                    <td class=title width=10%>계약진행담당자</td>
                    <td colspan='5'>&nbsp;<%if(!base.getAgent_emp_id().equals("")){ CarOffEmpBean a_coe_bean = cod.getCarOffEmpBean(base.getAgent_emp_id()); %><%=a_coe_bean.getEmp_nm()%>&nbsp;<%=a_coe_bean.getEmp_m_tel()%>&nbsp;(에이전트계약)<%}%></td>
    		    </tr>    		    		  
                <tr> 
                    <td class=title width=10%>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan='7'>&nbsp;<%=fee.getFee_cdt()%></td>
    		    </tr>    	    		      
                <tr> 
                    <td class=title width=10%>계약서 특약사항 기재 내용</td>
                    <td colspan='7'>&nbsp;<%=fee_etc.getCon_etc()%></td>
    		    </tr>    	    		      
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
                    <%
			content_seq  = rent_mng_id+""+rent_l_cd+"115";
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                		
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
                    %>    		
	<input type='hidden' name="file_name" value="<%=ht.get("FILE_NAME")%>">
                    <%		}%>
                    <%	}%>      
	
<%if(coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null")){%>
	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>특판배정관리</span></td>
	</tr>  		
        <tr>
        <td class=line2></td>
        </tr>      
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td width=10% class=title>특판계약번호</td>
                    <td >&nbsp;<a href="javascript:view_car_pur_com('<%=pur_com.get("COM_CON_NO")%>');"><%=pur_com.get("COM_CON_NO")%></a><input type='hidden' name="com_con_no" value="<%=pur_com.get("COM_CON_NO")%>"></td>
                </tr>
                <tr> 
                    <td width=10% class=title>차명</td>
                    <td >&nbsp;<%=pur_com.get("R_CAR_NM")%>
                        <%
                        	String pur_com_car_nm = AddUtil.replace(String.valueOf(pur_com.get("R_CAR_NM")),"&nbsp;"," ");
                        pur_com_car_nm = AddUtil.replace(pur_com_car_nm,"&#160;"," ");         
                    		String pur_cont_car_nm = cm_bean.getCar_nm()+" "+cm_bean.getCar_name();
                        	if(!pur_com_car_nm.equals(pur_cont_car_nm)){ %>
                        <font color=red>(특판배정에 있는 차명과 계약관리 차명이 다릅니다. 확인하십시오.)</font>
                        <%} %>                        
                    </td>
                </tr>
                <tr> 
                    <td width=10% class=title>선택사양</td>
                    <td >&nbsp;<%=pur_com.get("R_OPT")%>
                        <%if(!String.valueOf(pur_com.get("R_OPT")).equals(car.getOpt())){ %>
                        <font color=red>(특판배정에 있는 선택사양과 계약관리 선택사양이 다릅니다. 확인하십시오.)</font>
                        <%} %>
                    </td>
                </tr>
                <tr> 
                    <td width=10% class=title>색상</td>
                    <td >&nbsp;<%=pur_com.get("R_COLO")%>
                    	<%if(!String.valueOf(pur_com.get("R_COLO")).equals(car.getColo()+"/"+car.getIn_col()+"/"+car.getGarnish_col())){ %>
                        <font color=red>(특판배정에 있는 색상과 계약관리 색상이 다릅니다. 확인하십시오.)</font>
                        <%} %>
                    </td>
                </tr>  
                <tr> 
                    <td width=10% class=title>차가-소비자가</td>
                    <td >&nbsp;<%=AddUtil.parseDecimal(String.valueOf(pur_com.get("R_CAR_C_AMT")))%>원
                    	<%
                    		int pur_com_amt  = AddUtil.parseInt(String.valueOf(pur_com.get("R_CAR_C_AMT")));
                    		int pur_cont_amt = car.getCar_cs_amt()+car.getCar_cv_amt()+car.getOpt_cs_amt()+car.getOpt_cv_amt()+car.getClr_cs_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
                    	 	if(pur_com_amt>pur_cont_amt || pur_com_amt<pur_cont_amt ){ %>
                        <font color=red>(특판배정에 있는 소비자가과 계약관리 소비자가이 다릅니다. 확인하십시오.)</font>
                        <%	} %>
                    </td>
                </tr>    
                <tr> 
                    <td width=10% class=title>출고지/배달지</td>
                    <td >&nbsp;출고지 : <%=pur_com.get("DLV_EXT")%>&nbsp;&nbsp;&nbsp;
                    	배달지 : <%=pur_com.get("UDT_ST_NM")%>
                    	<!-- <font color=red>(특판배정에 있는 출고지와 배달지(=인수지)에 유의해주세요.)</font> -->
                    	<%if(!String.valueOf(pur_com.get("UDT_ST")).equals(pur.getUdt_st())){%>
                    	<br>&nbsp;
                    	<span style="font-size: 15px; font-weight:bold;"><font color=red>(특판배정에 있는 배달지와 계약 인수지가 다릅니다. 문서기안시 계약 인수지로 특판에 자동변경됩니다.)</font></span>
                    	<%} %>                       	                       
                    </td>
                </tr>              
            </table>
        </td>
    </tr> 
<%}else{%>    	

	<tr>
	    <td align="right">&nbsp;</td>
	</tr> 
	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>매매주문서   &nbsp;<a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a></span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>      
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=10%>매매주문서</td>
                    <td>&nbsp;
                    <%
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
                    <%	}else{%>      
        	    <span class="b"><a href="javascript:scan_reg('15')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
        	    <%}%>
        			</td>
                </tr>	
    		</table>
	    </td>
	</tr>
	<%if(car_off_chk1+car_off_chk2 > 0){%>
    	<tr>
        	<td>&nbsp;</td>
    	</tr>	
    	<tr>
        	<td><font color=red>* 출고영업소 <%=emp2.getCar_off_nm()%>의 
        	<%if(car_off_chk1 == 1){%>팩스번호<%}%>
        	<%if(car_off_chk1+car_off_chk2 == 2){%>|<%}%>
        	<%if(car_off_chk2 == 1){%>사업자등록번호<%}%>
        	가 없습니다. 영업지원-영업소관리에서 수정하십시오.        	
        	</font></td>
    	</tr>	
    	<tr>
        	<td class=h></td>
    	</tr>	
    	<%}%>
    	<input type='hidden' name="com_con_no" value="">
<%}%>

	<%	
		//attach_vt_size = 1;
		
		if(attach_vt_size >0 || (coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null"))){%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량현황</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
                <tr>
                    <td class=title>차명</td>
                    <td colspan="4">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%></td>
                    <td colspan="2" class=title>변속기</td>
                    <td colspan="4">&nbsp;<input type='text' name='auto' size='4' value='<%if(cm_bean.getAuto_yn().equals("Y")){%>A/T<%}else{%>M/T<%}%>' class='whitetext' ></td>
                </tr>	
                <tr>
                    <td class=title>옵션</td>
                    <td colspan="10">&nbsp;<%=car.getOpt()%></td>
                    
                </tr>	                		
                <tr> 
                    <td class=title width=10%>제작사명</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%>
                      <%if(pur.getDir_pur_yn().equals("Y")){%>&nbsp;<b>[특판출고]</b><%}%>
                    </td>
                    <td width=3% rowspan="2" class=title>영<br>업<br>소</td>
                    <td class=title width=7%>상호</td>
                    <td width=15%>&nbsp;<%=emp2.getCar_off_nm()%>
                    	<input type='hidden' name="dlv_brch" value="<%=emp2.getCar_off_nm()%>">
                    	<%if(cm_bean.getCar_comp_id().equals("0003")){
                    		String dlv_mon = AddUtil.getDate(1)+""+AddUtil.getDate(2);
                    	%>
                    	  (당월출고<%=d_db.getCarPurDlvBrchMonCnt(cm_bean.getCar_comp_id(), emp2.getCar_off_nm(), dlv_mon)%>대)
                    	<%}%>
                    </td>
                    <td width=3% rowspan="2" class=title>출<br>고</td>
                    <td width=7% class=title>출고지</td>
                    <td width=15%>
        			<%	//출고지코드
        				if(emp2.getCar_comp_id().equals("0001")){
        					CodeBean[] p_codes = c_db.getCodeAll("0018");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0002")){
        					CodeBean[] p_codes = c_db.getCodeAll("0019");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0004")||emp2.getCar_comp_id().equals("0005")){
        					CodeBean[] p_codes = c_db.getCodeAll("0020");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			<%	}else if(emp2.getCar_comp_id().equals("0003")){
        					CodeBean[] p_codes = c_db.getCodeAll("0021");
        					int p_size = p_codes.length;%>			
        			  &nbsp;<select name='dlv_ext' class='default'>
                        <option value="">선택</option>
        				<%	for(int i = 0 ; i < p_size ; i++){
        						CodeBean code = p_codes[i];	%>
        				<option value='<%=code.getNm()%>'><%= code.getNm()%></option>
        				<%	}%>
                      </select>
        			  <%}else{%>
        			  &nbsp;<input type='text' name='dlv_ext' size='15' value='' class='default' >
        			  <%}%>
        			</td>
                    <td width=3% rowspan="5" class=title>탁<br>송</td>
                    <td width=7% class=title>구분</td>
                    <td width=15%>
        			  &nbsp;<select name="cons_st" class='default' onchange="javascript:set_cons_amt();">
                        <option value="">==선택==</option>
        				<option value="1" >배달</option>
        				<option value="2" >자체</option>							
        			  </select>
        			</td>
    		    </tr>
                <tr>
                    <td class=title width=10%>과세구분</td>
                    <td width=15%>
                        <%String purc_gu = car.getPurc_gu();%>
                        <%if(purc_gu.equals("1")){%>
                        &nbsp;과세
                        <%}else if(purc_gu.equals("0")){%>
                        &nbsp;면세
                        <%}%></td>
                    <td class=title>연락처</td>
                    <td>&nbsp;<%=coe_bean.getCar_off_tel()%></td>
                    <td class=title>예정일시</td>
                    <td>&nbsp;<input type='text' size='12' name='dlv_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("DLV_EST_DT")))%>' <%if(pur.getDlv_est_dt().equals("")&&(!base.getDlv_dt().equals(""))){%>readonly<%}%> onBlur='javscript:this.value = ChangeDate(this.value);'>
        			  <input type='text' size='2' name='dlv_est_h' class='default' value='<%=String.valueOf(est.get("DLV_EST_H"))%>' <%if(pur.getDlv_est_dt().equals("")&&(!base.getDlv_dt().equals(""))){%>readonly<%}%>>시
        			  <!--<span class="b"><a href="javascript:dt_set()" onMouseOver="window.status=''; return true" title="클릭하세요">세팅</a></span>-->        			  
        			</td>
                    <td class=title>업체명</td>
                    <td>&nbsp;<input type='text' name="off_nm" value='' size='10' class='default'>
        			  <input type='hidden' name='off_id' value=''>
    			    <span class="b"><a href="javascript:search_off()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span></td>
                </tr>
                <tr>
                    <td class=title width=10%>색상</td>
                    <td width=15%>&nbsp;<%=car.getColo()%></td>
                    <td rowspan="2" class=title>영<br>업<br>사<br>원</td>
                    <td class=title>성명</td>
                    <td>&nbsp;<%=coe_bean.getEmp_nm()%>
					<%if(pur.getOne_self().equals("Y")){%>&nbsp;<b>[자체출고]</b><%}else{%>[영업사원출고]<%}%>
										
					</td>
                    <td rowspan="2" class=title>인<br>수</td>
                    <td class=title>인수지</td>
                    <td>
        			  &nbsp;<select name="udt_st" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getUdt_st().equals("1")){%> selected<%}%>>서울본사</option>
        				<option value="2" <%if(pur.getUdt_st().equals("2")){%> selected<%}%>>부산지점</option>
        				<option value="3" <%if(pur.getUdt_st().equals("3")){%> selected<%}%>>대전지점</option>				
        				<option value="5" <%if(pur.getUdt_st().equals("5")){%> selected<%}%>>대구지점</option>
        				<option value="6" <%if(pur.getUdt_st().equals("6")){%> selected<%}%>>광주지점</option>				
        				<option value="4" <%if(pur.getUdt_st().equals("4")){%> selected<%}%>>고객</option>
        			  </select>
        			</td>
                    <td class=title>탁송료1</td>
                    <td>&nbsp;<input type='text' name='cons_amt1' maxlength='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원
                    <span class="b"><a href="javascript:search_off_amt()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  </td>
                </tr>
                <tr>
                    <td class=title>배기량</td>
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                    <td class=title>연락처</td>
                    <td>&nbsp;<%=coe_bean.getEmp_m_tel()%></td>
                    <td class=title>예정일자</td>
                    <td>&nbsp;<input type='text' size='12' name='udt_est_dt' maxlength='12' class='default' value='' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title>탁송료2</td>
                    <td>&nbsp;<input type='text' name='cons_amt2' maxlength='10' value='0' class='whitenum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_cons_amt();'>원</td>
                </tr>
                <tr>
                    <td class=title>계출번호</td>
                    <td>
                      &nbsp;<input type='text' name='rpt_no' maxlength='15' value='<%=pur.getRpt_no()%>' class='default' size='15'></td>
                    <td rowspan="2" class=title>등<br>록</td>
                    <td class=title>등록지</td>
                    <td>
        			  &nbsp;<%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
        			  <input type="hidden" name="car_ext" value="<%=car.getCar_ext()%>">
        			</td>
                    <td rowspan="2" class=title>납<br>품</td>
                    <td class=title>납품지</td>
                    <td>&nbsp;<input type='text' name='rent_ext' size='12' value='' class='default' >
        			  <span class="b"><a href="javascript:cng_rent_ext()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			</td>
                    <td class=title>소계</td>
                    <td>&nbsp;<input type='text' name='cons_amt3' maxlength='10' value='0' class='whitenum' size='10'>원</td>
                </tr>	
    		    <tr>
        		    <td class=title>차대번호</td>
        			<td>
                      &nbsp;<input type='text' name='car_num' maxlength='20' value='<%=pur.getCar_num()%>' class='default' size='20'></td>
        		    <td class=title>예정일시</td>
        		    <td>
        		      &nbsp;<input type='text' size='12' name='reg_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("REG_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='reg_est_h' class='default' value='<%=String.valueOf(est.get("REG_EST_H"))%>'>
                    시 </td>
        		    <td class=title>예정일시</td>
        			<td>
        			  &nbsp;<input type='text' size='12' name='rent_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(String.valueOf(est.get("RENT_EST_DT")))%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                      <input type='text' size='2' name='rent_est_h' class='default' value='<%=String.valueOf(est.get("RENT_EST_H"))%>'>
                    시 </td>
                    <td colspan="2" class=title>기본탁송료</td>
                    <td>&nbsp;
                    
                      <span class="b"><a href="javascript:search_base_consamt()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                    </td>
    		    </tr>		  
    		</table>
	    </td>
	</tr> 
    <tr></tr><tr></tr><tr></tr>  	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>	
                <tr>
                    <td width="10%" rowspan="2" class='title'>구분 </td>
                    <td colspan="3" class='title'>소비자가격</td>
                    <td width="10%" rowspan="2" class='title'>구분</td>
                    <td colspan="3" class='title'>구입가격&nbsp;&nbsp;<a href="javascript:update_car_amt()"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a></td>
                </tr>
                <tr>
                    <td width="13%" class='title'>공급가</td>
                    <td width="13%" class='title'>부가세</td>
                    <td width="13%" class='title'>합계</td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="13%" class='title'>합계</td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td class=title>차량가격</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                </tr>
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td class=title>탁송료</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center" height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
             			원</td>
                    <td class=title>매출D/C<span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="클릭하세요"></a></span></td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>'  maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				원</td>
                    <td align="center">&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>'  maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
        				원</td>        				
                </tr>
              <tr id=tr_ecar_dc <%if(car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>개소세 감면액</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
         			원</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
         			원</td>
                <td align="center">&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)' readonly>
         			원</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                           
                <tr>
                    <td class='title'>합계</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' readonly>
        			    원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                    <td class='title'>합계</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' readonly>
        				원</td>
                    <td class='title'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  readonly>
        				원</td>
                </tr>
    		</table>
	    </td>
	</tr> 	
    <tr></tr><tr></tr><tr></tr> 	
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td class='title' width='10%'> 연번 </td>
					<td class='title' width='17%'>매출D/C 구분</td>
					<td class='title' width='34%'>내용</td>					
					<td class='title' width='13%'>소비자가대비</td>										
					<td width="13%" class='title'>대여료반영여부</td>
				    <td width="13%" class='title'>금액</td>
			    </tr>
				<tr>
					<td align='center'>1</td>
					<td>&nbsp;
					  <select name='s_dc1_re' class='default'>
                        <option value="">선택</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc1_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc1_re_etc' size='35' class="text" value='<%=car.getS_dc1_re_etc()%>'>
					<td align="center">  
					  <input type='text' name='s_dc1_per' size='4' class="text" value='<%=car.getS_dc1_per()%>' onBlur='javascript:setDc_per_amt(this, 1);'>%
					</td>
					<td align="center"><select name='s_dc1_yn' class='default'>
                              <option value="">선택</option>
                              <option value="Y" <%if(car.getS_dc1_yn().equals("Y")) out.println("selected");%>>반영</option>
                              <option value="N" <%if(car.getS_dc1_yn().equals("N")) out.println("selected");%>>미반영</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc1_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc1_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 1); set_dc_amt();'>
     					 원</td>
			    </tr>
				<tr>
					<td align='center'>2</td>
					<td>&nbsp;
					  <select name='s_dc2_re' class='default'>
                        <option value="">선택</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc2_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc2_re_etc' size='35' class="text" value='<%=car.getS_dc2_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc2_per' size='4' class="text" value='<%=car.getS_dc2_per()%>' onBlur='javascript:setDc_per_amt(this, 2);'>%
					</td>
					<td align="center"><select name='s_dc2_yn' class='default'>
                              <option value="">선택</option>
                              <option value="Y" <%if(car.getS_dc2_yn().equals("Y")) out.println("selected");%>>반영</option>
                              <option value="N" <%if(car.getS_dc2_yn().equals("N")) out.println("selected");%>>미반영</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc2_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc2_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 2); set_dc_amt();'>
     					 원</td>
			    </tr>
				<tr>
					<td align='center'>3</td>
					<td>&nbsp;
					  <select name='s_dc3_re' class='default'>
                        <option value="">선택</option>
					<%	for(int i = 0 ; i < c_size ; i++){
							CodeBean code = codes[i];	%>
						<option value='<%=code.getNm()%>' <%if(car.getS_dc3_re().equals(code.getNm())){ out.println("selected"); }%>><%= code.getNm()%></option>
					<%}%>
                      </select>
					</td>  
					<td align="center">  
					  <input type='text' name='s_dc3_re_etc' size='35' class="text" value='<%=car.getS_dc3_re_etc()%>'>
					</td>
					<td align="center">  
					  <input type='text' name='s_dc3_per' size='4' class="text" value='<%=car.getS_dc3_per()%>' onBlur='javascript:setDc_per_amt(this, 3);'>%
					</td>
					<td align="center"><select name='s_dc3_yn' class='default'>
                              <option value="">선택</option>
                              <option value="Y" <%if(car.getS_dc3_yn().equals("Y")) out.println("selected");%>>반영</option>
                              <option value="N" <%if(car.getS_dc3_yn().equals("N")) out.println("selected");%>>미반영</option>
                            </select></td>					
				    <td align="center"><input type='text' name='s_dc3_amt' size='10' value='<%=AddUtil.parseDecimal(car.getS_dc3_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setDc_per_amt(this, 3); set_dc_amt();'>
     					 원</td>
			    </tr>
		    </table>
		</td>
	</tr>	
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
        		            <select name='ecar_pur_sub_st' disabled>
        		            	<option value="" <%if(car.getEcar_pur_sub_st().equals("")){%> selected <%}%>>선택</option> 
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>제조사 차량대금 공제</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>아마존카 직접 수령</option>
                        </select>        		            
        	          </td>	                    
                </tr>
            </table>
	    </td>
    </tr>                 
    <%}%>     			
	<tr>
	    <td style='height:5'></td>
	</tr>	  
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 탁송구분 : [배달]-제조사를 통한 탁송(매입세금계산서에 탁송료 합산), [본인]-당사에서 탁송업체에 의뢰해서 출고지에서 당사까지 탁송</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 탁송업체 : 탁송구분이 자체일때 탁송의뢰하는 업체</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 탁송료1 : 출고지에서 당사로 오는 탁송료(매입세금계산서에 명시된 탁송료)</font> </td>
	</tr>		
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 탁송료2 : 당사에서 고객에게 납품할때 발생하는 탁송료</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 납품지역 : 납품할 지역/지명 (한글25자이내)</font> </td>
	</tr>				
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 납품예정일은 지급요청처리일로 부터 2일을 경과 할수 없습니다. 2일을 초과할 경우 팀장에게 구두결재를 받으십시오.</font> </td>
	</tr>				
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대금지출요청내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>품의일자</td>
                    <td>&nbsp;
                    <input type='text' name='doc_dt' size='15' value='<%=AddUtil.getDate()%>' class='whitetext'  onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                    <td class=title width=10%>임시운행보험료</td>
                    <%	//디폴트금액 있으면 반영
						if(pur.getTrf_amt5()==0 && b_ins_amt >0){
							pur.setTrf_amt5(b_ins_amt);
						} %>
                    <td colspan='3'>&nbsp;
                      <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
                    원
                    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='현대해상 보험료 보기' onclick="javascript:openHc();">-->
                    </td>
                </tr>					
                <tr> 
                    <td class=title width=10%>계약금</td>
                    <td width=15%>&nbsp;
                      <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    원</td>
                    <td class=title width=10%>잔액</td>
                    <td width="15%">&nbsp;
                      <input type='text' name='jan_amt' maxlength='15' value='0' class='defaultnum' size='10' onBlur='javascript:this.value=parseDecimal(this.value); set_con_amt();'>
                    원</td>
                    <td width="10%" class=title>지급처리요청일</td>
                    <td>&nbsp;
                    <input type='text' name='con_est_dt' size='15' value='' class='default'  onBlur='javscript:this.value = ChangeDate(this.value);'>					  
					  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;&nbsp;&nbsp;(계약금지급일:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <input type='hidden' name='con_pay_dt' value='<%=pur.getCon_pay_dt()%>'>					  
					  <%}else{%>						  
					  <%	if(pur.getCon_amt() >0 && cop_bean.getCon_amt() >0 &&  !cop_bean.getCon_pay_dt().equals("")){%>
					  &nbsp;&nbsp;&nbsp;&nbsp;(사전계약연동 계약금지급일:<%=cop_bean.getCon_pay_dt()%>)
					  <input type='hidden' name='con_pay_dt' value='<%=cop_bean.getCon_pay_dt()%>'>
					  <%	} %>				
					  <%} %>
					</td>                    
                </tr>			
                <%	
                	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && !cop_bean.getCon_bank().equals("")){
                		pur.setTrf_st0		(cop_bean.getTrf_st0());
                		pur.setAcc_st0		(cop_bean.getAcc_st0());
                		pur.setCon_bank		(cop_bean.getCon_bank());
                		pur.setCon_acc_no	(cop_bean.getCon_acc_no());
                		pur.setCon_acc_nm	(cop_bean.getCon_acc_nm());
                		pur.setCon_est_dt	(cop_bean.getCon_est_dt());
                	}
                	if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getTrf_st0().equals("") && pur.getCon_bank().indexOf("은행") == 0){
                		//현대자동차,기아자동차,삼성자동차 카드결재 가능
                		if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002") || emp2.getCar_comp_id().equals("0003")){
                			//20220914 현대총신대대리점, 르노블루모터스만 우선 카드 디폴트 처리
                			if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){
	                			pur.setTrf_st0("3");
                			}else{
                   				pur.setTrf_st0("1");
                   			}	
                		}	
                	}
                	if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_st5().equals("")){
                		//20220916 현대총신대대리점만 우선 카드 디폴트 처리
               			if(emp2.getCar_off_id().equals("00588")){
                			pur.setTrf_st5("3");
               			}else{
               				pur.setTrf_st5("1");
               			}
                	}
                %>
				<tr>
				  <td class=title width=10%>계약금지급수단</td>
                    <td colspan='5'>&nbsp;
                      지급수단 :
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>        				        				
        			  </select> 
        			  &nbsp;
                      카드/금융사 : 
					  <select name='con_bank'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        						for(int i = 0 ; i < bank_size ; i++){
        							CodeBean bank = banks[i];%>
                        <option value='<%= bank.getNm()%>' <%if(pur.getCon_bank().equals(bank.getNm())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                        <%	if(ck_size > 0){
        						for (int i = 0 ; i < ck_size ; i++){
        							Hashtable ht = (Hashtable)card_kinds.elementAt(i);%>
                  		<option value='<%= ht.get("CARD_KIND") %>' <%if(pur.getCon_bank().equals(String.valueOf(ht.get("CARD_KIND")))) out.println("selected");%>><%= ht.get("CARD_KIND") %></option>
                  		<%		}
        					}%>
                    </select>
                    &nbsp;
				  	계좌종류 :
				  	<select name="acc_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					카드/계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					적요/예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
                    </td>
				</tr>
				<tr>
				  <td class=title width=10%>특이사항</td>
                    <td colspan='5'>&nbsp;
					  <textarea name="con_amt_cont" cols="100" rows="3" class="default"></textarea>
                    </td>
				</tr>
				<tr>
					<td class=title width=10%>임시운행보험료<br/>영수증</td><!-- 2018.04.20 -->
					<%
					int attach_vt_26_size=0;
					attach_vt_26 = c_db.getAcarAttachFileListEqual(content_code, content_seq_26, 0);
                	attach_vt_26_size = attach_vt_26.size();
					%>
                    <td colspan='5'>&nbsp;
					  <%
					  	if(attach_vt_26_size > 0){
					  		for(int k=0; k<attach_vt_26_size; k++){
					  			Hashtable ht = (Hashtable)attach_vt_26.elementAt(k);
					  			%>
					  				<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>&nbsp;
					  			<%
					  		}
					  	}else{
					  		%>
<span class="b"><a href="javascript:scan_reg('26')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_scan_reg.gif align=absmiddle border=0></a></span>
					  		<%
					  	}
					  %>
                    </td>
				</tr>
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td><font color=#666666>&nbsp;※ 계약금 : 출고영업소에 지급된 계약금</font> </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;※ 계좌정보 : 계약금 등 현금으로 계좌이체할 출고영업소의 은행계좌정보입니다. 개인명의 계좌는 사용할수 없습니다.</font> </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;※ 계좌정보 : 출고영업소에 확인하여 <font color=red>현재 사용중인 계좌</font>만 입력하십시오. </font> 과거 이력으로 있는 계좌는 현재 사용하지 않을 수도 있습니다. </td>
	</tr>
	<tr>
	    <td><font color=#666666>&nbsp;※ 특이사항 : 고객이 계약금 지급한 경우, 해지된 계약의 보증금 승계 등등 특이사항을 입력하세요</font> </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>			
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용품요청내역</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class='title'><span class="title1">출고후추가장착</span></td>
                    <td colspan="3">
                    	&nbsp;<%=car.getAdd_opt()%>&nbsp;<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>원<font color="#666666">(부가세포함금액, 견적 반영분, LPG키트제외, 네비게이션 등)</font>
                    	<%if(cm_bean.getS_st().equals("801")||cm_bean.getS_st().equals("802")||cm_bean.getS_st().equals("811")||cm_bean.getS_st().equals("821")){%>
                    		<%if(!cr_bean.getCar_no().equals("")){ %>
								<br>&nbsp;&nbsp;화물차 전용 : 
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="" <%if(car.getVan_add_opt().equals("")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;없음
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="1" <%if(car.getVan_add_opt().equals("1")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;내장탑/윙바디	        				
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="2" <%if(car.getVan_add_opt().equals("2")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;활어수족관
								&nbsp;&nbsp;<input type="radio" name="van_add_opt" value="3" <%if(car.getVan_add_opt().equals("3")){%>checked<%}else{%>disabled="disabled"<%}%>>&nbsp;기중기/크레인
							<%}%>	
        				<%}%>
                    </td>
                </tr>
                <tr>
                    <td width="10%" class=title>견적반영용품</td>
                    <td colspan='3'>&nbsp;
		              <%if(car.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%> 
                      &nbsp;
                      <%if(car.getTint_s_yn().equals("Y")){%>전면 썬팅
                      &nbsp;
                                      가시광선투과율 : <%=car.getTint_s_per()%> %
                      <%}%>        	      
      		          &nbsp;
                      <%if(car.getTint_ps_yn().equals("Y")){%>고급 썬팅
                      &nbsp;
                                      내용 : <%=car.getTint_ps_nm()%>, 금액 : <%=AddUtil.parseDecimal(car.getTint_ps_amt())%>원 (부가세별도)
                      <%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%>
                      &nbsp;
                      <%if(car.getTint_eb_yn().equals("Y")){%>이동형 충전기<%}%>
                      &nbsp;
                      <%if(car.getTint_bn_yn().equals("Y")){%>블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)<%}%> 
                      &nbsp;
                      <%if(car.getTint_cons_yn().equals("Y")){%>추가탁송료등
                      &nbsp;
                      <%=AddUtil.parseDecimal(car.getTint_cons_amt())%>원
                      <%}%>                      
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청<%}%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;신형번호판신청(수도권)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청(대전/대구/광주/부산)<%}%> --%>
		    </td>
                </tr>			                	
                <tr>
                    <td class=title>제조사용품</td>
                    <td width="40%">&nbsp;
        			  <input type='radio' name="com_tint" value='' <%if(!emp2.getCar_comp_id().equals("0001") && !emp2.getCar_comp_id().equals("0002")){%>checked<%}else{%>checked onClick="javascript:cng_com_tint(0)"<%}%>>
                                  없음
				  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
                                  <input type='radio' name="com_tint" value='1' checked onClick="javascript:cng_com_tint(1)">
                                  썬팅+먼지털이개
                                  <input type='radio' name="com_tint" value='2' onClick="javascript:cng_com_tint(2)">
                                  브랜드키트
				  <%}%>
		    </td>
                    <td width="10%" class=title>제조사 썬팅</td>
                    <td width="40%">&nbsp;
        			  <input type='radio' name="com_film_st" value='' <%if(!emp2.getCar_comp_id().equals("0001") && !emp2.getCar_comp_id().equals("0002")){%>checked<%}else{%>checked onClick="javascript:cng_com_film_st(0)"<%}%>>
	       			  없음
				  <%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>	
                                  <input type='radio' name="com_film_st" value='1' checked onClick="javascript:cng_com_film_st(1)">       				  
                                  루마 (현대/기아)
        			  <input type='radio' name="com_film_st" value='2' onClick="javascript:cng_com_film_st(2)">
        			  모비스 (현대)
				  <input type='radio' name="com_film_st" value='3' onClick="javascript:cng_com_film_st(3)">
        			  SKC (기아)
        			  <input type='radio' name="com_film_st" value='4' onClick="javascript:cng_com_film_st(4)">
        			  3M (현대/기아)
				  <%}%>	
        	    </td>					  
                </tr>		
    		</table>
	    </td>
	</tr> 	
	<tr>
	    <td> <span class=style2>썬팅(측후면/전면)</span>
            <%if((tint1.getTint_yn().equals("Y") || tint1.getTint_yn().equals("")) && tint1.getReq_dt().equals("") && tint1.getConf_dt().equals("") && tint1.getPay_dt().equals("") && tint1.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('1')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>
            <%if(tint1.getTint_yn().equals("N") && (tint2.getTint_yn().equals("Y") || tint2.getTint_yn().equals("")) && tint2.getReq_dt().equals("") && tint2.getConf_dt().equals("") && tint2.getPay_dt().equals("") && tint2.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('1')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>      	  	    
	    </td>
	</tr>  				                 	
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td colspan='2' class='title'>시공구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint1.getTint_yn().equals("Y")){%>측후면<%}%>
                        <%if(tint1.getTint_yn().equals("Y") && tint2.getTint_yn().equals("Y")){%>+<%}%>
                        <%if(tint2.getTint_yn().equals("Y")){%>전면<%}%>
                        <%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("N")){%>시공하지않음<%}%>
                    </td>
                    <td colspan='2' class='title'>시공업체</td>
                    <td colspan='2' width='40%'>&nbsp;
                        <%=tint1.getOff_nm()%><%if(tint1.getTint_yn().equals("N") && tint2.getTint_yn().equals("Y")){%><%=tint2.getOff_nm()%><%}%></td>
                </tr>
                <%if(tint1.getTint_yn().equals("Y") || tint2.getTint_yn().equals("Y")){%>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>필름선택</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getFilm_st().equals("2")){%>3M
        		<%}else if(tint1.getFilm_st().equals("3")){%>루마
        		<%}else if(tint1.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint1.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint1.getFilm_st()%>)
        		<%}%>
                    </td>
                    <td rowspan='2' width='5%' class='title'>가시광선<br>투과율</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
                        <%=tint1.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getFilm_st().equals("2")){%>3M
        		<%}else if(tint2.getFilm_st().equals("3")){%>루마
        		<%}else if(tint2.getFilm_st().equals("5")){%>솔라가드
        		<%}else if(tint2.getFilm_st().equals("6")){%>고급
        		<%}else{%>기타(<%=tint2.getFilm_st()%>)
        		<%}%>                    
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=tint2.getSun_per()%>%</td>
                </tr>
                <tr> 
                    <td rowspan='2' width='5%' class='title'>비용부담</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getCost_st().equals("1")){%>없음
        		<%}else if(tint1.getCost_st().equals("2")){%>고객
        		<%}else if(tint1.getCost_st().equals("4")){%>당사
        		<%}else if(tint1.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td rowspan='2' width='5%' class='title'>견적반영</td>
                    <td width='5%' class='title'>측후면</td>
                    <td>&nbsp;
        		<%if(tint1.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint1.getEst_m_amt())%>원
        		<%}else if(tint1.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getCost_st().equals("1")){%>없음
        		<%}else if(tint2.getCost_st().equals("2")){%>고객
        		<%}else if(tint2.getCost_st().equals("4")){%>당사
        		<%}else if(tint2.getCost_st().equals("5")){%>에이전트
        		<%}%>                                           
                    </td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
        		<%if(tint2.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint2.getEst_m_amt())%>원
        		<%}else if(tint2.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>
                <tr> 
                    <td rowspan='2' class='title'>설치일자</td>
                    <td class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint1.getSup_est_dt())%>까지 요청함</td>
                    <td rowspan='2' class='title'>설치비용</td>
                    <td class='title'>측후면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint1.getTint_amt())%>원</td>
                </tr>
                <tr> 
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.ChangeDate3(tint2.getSup_est_dt())%>까지 요청함</td>
                    <td class='title'>전면</td>
                    <td>&nbsp;
                        <%=AddUtil.parseDecimal(tint2.getTint_amt())%>원</td>
                </tr>
                <%}%>
            </table>
	</td>
    </tr>      
	<tr>
	    <td> <span class=style2>블랙박스 </span>
			
            	<%if(base.getReg_id().equals(user_id) || base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) ){%>
					<%if(base.getCar_gu().equals("1") && (car.getOpt().contains("빌트인 캠")||car.getOpt().contains("빌트인캠"))){ %><!-- 20190522 -->
						- 빌트인캠이 포함된 차량입니다. <!-- 상시녹화를 필요로 하는 고객의 요청이 있는 경우에만 기타용품에 등록하세요 -->
					<%}else{ %>
	                	&nbsp;<a href="javascript:tint_update('3')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
					<%} %>
				<%}%>
            <%-- <%}%> --%>
	    </td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>설치구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint3.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint3.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint3.getOff_nm()%></td>
                </tr>
                <%if(tint3.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>모델선택</td>
                    <td>&nbsp;
                        <%if(tint3.getModel_st().equals("1")){%>추천모델<%}%>
                        <%if(!tint3.getModel_st().equals("") && !tint3.getModel_st().equals("1")){%>기타선택모델(<%=tint3.getModel_st()%>)<%}%>                    
                    </td>
                    <td class='title'>채널선택</td>
                    <td>&nbsp;
                        <%if(tint3.getChannel_st().equals("1")){%>1채널<%}%>
                        <%if(tint3.getChannel_st().equals("2")){%>2채널<%}%>                    
                    </td>
                </tr>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint3.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint3.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint3.getCost_st().equals("1")){%>없음
        		<%}else if(tint3.getCost_st().equals("2")){%>고객(전액)
        		<%}else if(tint3.getCost_st().equals("3")){%>고객(일부)
        		<%}else if(tint3.getCost_st().equals("4")){%>당사
        		<%}else if(tint3.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint3.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint3.getEst_m_amt())%>원
        		<%}else if(tint3.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint3.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>          	
	<tr>
	    <td> <span class=style2>내비게이션 </span>
            <%if(tint4.getReq_dt().equals("") && tint4.getConf_dt().equals("") && tint4.getPay_dt().equals("") && tint4.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('4')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>	    
	    </td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>설치구분</td>
                    <td width='40%' >&nbsp;
                        <%if(tint4.getTint_yn().equals("Y")){%>설치<%}%>
                        <%if(tint4.getTint_yn().equals("N")){%>설치하지않음<%}%>
                    </td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint4.getOff_nm()%></td>
                </tr>
                <%if(tint4.getTint_yn().equals("Y")){%>
                <tr> 
                    <td class='title'>제조사명</td>
                    <td>&nbsp;
                        <%=tint4.getCom_nm()%></td>
                    <td class='title'>모델명</td>
                    <td>&nbsp;
                        <%=tint4.getModel_nm()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint4.getCost_st().equals("1")){%>없음
        		<%}else if(tint4.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint4.getCost_st().equals("4")){%>당사
        		<%}else if(tint4.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint4.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint4.getEst_m_amt())%>원
        		<%}else if(tint4.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint4.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>       	
	<tr>
	    <td> <span class=style2>기타용품</span>
            <%if(tint5.getReq_dt().equals("") && tint5.getConf_dt().equals("") && tint5.getPay_dt().equals("") && tint5.getDoc_code().equals("")){%>
            <%if(base.getBus_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)){%>
                &nbsp;<a href="javascript:tint_update('5')" title=""><img src=/acar/images/center/button_modify_ss.gif align=absmiddle border=0></a>
            <%}%>
            <%}%>	    
	    </td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>상품명</td>
                    <td width='40%' >&nbsp;
                        <%=tint5.getCom_nm()%>&nbsp;<%=tint5.getModel_nm()%></td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint5.getOff_nm()%></td>
                </tr>
                <%if(!tint5.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint5.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint5.getCost_st().equals("1")){%>없음
        		<%}else if(tint5.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint5.getCost_st().equals("4")){%>당사
        		<%}else if(tint5.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint5.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint5.getEst_m_amt())%>원
        		<%}else if(tint5.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint5.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>    		
    <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
	<tr>
	    <td> <span class=style2>이동형 충전기</span>
	    	
	    </td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='10%' class='title'>상품명</td>
                    <td width='40%' >&nbsp;
                        <%=tint6.getCom_nm()%>&nbsp;<%=tint6.getModel_nm()%></td>
                    <td width='10%' class='title'>설치업체</td>
                    <td width='40%'>&nbsp;
                        <%=tint6.getOff_nm()%></td>
                </tr>
                <%if(!tint6.getModel_nm().equals("")){%>
                <tr> 
                    <td class='title'>비고</td>
                    <td colspan='3'>&nbsp;
                        <%=tint6.getEtc()%></td>
                </tr>   
                <tr> 
                    <td class='title'>비용부담</td>
                    <td>&nbsp;
        		<%if(tint6.getCost_st().equals("1")){%>없음
        		<%}else if(tint6.getCost_st().equals("2")){%>고객        		
        		<%}else if(tint6.getCost_st().equals("4")){%>당사
        		<%}else if(tint6.getCost_st().equals("5")){%>에이전트
        		<%}%>                       
                    </td>
                    <td class='title'>견적반영</td>
                    <td>&nbsp;
        		<%if(tint6.getEst_st().equals("Y")){%>반영 &nbsp;<%=AddUtil.parseDecimal(tint6.getEst_m_amt())%>원
        		<%}else if(tint6.getEst_st().equals("N")){%>미반영
        		<%}%>                       
                    </td>
                </tr>    
                <tr> 
                    <td class='title'>작업마감요청일시</td>
                    <td colspan='3'>&nbsp;
                        <%=AddUtil.ChangeDate3(tint6.getSup_est_dt())%>까지 요청함
                    </td>
                </tr>                               
                <%}%>                                         
            </table>
	</td>
    </tr>
    <%}%>
	<tr>
	    <td style='height:5'></td>
	</tr>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 용품요청 : 계약관리-용품에서 의뢰 등록 할 수 있습니다	    
        <%if(car.getTint_b_yn().equals("Y") && tint3.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;견적반영용품에 2채널 블랙박스이 있으나 용품 등록되지 않았습니다.<%}%>
        <%if((car.getTint_s_yn().equals("Y")||car.getTint_ps_yn().equals("Y")) && tint2.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;견적반영용품에 전면 썬팅이 있으나 용품 등록되지 않았습니다.<%}%>
        <%if(car.getTint_n_yn().equals("Y") && tint4.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;견적반영용품에 거치형 내비게이션이 있으나 용품 등록되지 않았습니다.<%}%>
        <%if(car.getTint_eb_yn().equals("Y") && tint6.getTint_no().equals("")){%><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;견적반영용품에 이동형 충전기가 있으나 용품 등록되지 않았습니다.<%}%>
	    </font></td>
	</tr>				
	<%if(emp2.getCar_comp_id().equals("0001") || emp2.getCar_comp_id().equals("0002")){%>
	<tr>
	    <td style='height:18'><font color=#666666>&nbsp;※ 현대/기아차 용품지원 : ① 루마썬팅 또는 모비스썬팅 + 극세사먼지떨이 ② 브랜드키트(트렁크정리함+슈즈케이스+에어벤트방향제+세차용걸레+왁스걸레+먼지떨이+멀티담요+세정제)</font> </td>
	</tr>	
	<%}%>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
	    <td class=line>
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width=10% rowspan="2" class=title>용도구분</td>
                    <td width=15% rowspan="2" class=title>계약조건<br>[VAT포함]</td>
                    <td colspan="3" class=title>입금내역</td>
                    <td colspan="2" class=title>미수금</td>
                </tr>
                <tr>
                    <td width=15% class=title>총금액</td>
                    <td width=5% class=title>횟수</td>
                    <td width=25% class=title>입금기간</td>
                    <td width=15% class=title>금액</td>
                    <td width=15% class=title>예정일자</td>
                </tr>
    		  <%Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "0");
    			Hashtable ext1 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "1");
    			Hashtable ext2 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, "1", "2");
    			int pp_amt0 	= fee.getGrt_amt_s();
    			int pp_amt1 	= fee.getPp_s_amt()+fee.getPp_v_amt();
    			int pp_amt2 	= fee.getIfee_s_amt()+fee.getIfee_v_amt();
    			int pp_pay_amt0 = AddUtil.parseInt(String.valueOf(ext0.get("PAY_AMT")));
    			int pp_pay_amt1 = AddUtil.parseInt(String.valueOf(ext1.get("PAY_AMT")));
    			int pp_pay_amt2 = AddUtil.parseInt(String.valueOf(ext2.get("PAY_AMT")));
    			%>
                <tr>
                    <td class=title width=10%>보증금</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0)%>'>원</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt0)%>'>원</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext0.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext0.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext0.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext0.get("MAX_PAY_DT")).equals(String.valueOf(ext0.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext0.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0-pp_pay_amt0)%>'>원</td>
                    <td align="center">&nbsp;<%if(pp_amt0-pp_pay_amt0 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>선납금</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt1)%>'>원</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt1)%>'>원</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext1.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext1.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext1.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext1.get("MAX_PAY_DT")).equals(String.valueOf(ext1.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext1.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt1-pp_pay_amt1)%>'>원</td>
                    <td align="center">&nbsp;<%if(pp_amt1-pp_pay_amt1 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>개시대여료</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt2)%>'>원</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_pay_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt2)%>'>원</td>
                    <td align="center"><%=AddUtil.parseDecimal(String.valueOf(ext2.get("CNT")))%></td>
                    <td align="center"><%if(AddUtil.parseInt(String.valueOf(ext2.get("CNT"))) > 0){%><%=AddUtil.ChangeDate2(String.valueOf(ext2.get("MIN_PAY_DT")))%><%if(!String.valueOf(ext2.get("MAX_PAY_DT")).equals(String.valueOf(ext2.get("MIN_PAY_DT")))){%>~<%=AddUtil.ChangeDate2(String.valueOf(ext2.get("MAX_PAY_DT")))%><%}%><%}else{%>-<%}%></td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt2-pp_pay_amt2)%>'>원</td>
                    <td align="center">&nbsp;<%if(pp_amt2-pp_pay_amt2 > 0){%><%=AddUtil.ChangeDate2(fee.getPp_est_dt())%><%}else{%>-<%}%></td>
                </tr>
                <tr>
                    <td class=title>합계</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0+pp_amt1+pp_amt2)%>'>원</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_pay_amt0+pp_pay_amt1+pp_pay_amt2)%>'>원</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align="center"><input type='text' size='10' maxlength='10' name='grt_non_amt' class='whitenum' value='<%=AddUtil.parseDecimal(pp_amt0+pp_amt1+pp_amt2-pp_pay_amt0-pp_pay_amt1-pp_pay_amt2)%>'>원</td>
                    <td align="center">-</td>
                </tr>
        	  	  <%if((pp_amt0+pp_amt1+pp_amt2-pp_pay_amt0-pp_pay_amt1-pp_pay_amt2) > 0){%>
                <tr>
                    <td class=title>후불처리사유</td>
                    <td colspan="4">&nbsp;<input type='text' name='pp_etc' size='40' value='<%=fee.getPp_etc()%>' class='default'></td>
                    <td class=title>후불결제예정일</td>
                    <td>&nbsp;		    
        		      <input type='text' size='11' name='pp_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
           		    </td>
                </tr>
        		  <input type='hidden' name='pp_st' value='미결'>
        		  <%}else{%>
        		  <input type='hidden' name='pp_st' value='완결'>
				  <input type='hidden' name='pp_etc' value='<%=fee.getPp_etc()%>'>
				  <input type='hidden' name='pp_est_dt' value='<%=AddUtil.ChangeDate2(fee.getPp_est_dt())%>'>				  
        		  <%}%>		
				<%if(base.getRent_st().equals("3") || cont_etc.getGrt_suc_r_amt() > 0){%>
                <tr> 
                    <td class=title>대차원계약</td>
                    <td colspan='6'>&nbsp;
					  승계여부 :
					  <select name='grt_suc_yn'>
                              <option value="">선택</option>
                              <option value="0" <%if(fee.getGrt_suc_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(fee.getGrt_suc_yn().equals("1")||fee.getGrt_suc_yn().equals(""))%>selected<%%>>별도</option>
                            </select>	
					  &nbsp;
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  대차보증금승계 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >원
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fee.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>			  
                      </td>
                </tr>		
				<%}else{%>
				<input type='hidden' name='grt_suc_m_id'  value='<%=cont_etc.getGrt_suc_m_id()%>'>
				<input type='hidden' name='grt_suc_l_cd'  value='<%=cont_etc.getGrt_suc_l_cd()%>'>
				<input type='hidden' name='grt_suc_c_no'  value='<%=cont_etc.getGrt_suc_c_no()%>'>
				<input type='hidden' name='grt_suc_o_amt' value='<%=cont_etc.getGrt_suc_o_amt()%>'>
				<input type='hidden' name='grt_suc_r_amt' value='<%=cont_etc.getGrt_suc_r_amt()%>'>
				<input type='hidden' name='grt_suc_yn' value='<%=fee.getGrt_suc_yn()%>'>
				<%}%>						  
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
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>가입구분</td>
                    <td width=15%>&nbsp;<%if(gins.getGi_st().equals("1")){%>가입<%}else if(gins.getGi_st().equals("0")){%>면제<%}%></td>
                    <td class=title width=10%>보험금액</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_amt())%>원</td>
                    <td width="10%" class=title>보험가입일</td>
                    <td width="15%">&nbsp;<%=AddUtil.ChangeDate2(gins.getGi_dt())%></td>
                    <td width="10%" class=title>보험료</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(gins.getGi_fee())%>원</td>
                </tr>	
        		  <%if(gins.getGi_st().equals("1") && gins.getGi_dt().equals("")){%>
                <tr> 
                    <td class=title width=10%>처리구분</td>
                    <td width=15%>&nbsp;미결</td>
                    <td class=title width=10%>미결사유</td>
                    <td colspan="3">&nbsp;<input type='text' name='gi_etc' size='40' value='<%=gins.getGi_etc()%>' class='default'></td>
                    <td class=title width=10%>완결예정일</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='gi_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(gins.getGi_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        	    </tr>	
        		  <input type='hidden' name='gi_st' value='미결'>
        		  <%}else{%>
                <tr> 
                    <td class=title>발행지점</td>
                    <td>&nbsp;<%=gins.getGi_jijum()%></td>
                    <td class=title>증권번호</td>
                    <td>&nbsp;<%=gins.getGi_no()%></td>
                    <td class=title>보험기간</td>
                    <td colspan='3'>&nbsp;<%=AddUtil.ChangeDate2(gins.getGi_start_dt())%>~<%=AddUtil.ChangeDate2(gins.getGi_end_dt())%> (<%=gins.getGi_day()%>일간)</td>
                </tr>
        		  <input type='hidden' name='gi_st' value='완결'>
        		  <%}%>		
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=10%>대표연대보증</td>
                    <td width=15%>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>가입<%}else if(cont_etc.getClient_guar_st().equals("2")){%>면제<%}%></td>
                    <td class=title width=10%>면제조건</td>
                    <td width="15%">&nbsp;
        			        <%if(cont_etc.getGuar_con().equals("1")){%>신용우수고객<%}%>
                      <%if(cont_etc.getGuar_con().equals("2")){%>선수금으로대체<%}%>
                      <%if(cont_etc.getGuar_con().equals("3")){%>보증보험으로대체<%}%>
                      <%if(cont_etc.getGuar_con().equals("4")){%>기타 결재획득<%}%>
                      <%if(cont_etc.getGuar_con().equals("5")){%>전문경영인<%}%>
                      <%if(cont_etc.getGuar_con().equals("6")){%>대표공동임차<%}%>
        			</td>
                    <td width="10%" class=title>기타연대보증</td>
                    <td width="15%">&nbsp;<%if(cont_etc.getGuar_st().equals("1")){%>가입<%}else if(cont_etc.getGuar_st().equals("2")){%>면제<%}%></td>
                    <td class=title>보증인원</td>
                    <td>&nbsp;<%=gur_size%>명</td>
                </tr>
        		  <%if(cont_etc.getClient_guar_st().equals("1") || gur_size > 0){%>	
                <tr> 
                    <td class=title width=10%>처리구분</td>
                    <td width=15%>
        			  &nbsp;<select name='guar_end_st' class='default'>
                        <option value="">선택</option>
                        <option value="1" <%if(cont_etc.getGuar_end_st().equals("1") || scan_cnt > 0){%>selected<%}%>>미결</option>
                        <option value="2" <%if(cont_etc.getGuar_end_st().equals("2") || scan_cnt ==0){%>selected<%}%>>완결</option>
                      </select>			
        			  &nbsp;<span class="b"><a href="javascript:view_scan()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_conf.gif align=absmiddle border=0></a></span>
        			</td>
                    <td class=title width=10%>미결사유</td>
                    <td colspan="3">&nbsp;<input type='text' name='guar_etc' size='40' value='<%=cont_etc.getGuar_etc()%>' class='default'></td>
                    <td class=title width=10%>완결예정일</td>
                    <td width=15%>&nbsp;<input type='text' size='11' name='guar_est_dt' maxlength='12' class='default' value='<%=AddUtil.ChangeDate2(cont_etc.getGuar_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        	    </tr>	
        		  <%}else{%>
        		  <input type='hidden' name='guar_end_st' value='2'>
        		  <%}%>		
    		</table>
	    </td>
	</tr> 
	<tr>
	    <td><font color=#666666>&nbsp;※ 처리구분이 미결일때 미결사유와 완결예정일을 넣어 주십시오. </font> </td>
	</tr>	
	<tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자동차보험</span></td>
	</tr>  		
    <tr>
        <td class=line2></td>
    </tr>  	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title>보험계약자</td>
                    <td>&nbsp;
                      <%String insurant = cont_etc.getInsurant();%>
                      <%if(insurant.equals("1") || insurant.equals("")){%>
                        아마존카
                      <%}else if(insurant.equals("2")){%>
                        고객
                      <%}%>
                    </td>                
                    <td class=title>피보험자</td>
                    <td colspan="3">&nbsp;
                      <%String insur_per = cont_etc.getInsur_per();%>
                      <%if(insur_per.equals("1") || insur_per.equals("")){%>
                        아마존카
                      <%}else if(insur_per.equals("2")){%>
                        고객
                      <%}%>
                    </td>
                    <td class=title >임직원운전한정특약</td>
                    <td>&nbsp;
                      <%if(cont_etc.getCom_emp_yn().equals("Y")){%>가입<%}%>
                      <%if(cont_etc.getCom_emp_yn().equals("N")){%>미가입<%}%>
                    </td>                           
        	    </tr>
        		  <%if(insur_per.equals("2")){%>
        	    <tr>
                    <td class=title>입보회사</td>
                    <td colspan="7" class=''>
        			    <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">&nbsp;
            				    <%if(insur_per.equals("2")){%>
            				     	보험사  : <%=cont_etc.getIp_insur()%>
                  				 	&nbsp;대리점 : <%=cont_etc.getIp_agent()%>
                  					&nbsp;담당자 : <%=cont_etc.getIp_dam()%>
            						&nbsp;연락처 : <%=cont_etc.getIp_tel()%>
            					<%}%>
            				    </td>
                            </tr>
                        </table>
        			</td>
                </tr>
        		  <%}%>
                <tr>
                    <td class=title>운전자범위</td>
                    <td class=''>&nbsp;
                      <%String driving_ext = base.getDriving_ext();%>
                      <%if(driving_ext.equals("1") || driving_ext.equals("")){%>
                         모든사람
                      <%}else if(driving_ext.equals("2")){%>
                         가족한정
                      <%}else if(driving_ext.equals("3")){%>
                         기타
                      <%}%></td>
                    <td class=title >운전자연령</td>
                    <td class=''>&nbsp;
                      <%String driving_age = base.getDriving_age();%>
                      <%if(driving_age.equals("0")){%>
                         만26세이상
                      <%}else if(driving_age.equals("3")){%>
                         만24세이상
                      <%}else if(driving_age.equals("1")){%>
                         만21세이상
                      <%}else if(driving_age.equals("2")){%>
                         모든운전자
                      <%}else if(driving_age.equals("5")){%>
              30세이상
                      <%}else if(driving_age.equals("6")){%>
              35세이상
                      <%}else if(driving_age.equals("7")){%>
              43세이상
                      <%}else if(driving_age.equals("8")){%>
              48세이상
                      <%}else if(driving_age.equals("9")){%>
              22세이상
                      <%}else if(driving_age.equals("10")){%>
              28세이상
                      <%}else if(driving_age.equals("11")){%>
              35세이상~49세이하
                      <%}%>
                    </td>
                    <td  class=title>대인배상</td>
                    <td width="15%">&nbsp;무한(대인배상Ⅰ,Ⅱ)</td>
                    <td width="10%" class=title>긴급출동</td>
                    <td width="15%" class=''>&nbsp;
                      <%String eme_yn = cont_etc.getEme_yn();%>
                      <%if(eme_yn.equals("Y")){%>
                        가입
                      <%}else if(eme_yn.equals("N")){%>
                        미가입
                      <%}%></td>
                </tr>
                <tr>
                     <td class=title>대물배상</td>
                     <td class=''>&nbsp;
                       <%String gcp_kd = base.getGcp_kd();%><%if(gcp_kd.equals("1")){%>5천만원<%}else if(gcp_kd.equals("2")){%>1억원<%}else if(gcp_kd.equals("3")){%>5억원<%}else if(gcp_kd.equals("4")){%>2억원<%}else if(gcp_kd.equals("8")){%>3억원<%}%></td>
                     <td class=title >자기신체사고</td>
                     <td class=''>&nbsp;
                       <%String bacdt_kd = base.getBacdt_kd();%>
                       <%if(bacdt_kd.equals("1")){%>
                            5천만원
                       <%}else if(bacdt_kd.equals("2")){%>
                            1억원
                       <%}%></td>
                     <td  class=title>무보험차상해</td>
                     <td>&nbsp;
                       <%String canoisr_yn = cont_etc.getCanoisr_yn();%>
                       <%if(canoisr_yn.equals("Y")){%>
                              가입
                       <%}else if(canoisr_yn.equals("N")){%>
                              미가입
                       <%}%></td>
                     <td class=title>자기차량손해</td>
                     <td class=''>&nbsp;
                       <%String cacdt_yn = cont_etc.getCacdt_yn();%>
                       <%if(cacdt_yn.equals("Y")){%>
                              가입
                       <%}else if(cacdt_yn.equals("N")){%>
                              미가입
                       <%}%></td>
                </tr>		
                <tr>
                    <td width="10%"  class=title>자차면책금</td>
                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
                    <td width="10%" class=title>결재자</td>
                    <td width="15%" class=''><%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%></td>
                    <td width="10%" class=title >변경사유</td>
                    <td colspan="3" class=''>&nbsp;(기본 <%=AddUtil.parseDecimal(car.getImm_amt())%>원)<%=cont_etc.getJa_reason()%></td>
                </tr>
                <tr>
                    <td  class=title>자동차</td>
                    <td colspan="7">&nbsp;
                      <input type="checkbox" name="air_ds_yn" 	value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%>checked<%}%> disabled>
        				운전석에어백
                      <input type="checkbox" name="air_as_yn" 	value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%>checked<%}%> disabled>
        				조수석에어백
        				<!--
                      <input type="checkbox" name="air_cu_yn" 	value="Y" <%if(cont_etc.getAir_cu_yn().equals("Y")){%>checked<%}%> disabled>
        				커튼에어백
                      <input type="checkbox" name="auto_yn" 	value="Y" <%if(cont_etc.getAuto_yn().equals("Y")){%>checked<%}%> disabled>
        				자동변속기
                      <input type="checkbox" name="abs_yn" 		value="Y" <%if(cont_etc.getAbs_yn().equals("Y")){%>checked<%}%> disabled>
        				ABS장치
                      <input type="checkbox" name="rob_yn" 		value="Y" <%if(cont_etc.getRob_yn().equals("Y")){%>checked<%}%> disabled>
        				도난방지장치				
                      <input type="checkbox" name="sp_car_yn" 	value="Y" <%if(cont_etc.getSp_car_yn().equals("Y")){%>checked<%}%> disabled>
                      스포츠카여부
                      -->
                      <input type="checkbox" name="v_blackbox_yn" 	value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%>checked<%}%> disabled>
        				블랙박스
                      </td>
                </tr>
        		  <%if(!base.getOthers().equals("")){%>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="7">&nbsp;<%=HtmlUtil.htmlBR(base.getOthers())%></td>
                </tr>
        		  <%}%>
            </table>
        </td>
    </tr>		
	<tr>
	    <td align="right">&nbsp;</td>
	<tr> 
    <tr>
	    <td align='center'>
	    	  <%if(base.getCar_st().equals("1")||base.getCar_st().equals("3")){%>
	    	  <%	if(fee.getCon_mon().equals("") || car.getCar_fs_amt() ==0){%>
	    	  &nbsp;※ 계약관리에 대여정보나 차량구입가격이 입력되지 않았습니다. 계약등록을 먼저 완료하십시오.
	    	  <%	}else{%>
	        <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
	        <%	}%>
	        <%}else{%>
	        <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>	        
	        <%}%>
	    </td>
	</tr>	
	<%}else{%>
	<tr>
	    <td align="right">&nbsp;</td>
	<tr>	
	<tr>
	    <td>&nbsp;※ 매매주문서 스캔은 필수입니다. 우선 등록해주십시오. 등록후 <span class="b"><a href="javascript:location.reload()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_reload.gif align=absmiddle border=0></a></span>을 해주세요.</td>
	</tr>	
	<tr>
	    <td>&nbsp;※ 매매주문서 스캔이 완료되면 다음단계로 넘어갑니다.</td>
	</tr>	
	<tr>
	    <td>&nbsp;※ 매매주문서 스캔 없이 기안 등록하여 출고 결재가 지연되는일이 발생해 위와 같이 변경합니다.</td>
	</tr>	
	<%}%>			
</table>
</form>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	
	
	if(fm.auto.value == 'M/T' && fm.car_b.value.indexOf('자동변속기') != -1){
		fm.auto.value = 'A/T';
	}	
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('변속기') != -1){
		fm.auto.value = 'A/T';
	}
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('DCT') != -1){
		fm.auto.value = 'A/T';
	}
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('C-TECH') != -1){
		fm.auto.value = 'A/T';
	}		
	if(fm.auto.value == 'M/T' && fm.opt.value.indexOf('A/T') != -1){
		fm.auto.value = 'A/T';
	}	
	if(fm.auto.value == 'M/T' && fm.car_b.value.indexOf('무단 변속기') != -1){
		fm.auto.value = 'A/T';
	}	
			
	
	function replaceFloatRound(per){
		return Math.round(per*1000)/10;	
	}
	
	<%if(attach_vt_size >0 || (coe_bean.getCar_off_id().equals("03900") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null"))){%>	
	set_cons_amt();
	sum_car_c_amt();
	sum_car_f_amt();
	set_con_amt();
	
		
	
	if(fm.com_con_no.value != ''){
		fm.rpt_no.value		= '<%=pur_com.get("COM_CON_NO")%>';			
		//fm.dlv_est_dt.value	= '<%=pur_com.get("DLV_CON_DT")%>';			
		fm.dlv_ext.value 	= '<%=pur_com.get("DLV_EXT")%>';
		//fm.udt_st.value 	= '<%=pur_com.get("UDT_ST")%>';
		//fm.cons_amt1.value 	= parseDecimal(<%=pur_com.get("CONS_AMT")%>);
		//fm.cons_amt3.value 	= parseDecimal(<%=pur_com.get("CONS_AMT")%>);
		//set_cons_amt();
		fm.s_dc1_re.value 	= '판매자정상조건';
		fm.s_dc1_re_etc.value 	= '특판DC';
		fm.s_dc1_amt.value 	= parseDecimal(<%=pur_com.get("DC_AMT")%>);
		fm.s_dc1_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
		//fm.s_dc1_yn.value 	= 'Y';	
		set_dc_amt();	
		if('<%=pur_com.get("CAR_OFF_ID")%>'=='03900' && <%=pur_com.get("ADD_DC_AMT")%> >0 ){
			fm.s_dc2_re.value 	= '포인트DC';
			fm.s_dc2_re_etc.value 	= '블루멤버스포인트';
			fm.s_dc2_amt.value 	= parseDecimal(<%=pur_com.get("ADD_DC_AMT")%>);
			fm.s_dc2_per.value 	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
			set_dc_amt();	
		}	
		if(fm.udt_st.value != '<%=pur_com.get("UDT_ST")%>'){
			alert('특판배정관리 배달지와 인수지가 다릅니다. 유의하세요.');
		}
	}	
	
	if(toInt(parseDigit(fm.s_dc1_amt.value)) > 0 && toFloat(fm.s_dc1_per.value) == 0.0){
		fm.s_dc1_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc1_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc2_amt.value)) > 0 && toFloat(fm.s_dc2_per.value) == 0.0){
		fm.s_dc2_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc2_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	if(toInt(parseDigit(fm.s_dc3_amt.value)) > 0 && toFloat(fm.s_dc3_per.value) == 0.0){
		fm.s_dc3_per.value	= replaceFloatRound(toInt(parseDigit(fm.s_dc3_amt.value)) / toInt(parseDigit(fm.car_f_amt.value)) );
	}
	
	<%}%>
	

	
		
//-->
</script>
</body>
</html>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>

