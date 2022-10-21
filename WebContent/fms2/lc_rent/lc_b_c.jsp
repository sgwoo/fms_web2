<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"	       scope="page"/>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               scope="page"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="ac_db"     class="acar.cost.CostDatabase"             scope="page"/>
<jsp:useBean id="ae_db"     class="acar.ext.AddExtDatabase"            scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase"      scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")	==null?"":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null?"" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 		= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 		= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 		= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 		= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	
	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "08");
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//자동차기본정보-기본차량
	CarMstBean cm_bean2 = new CarMstBean();
	
	if(!cm_bean.getCar_b_inc_id().equals("")){
		cm_bean2 = cmb.getCarNmCase(cm_bean.getCar_b_inc_id(), cm_bean.getCar_b_inc_seq());
	}
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}
	
	//대여료갯수조회(연장여부)
	int fee_size 	= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	if(rent_st.equals("")) rent_st = "1";
	if(fee_size > 1) rent_st = Integer.toString(fee_size);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//차량기본정보
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//법인고객차량관리자
	Vector car_mgrs = a_db.getCarMgrListNew(rent_mng_id, rent_l_cd, "Y");
	int mgr_size = car_mgrs.size();
	
	//연대보증인정보
	Vector gurs = a_db.getContGurList(rent_mng_id, rent_l_cd);
	int gur_size = gurs.size();
	
	//고객재무제표
	ClientFinBean c_fin = al_db.getClientFin(base.getClient_id(), cont_etc.getFin_seq());
	
	//신용평가 조회
	ContEvalBean eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
	ContEvalBean eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
	ContEvalBean eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
	ContEvalBean eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
	ContEvalBean eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
	ContEvalBean eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
	
	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	
	//마지막이행보증보험
	ContGiInsBean max_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);

	
	//영업소 담당자
	CommiBean emp1 	= a_db.getCommi(rent_mng_id, rent_l_cd, "1");
	CommiBean emp2 	= a_db.getCommi(rent_mng_id, rent_l_cd, "2");
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);
	
	//사전계출계약
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//신용등급코드
	CodeBean[] gr_cd1 = c_db.getCodeAll2("0013", "1");
	CodeBean[] gr_cd2 = c_db.getCodeAll2("0013", "2");
	CodeBean[] gr_cd3 = c_db.getCodeAll2("0013", "3");
	
	int eval_cnt = -1;
	
	//자산형태
	CodeBean[] ass_cd = c_db.getCodeAll2("0014", "");
	
  	//차량등록지역
  	CodeBean[] code32 = c_db.getCodeAll3("0032");
  	int code32_size = code32.length;
  
  	//전기차 고객주소지
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	

  	//수소차 고객주소지
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  
  	//차량인수지점
  	CodeBean[] code35 = c_db.getCodeAll3("0035");
  	int code35_size = code35.length;
  
	
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());//차량등록 경과기간(차령)
	
	//스캔파일 체크여부
	String scan_chk = "Y";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page;
	
	String valus_t = valus;
	
	int fee_opt_amt = 0;
	
	int zip_cnt =4;
	
	//영업효율
	Hashtable cost_cmp = ac_db.getSaleCostCampaignCase("1", rent_mng_id, rent_l_cd, rent_st);
	//영업효율
	Hashtable t_cost_cmp = ac_db.getSaleCostCampaignCase("9", rent_mng_id, rent_l_cd, "t");	
	
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}
	
	
	
	
	
	//장기전자계약서
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, rent_st);	
	
	int alink_count1 = ln_db.getALinkCnt("lc_rent_link",   rent_l_cd)+ln_db.getALinkCnt("lc_rent_link_m",   rent_l_cd);
	
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

	//변경화면
	function go_modify()
	{
		var fm = document.form1;
		fm.target = "_self";
		fm.action = "/fms2/lc_rent/lc_b_s.jsp";
		fm.submit();
	}
	
	//리스트
	function list(){
		var fm = document.form1;	
		
		if(fm.from_page.value == '')						fm.action = 'lc_b_frame.jsp';
		else if(fm.from_page.value == '/fms2/lc_rent/lc_bc_frame.jsp')		fm.action = '/fms2/lc_rent/lc_bc_frame.jsp';		
		else if(fm.from_page.value == '/fms2/mis/sale_cost_mng_frame.jsp')	fm.action = '/fms2/mis/sale_cost_mng_frame.jsp';				
		else									fm.action = fm.from_page.value;
		
		fm.target = 'd_content';
		fm.submit();
	}	
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
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
	}
		
	//차량 특소세 자동계산
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;		
	}
	
	function view_car_amt(){
		var fm = document.form1;
		if(fm.view_car_amt.value == ''){
			tr_car1.style.display='';
			fm.view_car_amt.value = 'open';
		}else{
			tr_car1.style.display='none';
			fm.view_car_amt.value = '';			
		}
	}
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj, rent_dt)
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') set_fee_amt(obj, rent_dt);
	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj, rent_dt)
	{
		var fm = document.form1;		
	}
						
	//결재하기
	function sanction(){
		var fm = document.form1;
			
		if(toInt(fm.chk_cnt.value) > 0){
			alert('입력값 체크 결과 확인이 필요한 항목이 '+toInt(fm.chk_cnt.value)+'건 발생했습니다.');
			return;
		}
		
		fm.idx.value = 'sanction';
		
		fm.action='lc_b_u_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	//결재요청 취소하기
	function sanction_req_cancel(){
		var fm = document.form1;
		fm.idx.value = 'sanction_req_cancel';		
		fm.action='lc_b_u_a.jsp';		
		fm.target='i_no';
		fm.submit();
	}	
	
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	
			
	//마감보기
	function view_sale_cost_lw(){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw.jsp<%=valus%>", "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	
	
	//마감보기
	function view_sale_cost_lw_base(){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_base.jsp<%=valus%>", "VIEW_SALE_COST_LW_BASE", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	

	//마감보기
	function view_sale_cost_lw_add(){
		var height = <%=s_height%>;
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=base.getRent_l_cd()%>&add_rent_st=t", "VIEW_SALE_COST_LW_ADD", "left=0, top=0, width=850, height="+height+", scrollbars=yes");
	}	
	
	//동일거래처 기존거래 보기
	function view_lc_rent(){
		var height = 400;
		window.open("view_rent_list.jsp?client_id=<%=base.getClient_id()%>", "VIEW_LC_RENT", "left=0, top=0, width=1150, height="+height+", scrollbars=yes");		
	}
	
	// bh.sim 테스트용 start
	function sanction_temp(){
		var fm = document.form1;
					
		fm.idx.value = 'sanction';
		
		fm.action='lc_b_u_a.jsp';		
		fm.target='i_no';
		fm.submit();
		
	}// bh.sim 테스트용 end
	
	//문자발송
	function SendMsg(msg_st){
		var fm = document.form1;
		fm.msg_st.value = msg_st;
		window.open('about:blank', "LC_SEND_MSG", "left=0, top=0, width=900, height=400, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "LC_SEND_MSG";
		if(msg_st=='con_amt_pay_req'){
			fm.action = "/fms2/lc_rent/lc_send_msg.jsp";
		}else{
			fm.action = "/fms2/car_pur/reg_trfamt5.jsp";
		}
		fm.submit();
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
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
<form action='lc_b_c.jsp' name="form1" method='post'>
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
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_c.jsp'>
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
  <input type='hidden' name="fin_seq" 			value="<%=c_fin.getF_seq()%>">  
  <input type='hidden' name="reg_dt"			value="<%=base.getReg_dt()%>">    
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">      
  <input type='hidden' name="gur_size"			value="<%=gur_size%>">     
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
  <input type='hidden' name="est_from"			value="lc_b_c">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="r_max_agree_dist"		value=""> 
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">            
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">    
  <input type='hidden' name="san_st"			value="<%=san_st%>">              
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="msg_st"		value="">
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>미결계약 보기</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
	    <td align='right'>
	        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	        <%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약결재",ck_acar_id) || nm_db.getWorkAuthUser("영업팀내근직",ck_acar_id)){%>	    
	        <a href="javascript:go_modify()" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_modify_s.gif align=absmiddle border=0></a>
	        &nbsp;&nbsp;&nbsp;	 
	        <%	}%>       
	        <%}%>       
	        <a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>
	    </td>
	</tr>
	
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class=line> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr> 
                    <td class=title width=13%>품의구분</td>
                    <td width=20%>&nbsp;<%if(now_stat.equals("연장")){%>연장계약
                              <%}else if(now_stat.equals("계약승계")){%>계약승계계약
                              <%}else if(now_stat.equals("차종변경")){%>차종변경계약
                              <%}else{%>
                                  <%if(base.getCar_gu().equals("1")){%>신차계약
                                  <%}else if(base.getCar_gu().equals("0")){%>재리스계약
                                  <%}else if(base.getCar_gu().equals("3")){%>월렌트계약
                                  <%}%>                                  
                                  <%if(base.getReject_car().equals("Y")){%>&nbsp;(인수거부차량)<%}%>
                              <%}%>
                    </td>
                    <td>&nbsp;
                        <%if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){%>
                            [전자계약서]
                        <%}%>
                    </td>
                </tr>
            </table>		
        </td>
	</tr>
    <tr>
	    <td>(등록일 : <%=AddUtil.ChangeDate2(base.getReg_dt())%>)</td>
	</tr>			

    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%>(<%=rent_mng_id%>)</td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;
        		<select name="rent_st"  disabled>
                            <option value=''>선택</option>
                            <option value='1' <%if(base.getRent_st().equals("1")){%>selected<%}%>>신규</option>
                            <option value='3' <%if(base.getRent_st().equals("3")){%>selected<%}%>>대차</option>
                            <option value='4' <%if(base.getRent_st().equals("4")){%>selected<%}%>>증차</option>
                        </select>
                        <%if(base.getRent_st().equals("4")||base.getRent_st().equals("3")){%>
                        &nbsp;
                        <a href="javascript:view_lc_rent()" title="이력"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>
                        <%}%>
                    </td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;
        			  <select name="bus_st" disabled>
                        <option value="">선택</option>
                        <option value="1" <%if(base.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                        <option value="8" <%if(base.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                        <option value="5" <%if(base.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>                        
                        <option value="2" <%if(base.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                        <option value="7" <%if(base.getBus_st().equals("7")){%>selected<%}%>>에이젼트</option>                        
                        <option value="6" <%if(base.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                        <option value="3" <%if(base.getBus_st().equals("3")){%>selected<%}%>>업체소개</option>
                        <option value="4" <%if(base.getBus_st().equals("4")){%>selected<%}%>>catalog</option>                        
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;
                    <%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("5")){%>업무대여<%}%>
                    <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;
        			  <select name="rent_way" disabled>
                        <option value=''>선택</option>
                        <option value='1' <%if(max_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>
                        <option value='2' <%if(max_fee.getRent_way().equals("2")){%>selected<%}%>>맞춤식</option>
                        <option value='3' <%if(max_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(base.getBus_id(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_id" value="<%=base.getBus_id()%>">
					                                            
                    </td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="<%=cont_etc.getBus_agnt_id()%>">
		    </td>
                    <td class=title>예비배정자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(base.getMng_id2(), "USER")%>" size="12"> 
			<input type="hidden" name="mng_id2" value="<%=base.getMng_id2()%>">
                    </td>					
                </tr>
                <tr> 
                    <td class=title>영업담당자</td>
                    <td>&nbsp;			
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(base.getBus_id2(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_id2" value="<%=base.getBus_id2()%>">
		    </td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(base.getMng_id(), "USER")%>" size="12"> 
			<input type="hidden" name="mng_id" value="<%=base.getMng_id()%>">
  		    </td>
                    <td class=title>차량인도일</td>
                    <td>&nbsp;
        		<input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="11" maxlength='11' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
                <tr>
                    <td class=title>차량이용지역</td>
                    <td>&nbsp;
                        <%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
                        <input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
		    </td>
		    <td class=title>계약결재</td>
		    <td colspan='3'>&nbsp;
			<%=c_db.getNameById(base.getSanction_id(),"USER")%>&nbsp;<%=AddUtil.ChangeDate2(base.getSanction_date())%></td>
                </tr>									
            </table>
	</td>
    </tr>
    <tr>
	<td class=h></td>
    </tr>					
    <%if(now_stat.equals("계약승계") && String.valueOf(begin.get("CLS_ST")).equals("계약승계")){
    		if(cont_etc.getRent_suc_dt().equals("")) cont_etc.setRent_suc_dt(base.getReg_dt());
			ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			//원게약자 승계수수료 부담
			if(cont_etc.getRent_suc_commi_pay_st().equals("1") && cont_etc.getRent_suc_commi() != (suc2.getExt_s_amt()+suc2.getExt_v_amt())){
				suc2 = ae_db.getAGrtScd(rent_mng_id, cont_etc.getRent_suc_l_cd(), "1", "5", "1");//기존 등록 여부 조회
			}%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약승계</span></td>
	</tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>					
                <tr>
                    <td class=title width=13%>계약승계일자</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="11" maxlength='11' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'>
    	            </td>		    
                    <td class=title>승계시점주행거리</td>
                    <td>&nbsp;
    			    <input type="text" name="rent_suc_dist" value="<%=AddUtil.parseDecimal(cont_etc.getRent_suc_dist())%>" size="11" maxlength='10' class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>km
    	            </td>		    
    		</tr>	
				<tr>
                    <td class=title width=13%>비고-승계루트</td>
                    <td colspan='3'>&nbsp;
    			    	<textarea name="rent_suc_route" cols="100" class="text" style="IME-MODE: active" rows="3"><%=cont_etc.getRent_suc_route()%></textarea> 						
					</td>					
				</tr>    		  
    		    
		<tr>			
					</td>	
                    <td class=title width=13%>계약승계수수료</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  &nbsp;&nbsp;&nbsp;
					  <% 	if(suc2 == null || suc2.getRent_l_cd().equals("")){%> 
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='whitenum' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='whitenum' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;					  					  
					  <%	}else{%>
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;
					  <%	}%>				   				   
				   &nbsp;&nbsp;&nbsp;
				   * 정상승계수수료 : <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())*0.7/100)%>원	  
				   (신차소비자가 <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()))%>원의 0.7%)

					  
					  </td>
                    
                </tr>
                
				<tr>
                    <td class=title width=13%>승계수수료감면사유</td>
                    <td width=50%>&nbsp;
    			    	<select name='rent_suc_exem_cau' disabled>
                                      <option value="">선택</option>
                                      <option value="1" <%if(cont_etc.getRent_suc_exem_cau().equals("1")){%>selected<%}%>>법인 전환 (전액감면)</option>
                                      <option value="2" <%if(cont_etc.getRent_suc_exem_cau().equals("2")){%>selected<%}%>>이용자 동일 (50%감면)</option>
                                      <option value="3" <%if(cont_etc.getRent_suc_exem_cau().equals("3")){%>selected<%}%>>기존고객과 특수관계</option>
                                      <option value="5" <%if(cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>에이전트 승계수당과 상계</option>                                      
                                      <option value="4" <%if(!cont_etc.getRent_suc_exem_cau().equals("") && !cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5")){%>selected<%}%>>기타 (내용 직접 입력)</option>
                      </select>       
                      <%if(!cont_etc.getRent_suc_exem_cau().equals("") && !cont_etc.getRent_suc_exem_cau().equals("1") && !cont_etc.getRent_suc_exem_cau().equals("2") && !cont_etc.getRent_suc_exem_cau().equals("3") && !cont_etc.getRent_suc_exem_cau().equals("5")){%>                      
                      <input type='text' name='rent_suc_exem_cau_sub' size='30' class='whitetext' value="<%=cont_etc.getRent_suc_exem_cau()%>">    					
                      <%}else{%>
                      <input type='hidden' name="rent_suc_exem_cau_sub"		value="<%=cont_etc.getRent_suc_exem_cau()%>">
                      <%}%>
					</td>					
					<td class=title width=10%>수수료감면 결재자</td>
					<td>&nbsp;
					        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(cont_etc.getRent_suc_exem_id(), "USER")%>" size="12"> 
			                        <input type="hidden" name="rent_suc_exem_id" value="<%=cont_etc.getRent_suc_exem_id()%>">						
					</td>					
				</tr>	
		
				<tr>
                    <td class=title width=13%>비용부담자</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_commi_pay_st' disabled>
                           <option value="">선택</option>
                           <option value="1" <%if(cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>>원계약자</option>
                           <option value="2" <%if(cont_etc.getRent_suc_commi_pay_st().equals("2")){%>selected<%}%>>계약승계자</option>
                        </select>
					</td>					
				</tr>
				<tr>
                    <td class=title width=13%>스케줄이관회차</td>
                    <td width=50%>&nbsp;
    			    	<input type='text' size='2' name='rent_suc_fee_tm' maxlength='12' class='whitetext' value='<%=cont_etc.getRent_suc_fee_tm()%>' >회차						
					</td>					
					<td class=title width=10%>일자계산기준일</td>
					<td>&nbsp;
						<input type="text" name="rent_suc_fee_tm_b_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_fee_tm_b_dt())%>" size="11" maxlength='11' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value)'> 
						
					</td>					
				</tr>					
				<tr>
                    <td class=title width=13%>보증금</td>
                    <td width=50%>&nbsp;
    			    	원계약보증금
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계보증금
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
					</td>					
					<td class=title width=10%>보증금승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_grt_yn' disabled> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>선납금</td>
                    <td width=50%>&nbsp;
    			    	원계약선납금
						<input type='text' size='11' name='suc_pp_suc_o_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계선납금
						<input type='text' size='11' name='suc_pp_suc_r_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getPp_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
					</td>					
					<td class=title width=13%>선납금승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_pp_yn' disabled> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_pp_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_pp_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>개시대여료</td>
                    <td width=50%>&nbsp;
    			    	원계약개시대여료
						<input type='text' size='11' name='suc_ifee_suc_o_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계개시대여료
						<input type='text' size='11' name='suc_ifee_suc_r_amt' maxlength='12' class='whitenum' value='<%=AddUtil.parseDecimal(cont_etc.getIfee_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
					</td>					
					<td class=title width=13%>개시대여료승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_ifee_yn' disabled> 
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_ifee_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_ifee_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>	
				<tr>
                    <td class=title width=13%>미사용기간</td>
                    <td colspan='3'>&nbsp;
    			    	<input type='text' size='3' name='n_mon' maxlength='3' class='whitenum' value='<%=cont_etc.getN_mon()%>'>개월						
						<input type='text' size='3' name='n_day' maxlength='3' class='whitenum' value='<%=cont_etc.getN_day()%>'>일						
					</td>					
				</tr>									
            </table>
	    </td>
    </tr>
    <%}%>	
	<%if((now_stat.equals("계약승계") || now_stat.equals("차종변경")) && (String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경"))){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경전 원계약</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>		
    <tr> 
        <td class=line> 		
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
    		    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
                <tr> 
                    <td class=title width=13%>변경구분</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>변경일자</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <td class=title width=10%>고객</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                </tr>
    		    <tr>
        		    <td class=title>해지내역</td>
        			<td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
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
    		    <tr>
    		        <td class=title>해지내역</td>
    			    <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
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
	    <td class=h></td>
	</tr>
	<%if(!base.getCar_st().equals("2")){%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객</span>(<%=client.getClient_id()%>)</td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>상호/성명</td>
                    <td width='50%' align='left'>&nbsp;
                      <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='whitetext' readonly>        	      
        	    </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>지점/현장</td>
                    <td height="26" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='whitetext' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>        			  
        			</td>
                    <td width='10%' class='title'>개업년월일</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="open_year" value='<%=client.getOpen_year()%>' size='22' class='whitetext' readonly></td>					
                </tr>
                <tr>
                    <td class='title'>우편물주소</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>" class='whitetext'>						
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr" size="60" value="<%=base.getP_addr()%>" class='whitetext'>
						
					</td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='whitetext' onBlur='javascript:CheckLen(this.value,50)'></td>
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
                <%if(!client.getClient_st().equals("1")){ %>
                <tr>
                    <td class='title'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<%=base.getLic_no()%></td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자(<%=client.getClient_nm()%>)의 운전면허번호를 기재</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>차량이용자 운전면허번호</td>
		            <td width='15%'>&nbsp;<%=base.getMgr_lic_no()%></td>
		            <td width='20%'>&nbsp;이름 : <%=base.getMgr_lic_emp()%></td>
		            <td width='12%'>&nbsp;관계 : <%=base.getMgr_lic_rel()%></td>
		            <td width='40%'>&nbsp;(개인,개인사업자)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<%}%></td>
                </tr>  
                <%} %>
                
                <%
                	CarMgrBean mgr5 = new CarMgrBean();
                	for(int i = 0 ; i < mgr_size ; i++){
        				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        				if(mgr.getMgr_st().equals("추가운전자")){
            				mgr5 = mgr;
            			}
                	}	
        		%>
        		<%//if(mgr5.getMgr_st().equals("추가운전자")){ %>    
                <tr>
                    <td class='title'>추가운전자 운전면허번호</td>
		            <td>&nbsp;<%=mgr5.getLic_no()%></td>
		            <td>&nbsp;이름 : <%=mgr5.getMgr_nm()%></td>
		            <td>&nbsp;관계 : <%=mgr5.getEtc()%></td>
		            <td>&nbsp;</td>
                </tr>
                <%//} %>        	
                
                <!-- 운전자격검증결과 -->                    
                <tr>
                    <td class='title' rowspan='2' width='13%'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <%=base.getTest_lic_emp()%></td>
		            <td width='12%'>&nbsp;관계 : <%=base.getTest_lic_rel()%></td>
		            <td width='40%'>&nbsp;검증결과 : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;※ 개인고객은 계약자 본인을, 개인사업자/법인사업자 고객은 계약서상 차량이용자의 운전자격을 검증</td>
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
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="8%">근무처</td>			
                    <td class=title width="8%">부서</td>
                    <td class=title width="8%">성명</td>
                    <td class=title width="8%">직위</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="30%" class=title>E-MAIL</td>
                    <td width="5%" class=title>조회</td>
                </tr>
    		  <%String mgr_zip = "";
    			String mgr_addr = "";
    		  	for(int i = 0 ; i < mgr_size ; i++){
    				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    				if(mgr.getMgr_st().equals("차량이용자")){
    					mgr_zip = mgr.getMgr_zip();
    					mgr_addr = mgr.getMgr_addr();
    				}%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='<%=mgr.getCom_nm()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='<%=mgr.getMgr_dept()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='<%=mgr.getMgr_nm()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='<%=mgr.getMgr_tel()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='whitetext' onBlur='javascript:CheckLen(this.value,15)'></td>				
                    <td align='center'><input type='text' name="mgr_email" size='30' value="<%=mgr.getMgr_email()%>" class='whitetext'></td>
                    <td align='center'>-</td>
                </tr>
    		  <%	} %>
                <tr> 
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
					<td colspan=8>&nbsp;
						<input type="text" name="t_zip" id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr1" size="80" value="<%=mgr_addr%>" class='whitetext'>
					</td>					
                </tr>
            </table>
        </td>
    </tr>
	<%if(client.getClient_st().equals("2")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>소득정보</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td class=title width=13%>직업</td>
                    <td width=20%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='whitetext'></td>
                    <td class=title width=10%>소득구분</td>
                    <td colspan="3">&nbsp;
        			  <select name='c_pay_st' disabled>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>선택</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>급여소득</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>사업소득</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>기타사업소득</option>
        		            </select>
        			</td>
                </tr>
    		    <tr>
        		    <td class='title'>직장명</td>
        		    <td>&nbsp;<input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='15' class='whitetext'></td>
                    <td class=title width=10%>근속연수</td>
                    <td width=20%>&nbsp;<input type='text' size='2' name='wk_year' value='<%=client.getWk_year()%>' maxlength='2' class='whitetext'>년</td>
                    <td class=title width=10%>연소득</td>
                    <td>&nbsp;<input type='text' size='7'  name='pay_type' maxlength='9' class='whitetext' value='<%=client.getPay_type()%>'>&nbsp;만원
        			</td>
    		    </tr>		  
            </table>
        </td>
    </tr>
	<%}else{%>
	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>요약 재무제표</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
		        <tr>
		       
		            <td colspan="2" rowspan="2" class=title>구분<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>당기(
		                <input type='text' name='c_kisu' size='10' value='<%=c_fin.getC_kisu()%>' maxlength='20' class='whitetext' >
		            기)</td>
		            <td width="43%" class=title>전기(
		                <input type='text' name='f_kisu' size='10' value='<%=c_fin.getF_kisu()%>' maxlength='20' class='whitetext' >
		            기)</td>
		        </tr>
		        <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='whitetext' maxlength='11' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='10' class='whitetext' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='whitetext' maxlength='11' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='10' class='whitetext' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
		        </tr>
		        <tr>
		            <td colspan="2" class=title>자산총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>자<br>
		            본</td>
		            <td width="9%" class=title>자본금</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td class=title>자본총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>매출</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>당기순이익</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='whitenum' value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		    </table>	     
        </td>
    </tr>
	<%}%>
	<%if(!base.getCar_st().equals("5")){%>
    <tr id=tr_eval_st1 style='display:none'> 
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용등급</span></td>
    </tr>    
    <tr id=tr_eval_st2 style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>구분</td>
                    <td width="16%" class=title>상호/성명</td>
                    <td width="12%" class=title>판정기관</td>
                    <td width="13%" class='title'>신용평점</td>
                    <td width="16%" class='title'>신용등급</td>
                    <td width="16%" class='title'>평가(산출)일자</td>					
                    <td width="16%" class='title'>조회일자</td>
                </tr>
        		  <%
        		  	if(client.getClient_st().equals("2")){
        		  		if(eval3.getEval_nm().equals("")) eval3.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='3'><input type='hidden' name='e_seq' value='<%=eval3.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval3.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval3.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval3.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval3.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval3.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval3.getEval_off().equals("2")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        					%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval3.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("1") || eval3.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%
        		  	
        		  		if(eval5.getEval_nm().equals("")) eval5.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='5'><input type='hidden' name='e_seq' value='<%=eval5.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval5.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval5.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval5.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval5.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval5.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval5.getEval_off().equals("2") || eval5.getEval_off().equals("")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval5.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%}else{
        		  		if(eval1.getEval_nm().equals("")) eval1.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인<input type='hidden' name='eval_gu' value='1'><input type='hidden' name='e_seq' value='<%=eval1.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval1.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval1.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval1.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval1.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval1.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;"  disabled>
                          <option value="">선택</option>
        				  <%if(eval1.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval1.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("1") || eval1.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd3.length; i++){
        						CodeBean cd = gr_cd3[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
                    <td align="center"><input type='text' name='eval_b_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>					
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){
        		  			if(eval2.getEval_nm().equals("")) eval2.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='2'><input type='hidden' name='e_seq' value='<%=eval2.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval2.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval2.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval2.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval2.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval2.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval2.getEval_off().equals("2") || eval2.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval2.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			if(eval6.getEval_nm().equals("")) eval6.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='6'><input type='hidden' name='e_seq' value='<%=eval6.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval6.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval6.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval6.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval6.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval6.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval6.getEval_off().equals("2") || eval6.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval6.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>
        		  <%	
        		  		if(cont_etc.getClient_share_st().equals("1")){
        		  			if(eval7.getEval_nm().equals("")) eval7.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='7'><input type='hidden' name='e_seq' value='<%=eval7.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval7.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval7.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval7.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval7.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval7.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval7.getEval_off().equals("2") || eval7.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval7.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			if(eval8.getEval_nm().equals("")) eval8.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='6'><input type='hidden' name='e_seq' value='<%=eval6.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval8.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval8.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval8.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval8.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval8.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval8.getEval_off().equals("2") || eval8.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval8.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>        		  
        		  <%}%>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));
        				if(eval4.getEval_nm().equals("")) eval4.setEval_nm(String.valueOf(gur.get("GUR_NM")));
        				eval_cnt++;%>
                <tr>
                    <td class=title>연대보증인<%=i+1%><input type='hidden' name='eval_gu' value='4'><input type='hidden' name='e_seq' value='<%=eval4.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval4.getEval_nm()%>'></td>
                    <td align="center">
                      <select name='eval_off'  disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(eval4.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval4.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval4.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><%= eval4.getEval_score()%></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;" disabled>
                          <option value="">선택</option>
        				  <%if(eval4.getEval_off().equals("2") || eval4.getEval_off().equals("")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        					  for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
	                      		switch(eval4.getEval_gr()){
		                      		case "1": scope = "(955~1000)"; break;
		        					case "2": scope = "(907~954)"; break;
		        					case "3": scope = "(837~906)"; break;
		        					case "4": scope = "(770~836)"; break;
		        					case "5": scope = "(693~769)"; break;
		        					case "6": scope = "(620~692)"; break;
		        					case "7": scope = "(535~619)"; break;
		        					case "8": scope = "(475~534)"; break;
		        					case "9": scope = "(390~474)"; break;
		        					case "10": scope = "(1~389)"; break;
	                      		}
        						%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope %></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("1")){
        				    for(int j =0; j<gr_cd2.length; j++){
        						CodeBean cd = gr_cd2[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='whitetext' value='<%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	}
        		  	}%>
            </table>
        </td>
    </tr>
	  <input type='hidden' name="eval_cnt"			value="<%=eval_cnt%>">              
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>자산현황</span></td>
	</tr>

	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>구분</td>
                    <td colspan="2" class=title>물건지1</td>
                    <td colspan="2" class=title>물건지2</td>
                </tr>
                <tr>
                    <td width="15%" class=title>형태</td>
                    <td width="28%" class='title'>주소</td>
                    <td width="15%" class=title>형태</td>
                    <td width="29%" class='title'>주소</td>
                </tr>	  
        		  <%if(client.getClient_st().equals("2")){%>
                <tr>
                    <td class=title>계약자</td>
        			<td align="center">
        			<% zip_cnt++;%>
                      <select name='ass1_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip2" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr2" size="45" value="<%=eval3.getAss1_addr()%>" class='whitetext'>
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip3" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr3" size="45" value="<%=eval3.getAss2_addr()%>" class='whitetext'>
					</td>
                </tr> 
                  <% }else{%>
                <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip4" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr4" size="45" value="<%=eval1.getAss1_addr()%>" class='whitetext'>
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip5" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr5" size="45" value="<%=eval1.getAss2_addr()%>" class='whitetext'>
					</td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip6" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr6" size="45" value="<%=eval2.getAss1_addr()%>" class='whitetext'>
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip7" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr7" size="45" value="<%=eval2.getAss2_addr()%>" class='whitetext'>
					</td>
                </tr>
        		  <% 	} %>
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){%>
                <tr>
                    <td class=title>공동임차인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip6" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr6" size="45" value="<%=eval7.getAss1_addr()%>" class='whitetext'>
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip7" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr7" size="45" value="<%=eval7.getAss2_addr()%>" class='whitetext'>
					</td>
                </tr>
        		  <% 	} %>        		  
        		  <% } %>
        		  <%if(gur_size > 0){
        		  		for(int i = 0 ; i < gur_size ; i++){
        				Hashtable gur = (Hashtable)gurs.elementAt(i);
        				eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));%>		  	  
                <tr>
                    <td class=title>연대보증인<%=i+1%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip8" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr8" size="45" value="<%=eval4.getAss2_addr()%>" class='whitetext'>
					</td>
        			<% zip_cnt++;%>
        			<td align="center">
                      <select name='ass2_type'  disabled>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<td colspan=>&nbsp;
						<input type="text" name="t_zip" id="t_zip9" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>" class='whitetext'>
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr9" size="45" value="<%=eval4.getAss2_addr()%>" class='whitetext'>
					</td>
					<% zip_cnt++;%>
                </tr>
        		  <%	}
        		  	}%>		
            </table>
        </td>
    </tr>
    <tr id=tr_eval_st3 style='display:none'> 
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타참고사항</span></td>
    </tr>    
    <tr id=tr_eval_st4 style='display:none'> 
	<td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>기타</td>
                    <td>&nbsp;<textarea name='dec_etc' rows='5' cols='100' maxlenght='500' disabled><%=cont_etc.getDec_etc()%></textarea></td>
                </tr>
    		</table>	  
	</td>
    </tr>	
    <tr id=tr_eval_st5 style='display:none'> 
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용등급판정</span></td>
    </tr>   
    <tr id=tr_eval_st6 style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" rowspan="2" class=title>적용신용등급</td>
                    <td colspan="2" class=title>심사</td>
                    <td colspan="2" class=title>결재</td>
                </tr>
                <tr>
                    <td width="20%" class=title>담당자</td>
                    <td width="20%" class='title'>판정일자</td>
                    <td width="20%" class=title>결재자</td>
                    <td width="27%" class='title'>결재일자</td>
                </tr>
                <tr>
                    <td align="center">
        	        <%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>                                           
                            <select name='dec_gr' disabled>                          
                                <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>신설법인</option>
                                <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>일반고객</option>
                                <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>우량기업</option>
                                <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>초우량기업</option>
                            </select>  
                        
                    </td>                       
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%>
			<input type="hidden" name="dec_f_id" value="<%=cont_etc.getDec_f_id()%>">			
                    </td>
                    <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='whitetext' value="<%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%>
			<input type="hidden" name="dec_l_id" value="<%=cont_etc.getDec_l_id()%>">
                    </td>
                    <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value='<%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
	<%}%>
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
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_no()%> (<%=cr_bean.getCar_mng_id()%>)</td>
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
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[저공해]<%}%><%=cm_bean.getCar_name()%></td>
                </tr>
                <tr>
                    <td class='title'>소분류 </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0008", "", cm_bean.getS_st())%></td>
                    <td class='title' width="10%">차종코드</td>
                    <td>&nbsp;[<%=cm_bean.getJg_code()%>]<%=ej_bean.getCars()%></td>
                    <td class='title'>배기량</td>
                    <td>&nbsp;<%if(cr_bean.getCar_mng_id().equals("")){%><%=cm_bean.getDpm()%>cc<%}else{%><%=cr_bean.getDpm()%>cc<%}%></td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td colspan="5">&nbsp;<%=car.getConti_rat()%></td>
                </tr>
                <tr>
                    <td class='title'>GPS위치추적정치</td>
                    <td colspan="5">&nbsp;
        			  <%if(cr_bean.getGps().equals("Y")){%>장착<%}else{%>미장착<%}%>
					  </td>
                </tr>								
                <tr>
                    <td class='title'>기본사양</td>
                    <td colspan="5" align=center>
                        <table width=99% border=0 cellspacing=0 cellpadding=0>
                            <tr>
                                <td style='height:5'></td>
                            </tr>
                            <tr>
                                <td>
        			  <%if(!cm_bean2.getCar_name().equals("")){%>
        			      <font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font>
        			  <%}%>
        			  <%=cm_bean.getCar_b()%></td>
        			        </tr>
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
            </table>
        </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>

    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title'>색상</td>
                    <td colspan="5">&nbsp;                        
        			  <input type='text' name='color' size='45' maxlength='100' class='whitetext' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (내장색상(시트): <input type='text' name="in_col" size='20' class='whitetext' value='<%=car.getIn_col()%>'> )  
					  (가니쉬: <input type='text' name="garnish_col" size='20' class='whitetext' value='<%=car.getGarnish_col()%>'> )  
        			  </td>
                </tr>		
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
                <tr>
                    <td class='title'>전기차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="ecar_loc_st" disabled>
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>        			  
        			  </td>
                </tr>
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
                <tr>
                    <td class='title'>수소차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="hcar_loc_st" disabled>
                    	  <option value=""  <%if(pur.getHcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code37_size ; i++){
                            CodeBean code = code37[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getHcar_loc_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>        
                      </select>        			  
        			  </td>
                </tr>
                <%}%>                
                <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-연료종류%>
                <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
                    <td class='title'>맑은서울스티커 발급<br>(남산터널 이용 전자태그)</td>
                    <%-- <td colspan="5">&nbsp;
                        <select name="eco_e_tag" disabled>
                    	  <option value=""  <%if(car.getEco_e_tag().equals(""))%>selected<%%>>선택</option>
                        <option value="0" <%if(car.getEco_e_tag().equals("0"))%>selected<%%>>미발급</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>발급</option>
                      </select>
                      &nbsp;※ 친환경차 고객 중 남산터널 실이용자만 발급 선택, 하이브리드/플러그인 하이브리드 차량의 경우 서울등록으로 대여료가 소폭 상승됨.
        			      </td> --%>
        			<td colspan="5">&nbsp;<%String eco_e_tag = car.getEco_e_tag();%><%if(eco_e_tag.equals("0")){%>미발급<%}else if(eco_e_tag.equals("1")){%>발급<%}%></td>
        			<input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">
                </tr>		
                <%}%>
                <tr>
                    <td class='title'>차량인수지</td>
                    <td colspan="5">&nbsp;
                        <select name="udt_st" disabled>
                        <option value=''>선택</option>
                    	  <%for(int i = 0 ; i < code35_size ; i++){
                            CodeBean code = code35[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getUdt_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
        			  &nbsp; 인수시 탁송료 :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원 (고객인수일 때는 직접 입력하세요.)
        			  </td>
                </tr>			  
                <tr>
                    <td width='13%' class='title'>등록지역</td>
                    <td width='20%'>&nbsp;
                      <select name="car_ext" disabled>
                        	<option value=''>선택</option>
                    	  <%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select></td>
                    <td width='10%' class='title'>썬팅</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='whitetext'> %
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
	                    <td width='10%' class='title'>블루링크여부</td>
	                    <td>&nbsp;
	                        <select name="bluelink_yn" disabled>
	                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>선택</option>
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>있음</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>없음</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;※ 있음선택시 블루링크 가입 안내문 알림톡발송(스케줄생성시)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'>LPG키트</td>
                    <td colspan="5" >
        			    <table width="100%" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                              <td width="80">&nbsp;
                                  <select name='lpg_yn' disabled>
                                    <option value="">선택</option>
                                    <option value="Y" <%if(car.getLpg_yn().equals("Y")) out.println("selected");%>>장착</option>
                                    <option value="N" <%if(car.getLpg_yn().equals("N")) out.println("selected");%>>미장착 </option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_setter' disabled>
                                    <option value=''>선택</option>
                                    <option value='1' <%if(car.getLpg_setter().equals("1")){%> selected <%}%>>고객장착</option>
                                    <option value='2' <%if(car.getLpg_setter().equals("2")){%> selected <%}%>>월대여료포함</option>
                                  </select>
                              </td>
                              <td width="110">&nbsp;
                                  <select name='lpg_kit' disabled>
                                    <option value=''>선택</option>
                                    <option value='1' <%if(car.getLpg_kit().equals("1")){%> selected <%}%>>간접분사</option>
                                    <option value='2' <%if(car.getLpg_kit().equals("2")){%> selected <%}%>>직접분사</option>
                                    <option value='3' <%if(car.getLpg_kit().equals("3")){%> selected <%}%>>장착불가</option>
                                  </select>
                              </td>
                              <td>&nbsp;
                                  <input type='text' name='lpg_price' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(car.getLpg_price())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
            					  원 </td>
                            </tr>
                        </table>
        			</td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">출고후추가장착</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='65' class="whitetext" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적반영분,LPG키트제외,네비게이션등)</font></span>
                    </td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">견적반영용품</span></td>
                    <td colspan="5">&nbsp;
                      <label><input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2채널 블랙박스</label>
                      &nbsp;
                      <label><input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> 전면 썬팅(기본형)</label>,
                      가시광선투과율 :
                      <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='whitetext'>
        	      % 
      		      &nbsp;
      		      <label><input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> 고급썬팅</label>
      		      &nbsp;&nbsp;내용 <input type="text" name="tint_ps_nm" size="9" value='<%=car.getTint_ps_nm()%>'>
      		      &nbsp; 금액 <input type="text" name="tint_ps_amt" size="9" value='<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> 원 (부가세별도)
				      <br>
      		      &nbsp;
                      <label><input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> 전면썬팅 미시공 할인</label>  
      		      &nbsp;
                      <label><input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> 블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)</label>  
				  &nbsp;
                      <label><input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> 추가탁송료등 </label>  
					  <input type="text" name="tint_cons_amt" size="9" value='<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);compare(0, this);'> 원
      		      &nbsp;
                      <label <%if(!car.getTint_n_yn().equals("Y")){%>style="display: none;"<%}%>><input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> 거치형 내비게이션</label>
                      <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
      		      &nbsp;
                      <label><input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> 이동형 충전기(전기차)</label>
                      <%}%>   
                  &nbsp;
                      	번호판구분
                      <!-- 신형번호판신청 -->
                   	<select name="new_license_plate">
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>신형</option>
                   		<option value="0" <%if (!(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2"))) {%>selected<%}%>>구형</option>
                   		<%-- <option value="" <%if (car.getNew_license_plate().equals("")) {%>selected<%}%>>요청없음</option>
                   		<option value="1" <%if (car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")) {%>selected<%}%>>신청</option> --%>
<%--                    		<option value="1" <%if (car.getNew_license_plate().equals("1")) {%>selected<%}%>>수도권</option> --%>
<%--                    		<option value="2" <%if (car.getNew_license_plate().equals("2")) {%>selected<%}%>>대전/대구/광주/부산</option> --%>
                   	</select>                   
                      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    </td>
                </tr>   
                <tr>
                    <td class='title'><span class="title1">서비스품목</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='65' class="whitetext" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적미반영분)</font></span><br>
        					  &nbsp;<input type="checkbox" name="serv_b_yn" value="Y" <%if(car.getServ_b_yn().equals("Y")){%>checked<%}%>> 블랙박스 (2015년8월1일부터)
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
        					  &nbsp;<input type="checkbox" name="serv_sc_yn" value="Y" <%if(car.getServ_sc_yn().equals("Y")){%>checked<%}%>> 고정형충전기
        					  <%} %>
                    </td>
                </tr>		  
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;
                        <textarea rows='5' cols='90' name='remark' disabled><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
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
                      <select name="purc_gu" disabled>
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
        			<select name="car_origin" disabled>
                        <option value="">선택</option>
                        <option value="1" <%if(car_origin.equals("1")){%> selected <%}%>>국산</option>
                        <option value="2" <%if(car_origin.equals("2")){%> selected <%}%>>수입</option>
                      </select></td>
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
                    <td width="13%" class='title'>합계</td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="13%" class='title'>합계</td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>차량가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>탁송료</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title><span class="b">매출D/C</span></td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                </tr>
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>개소세 감면액</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
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
                      <select name='pay_st' disabled>
                        <option value="">선택</option>
                        <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>과세</option>
                        <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>면세</option>
                      </select>
                    </td>
                    <td class='title'>특소세</td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>교육세</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>합계</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				원</td>
                </tr>
            </table>		
	    </td>
    </tr>			  
    <tr id=tr_car0 style="display:<%if(!base.getCar_gu().equals("1") || fee_size > 1){%>''<%}else{%>none<%}%>"> 
	<%	int sh_car_amt = 0;
		String sh_year= "";
		String sh_month = "";
		String sh_day = "";
		String sh_day_bas_dt = "";
		int sh_amt = 0;
		float sh_ja = 0;
		int sh_km = 0;
		int sh_tot_km = 0;
		String sh_km_bas_dt = "";
		String sh_init_reg_dt = "";
		if(!base.getCar_gu().equals("1") || fee_size > 1){
				sh_car_amt 		= fee_etc.getSh_car_amt();
				sh_year 		= fee_etc.getSh_year();
				sh_month 		= fee_etc.getSh_month();
				sh_day	 		= fee_etc.getSh_day();
				sh_amt			= fee_etc.getSh_amt();
				sh_ja			= fee_etc.getSh_ja();
				sh_km			= fee_etc.getSh_km();
				sh_tot_km		= fee_etc.getSh_tot_km();
				sh_km_bas_dt	= fee_etc.getSh_km_bas_dt();
				sh_init_reg_dt	= fee_etc.getSh_init_reg_dt();
				sh_day_bas_dt	= fee_etc.getSh_day_bas_dt();
				if(sh_tot_km==0) sh_tot_km = a_db.getSh_tot_km(base.getCar_mng_id(), fee_etc.getSh_km_bas_dt());
				
				if(sh_year.equals("")){
					sh_year 	= String.valueOf(carOld.get("YEAR"));
					sh_month 	= String.valueOf(carOld.get("MONTH"));
					sh_day	 	= String.valueOf(carOld.get("DAY"));
				}
		}
		if(sh_init_reg_dt.equals("")) sh_init_reg_dt = cr_bean.getInit_reg_dt();
	%>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='whitenum' readonly >
        				  원 <%if(base.getCar_gu().equals("0")){%><a href="javascript:view_car_amt();"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%>
        				  <input type='hidden' name="view_car_amt" value=""></td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="10%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='whitenum' readonly >
					  %</td>
                    <td class='title' width='10%'><%if(base.getCar_gu().equals("0")){%>
                      중고차가
                        <%}else if(base.getCar_gu().equals("2")){%>
                        중고차구입가
                    <%}%></td>
                  <td width="37%">&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='whitenum'  readonly>
					  원
					  </td>
                </tr>
                <tr>
                  <td class='title'>차령</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_year' value='<%=sh_year%>'size='1' class='white' >
                    년
                    <input type='text' name='sh_month' value='<%=sh_month%>'size='2' class='white' >
                    개월
                    <input type='text' name='sh_day' value='<%=sh_day%>'size='2' class='white' >
                    일 (최초등록일
                    <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='white' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~계약일
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' >
				  

                  )				  
				  </td>
                </tr>
                <tr>				  
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='whitenum' >
					  km ( <%if(fee_size==1){%>계약일 <%}else{%> 대여개시일<%}%>
					  <input type='text' name='sh_day_bas_dt2' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' > 
					  ) / 확인주행거리 
					  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal(sh_tot_km) %>' class='whitenum' >
					  km ( 최종확인일
					  <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(sh_km_bas_dt) %>' class='white' >
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
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>' size='10' class='whitetnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_bank_amt' value='<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
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
        		<input type='text' name='r_import_cash_back' value='<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_bank_amt' value='<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
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
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>보조금수령방식</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st' disabled>
        		            	<option value="">선택</option>
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
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22세이상</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28세이상</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35세이상~49세이하</option>
                          </select></td>
                    <td width="10%" class=title >대물배상</td>
                    <td width="20%">&nbsp;
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
                        <select name='insurant' disabled>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select></td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                      </select></td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>운전자범위</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext' disabled>
                          <option value="">선택</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>모든사람</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>가족한정</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>기타</option>
                      </select>
        			</td>
                    <td width="10%" class=title >운전자연령</td>
                    <td>&nbsp;
                        <select name='driving_age' disabled>
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
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22세이상</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28세이상</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35세이상~49세이하</option>					  						  
                      </select></td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn' disabled>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select></td>                        
                </tr>
                <tr>
                    <td width="13%" class=title>대인배상</td>
                    <td width="20%">&nbsp; 무한(대인배상Ⅰ,Ⅱ)</td>
                    <td width="10%" class=title>대물배상</td>
                    <td class=''>&nbsp;
                        <select name='gcp_kd' disabled>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                      </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td>&nbsp;
                        <select name='bacdt_kd' disabled>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>무보험차상해</td>
                    <td>&nbsp;
                      <select name='canoisr_yn' disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>            </td>
                    <td class=title>자기차량손해</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn' disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>              </td>
                    <td class=title >긴급출동</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn' disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>자차면책금</td>
                    <td>&nbsp;
        			<input type='text' size='12' maxlength='10' name='car_ja' class='whitenum' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			원</td>
                    <td class=title>변경사유</td>
                    <td class=''>&nbsp;
                      <input type='text' size='18' name='ja_reason' class='whitetext' value='<%=cont_etc.getJa_reason()%>'></td>
                    <td class=title >결재자</td>
                    <td class=''>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">			
                        (기본 <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>원) </td>
                </tr>
                <tr>
                    <td  class=title>자동차</td>
                    <td colspan="5">&nbsp;
                      <select name="air_ds_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAir_ds_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>
        				운전석에어백
        		&nbsp; 					
        			  <select name="air_as_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAir_as_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				조수석에어백
        	      &nbsp; 			
                      <select name="blackbox_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				블랙박스        				
        				<br/>
        	      &nbsp; 	
                      <select name="lkas_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				차선이탈(제어형)	
       			&nbsp; 			
                      <select name="ldws_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				차선이탈(경고형)	
       			&nbsp; 			
                      <select name="aeb_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				긴급제동(제어형)	
       			&nbsp; 			
                      <select name="fcw_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				긴급제동(경고형)	
       			&nbsp; 			
                      <select name="ev_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				전기자동차
				&nbsp; 			
                      <select name="hook_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				견인고리(트레일러용)
				&nbsp; 			
                      <select name="legal_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>	
        				법률비용지원금(고급형)
        				&nbsp; 			
                      <select name="top_cng_yn" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getTop_cng_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getTop_cng_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				탑차(구조변경)
        				<br/>
        				&nbsp;  
        				기타장치 : 
                      <input type="text" class="whitetext" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50"> <!-- (견인고리 등 기타장치) -->
                      </td>
                </tr>
                <tr>
                    <td  class=title>차량관리<br>서&nbsp;비&nbsp;스<br>제공범위</td>
                    <td colspan="5">&nbsp;
                      		  <input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  사고대차서비스<%if(ac_dae_yn_chk.equals("N")){%>(피해사고시 제외)<%}%><br>
        			  &nbsp;
        			  <input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>> 
        			  교통사고 발생시 사고처리 업무대행 (보험사 관련 업무 등) <br>
        			  &nbsp;
        			  <%if(cyc_yn_chk.equals("Y")){%>
        			  <input type="checkbox" name="cyc_yn" 		value="Y" <%if(cont_etc.getCyc_yn().equals("Y")){%>checked<%}%>> 
                      		  매 7,000km 또는 고객요청시 순회점검 서비스 실시 <br>
        			  &nbsp;        			  
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  일체의 정비서비스(내부구성부품 및 소모품 교환, 엔진오일 교환 등) <br>
        			  &nbsp;
                      		  <%}else{%>
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  일체의 정비서비스(각종 내구성부품/소모품  점검,교환,수리) * 제조사 차량 취급설명서 기준 <br>
        			  &nbsp;
                      		  <%}%>
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
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='whitetext'>
                      				&nbsp;대리점 : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='whitetext'>
                      				&nbsp;담당자 :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='whitetext'>
                					&nbsp;연락처 :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='whitetext'>
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
					  <select name='cacdt_mebase_amt'  disabled>
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  / (최대)자기부담금 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  / (최소)자기부담금  
                      <select name='cacdt_memin_amt' disabled>
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
                        <textarea rows='3' cols='90' name='others'><%=base.getOthers()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>	
	<%if(!base.getCar_st().equals("2")){%>
	<tr id=tr_gi style='display:none'>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>


	<%	
		for(int f=1; f<=gin_size ; f++){
			ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));			
			
			if(f<gin_size ){%>   
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1'  <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		가입
                  		<input type='radio' name="gi_st" value='0'  <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		면제 </td>
                </tr>			       
                <tr id=tr_gi<%=f+1%> style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='ext_gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='ext_gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='ext_gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='whitetext'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='ext_gi_amt' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                    <td class=title >보증보험료</td>
                    <td>&nbsp;
                        <input type='text' name='ext_gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                </tr>
	<%		}else{//마지막회차%>	 
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1'  <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		가입
                  		<input type='radio' name="gi_st" value='0'  <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		면제 </td>
                </tr>	               
                <tr id=tr_gi<%=f+1%> style="display:<%if(ext_gin.getGi_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='whitetext'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                    <td class=title >보증보험료</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                </tr>	
	<%		}%>
	<%	}%>                	
            </table>
        </td>
    </tr>
<%--     <%if(client.getClient_st().equals("1")){%>	 --%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
<%--     <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
    <tr id='tr_client_share_st'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				있다
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%>>
        				없다</td>
                </tr>
                <!-- 운전자격검증결과 -->
                <%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){ %>    
                <tr>
                    <td class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <%=base.getTest_lic_emp2()%></td>
		            <td width='12%'>&nbsp;관계 : <%=base.getTest_lic_rel2()%></td>
		            <td width='40%'>&nbsp;검증결과 : <%=c_db.getNameByIdCode("0050", "", base.getTest_lic_result2())%></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(개인)&nbsp;※ 개인고객의 공동임차인이 있는 경우 운전자격을 검증</td>
                </tr>  
                <%} %>
            </table>  
        </td>
    </tr>           	    
    <tr id=tr_client_guar_st style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				입보
        			  <input type='radio' name="client_guar_st" value='2' <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				면제</td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con' disabled>
                          <option value="">선택</option>
                          <option value="6" <%if(cont_etc.getGuar_con().equals("6")){%>selected<%}%>>대표공동임차</option>
                          <option value="1" <%if(cont_etc.getGuar_con().equals("1")){%>selected<%}%>>신용우수법인</option>
                          <option value="2" <%if(cont_etc.getGuar_con().equals("2")){%>selected<%}%>>선수금으로대체</option>
                          <option value="3" <%if(cont_etc.getGuar_con().equals("3")){%>selected<%}%>>보증보험으로대체</option>
                          <option value="5" <%if(cont_etc.getGuar_con().equals("5")){%>selected<%}%>>전문경영인</option>
                          <option value="4" <%if(cont_etc.getGuar_con().equals("4")){%>selected<%}%>>기타 결재획득</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>결재자</td>
                    <td class='left'>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(cont_etc.getGuar_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="guar_sac_id" value="<%=cont_etc.getGuar_sac_id()%>">			
        	    </td>
                </tr>
            </table>  
        </td>
    </tr>
<%--     <%}%> --%>
    <tr id=tr_guar_st style='display:none'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증유무</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' <%if(cont_etc.getGuar_st().equals("1")){%>checked<%}%>>
        				입보
        			  <input type='radio' name="guar_st" value='2' <%if(cont_etc.getGuar_st().equals("2")){%>checked<%}%>>
        				면제</td>
                </tr>
                <tr id=tr_guar2 <%if(cont_etc.getGuar_st().equals("1")){%>style="display:''"<%}else{%>style='display:none'<%}%>>
                    <td height="26" colspan="4" class=line>
        			    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>구분</td>
                                <td width="10%" class=title>성명</td>
                                <td width="15%" class='title'>생년월일</td>
                                <td width="28%" class='title'>주소</td>
                                <td width="13%" class='title'>연락처</td>
                                <td width="16%" class='title'>관계</td>
                                <td width="5%" class='title'>조회</td>
                            </tr>
                      <%for(int i = 0 ; i < gur_size ; i++){
        					Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=gur.get("GUR_ID")%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='whitetext' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='whitetext' value='<%=AddUtil.ChangeEnpH(String.valueOf(gur.get("GUR_SSN")))%>'></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='whitetext' value='<%=gur.get("GUR_ZIP")%>' readonly>&nbsp;<input type='text' name="t_addr" size='25' class='whitetext' value='<%=gur.get("GUR_ADDR")%>'></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='whitetext' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='whitetext' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"></td>
                            </tr>
                      <%}%>
                        </table>
        			</td>			
                </tr>
            </table>  
        </td>
    </tr>   
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>채권확보</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td height="26" colspan="4" class=line>
        		<table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="6%" rowspan="4" class=title>계약<br>구분</td>
				<td width="7%" rowspan="4" class=title>차량<br>구분</td>
                                <td colspan="5" class=title>신용평가</td>
                                <td colspan="3" class=title>채권확보</td>
                                <td colspan="2" class=title>대여료DC</td>
                            </tr>
                            <tr>
                              <td rowspan="3" class=title>심사대상</td>
                              <td rowspan="3" class=title>평가기관</td>
                              <td rowspan="3" class=title>신용평점</td>
                              <td rowspan="3" class=title>평가등급</td>
                              <td rowspan="3" class=title>기준(조회)<br>일자</td>
                              <td class=title>선수구분</td>
                              <td class=title>연대보증유무</td>
                              <td class=title>결재자</td>
                              <td class=title>금액</td>
                              <td class=title>적용근거</td>
                            </tr>
                            <tr>
                              <td class=title>금액</td>
                              <td rowspan="2" class=title>계약자와의<br>관계</td>
                              <td rowspan="2" class=title>결재일자</td>
                              <td rowspan="2" class=title>DC율</td>
                              <td class=title>결재자</td>
                            </tr>
                            <tr>
                              <td class=title>채권확보율</td>
                              <td class=title>결재(기준)일자</td>
                            </tr>
                            <tr>
                              <td rowspan="4" align='center'>
                                <%if(base.getRent_st().equals("1")){%>신규<%}%>
                                <%if(base.getRent_st().equals("3")){%>대차<%}%>
                                <%if(base.getRent_st().equals("4")){%>증차<%}%>
                                <%if(base.getCar_st().equals("5")){%>업무대여<%}%>
                              </td>
                              <td rowspan="4" align='center'><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>							  
                              <td width="8%" align='center'><%if(client.getClient_st().equals("1")){%>법인<%}else if(client.getClient_st().equals("2")){%>-<%}else{%>사업장<%}%></td>
                              <td width="8%" align='center'>
                                <%if(eval1.getEval_off().equals("1")){%>크레탑<%}%>
                                <%if(eval1.getEval_off().equals("2")){%>NICE<%}%>
                                <%if(eval1.getEval_off().equals("3")){%>KCB<%}%>                              
                              </td>
                              <td width="8%" align='center'><%=eval1.getEval_score()%></td>
                              <td width="8%" align='center'>
                              	<%if(!eval1.getEval_off().equals("3")){%>
                              		<%=c_db.getNameByIdCode("0013", "", eval1.getEval_gr())%>
                              	<%} else{
                              		String scope = "";
                              		switch(eval1.getEval_gr()){
        	                      		case "1": scope = "(955~1000)"; break;
        	        					case "2": scope = "(907~954)"; break;
        	        					case "3": scope = "(837~906)"; break;
        	        					case "4": scope = "(770~836)"; break;
        	        					case "5": scope = "(693~769)"; break;
        	        					case "6": scope = "(620~692)"; break;
        	        					case "7": scope = "(535~619)"; break;
        	        					case "8": scope = "(475~534)"; break;
        	        					case "9": scope = "(390~474)"; break;
        	        					case "10": scope = "(1~389)"; break;
                              		}
                              	%>
                              		<%=c_db.getNameByIdCode("0013", "", eval1.getEval_gr())%><%=scope%>
                              	<%} %>
                              </td>
                              <td width="8%" align='center'><%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%></td>
                              <td width="10%" align='center'>
                                  <%if(max_fee.getGrt_amt_s()+max_fee.getPp_s_amt()+max_fee.getIfee_s_amt()>0){%>
                                  	현금
                                      <%if(max_gin.getGi_amt()>0){%>
				          + 보증보험
				      <%}%>    
                                  <%}else{%>  
                                      <%if(max_gin.getGi_amt()>0){%>
				          보증보험
				      <%}else{%>    
                                  	-                                    	
                                      <%}%>
                                  <%}%>                                
                              </td>
                              <td width="9%" align='center'>
                                <%if(cont_etc.getClient_guar_st().equals("1") || cont_etc.getGuar_st().equals("1")){%>유<%}else{%>무<%}%>
                              </td>
                              <td width="10%" align='center'><%=c_db.getNameById(fee_etc.getCredit_sac_id(), "USER")%></td>
                              <td width="8%" align='center'><%=AddUtil.parseDecimal(max_fee.getInv_s_amt()+max_fee.getInv_v_amt()-max_fee.getFee_s_amt()-max_fee.getFee_v_amt())%>원</td>
                              <td width="10%" align='center'>
                                <%if(fee_etc.getDc_ra_st().equals("1")){%>정상DC조건<%}%>
                                <%if(fee_etc.getDc_ra_st().equals("2")){%>특별DC<%}%>
                              </td>
                            </tr>
                            <%	ContEvalBean eval = new ContEvalBean();
                            	if(client.getClient_st().equals("2")){
                            		eval = eval3;
                            	}else{                            	
					if(!cont_etc.getClient_guar_st().equals("2")){
						eval = eval2;
					}else{					
						if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
							eval = eval7;
						}
					}
                            	}
                            %>
                            <tr>
                              <td rowspan="2" align='center'><%if(client.getClient_st().equals("1")){%>대표자<%}else if(client.getClient_st().equals("2")){%>개인<%}else{%>대표자<%}%></td>
                              <td align='center'>
                                <%if(eval.getEval_off().equals("1")){%>크레탑<%}%>
                                <%if(eval.getEval_off().equals("2")){%>NICE<%}%>
                                <%if(eval.getEval_off().equals("3")){%>KCB<%}%>                              
                              </td>
                              <td align='center'><%=eval.getEval_score()%></td>
                              <td width="10%" align='center'>
                              	<%if(!eval.getEval_off().equals("3")){%>
                              		<%=c_db.getNameByIdCode("0013", "", eval.getEval_gr())%>
                              	<%} else{
                              		String scope = "";
                              		switch(eval.getEval_gr()){
        	                      		case "1": scope = "(955~1000)"; break;
        	        					case "2": scope = "(907~954)"; break;
        	        					case "3": scope = "(837~906)"; break;
        	        					case "4": scope = "(770~836)"; break;
        	        					case "5": scope = "(693~769)"; break;
        	        					case "6": scope = "(620~692)"; break;
        	        					case "7": scope = "(535~619)"; break;
        	        					case "8": scope = "(475~534)"; break;
        	        					case "9": scope = "(390~474)"; break;
        	        					case "10": scope = "(1~389)"; break;
                              		}
                              	%>
                              		<%=c_db.getNameByIdCode("0013", "", eval.getEval_gr())%><%=scope%>
                              	<%} %>
                              </td>
                              <td width="10%" align='center'><%=AddUtil.ChangeDate2(eval.getEval_s_dt())%></td>
                              <td align='center'><input type='text' size='10' name='stat_credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(max_fee.getCredit_r_amt())%>' readonly>원</td>
                              <td rowspan="2" align='center'>&nbsp;
                                <%if(cont_etc.getClient_guar_st().equals("1")){%>대표
                                <%}else{%>
                                  <%if(cont_etc.getGuar_st().equals("1")){%>
                                    <%for(int i = 0 ; i < gur_size ; i++){
        					Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
        					<%=gur.get("GUR_REL")%> &nbsp;       					
        			    <%}%>		
                                  <%}%>
                                <%}%>
                              </td>
                              <td rowspan="2" align='center'><%=AddUtil.ChangeDate2(fee_etc.getCredit_sac_dt())%></td>
                              <td rowspan="2" align='center'><%=max_fee.getDc_ra()%>%</td>
                              <td align='center'>&nbsp;
                                <%if(fee_etc.getDc_ra_st().equals("1")){%>정상조건
                                <%}else{%>
                                  <%=c_db.getNameById(fee_etc.getDc_ra_sac_id(), "USER")%>
                                <%}%>
                              </td>
                            </tr>
                            <%	if(client.getClient_st().equals("2")){
                            		eval = eval5;
                            	}else{                            	
					if(!cont_etc.getClient_guar_st().equals("2")){
						eval = eval6;
					}else{					
						if(client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
							eval = eval8;
						}
					}
                            	}
                            %>
                            
                            <tr>
                              <td align='center'>
                                <%if(eval.getEval_off().equals("1")){%>크레탑<%}%>
                                <%if(eval.getEval_off().equals("2")){%>NICE<%}%>
                                <%if(eval.getEval_off().equals("3")){%>KCB<%}%>                              
                              </td>
                              <td align='center'><%=eval.getEval_score()%></td>
                              <td width="10%" align='center'>
                              	<%if(!eval.getEval_off().equals("3")){%>
                              		<%=c_db.getNameByIdCode("0013", "", eval.getEval_gr())%>
                              	<%} else{
                              		String scope = "";
                              		switch(eval.getEval_gr()){
        	                      		case "1": scope = "(955~1000)"; break;
        	        					case "2": scope = "(907~954)"; break;
        	        					case "3": scope = "(837~906)"; break;
        	        					case "4": scope = "(770~836)"; break;
        	        					case "5": scope = "(693~769)"; break;
        	        					case "6": scope = "(620~692)"; break;
        	        					case "7": scope = "(535~619)"; break;
        	        					case "8": scope = "(475~534)"; break;
        	        					case "9": scope = "(390~474)"; break;
        	        					case "10": scope = "(1~389)"; break;
                              		}
                              	%>
                              		<%=c_db.getNameByIdCode("0013", "", eval.getEval_gr())%><%=scope%>
                              	<%} %>
                              </td>
                              <td width="10%" align='center'><%=AddUtil.ChangeDate2(eval.getEval_s_dt())%></td>
                              <td align='center'><input type='text' size='4' name='stat_credit_r_per' class='whitenum' value='<%=max_fee.getCredit_r_per()%>' readonly>%</td>
                              <td align='center'><%=AddUtil.ChangeDate2(max_fee.getBas_dt())%></td>
                            </tr>
                            <tr>
                              <td align='center'>계약자</td>
                              <td align='center'>자체평가</td>
                              <td align='center'></td>
                              <td align='center'>
                                <%if(cont_etc.getDec_gr().equals("3")){%>신설법인<%}%>
                                <%if(cont_etc.getDec_gr().equals("0")){%>일반고객<%}%>
                                <%if(cont_etc.getDec_gr().equals("1")){%>우량기업<%}%>
                                <%if(cont_etc.getDec_gr().equals("2")){%>초우량기업<%}%>
                              </td>
                              <td align='center'><%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%></td>
                              <td colspan="5" class=title>자체평가등급=신차(초우량), 재리스(우량), 연장(기존등급) 기준을 일괄적용함</td>
                            </tr>
                            <tr>
                              <td colspan="2" class=title>적요</td>
                              <td colspan="5">&nbsp;<%=cont_etc.getDec_etc()%></td>
                              <td colspan="3">&nbsp;선수금=현금(<%=AddUtil.parseDecimal(max_fee.getGrt_amt_s()+max_fee.getPp_s_amt()+max_fee.getPp_v_amt()+max_fee.getIfee_s_amt()+max_fee.getIfee_v_amt())%>원)+보증보험증권(<%=AddUtil.parseDecimal(max_gin.getGi_amt())%>원)</td>
                              <td colspan="2">&nbsp;<%=fee_etc.getDc_ra_etc()%></td>
                            </tr>      
                        </table>
        	    </td>			
                </tr>
            </table>  
        </td>
    </tr>     
         
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
    </tr>
	<%	for(int f=1; f<=fee_size; f++){
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			if(fee_size >1 && f==(fee_size-1)){
				fee_opt_amt = fees.getOpt_s_amt()+fees.getOpt_v_amt();
			}
			
			if(f<fee_size){%>	
    <tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 	
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%if(f >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fee_etc.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>		
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="ext_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext'>
            			 개월</td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="ext_rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                      <input type="text" name="ext_rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value);'></td>
                  </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr>
                    <td colspan="2" class='title'>구분</td>
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width='4%'>입금</td>
                    <td class='title' width="28%">계약조건</td>
                    <td class='title' width='20%'>정상조건</td>
                  </tr>
                  <tr>
                    <td width="3%" rowspan="3" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title'>보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='ext_grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='ext_gur_p_r_per' class='whitenum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>
					<%if(fee_size==1 && f==1 && base.getRent_st().equals("3")){%>
					  대차 보증금 승계여부 :
					  <select name='ext_grt_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	
					<%}else{%>
        			  <%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%>
        			  <input type='hidden' name='ext_gur_suc_yn' value='<%=fees.getGrt_suc_yn()%>'>
					<%}%>
        			  <input type='hidden' name='ext_gur_per' value=''>
        			  <input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'>
						</td>
                  </tr>
                  <tr>
                    <td class='title'>선납금</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='ext_f_pere_r_per' class='whitenum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				  </td>
                    <td align='center'>-<input type='hidden' name='ext_pere_per' value=''>
           선납금 계산서발행구분 :
					<select name='pp_chk' disabled>
                              <option value="">선택</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>납부일시발행</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>매월균등발행</option>
                            </select>                       	
                    	</td>
                  </tr>
                  <tr>
                    <td class='title'>개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ext_ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='ext_pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료 </td>
                    <td align='center'>
        			  <%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%>
        			  <input type='hidden' name='ifee_suc_yn' value='<%=fees.getIfee_suc_yn()%>'>
        			  <input type='hidden' name='ext_pere_mth' value=''></td>
                  </tr>
                <tr>                                     
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>
              <!--20130605 약정운행주행거리 운영-->    
                <td class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='ext_agree_dist' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='ext_rtn_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <%}else{ %>
                  <input type="hidden" name="ext_rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">                  
                  <%} %>
                  <input type="hidden" name="ext_rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <br>&nbsp;                    
                  (약정초과운행시) 초과운행대여료 <input type='text' name='ext_over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='ext_over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                  -->
                  <input type="hidden" name="ext_agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!--       
                  <select name='ext_agree_dist_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>선택</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>전액면제(기본식)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%만 납부(일반식)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>매입옵션 없음(기본식,일반식)</option>
                  </select>	
                  -->
                </td>
                <td align='center'>-
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;">보유차주행거리</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='ext_over_bas_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
                        km
                        (재리스 계약시점 보유차 주행거리, 계약서 기재 값)
                        <!-- 
                        ,
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        예상 주행거리 <input type='text' name='ext_cust_est_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1년
                         -->
                    </td>
                </tr>	                     
                  <tr>
                    <td rowspan="4" class='title'>잔<br>
                      가</td>
                    <td class='title'>표준 최대잔가</td>
                    <td align="center">-</td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='ext_b_max_ja' maxlength='10' class='fixnum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'></td>
                  </tr>
                  <tr>
                    <td class='title'>조정 최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='ext_max_ja' maxlength='10' class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'></td>
                  </tr>                  
                  <tr>
                    <td class='title'>매입옵션</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='ext_f_opt_per' class='whitenum' value='<%=fees.getF_opt_per()%>'>
    				            % 
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="ext_opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%>>
                      없음
                      <input type='radio' name="ext_opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  있음
                    </td>
                  </tr>
                  <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
                <tr>
                    <td class='title' colspan="2">적용잔가</td>
                    <td align="center"><input type='text' size='10' name='i_ext_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='i_ext_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='-' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='i_ext_ja_r_amt' readonly maxlength='11' class='whitenum' value='-' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='i_ext_app_ja' maxlength='10' readonly class="whitenum" value='-'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}else{%>
                  <tr>
                    <td class='title'>적용잔가</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='ext_app_ja' maxlength='10' class='whitenum' value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                  </tr>
                  <%}%>
                  <tr>
                    <td rowspan="2" class='title'>대<br>여<br>료</td>
                    <td class='title'>계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='ext_fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">DC율:
                      <input type='text' size='4' name='ext_dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>
                    </font>%</span></td>
                    <td align='center'>
					월대여료납입방식 :
					  <select name='ext_fee_chk' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getFee_chk().equals("0"))%>selected<%%>>매월납입</option>
                              <option value="1" <%if(fees.getFee_chk().equals("1"))%>selected<%%>>일시완납</option>
                            </select>	
					</td>
                  </tr>
                  <tr>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='10' name='ext_inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10' name='ext_inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='ext_inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">기준일자<span class="contents1_1">
                      <input type='text' size='11' name='ext_bas_dt' maxlength='11' class="fix" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </span></td>
                    <td align='center'></td>
                  </tr>
		  <%	int ext_fee_etc_rowspan = 1;
		    	if(fees.getRent_st().equals("1")) ext_fee_etc_rowspan = ext_fee_etc_rowspan+2; //대차계약이면 한줄 추가
					//운전자추가요금추가
		    	ext_fee_etc_rowspan++;
		  %>
                  <tr>
                    <td rowspan="<%=ext_fee_etc_rowspan%>" class='title'>기<br>
                      타</td>
                    <td class='title' style="font-size : 7pt;">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='ext_cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='ext_cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='ext_cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                  </tr>    		
               		  
				<%if(fees.getRent_st().equals("1")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
				%>
                  <tr>                    
                    <td class='title'>영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준:
        			  <select name='ext_commi_car_st' disabled>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>차량가격</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='ext_commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="ext_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum'>
        		      %</td>
                    <td align='center'>
        				<input type='text' name="ext_comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' readonly>
        			  %</td>
                  </tr>		
                <tr>
                    <td class='title'>운전자추가요금</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='ext_driver_add_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>'>
        				  원 (공급가)</td>                  
                </tr>                  						
                <tr>
                    <td class='title' style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
					  <b>[원계약정보]</b>					  
					  &nbsp;계약번호 : <input type='text' name='ext_grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='ext_grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='ext_grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' >원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='ext_grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >원
					  <input type='hidden' name='ext_grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  
        			</td>
                </tr>		
				<%}%>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
                <tr>
                    <td colspan="2" class='title'>전기차 인수/반납 유형</td>
                    <td colspan="6">&nbsp;
                    	<select name='ext_return_select' disabled>
                        <option value=''>선택</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>인수/반납 선택형</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>반납형</option>
                    	</select>
                    </td>
                </tr>
                <%}%>				
                <tr>
                    <td colspan="2" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_con_etc' disabled><%=fee_etcs.getCon_etc()%></textarea></td>
                </tr>			                  
                  <tr>
                    <td colspan="2" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_fee_cdt' disabled><%=fees.getFee_cdt()%></textarea></td>
                  </tr>			
                <%if(fee_etcs.getRent_st().equals("1")){%>
                <tr>
                    <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                    <td colspan="6">&nbsp;<%=cont_etc.getCls_etc()%></td>
                </tr>
                <%}%>                  
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='ext_fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='whitetext' >
        				회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;매월
                      <select name='ext_fee_est_day' disabled>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;
                      <input type='text' name='ext_fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='ext_fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  							
	    </td>
    </tr>			
	<%		}else{//마지막회차
%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr id=tr_fee_rent style="display:<%if(!fees.getRent_st().equals("1")){%>''<%}else{%>none<%}%>">
                <td width="13%" align="center" class=title>계약일자</td>
                <td width="20%">&nbsp;
					  <%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || user_id.equals(base.getBus_id())){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>계약담당자</td>
                <td >&nbsp;    
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fees.getExt_agnt(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_agnt" value="<%=fees.getExt_agnt()%>">			
                </td>
                <td width="10%" align="center" class=title>영업대리인</td>
                <td >&nbsp;                  
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_bus_agnt_id" value="<%=fee_etcs.getBus_agnt_id()%>">			
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' >
        			 개월</td>
                <td width="10%" align="center" class=title>대여개시일</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                <td width="10%" align="center" class=title>대여만료일</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
              </tr>
              <input type='hidden' name='spr_kd' value='<%=base.getSpr_kd()%>'>	  
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
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='fixnum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
        				    </td>
                    <td align='center'>
					<%if(fee_size==1 && base.getRent_st().equals("3")){%>
					  대차 보증금 승계여부 :
					  <select name='grt_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='grt_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_pere_r_per' class='fixnum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>-<input type='hidden' name='pere_per' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료 </td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ifee_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_v_amt' maxlength='10' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='fixnum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">입금예정일 :
                          <input type='text' size='11' name='pp_est_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>&nbsp;
					<%	ExtScdBean suc = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, fees.getRent_st(), "5", "1");//승계수수료 기존 등록 여부 조회
						if(suc == null || suc.getRent_l_cd().equals("")){%>
					<%	}else{%>	
					승계수수료 입금여부 : <%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "5")%>
					<%	}%>
					</td>
                </tr>
                <tr>
        			<td class='title' colspan="2">총채권확보</td>
                    <td colspan='3'>&nbsp;
                        결재자 : <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etcs.getCredit_sac_id()%>">			
			&nbsp;&nbsp;&nbsp;&nbsp;
			결재일자 : <input type='text' size='11' name='credit_sac_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td align='center'>-</td>		
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>              
              <!--20130605 약정운행주행거리 운영-->    
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">
                  <%} %>                  
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <br>&nbsp;
                  (약정초과운행시) 초과운행대여료 <input type='text' name='over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!--       
                  <select name='agree_dist_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>선택</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>전액면제(기본식)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%만 납부(일반식)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>매입옵션 없음(기본식,일반식)</option>
                  </select>	
                  -->
                  <!--   
                  <br>&nbsp;
                  ※ 약정운행거리 미적용시 약정운행거리에 <input type='text' name='ex_agree_dist' size='5' class='whitenum' value='미적용' >과 같이 입력하면 됩니다.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        ※ 예상 운행거리 <input type='text' name='cust_est_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1년
                  -->      
                </td>
                <td align='center'>
                  <%if(AddUtil.parseInt(fees.getRent_dt()) > 20130604){
                  	e_bean = e_db.getEstimateCase(fee_etcs.getBc_est_id()); 
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
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
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
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='fixnum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'>
                        <%if(base.getCar_gu().equals("1")){%>
                        <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1년
                        <%}else{%>
                        <input type='hidden' name='e_agree_dist' value='<%=AddUtil.parseDecimal(e_bean.getAgree_dist())%>'>	
                        <%}%>
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">조정 최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1년
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_opt_per' class='defaultnum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
    				            %  
        				    </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> >
                      없음
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> >
        	 		  있음
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차  20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
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
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					월대여료납입방식 :
					  <select name='fee_chk' disabled>
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
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>&nbsp;</td>
                </tr>
                <tr>
	                <td class='title'>월보험료(고객피보험)</td>
	                <td align="center" ><input type='text' size='10' name='ins_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' >
        				  원</td>
                    <td align="center" ><input type='text' size='10' name='ins_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' >
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='ins_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' >    
					 원/12</td>
                    <td align='center'>-
                    	<%-- 자동차보험 관련 특약 약정서<br>
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a> --%>
                    </td>
              	</tr> 
               	<tr>
                    <td class='title'>운전자추가요금</td>
                    <td align="center" >
                    	<input type='text' size='10' name='driver_add_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' > 원 
                    </td>
                    <td align="center" >
                    	<input type='text' size='10' name='driver_add_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='driver_add_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align="center" >
                    	<input type='text' size='10' name='tinv_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='10' name='tinv_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='10' maxlength='10'  name='tinv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                </tr>
        <tr>
                <td class='title' colspan="2">대여료DC</td>
                <td colspan='3'>&nbsp;
                    결재자 : 
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="dc_ra_sac_id" value="<%=fee_etcs.getDc_ra_sac_id()%>">
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    결재일자 : 	
		    <input type='text' size='11' name='bas_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                
                </td>                    
                <td align='center'>-</td>            
                <td align="center">
                    적용근거 : <select name='dc_ra_st'>
                        <option value=''>선택</option>
                        <option value='1' <%if(fee_etcs.getDc_ra_st().equals("1")){%>selected<%}%>>정상DC조건</option>
                        <option value='2' <%if(fee_etcs.getDc_ra_st().equals("2")){%>selected<%}%>>특별DC</option>
                    </select>
                    &nbsp;
		    기타 : 
		    <input type='text' size='18' name='dc_ra_etc' class="whitetext" value='<%=fee_etcs.getDc_ra_etc()%>'>
                </td>
                <td align='center'>
                    DC율 <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC금액 <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etcs.getDriver_add_amt()+fee_etcs.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
        				  원
                </td>
              </tr>                
        
				<%	int fee_etc_rowspan = 1;
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
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>	
                           	  					  
				<%if(fees.getRent_st().equals("1")){
					//대차원계약정보
					Hashtable suc_cont = new Hashtable();
					if(!cont_etc.getGrt_suc_l_cd().equals("")){
						suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
					}
					%>
                <tr>
                    <td class='title' colspan="2">영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준:
        			  <select name='commi_car_st' disabled>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>차량가격</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum'>
        		      %</td>
                    <td align='center'>
        				<input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='fixnum' <%if(!nm_db.getWorkAuthUser("전산팀",user_id) || !base.getUse_yn().equals("")){%>readonly<%}%>>
        			  %</td>
                </tr>					
                       
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
					  <b>[원계약정보]</b>					  
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;					  
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  <%} %>					  	
        			</td>
                </tr>						
				<%}else{%>	
				<input type='hidden' name='commi_car_st' 	value='<%=emp1.getCommi_car_st()%>'>							
				<input type='hidden' name='commi_car_amt' 	value='<%=emp1.getCommi_car_amt()%>'>							
				<input type='hidden' name='comm_r_rt' 		value='<%=emp1.getComm_r_rt()%>'>							
				<input type='hidden' name='comm_rt' 		value='<%=emp1.getComm_rt()%>'>							
				<%}%>
				
			  <input type='hidden' name='bus_agnt_r_per' 	value='<%=fee_etcs.getBus_agnt_r_per()%>'>
			  <input type='hidden' name='bus_agnt_per' 	value='<%=fee_etcs.getBus_agnt_per()%>'>
			  <input type='hidden' name='cls_n_mon' 	value='<%=fee_etcs.getCls_n_mon()%>'>
			  <input type='hidden' name='cls_n_amt' 	value='<%=fee_etcs.getCls_n_amt()%>'>			 
			  <input type='hidden' name='min_agree_dist' 	value='<%=fee_etcs.getMin_agree_dist()%>'>
			  <input type='hidden' name='max_agree_dist' 	value='<%=fee_etcs.getMax_agree_dist()%>'>			  
			  <input type='hidden' name='over_serv_amt' 	value='<%=fee_etcs.getOver_serv_amt()%>'>
			  <input type='hidden' name='over_run_day' 	value='<%=fee_etcs.getOver_run_day()%>'>
			  <input type='hidden' name='fee_sac_id' 	value='<%=fees.getFee_sac_id()%>'>

              				
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
                <tr>
                    <td colspan="3" class='title'>전기차 인수/반납 유형</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select'>
                        <option value=''>선택</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>인수/반납 선택형</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>반납형</option>
                    	</select>
                    </td>
                </tr>
                <%}%>			     
                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='con_etc'><%=fee_etcs.getCon_etc()%></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>			
                <%if(fee_etc.getRent_st().equals("1")){%>
                <tr>
                    <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                    <td colspan="6">&nbsp;<%=cont_etc.getCls_etc()%></td>
                </tr>
                <%}%>                
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='whitetext' >
        				회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;매월
                      <select name='fee_est_day' disabled>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;
                      <input type='text' name='fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  				
	    </td>
    </tr>			
	<%		}%>
	<%	}%>
	
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
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=whitenum value='<%=fee_etc.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;경매장예상낙찰가격</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=whitenum value='<%=fee_etc.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;기타비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='whitenum' value='<%=fee_etc.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_u_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;기타수익</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='whitenum' value='<%=fee_etc.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_g_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='whitenum' value='<%=fee_etc.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='bc_b_ac_cont' maxlength='150' class=text value='<%=fee_etc.getBc_b_ac_cont()%>'></td>
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
            				  <td align="center"><input type='text' size='12' name='bc_b_t' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etc.getBc_b_t())%>' onBlur='javascript:this.value=parseDecimal(this.value);'></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
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
    <tr>
        <td class=h></td>
    </tr>			
	<%}%>
			
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
                    <td width="3%" rowspan="4" class='title'>대<br>여<br>료<br>납<br>입<br>방<br>법</td>				
                    <td width="10%" class='title'>수금구분</td>
                    <td width="20%">&nbsp;
                      <select name='fee_sh' disabled>
                        <option value="">선택</option>
                        <option value="0" <%if(fee.getFee_sh().equals("0")){%> selected <%}%>>후불</option>
                        <option value="1" <%if(fee.getFee_sh().equals("1")){%> selected <%}%>>선불</option>
                      </select></td>
                    <td width="10%" class='title'>납부방법</td>
                    <td>&nbsp;
                      <select name='fee_pay_st' disabled>
                        <option value=''>선택</option>
                        <option value='1' <%if(fee.getFee_pay_st().equals("1")){%> selected <%}%>>자동이체</option>
                        <option value='2' <%if(fee.getFee_pay_st().equals("2")){%> selected <%}%>>무통장입금</option>
                        <option value='4' <%if(fee.getFee_pay_st().equals("4")){%> selected <%}%>>수금</option>
                        <option value='5' <%if(fee.getFee_pay_st().equals("5")){%> selected <%}%>>기타</option>
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>카드</option>
                      </select></td>
        			  <td class='title'>CMS미실행</td>
        			  <td>&nbsp;
        			    사유 : <input type='text' name='cms_not_cau' size='25' value='<%=fee_etc.getCms_not_cau()%>' class='whitetext'>
        			  </td>			  
                </tr>					  		  		  
                <tr>
                    <td class='title'>거치여부</td>
                    <td colspan="3">&nbsp;
                    <select name='def_st' disabled>
                      <option value="N" <%if(fee.getDef_st().equals("N")){%> selected <%}%>>없음</option>
                      <option value="Y" <%if(fee.getDef_st().equals("Y")){%> selected <%}%>>있음</option>
                    </select>
        			 사유 :            
        			 <input type='text' name='def_remark' size='40' value='<%=fee.getDef_remark()%>' class='whitetext'>
        			</td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="def_sac_id" value="<%=fee.getDef_sac_id()%>">			
                    </td>
                </tr>
                  <tr>
                    <td class='title'>자동이체                        
                    </td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						  계좌번호 : 
        			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='whitetext'  style="IME-MODE:disabled;" >
        			      (
        			      <select name='cms_bank_cd' disabled>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];	
        												if(cms.getCms_bank().equals("")){%>
                        <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}else{                        %>
                        <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        										}
        								%>
                      </select>
        
        			       ) </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
						  예 금 주 :&nbsp;
        			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='20' class='whitetext'>
        				  &nbsp;&nbsp;
        				  / 결제일자 : 매월
        			      <select name='cms_day' disabled>
        			      <option value="">선택</option>
						    <%for(int i=1; i<=31; i++){%>
                        	<option value="<%=i%>"  <%if(cms.getCms_day().equals(String.valueOf(i)))%>selected<%%>><%=i%></option>
							<%}%>

                      	  </select>
        			일
        				  </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
					  예금주 생년월일/사업자번호 :
    			      <input type='text' name='cms_dep_ssn' size='15' class='whitetext' value="<%=AddUtil.ChangeEnpH(cms.getCms_dep_ssn())%>">
					  
    				  &nbsp;&nbsp;예금주 주소 : 
						<input type="text" name="t_zip" id="t_zip10" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						&nbsp;&nbsp;<input type="text" name="t_addr" id="t_addr10" size="50" value="<%=cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;
					  연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='whitetext' value="<%=cms.getCms_tel()%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='whitetext' value="<%=cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='whitetext' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">	

        				  </td>
        			    </tr>											
        			</table>
        			</td>
                  </tr>
                <tr>
                    <td class='title'>통장입금</td>
                    <td colspan="5">&nbsp; 
                      <select name='fee_bank' disabled>
                        <option value=''>선택</option>
                        <%if(bank_size > 0){
        							for(int j = 0 ; j < bank_size ; j++){
        								CodeBean bank = banks[j];%>
                              <option value='<%= bank.getCode()%>' <%if(fee.getFee_bank().equals(bank.getCode())){%> selected <%}%>><%= bank.getNm()%> </option>
                              <%	}
        						}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
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
                    <td width="20%">&nbsp;
                      <input type="radio" name="tax_type" value="1" <% if(base.getTax_type().equals("1")) out.print("checked"); %>>
        			    본사
        		      <input type="radio" name="tax_type" value="2" <% if(base.getTax_type().equals("2")) out.print("checked"); %>>
        		    	지점 </td>
                    <td width="10%" class='title' style="font-size : 8pt;">청구서수령방법</td>
                    <td width="20%">&nbsp;
        			  <%if(cont_etc.getRec_st().equals("") && client.getEtax_not_cau().equals("")) 	cont_etc.setRec_st("1");
        			    if(cont_etc.getRec_st().equals("") && !client.getEtax_not_cau().equals("")) cont_etc.setRec_st("2");%>
                      <select name='rec_st' disabled>
                        <option value="">선택</option>					
                        <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>이메일</option>
                        <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>우편</option>
                        <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>수령안함</option>
                      </select>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st' disabled>
                        <option value="">선택</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>당사시스템</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>별도시스템</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='whitetext'>
        			</td>
                </tr>
			  <!--부가세환급차량이 추가 되었을 경우에 부가세환급차량 계산서 별도 발금에 대해 묻는다.-->
			  <%	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && client.getPrint_car_st().equals("") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409")
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){//'100','101','601','602','700','701','702','801','802','803','811','812'%>
			  <tr>
                <td width="13%" class='title'>계산서별도발행구분</td>			  
			    <td colspan='5'>&nbsp;
				  <select name='print_car_st' disabled>
                    <option value="">선택</option>				  
                    <option value=''  <%if(client.getPrint_car_st().equals("")) out.println("selected");%>>없음</option>
                    <option value='1' <%if(client.getPrint_car_st().equals("1")) out.println("selected");%>>승합/화물/9인승/경차</option>							
                  </select>	
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' 차량은 부가세환급대상 차량입니다. 부가세환급할경우 계산별도발행구분을 [승합/화물/9인승/경차]로 선택하십시오.</font>
				</td>	
			  </tr>
			  <%	}%>						
            </table>
        </td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고전대차<%if(base.getRent_st().equals("3")){%>(만기매칭대차)<%}%></span></td> 
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tae1 style="display:<%if(!base.getCar_st().equals("2") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>출고전대차여부</td>
                    <td width="20%">&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                      <input type='radio' name="prv_dlv_yn" value='N'  <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      없다
                      <input type='radio' name="prv_dlv_yn" value='Y'  <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		있다
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">대차기간포함여부</td>
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
    <tr></tr><tr></tr>
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='12' class='whitetext' readonly value='<%=taecha.getCar_no()%>'>                      
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
                      <input type='text' name='tae_car_rent_st' class='whitetext' size='11' maxlength='11' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>대여만료일</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_et' class='whitetext' size='11' maxlength='11' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
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
                    <td colspan='3' >&nbsp;
                      <input type='text' name='tae_rent_fee' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>					  					  
        			</td>
                    <td class=title>정상요금</td>
                    <td>&nbsp;					  
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
        			  <input type='hidden' name='tae_rent_inv_s'	 value=''>
        			  <input type='hidden' name='tae_rent_inv_v'	 value=''>					  
					  <input type='hidden' name='tae_est_id'	 	 value='<%=taecha.getEst_id()%>'>					  
        			</td>
              </tr>		
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title>신차해지시요금정산</td>
                    <td colspan='5' >&nbsp;
                      <input type='radio' name="tae_rent_fee_st" value='1' <%if(taecha.getRent_fee_st().equals("1")){%> checked <%}%> >
                                      월렌트정상요금
                      <input type='text' name='tae_rent_fee_cls' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          견적서에 표기되어 있지 않음                       				  					 
        			</td>                     
              </tr>		  
              <%} %>
              <tr>
                <td class=title>청구여부</td>
                <td>&nbsp;
                  <select name='tae_req_st' disabled>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>청구</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>무상대차</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                <td>&nbsp;
                  <select name='tae_tae_st' disabled>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>발행</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>미발행</option>
                  </select></td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">			
    		</td>
              </tr>
              <%if(!cont_etc.getGrt_suc_l_cd().equals("")){//만기매칭대차 이관스케줄 변경 결재자%>
              <tr>
                <td class='title'>만기매칭대차 이관스케줄<br>변경 결재자</td>
                <td colspan='5'>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="end_rent_link_sac_id" value="<%=taecha.getEnd_rent_link_sac_id()%>">			
    		</td>
              </tr>  
              <%} %>
            </table>
        </td>
    </tr>
    <%if(!base.getCar_st().equals("5")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>영업사원<%}else if(base.getCar_gu().equals("2")){%>중고차딜러<%}%>-영업담당</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:<%if(!base.getCar_gu().equals("0") && !base.getCar_st().equals("2") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 		
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr>
                <td width="3%" rowspan="6" class='title'>영<br>
     			  업</td>
                <td class='title'>영업구분</td>
                <td colspan='5'>&nbsp;
		  			<label><input type='radio' name="pur_bus_st" value='1' <%if(pur.getPur_bus_st().equals("1")){%>checked<%}%>>
                  	자체영업</label>
                  	<label><input type='radio' name="pur_bus_st" value='2' <%if(pur.getPur_bus_st().equals("2")){%>checked<%}%>>
                  	영업사원영업</label>
                   	<label><input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  	에이전트</label>	                  
					</td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
	              	<td class='title'>출고보전수당 지급여부</td>
	              	<td colspan='5'>&nbsp;
	              		<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%>>
	              		없음</label>　　
	              		<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%>>
	              		있음</label>
	              		
	              		<%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>
	              		    &nbsp;&nbsp;
	              		    <select name='dir_pur_commi_yn'>
                          <option  value="">선택</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>특판출고(실적이관가능)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>특판출고(실적이관불가능)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>자체출고대리점출고</option>
                        </select>    
	              		<%}%>
	              	</td>
				</tr>
                <tr>
                    <td width="10%" class='title'>영업담당</td>
                    <td width="20%" >&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp1.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp1.getEmp_id()%>'>                      
        		    </td>
                    <td width="10%" class='title'>상호/영업소명</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp1.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'>
					  </td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp1.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
                <tr>
                    <td class='title'>소득구분</td>
                    <td >&nbsp;
                      <input type='text' name='cust_st' size='15' value='<%=emp1.getCust_st()%>' class='whitetext' readonly></td>
                    <td class='title'>최대수수료율</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum' readonly>
        			  % 
        			</td>
                    <td class='title'>적용수수료율</td>
                    <td>&nbsp;
                      <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum'>
        		      % 
        			  <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원			  
        			</td>
                </tr>
                <tr>
                    <td class='title'>변경사유</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='whitetext'>
                    </td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">			
        	    </td>
                </tr>
                <tr>
                    <td class='title'>은행명</td>
                    <td >&nbsp;
        		      <select name='emp_bank_cd' disabled>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        										}%>
                      </select>
        			</td>
                    <td class='title'>계좌번호</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='whitetext'>
        			</td>
                    <td class='title'>예금주명</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='whitetext'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>
    <%}%>
	<%}%>
	<%if(!base.getCar_st().equals("5")){%>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>영업사원-출고담당<%}else if(base.getCar_gu().equals("2")){%>중고차구입처<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:<%if(!base.getCar_gu().equals("0") && !base.getReject_car().equals("Y")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="<%if(base.getCar_gu().equals("1")){%>5<%}else if(base.getCar_gu().equals("2")){%>5<%}%>" class='title'>출<br>
                      고</td>			  
                <td class='title'>출고구분</td>
                <td>&nbsp;
				  <label><input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				자체출고</label>
        		  <label><input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				영업사원출고</label>
    			</td>
    		<td class='title'>특판출고여부</td>
                <td>&nbsp;
                    <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%>>
        				특판
        	    <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%>>
        				기타(자체)        		  
    			</td>	
    		<td class='title'>출고요청일</td>
                <td>&nbsp;
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='whitetext' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
                		  &nbsp;
        		  <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				출고요청한다
        		  
    			</td>	
              </tr>		
                <tr>
                    <td width="10%" class='title'>출고담당</td>
                    <td width="20%" >&nbsp;
                      <input type='text' name='emp_nm' size='5' class='whitetext' value='<%=emp2.getEmp_nm()%>' readonly>
        			  <input type='hidden' name='emp_id' value='<%=emp2.getEmp_id()%>'>
                      <input type='checkbox' name="emp_chk" ><font size='1'>상동</font></td>
                    <td width="10%" class='title'>영업소명</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>
                    </td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){%>    		  
              <tr>
                <td class='title'>계출번호</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='whitetext' readonly maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>출고예정일</td>
                <td>&nbsp;
                  <input type='text' name='dlv_est_dt' value='<%=pur.getDlv_est_dt()%>' class='whitetext' readonly size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			  &nbsp;
              	  <input type='text' size='2' name='dlv_est_h' class='whitetext' readonly value='<%=pur.getDlv_est_h()%>'>
             	   시 
    			</td>
                <td class='title'>출고일자</td>
                <td>&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='whitetext' readonly size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
              </tr>              
    		  <%}else if(base.getCar_gu().equals("2")){%>
              <tr>
                <td class='title'>매매일자</td>
                <td >&nbsp;
                  <input type='text' name='dlv_dt' value='<%= AddUtil.ChangeDate2(base.getDlv_dt())%>' class='whitetext' size='11' maxlength='11' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>
                <td class='title'>매매금액</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='trf_amt1' value='<%=AddUtil.parseDecimal(pur.getTrf_amt1())%>' class='whitetext' size='10' maxlength='10' onBlur='javascript:this.value=parseDecimal(this.value);'>
    			</td>
              </tr>
              <tr>
                <td class='title'>전차량번호</td>
                <td >&nbsp;
                  <input type='text' name='rpt_no' value='<%=pur.getRpt_no()%>' class='whitetext' maxlength='15' size='15' onBlur='javascript:this.value=this.value.toUpperCase()'>
    		    </td>
                <td class='title'>차대번호</td>
                <td colspan="3">&nbsp;
                  <input type='text' name='car_num' value='<%=pur.getCar_num()%>' class='whitetext' maxlength='20' size='20' onBlur='javascript:this.value=this.value.toUpperCase()'>
    			</td>
              </tr>
    		  <%}%>
    		  <tr>
                <td class='title'>계약금</td>
                <td colspan="5">&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='whitenum' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>원
				     <%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%}%>
                	<%if(pur.getCon_amt() > 0 && !pur.getCon_amt_pay_req().equals("")){%>
                	&nbsp;송금요청(<%=pur.getCon_amt_pay_req()%>)
                	<%}%>	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st0"  disabled>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='con_bank' disabled>
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
				  	<select name="acc_st0"  disabled>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='whitetext'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='15' class='whitetext'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='whitetext' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
        								  <%if(!pur.getCon_pay_dt().equals("")){%>	
					  &nbsp;&nbsp;(계약금지급일:<%=AddUtil.ChangeDate2(pur.getCon_pay_dt())%>)
					  <%}%>        			
        			
    			</td>															
              </tr>              	  
    		  <%if(!base.getCar_gu().equals("2")){%>    		                
              <tr>				
                <td class='title'>임시운행보험료</td>
                <td colspan='5'>&nbsp;
                  금액 : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='whitenum' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>원
				     <%if(pur.getTrf_amt5() > 0 && pur.getTrf_pay_dt5().equals("") && pur.getTrf_amt_pay_req().equals("")){%>
                	 <%	if(pur.getCon_amt() == 0 && pur.getCon_amt_pay_req().equals("")){%>
                		<a href="javascript:SendMsg('trf_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	 <%	}%>
                	 <%}%>
                	 <%if(pur.getTrf_amt5() > 0 && !pur.getTrf_amt_pay_req().equals("")){%>
                	 &nbsp;송금요청(<%=pur.getTrf_amt_pay_req()%>)
                	 <%}%>	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st5" disabled>
                        <option value="">==선택==</option>
        				<option value="2" <%if(pur.getTrf_st5().equals("2")) out.println("selected");%>>선불카드</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>후불카드</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='card_kind5'  disabled>
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
				  	<select name="acc_st5" disabled>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='whitetext'>
					&nbsp;
					예금주 : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='15' class='whitetext'>
        			<br>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='whitetext' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>				    
    			</td>				
              </tr> 
    		  <%}%>                      	  
            </table>
        </td>
    </tr>
	<tr>
	    <td>* 출고영업소에 차량대금를 지급할 계좌를 입력하십시오. 개인명의 계좌는 사용할 수 없습니다.</td>
	<tr>
	<tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적사후관리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=13%>시장상황</td>
                    <td>&nbsp;<textarea name='bus_cau' rows='5' cols='100' maxlenght='500'><%=f_fee_etc.getBus_cau()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>	
    			
	<%	int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;
		int add_rent_mail_yn = 0;
	%>
	<%if(!base.getCar_st().equals("2")){%>
    <tr> 
        <td colspan="2"><a name="scan"><img src=/acar/images/center/icon_arrow.gif align=absmiddle></a> <span class=style2>기본스캔파일
		  &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a></span>
		</td>
    </tr>
	<%	if(!client.getClient_st().equals("2")) scan_mm ="대표자 ";%>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr>
        <td colspan="2" class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                  <td width="10%" class=title>연번</td>
                  <td width="40%" class=title>구분</td>                  
                  <td width="20%" class=title>스캔파일</td>
                  <td width="20%" class=title>등록일자</td>
                  <td width="10%" class=title>삭제</td>		  
                </tr>
        	<%  
        	
        	
                   	String file_st = "";
                   	String file_rent_st = "";
                   
                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
			String content_code = "LC_SCAN";
			String content_seq  = rent_mng_id+""+rent_l_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			
			String alink_scan_1_yn = "";
        	
        	%>
        		

        	
        	
        	
				
				
				
		<!--변경후-->	
		<%	for(int f=1; f<=fee_size; f++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));%>	



        	
        	<%		if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f>1 && f==fee_size ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">자동차대여이용계약서(연장)</td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%		}%>
        	
        	
        	<%		if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f==1 ){  %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">자동차대여이용계약서(신규,대차,증차)</td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/privacy_agree.pdf' target="_blank"><img src=/acar/images/center/button_in_sj.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%		}%>        	
        	
        	
        	
        	<%		if(now_stat.equals("계약승계") && cont_etc.getSuc_rent_st().equals(String.valueOf(f)) && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > 20140101 ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">자동차대여이용계약서(계약승계)</td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%		}%>        	
        	

        	

		<%		if((now_stat.equals("계약승계") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("차종변경") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("연장") && fee_size==f)){//jpg%>
		
		<!--개시후계약서(jpg)-->				
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "17";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					
 					if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")){
							add_rent_mail_yn++; 
					}                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(앞)-jpg파일
			<%		if(now_stat.equals("계약승계") && fee_etcs.getReg_dt().equals(base.getReg_dt())) 	out.println(" : 계약승계");
				  	if(now_stat.equals("차종변경") && fee_etcs.getReg_dt().equals(base.getReg_dt()))	out.println(" : 차종변경");
					if(now_stat.equals("연장") && fee_size==f)						out.println(" : 연장");
		  	%>                    
                    </td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(앞)-jpg파일</td>
                    <td align="center"></td>
                    <td align="center"><%if(!base.getCar_st().equals("5") && f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--개시후계약서(jpg)-->				
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "18";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					
 					if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")){
							add_rent_mail_yn++; 
					}                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(뒤)-jpg파일
			<%		if(now_stat.equals("계약승계") && fee_etcs.getReg_dt().equals(base.getReg_dt())) 	out.println(" : 계약승계");
				  	if(now_stat.equals("차종변경") && fee_etcs.getReg_dt().equals(base.getReg_dt()))	out.println(" : 차종변경");
					if(now_stat.equals("연장") && fee_size==f)						out.println(" : 연장");
		  	%>                    
                    </td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(뒤)-jpg파일</td>
                    <td align="center"></td>
                    <td align="center"><%if(!base.getCar_st().equals("5") && f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">      
                		
								
		<%		}else{%>
		
		<!--최초계약서(pdf)-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "1";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					 					
 					
 								if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && alink_count1>0 && !base.getCar_st().equals("5")){
 									alink_scan_1_yn = "Y";       					 					
 								}
 								
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서</td>
                    <td align="center"></td>
                    <td align="center"><%if(!base.getCar_st().equals("5") && f==1 && alink_count1==0 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 ){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                		
			
		<%			if(f==1 && AddUtil.parseInt(fee_etcs.getReg_dt()) >= 20100501){%>
				
		<!--대여개시후계약서(앞)-jpg파일-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "17";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                
		<!--대여개시후계약서(뒤)-jpg파일-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "18";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  										
		<%			}%>
		<%		}%>				
		<%	}//for end%>			
				
		
		<!--개인(신용)정보 수집·이용·제공·조회동의서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "37";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서jpg</td>
                    <td align="center"></td>
                    <td align="center">
			<%	//20140801부터 필수
				if(AddUtil.parseInt(base.getRent_dt()) > 20140731 && fee_size == 1 && !base.getCar_st().equals("5")){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//법인 대표자연대면제는 제외
					}else{
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				}				
			%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>"> 
                
                
		<!--개인(신용)정보 수집·이용·제공·조회동의서(공동임차인) - 개인/개인사업자-->	
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>		
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "51";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서jpg(공동임차인)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서jpg(공동임차인)</td>
                    <td align="center"></td>
                    <td align="center">
			<%	//20210601부터 필수
				if(AddUtil.parseInt(base.getRent_dt()) >= 20210601 && fee_size == 1 && !base.getCar_st().equals("5")){
						scan_cnt++;
						out.println("<font color=red>불충</font>");
				}				
			%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                 
        <%	}%>        
                
		<!--CMS동의서jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "38";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                 
                	
			
		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
		
		<!--임직원운전한정특약가입요청서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "40";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "40", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">임직원운전한정특약가입요청서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">임직원운전한정특약가입요청서</td>
                    <td align="center"></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   				
			
		<%}%>	
						       		
				       		
       		<tr>
  		    <td class=line2 colspan="6"></td>
		</tr>
				
		<%	if(!client.getClient_st().equals("2")){%>
		
		<!--사업자등록증jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "2";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "2", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"></td>
                    <td align="center"><%if(!base.getCar_st().equals("5")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">    
                                
        	<%	}%>
        		
        	<%	if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>
        	
		<!--법인등기부등본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "3";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "3", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>불충</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">      
                
		<!--법인인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "6";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "6", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">       
                
        	<%}%>
        		
       		<%	if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){%>
       		<%	}else{%>
       		<%		if(scan_chk.equals("Y")){%>		
       		
		<!--<%=scan_mm%>신분증jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "4";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "4", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>신분증jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>신분증jpg</td>
                    <td align="center"></td>
                    <td align="center"><%if(!base.getCar_st().equals("5")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                       		
		<!--<%=scan_mm%>주민등록등본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "7";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "7", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>주민등록등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>주민등록등본</td>
                    <td align="center"></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>불충</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">     
                
		<!--<%=scan_mm%>인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "8";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "8", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=scan_mm%>인감증명서</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                    
        		
       		<%		}%>
       		<%	}%>
       		
                <%	//연대보증인 구비서류-----------------------------------
        		if(cont_etc.getGuar_st().equals("1")){
		%>
		
		<!--연대보증서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "14";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "14", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">연대보증서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">연대보증서</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">     

		<!--사업자등록증/신분증-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "11";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "11", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증/신분증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">사업자등록증/신분증</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">       
                
		<!--법인등기부등본/주민등록등본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "12";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "12", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본/주민등록등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인등기부등본/주민등록등본</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>"> 
                
		<!--법인인감증명서/인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "13";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "13", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서/인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">법인인감증명서/인감증명서</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                                    		
		
		
		<%	}%>	
		
		
		<!--통장사본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "9";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">통장사본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">통장사본</td>
                    <td align="center"></td>
                    <td align="center">
			<%
				//자동이체 & 신규계약 
				if(fee.getFee_pay_st().equals("1") && base.getRent_st().equals("1") && fee_size == 1){
					scan_cnt++;
					out.println("<font color=red>불충</font>");
				}				
			%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">    
                
		<%if(ej_bean.getJg_g_7().equals("3")){%>                
		<!--전기차확약서-->			
                <% 	scan_num++; 
	                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "44", 0);
  	              	attach_vt_size = attach_vt.size();
                	
    	            	if(attach_vt_size > 0){
											for (int j = 0 ; j < 1 ; j++){
 												Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">전기차확약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">전기차확약서</td>
                    <td align="center"></td>
                    <td align="center">
								<%	//20200221 국고보조금 삭제로 필요없음
									//if(ej_bean.getJg_g_7().equals("3") && car.getServ_sc_yn().equals("Y")){
									//			scan_cnt++;
									//			out.println("<font color=red>불충</font>");
									//	}		
								%>                    
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="44">                                  
		<%}%>                
                
		<%if(cont_etc.getInsur_per().equals("2")){%>
		
		<!--보험가입특약서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "19";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "19", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험가입특약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험가입특약서</td>
                    <td align="center"></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--보험청약서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "36";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "36", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험청약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험청약서</td>
                    <td align="center"></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--보험가입증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "39";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "39", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험가입증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">보험가입증명서</td>
                    <td align="center"></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                  
                                				
                <%}%>
			
			
			
		<%if(now_stat.equals("계약승계")){%>
		
		<!--이전계약자인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "20";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "20", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">이전계약자인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">이전계약자인감증명서</td>
                    <td align="center"></td>
                    <td align="center"><!--<% //scan_cnt++;%><font color=red>불충</font>--></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  						
		
		<%}%>
		
		<!--심사자료-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "49";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "49", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">심사자료</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">심사자료</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">      
                  		
		<!--개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)-->	
		<%if(fee_etc.getDriver_add_amt()>0){ %>	
                <% 	scan_num++; 
                	file_rent_st = fee_etc.getRent_st();
                	file_st = "52";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "52", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   
                <% 	scan_num++; 
                	file_rent_st = fee_etc.getRent_st();
                	file_st = "32";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, file_st, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">    				
        <%	}%>  				
       		
		<!--세금계산서-->				
                <% 	file_rent_st = "1";
                	file_st = "10";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "10", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
 					scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">세금계산서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>         	
                
		<!--매매주문서-->				
                <% 	file_rent_st = "1";
                	file_st = "15";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "15", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">매매주문서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>   
                
		<!--임시운행보험료 영수증-->				
                <% 	file_rent_st = "1";
                	file_st = "26";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "26", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">임시운행보험료 영수증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>   
                
		<!--그외-->		
                <% 	content_seq  = rent_mng_id+""+rent_l_cd;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					
 					if(!String.valueOf(ht.get("CONTENT_SEQ")).equals("") && String.valueOf(ht.get("CONTENT_SEQ")).length() > 20){ 						
 						file_st = String.valueOf(ht.get("CONTENT_SEQ")).substring(20); 						
 					}
 					
 					if(file_st.equals("1")||file_st.equals("2")||file_st.equals("3")||file_st.equals("4")||file_st.equals("5")||file_st.equals("6")||file_st.equals("7")||file_st.equals("8")||file_st.equals("9")||file_st.equals("10")||file_st.equals("11")||file_st.equals("12")||file_st.equals("13")||file_st.equals("14")||file_st.equals("15")||file_st.equals("17")||file_st.equals("18")||file_st.equals("19")||file_st.equals("20")||file_st.equals("36")||file_st.equals("37")||file_st.equals("38")||file_st.equals("39")||file_st.equals("40")||file_st.equals("51")||file_st.equals("52")||(fee_etc.getDriver_add_amt()>0 && file_st.equals("32"))) continue;
 					
 					scan_num++;                              	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>                       
                
		<!--기타-->				
                <% 	file_rent_st = "1";
                	file_st = "5";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "5", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">기타</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>       				

             		                   
                
            </table>
        </td>
    </tr>
	<%for(int i=1; i<=20; i++){//입력값 점검%>
	<tr id=tr_chk<%=i%> style='display:none'>
	    <td><input type='text' name="chk<%=i%>" value='' size="100" class='redtext'></td>
	</tr>	
	<%}%>
	
	<%for(int i=1; i<=20; i++){//결재자%>
	<tr id=tr_sanc<%=i%> style='display:none'>
	    <td><input type='text' name="sanc<%=i%>" value='' size="100" class='chktext'></td>
	</tr>	
	<%}%>	    
	
	
	<%}%>
	
    <%
	//계약서 이메일발송 저장 리스트
	Vector ime_vt =  ImEmailDb.getReNewInfoMailDocSendList(rent_l_cd+""+String.valueOf(fee_size));
	int ime_vt_size = ime_vt.size();
	
	if(ime_vt_size>0){
    %>	 
    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연장계약서 메일관리</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>			
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                  <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="8%">발송여부</td>			
                    <td class=title width="8%">수신여부</td>
                    <td class=title width="15%">받는사람</td>
                    <td class=title width="15%">발송일시</td>
                    <td class=title width="41%">제목</td>
                  </tr>
        	  <%	for(int i = 0 ; i < ime_vt_size ; i++){
        			Hashtable ime_ht = (Hashtable)ime_vt.elementAt(i);%>
                  <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=ime_ht.get("ERRCODE_NM")%></td>
                    <td align='center'><%=ime_ht.get("OCNT_NM")%></td>
                    <td align='center'><%=ime_ht.get("EMAIL")%></td>
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(ime_ht.get("STIME")))%></td>
                    <td>&nbsp;<%=ime_ht.get("TO_TYPE")%>&nbsp;<%=ime_ht.get("SUBJECT2")%></td>
                  </tr>
        	  <%	} %>
            </table>
        </td>
    </tr>				
    <tr>
        <td class=h></td>
    </tr>		    
    <%	}%>

<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6") ){%>	    	
    <tr>
	<td align='center'>	
	
	      	    		 
	    <%	String sanction_date = base.getSanction_date();
	  		if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);
	  		
	  		int sanction_user_type = a_db.getSanctionUserType(base.getBus_id(),"");
	  		
	  		if(fee_size >1){
	  			sanction_user_type = a_db.getSanctionUserType(max_fee.getExt_agnt(),"");
	  		}
	  	%>
	  	
	    <%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date) && nm_db.getWorkAuthUser("계약결재",ck_acar_id)){%>	    
	    <br>
		<%if(sanction_user_type==1){ %>
	        <a href="javascript:sanction();" title='점검처리하기'>[점검확인]</a>		
   		    <br><br>
		       점검요청취소사유 : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>		
		    <a href="javascript:sanction_req_cancel();" title='점검요청 취소하기'>[점검요청취소하기]</a>
		<%}else{%>
	        <a href="javascript:sanction();" title='계약결재하기'><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a>			        
		    <br><br>
		       결재요청취소사유 : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>		
		    <a href="javascript:sanction_req_cancel();" title='결제요청 취소하기'>[결제요청취소하기]</a>
		<%}%>
		<br><br>

	    <%	}else{%>
	    
	    <!-- 결재요청자 -->
	    <%		if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date) && base.getSanction_req().equals(ck_acar_id)){%>	    
	    <br>
		<%			if(sanction_user_type==1){ %>	        
		       점검요청취소사유 : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>		
		    <a href="javascript:sanction_req_cancel();" title='점검요청 취소하기'>[점검요청취소하기]</a>
		<%			}else{%>
		       결재요청취소사유 : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>		
		    <a href="javascript:sanction_req_cancel();" title='결제요청 취소하기'>[결제요청취소하기]</a>
		<%			}%>
		<br><br>

	    <%		}%>
	    <%	}%>
		
	</td>
    </tr>
    <tr>
	<td></td>
    </tr>		
    <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>
    <tr>
        <td align='right'>
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1")) ){%>	  
	    <a href="lc_reg_step2.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 	    	    
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("2")) ){%>	  
	    <a href="lc_reg_step3.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_3step.gif align=absmiddle border=0></a>&nbsp;	  
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("3")) ){%>	  
	    <%if(base.getCar_st().equals("4")){%>
	        <a href="lc_reg_step4_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
	    <%}else{%>
	        <a href="lc_reg_step4.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
	    <%}%>
          <%}%>	
          <%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>	
	</td>	
    </tr>
    <%}%>

    <%if(!fee_etc.getBc_est_id().equals("")){%>	
    <tr>
	<td>&nbsp;</td>
    </tr>			
    <tr>
	<td align="center">
		<a href="javascript:view_sale_cost_lw()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yumg.gif border=0 align=absmiddle></a>
		<%if(String.valueOf(cost_cmp.get("RENT_L_CD")).equals("") || String.valueOf(cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<%}else{%>
		<a href="javascript:view_sale_cost_lw_base()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_see_yuhy.gif border=0 align=absmiddle></a>
		<%}%>
		<%if(!String.valueOf(t_cost_cmp.get("RENT_L_CD")).equals("") && !String.valueOf(t_cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<a href="javascript:view_sale_cost_lw_add()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yuhy.gif border=0 align=absmiddle></a>		
		<%}%>		
	</td>
    </tr>			
    <%}%>
<%}%>	  
</table>
  <input type='hidden' name="zip_cnt" 			value="<%=zip_cnt%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
<%if(base.getCar_gu().equals("1")){%>
	//페이지 로드 시 출고보전수당 지급여부 초기화		2017. 12. 06
	//document.addEventListener("DOMContentLoaded", function(){
	$(document).ready(function(){
		var pur_bus_st_chk = $("input[name=pur_bus_st]").is(":checked");
		var pur_bus_st_val = $("input[name=pur_bus_st]:checked").val();					// 영업구분
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		
		$("#dlv_con_commi_yn_tr").hide();																	// 출고보전수당 지급여부 -> 필드 숨기기
		if(pur_bus_st_chk){
			if(pur_bus_st_val == "1"){
			}else if(pur_bus_st_val == "2" || pur_bus_st_val == "4"){							// 영업구분 -> 영업사원영업, 에이전트
				$("#dlv_con_commi_yn_tr").show();														// 출고보전수당 지급여부 -> 필드 보여주기
				if(dlv_con_commi_yn_val == "Y"){															// 출고보전수당 지급여부 -> 있음 선택
					$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 -> 자체출고 선택
					$("input[name='one_self']:radio[value='N']").prop("disabled", true);		// 출고구분 -> 영업사원출고 비황성화
				}else if(dlv_con_commi_yn_val == "N"){													// 출고보전수당 지급여부 -> 없음 일 경우
					$("input[name='one_self']:radio[value='N']").prop("disabled", false);	// 출고구분 -> 영업사원출고 활성화
					$("input[name='one_self']:radio[value='N']").prop("checked", true);	// 출고구분 -> 영업사원출고 선택
				}
			}	
		}
	});
	
	// 출고보전수당		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// 출고구분 영업사원출고
	$("input[name=pur_bus_st]").change(function(){ 
		if($(this).val() == "1"){							// 영업구분 자체영업 선택 시
			$("#dlv_con_commi_yn_tr").hide();		// 출고보전수당 지급여부 숨김
			one_self_no.prop("disabled", false);		// 출고구분 영업사원출고 활성화
		}else{														// 영업구분 영업사원영업, 에이전트 선택 시
			$("#dlv_con_commi_yn_tr").show();	// 출고보전수당 지급여부 보이기
		}
	});
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 있음 선택 시
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 자체출고 선택
			one_self_no.prop("disabled", true);														// 출고구분 영업사원출고 비활성화
		}else{																										// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 없음 선택 시
			one_self_no.prop("disabled", false);														// 출고구분 영업사원출고 활성화
			one_self_no.prop("checked", true);														// 출고구분 영업사원출고 선택
		}
	});
<%}%>	

 	var fm = document.form1;
 	
	fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
	fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
	fm.tot_c_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
	fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
	fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );							
 	
	fm.tot_pp_s_amt.value = parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
	fm.tot_pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
	fm.tot_pp_amt.value   = parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		

	var car_price 	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value)) - toInt(parseDigit(fm.tax_dc_amt.value));
	var s_dc_amt = 0;
		
	if(toInt(fm.s_dc1_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc1_amt.value));
	if(toInt(fm.s_dc2_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc2_amt.value));
	if(toInt(fm.s_dc3_amt.value) > 0 )		s_dc_amt 	= s_dc_amt + toInt(parseDigit(fm.s_dc3_amt.value));
	
	if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
	if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
	if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));

	//수입차
	if(<%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
		s_dc_amt = 0;
	}
		
 	car_price = car_price - s_dc_amt;
				
	if(fm.car_gu.value != '1'){
		car_price 	= toInt(parseDigit(fm.sh_amt.value));
	}
		
	if(<%=fee_size%> > 1){
		car_price 	= toInt(parseDigit(fm.sh_amt.value));
		if(toInt(parseDigit(fm.fee_opt_amt.value)) > 0) car_price	= toInt(parseDigit(fm.fee_opt_amt.value));
	}		
				
	var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
	
	
	if(pp_price>0 || car_price>0){
		fm.credit_r_per.value 		= replaceFloatRound(pp_price / car_price );
		fm.credit_r_amt.value 		= parseDecimal(pp_price);
		fm.stat_credit_r_per.value 	= fm.credit_r_per.value;
		fm.stat_credit_r_amt.value 	= fm.credit_r_amt.value;
	} 	

	var car_st 		= fm.car_st.value;
	//채권확보
	if(car_st == '1'){
		if(car_price < 25000000)																fm.credit_per.value = '20';
		else if(car_price > 25000000 && car_price < 45000000)		fm.credit_per.value = '30';
		else if(car_price > 45000000)														fm.credit_per.value = '25';
	}else if(car_st == '3'){
		if(car_price < 25000000)																fm.credit_per.value = '30';
		else if(car_price > 25000000 && car_price < 45000000)		fm.credit_per.value = '35';
		else if(car_price > 45000000)														fm.credit_per.value = '40';		
	}
	if(<%=base.getRent_dt()%> >= 20141223){
		if(car_price <= 30000000)																fm.credit_per.value = '20';
		else if(car_price > 30000000)														fm.credit_per.value = '25';
	}
	if(<%=base.getRent_dt()%> >= 20150312){
		if(car_price <= 45000000)																fm.credit_per.value = '20';
		else if(car_price > 45000000)														fm.credit_per.value = '25';
	}
	
	//전기차는 기본 보증금에서 10% 빼준다
  if('<%=ej_bean.getJg_g_7()%>' == '3'){
   	fm.credit_per.value     = toInt(fm.credit_per.value)-10;
  }
	//수소차는 기본 보증금에서 15% 빼준다
  if('<%=ej_bean.getJg_g_7()%>' == '4'){
   	fm.credit_per.value     = toInt(fm.credit_per.value)-15;
  }
    
	var credit_per = toInt(fm.credit_per.value)/100;
	fm.credit_amt.value = parseDecimal(car_price*credit_per);	
			
	<%if(!base.getCar_st().equals("2")){%>
	
	fm.scan_cnt.value = <%=scan_cnt%>;	
	
	<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("1")){%>	
	fm.scan_cnt.value = <%=scan_cnt-1%>;	
	<%}%>
	
	if(fm.car_st.value != '2'){
		cont_chk();
	}
		
	function cont_chk(){

		if(<%=fee_etc.getReg_dt()%> >= 20100501 && toInt(fm.scan_cnt.value) > 0){
		
			
							
			
			fm.chk1.value = '* 미등록 스캔이 <%=scan_cnt%>건 있습니다. --> 결재 조건이 충족되지 않습니다.';
			<%	if(client.getFirm_type().equals("7")){%>
			fm.chk1.value = '* 미등록 스캔이 <%=scan_cnt%>건 있습니다. --> 결재 조건이 충족되지 않습니다. -> 지방자체단체일 경우라도 다른 파일을 대체해서 스캔등록하십시오.';
			<%	}%>
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;

		}
		
		//결재자 입력값 확인
		if(<%=base.getRent_dt()%> > 20070831){
		        <%if(client.getClient_st().equals("1")){%>
			if(fm.client_st.value != '2' && fm.client_guar_st[1].checked == true &&  fm.guar_sac_id.value != ''){
				fm.sanc1.value = '* 대표이사보증 면제 결재자는 <%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%> 입니다.';
				tr_sanc1.style.display = '';					
			}		
			<%}%>
			if(fm.car_ja.value != fm.imm_amt.value &&  fm.rea_appr_id.value != ''){
				fm.sanc2.value = '* 자차면책금 변경 결재자는 <%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%> 입니다.';
				tr_sanc2.style.display = '';					
			}
			if(fm.def_st.value == 'Y' && fm.def_sac_id.value != ''){
				fm.sanc4.value = '* 거치여부 결재자는 <%=c_db.getNameById(fee.getDef_sac_id(),"USER")%> 입니다.';
				tr_sanc4.style.display = '';					
			}		
			if(fm.prv_dlv_yn[1].checked == true && fm.tae_sac_id.value != ''){
				fm.sanc5.value = '* 출고전대차 결재자는 <%=c_db.getNameById(taecha.getTae_sac_id(),"USER")%> 입니다.';
				tr_sanc5.style.display = '';							
			}
			if(toFloat(fm.comm_rt.value) != toFloat(fm.comm_rt.value) && fm.ch_sac_id.value != ''){
				fm.sanc6.value = '* 영업사원 변경사유 또는 결재자는 <%=c_db.getNameById(emp1.getCh_sac_id(),"USER")%> 입니다.';
				tr_sanc6.style.display = '';							
			}														
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';											
			}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';											
			}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';											
			}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';											
			}
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){
				fm.sanc8.value = '* 보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc8.style.display = '';											
			}
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){
				fm.sanc8.value = '* 보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc8.style.display = '';											
			}
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){
				fm.sanc9.value = '* 보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc9.style.display = '';											
			}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){
				fm.sanc9.value = '* 보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc9.style.display = '';											
			}			
			<%}%>
		}		
		
		<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
		<%}else{%>
		<%if(!base.getCar_st().equals("5")){%>
		//필수이력 체크
		if(<%=base.getRent_dt()%> > 20070831){
			if(fm.client_st.value == '1' && fm.client_guar_st[0].checked == false && fm.client_guar_st[1].checked == false){	
				fm.chk2.value = '* 대표이사보증 유무가 없습니다.';
				tr_chk2.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			if(fm.client_st.value == '1' && fm.client_guar_st[1].checked == true && (fm.guar_con.value == '' || fm.guar_sac_id.value == '')){
				fm.chk2.value = '* 대표이사보증 면제조건 및 결재자가 없습니다.';
				tr_chk2.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}		
		
			if(fm.guar_st[0].checked == false && fm.guar_st[1].checked == false){	
				fm.chk3.value = '* 연대보증인 유무가 없습니다.';
				tr_chk3.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			
			
			<%if(ej_bean.getJg_w().equals("1")){//수입차%>
				if(fm.car_ja.value != fm.imm_amt.value && (fm.ja_reason.value == '' || fm.rea_appr_id.value == '')){
						fm.chk6.value = '* 자차면책금 변경사유 또는 결재자가 없습니다.';
						tr_chk6.style.display = '';					
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			<%}else{%>
				if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
					if(fm.car_ja.value != fm.imm_amt.value && (fm.ja_reason.value == '' || fm.rea_appr_id.value == '')){
						fm.chk6.value = '* 자차면책금 변경사유 또는 결재자가 없습니다.';
						tr_chk6.style.display = '';					
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
				}			
			<%}%>				

			if(fm.credit_sac_id.value == ''){
				fm.chk9.value = '* 채권확보 결재자가 없습니다.';
				tr_chk9.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
		
			if(fm.def_st.value == 'Y' && (fm.def_remark.value == '' || fm.def_sac_id.value == '')){
				fm.chk10.value = '* 거치여부가 있으나 거치사유 또는 거치 결재자가  없습니다.';
				tr_chk10.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}		

			if(fm.prv_dlv_yn[1].checked == true && fm.tae_sac_id.value == ''){
				fm.chk12.value = '* 출고전대차 결재자가 없습니다.';
				tr_chk12.style.display = '';							
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}

			if(fm.dec_gr.value == ''){
				fm.chk5.value = '* 판정신용등급이 없습니다.';
				tr_chk5.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			
			<%if(fee_size ==1 && base.getCar_gu().equals("0")){%>
			//보유차계약시점주행거리                   
            //alert('재리스 신규계약');
            var over_bas_km = toInt(parseDigit(fm.over_bas_km.value));
            if(over_bas_km == 0){
	            fm.sanc10.value = '* 재리스 보유차 계약시점 주행거리가 없습니다.';
	            tr_sanc10.style.display = '';
	            fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;                              
            }
            <%}%>
			
			if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false){
				fm.chk7.value = '* 매입옵션 유무가 없습니다.';
				tr_chk7.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}			
			if(fm.opt_chk[1].checked == true && (fm.opt_per.value == '' || toInt(parseDigit(fm.opt_amt.value))==0)){
				if(fm.rent_l_cd.value != 'S111HHGR00245'){
					fm.chk7.value = '* 매입옵션율 또는 매입옵션금액이 없습니다.';
					tr_chk7.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			}
				
			if('<%=max_fee.getFee_s_amt()%>'=='0' && '<%=max_fee.getPp_s_amt()+max_fee.getGrt_amt_s()+max_fee.getIfee_s_amt()%>'=='0'){
				fm.chk17.value = '* 선수금과 대여료 계약요금이 없습니다.';
				tr_chk17.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			
			if(fm.fee_pay_st.value == '1'){
				if(fm.cms_bank_cd.value == '' || fm.cms_acc_no.value == '' || fm.cms_dep_nm.value == '' || fm.cms_dep_ssn.value == ''	){
					fm.chk8.value = '* 자동이체인데 은행정보가 없습니다. 은행,계좌,예금주명,예금주 생년월일/사업자번호를 확인하세요';	
									
					if(fm.cms_acc_no.value != '')		{ 
						if ( !checkInputNumber("CMS 계좌번호", fm.cms_acc_no.value) ) {	
							fm.cms_acc_no.focus(); 		return; 
						}
					}
							
					tr_chk8.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;							
				
				}
			}
			
			if(fm.bus_id2.value == ''){
				fm.chk5.value = '* 영업담당자가 없습니다.';
				tr_chk5.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			
			<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
			//영업담당 영업구분 체크
			if(fm.pur_bus_st[0].checked == false && fm.pur_bus_st[1].checked == false && fm.pur_bus_st[2].checked == false){
				fm.chk12.value = '* 영업담당 영업구분이 없습니다.';
				tr_chk12.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
						
			//출고담당 출고구분 체크
			if(fm.one_self[0].checked == false && fm.one_self[1].checked == false){
				fm.chk13.value = '* 출고담당 출고구분이 없습니다.';
				tr_chk13.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			

				
			<%}%>
			
			
			
		}
		<%}%>		
		<%}%>
		
		if(fm.est_area.value == ''){
			fm.chk4.value = '* 차량이용지역이 없습니다.';
			tr_chk4.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		if(toInt(parseDigit(fm.car_ja.value)) == 0){		
			fm.chk6.value = '* 자차면책금이 없습니다.';
			tr_chk6.style.display = '';		
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
				
		if(fm.cls_r_per.value == ''){
			fm.chk8.value = '* 중도해지위약율이 없습니다.';
			tr_chk8.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}

		if(fm.rec_st.value == ''){
			fm.chk11.value = '* 세금계산서 청구서 수령방법이 없습니다.';
			tr_chk11.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}		
		
			<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){
				Hashtable ext0 = a_db.getScdExtPay(rent_mng_id, rent_l_cd, max_fee.getRent_st(), "0");
    			int pp_amt0 	= AddUtil.parseInt(String.valueOf(ext0.get("EXT_S_AMT")));
    			int pp_pay_amt0 = AddUtil.parseInt(String.valueOf(ext0.get("PAY_AMT")));
				if((pp_amt0-pp_pay_amt0) > 0){%>
				fm.chk8.value = '* 계약승계 보증금이 입금완료되지 않았습니다.';
				tr_chk8.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;				
			<%	}
			}%>	

		<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("N")){%>
    	<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
		fm.chk16.value = '* 법인고객의 임직원운전한정특약이 미가입입니다. 승인처리하십시오.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
   		<%	}else{%>
    	<%		if(base.getOthers().equals("")){%>	
		fm.chk16.value = '* 법인고객의 임직원운전한정특약이 미가입입니다. 미가입사유를 보험관리-비고에 입력하십시오.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
 		<%		}%>
    	<%	}%>
    	<%}%>
    	

    
		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("")){%>
		fm.chk16.value = '* 법인고객의 임직원운전한정특약이 가입여부가 없습니다.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    	<%}%>			
		
	}
	
	<%}%>

//-->
</script>
</body>
</html>
