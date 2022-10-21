<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.estimate_mng.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.res_search.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="as_db" scope="page" class="acar.cls.AddClsDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="rs_db" 	class="acar.res_search.ResSearchDatabase" 	scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
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
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
	CarRegDatabase crd 		= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");	
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//마지막대여정보
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
	//마지막대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	//차량회수여부
	int in_size 			= af_db.getYnCarCallIn(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, String.valueOf(fee_size));
	
	//보조번호판 발급정보
	CarSecondPlateBean second_plate = a_db.getCarSecondPlate(rent_mng_id, rent_l_cd);
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//해지정보
	ClsBean cls = as_db.getClsCase(rent_mng_id, rent_l_cd);
	
	//차량정보-여러테이블 조인 조회
	Hashtable carbase = shDb.getBase(base.getCar_mng_id(), max_fee.getRent_end_dt());
	
	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+fee_size+"&from_page="+from_page+"&now_stat="+now_stat;
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
	//수정모드
	function view_cont_b(){
		var fm = document.form1;	
		fm.action = 'lc_b_s.jsp';
		<%if(base.getCar_st().equals("4")){%>
		fm.action = 'lc_b_u_rm.jsp';
		<%}%>
		<%if(base.getCar_gu().equals("2")){%>
		fm.action = 'lc_b_u_ac.jsp';
		<%}%>
		fm.target = 'd_content';
		fm.submit();
	}	

	//리스트
	function list(){
		var fm = document.form1;
		if(fm.from_page.value != '') 	fm.action = fm.from_page.value;
		else 				fm.action = 'lc_s_frame.jsp';
		fm.target = 'd_content';
		fm.submit();
	}	

	//하단페이지 보기
	function display_c(st){
		var fm = document.form1;	
		fm.action = 'lc_c_c_'+st+'.jsp';
		if(st == 'fee' && fm.car_st.value == '4') fm.action = 'lc_c_c_fee_rm.jsp';
		fm.target = 'c_foot';
		fm.submit();
	}
	
	//상단 일자별 내역보기
	function display_h_in(idx){
		var fee_size = <%=fee_size%>;
		
		head_cont.tr_cont.style.display 		= 'none';		
		head_cont.tr_pur.style.display 			= 'none';
		head_cont.tr_car.style.display 			= 'none';
		head_cont.tr_taecha.style.display 		= 'none';
		<%if(!base.getCar_st().equals("2")){ for(int i=0; i<fee_size; i++){%>
		head_cont.tr_fee<%=i+1%>.style.display 	= 'none';
		<%}}%>		
		head_cont.tr_cls.style.display 			= 'none';
				
		if(idx == 'cont'){
			head_cont.tr_cont.style.display 	= '';
		}else if(idx == 'pur'){
			head_cont.tr_pur.style.display 		= '';
		}else if(idx == 'car'){
			head_cont.tr_car.style.display 		= '';
		}else if(idx == 'taecha'){
			head_cont.tr_taecha.style.display 	= '';
		<%if(!base.getCar_st().equals("2")){ for(int i=0; i<fee_size; i++){%>
		}else if(idx == 'fee<%=i+1%>'){
			head_cont.tr_fee<%=i+1%>.style.display 	= '';
		<%}}%>	
		}else if(idx == 'cls'){
			head_cont.tr_cls.style.display 		= '';
		}else if(idx == 'auc'){
			head_cont.tr_auc.style.display 		= '';
		}else{
			head_cont.tr_cont.style.display 	= '';
		}
	}
	
	//고객 보기
	function view_client()
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>", "CLIENT", "left=10, top=10, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		

	//메일관리 보기
	function view_mail(m_id, l_cd){
		window.open("/acar/car_rent/rent_email_reg.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "RentDocEmail", "left=100, top=100, width=1000, height=700, scrollbars=yes, status=yes");		
	}

	//스캔관리 보기
	function view_scan(m_id, l_cd){
		window.open("scan_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SCAN", "left=100, top=10, width=720, height=900, scrollbars=yes");		
	}

	//납품관리 보기
	function view_est(m_id, l_cd){
		window.open("/acar/car_rent/est_view.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_STAT", "left=100, top=100, width=620, height=400, scrollbars=yes");		
	}
	
	//중도해지정산  보기
	function view_settle(m_id, l_cd){
	
		alert("해지 사전 정산서 입니다. 실 정산금과 차이가 있을 수 있습니다. !!!!");
		alert("초과운행부담금은 해지시 주행거리를 입력하고 타이틀 초과운행대여료(M)를 클릭하면 팝업페이지에서 확인할 수 있습니다. 예상주행거리 디폴트이므로 실제 주행거리를 확인하여 입력하십시오.");
	
		<%if(base.getCar_st().equals("4")){%>
		window.open("/acar/cls_con/cls_settle_rm.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=850, scrollbars=yes, status=yes");	
		<%} else {%>	
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=850, scrollbars=yes, status=yes");		
		<%} %>	
		
	}	
	
	//대여료메모
	function reg_cooperation()
	{
		window.open("/fms2/cooperation/cooperation_i.jsp?from_page=/fms2/lc_rent/lc_s_frame.jsp&rent_l_cd=<%=rent_l_cd%>&client_id=<%=base.getClient_id()%>", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//대여료메모
	function view_memo(m_id, l_cd)
	{
		window.open("/fms2/con_fee/credit_memo_frame.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1&fee_tm=A&tm_st1=0", "CREDIT_MEMO", "left=0, top=0, width=900, height=750, scrollbars=yes");						
	}		
	
	
	//중도해지
	function view_cls(m_id, l_cd)
	{	
		var url = "";
		
		<%if(base.getCar_st().equals("4")){%>
		url = "/acar/cls_con/cls_u_rm.jsp?m_id="+m_id+"&l_cd="+l_cd;	
		<%}else{%>	
			<%if(base.getUse_yn().equals("Y")){%>
			url = "/acar/cls_con/cls_i_tax.jsp?m_id="+m_id+"&l_cd="+l_cd;
			<%}else{%>
			url = "/acar/cls_con/cls_u.jsp?m_id="+m_id+"&l_cd="+l_cd;		
			<%}%>
		<% } %>	
		window.open(url, "CLS_I", "left=50, top=50, width=840, height=650, status=yes, scrollbars=yes");
	}	
			
	//계약만료,중도해지 취소
	function cancel_cls(m_id, l_cd){
		var fm = document.form1;
		fm.cng_item.value = 'cancel_cls';
		
		if(confirm('취소하시겠습니까?')){	
		if(confirm('정말 취소하시겠습니까?')){		
		if(confirm('해지취소하시겠습니까?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}}}								
	}
	
	//길이 체크	
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}	
	
	//수정
	function update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id' || st == 'bus_id2' || st == 'mng_id' || st == 'mng_id2' || st == 'bus_st' || st == 'est_area' || st == 'bus_agnt_id' || st == 'suc_cls_dt'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}else{
			window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=500, status=yes, scrollbars=yes");
		}
	}
	//점검
	function cont_check(){
		var fm = document.form1;
		fm.cng_item.value = 'cont_check';
		
		if(confirm('점검하시겠습니까?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}
	
	//미제출서류
	function cont_check_memo(){
		window.open("/fms2/lc_rent/lc_n_memo.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>&r_st=<%=fee_size%>", "CONT_CHK_MEMO", "left=0, top=0, width=700, height=600, status=yes, scrollbars=yes");	
	}
	
	//계약변경확인
	function cont_cng_check(){
		var fm = document.form1;
		fm.cng_item.value = 'cont_cng_check';
		
		if(confirm('확인하시겠습니까?')){	
			fm.action='lc_c_h_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}							
	}	
	//차량임시회수
	function car_call_in(m_id, l_cd)
	{
		window.open("/fms2/lc_rent/car_call_in_list.jsp?auth_rw=<%=auth_rw%>&m_id="+m_id+"&l_cd="+l_cd+"&r_st=1", "CAR_CALLIN", "left=0, top=0, width=800, height=750");
	}		
	
	//재리스견적
	function car_secondhand(){
		var fm = document.form1;
		
		//if(<%=carbase.get("TODAY_DIST")%>==0 || <%=carbase.get("TODAY_DIST")%>==null){ alert('입력된 주행거리가 없습니다. 고객지원-업무등록에서 부정기등록으로 주행거리를 먼저 입력해주세요'); return;}
		
		
		//월렌트
		<%if(base.getCar_st().equals("4")){%>	
		
		<%	if(cr_bean.getSecondhand().equals("1")){%>		 	
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();					
		<%	}else{%>
		if(confirm('재리스결정대상 차량이 아닙니다. 본사 관리팀장님에게 재리스결정 차량으로 적절한지 문의를 하시기 바랍니다.')){
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();					
		}	
		<%	}%>							

		
		//월렌트아님	
		<%}else{%>
		if(confirm('예상주행거리가 <%=carbase.get("TODAY_DIST")%>입니다. 이 주행거리로 견적하시겠습니까?')){
				fm.action='/acar/secondhand/secondhand_detail_frame.jsp';		
				fm.target='_blank';
				fm.submit();
		}		
		<%}%>
	
	}
	
	
	//연장견적
	function add_rent_esti_s(){
		window.open("search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_ESTI_S", "left=0, top=0, width=1100, height=750, status=yes, scrollbars=yes");	
	}	
	//중고차가
	function sh_car_amt(){
		window.open("search_sh_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_AMT_S", "left=0, top=0, width=1100, height=550, status=yes, scrollbars=yes");	
	}
	
	//월렌트 차량예약 계약확정 승인
	function rent_conform(){
		window.open("/fms2/lc_rent/lc_rm_conform.jsp<%=valus%>", "LC_RM_CONFORM", "left=100, top=100, width=1280, height=850, status=yes, scrollbars=yes");
	}
	
	//월렌트 차량예약 계약확정 취소
	function rent_delete(){
		var fm = document.form1;
		fm.cng_item.value = 'lc_rm_delete';
		if(confirm('취소하시겠습니까?')){
		if(confirm('계약관련 모든 데이타를 삭제하게 됩니다. \n\n삭제하시겠습니까?')){
			fm.action='lc_c_h_a.jsp';
			fm.target='i_no';
			//fm.target='_blank';
			fm.submit();
		}}
	}

	// jjlim@20171101 add kakao_contract
	function view_kakao_contract(m_id, l_cd, car_comp_id) {
        window.open("/acar/kakao/alim_talk_contract.jsp?mng_id="+m_id+"&l_cd="+l_cd+"&car_comp_id="+car_comp_id, "VIEW_KAKAO_CONTRACT", "left=0, top=0, width=800, height=750, scrollbars=yes");
	}
	
	// 확인서 출력 팝업 2017.12.27
	function view_confirm_popup(){
		var url = "./lc_c_h_confirm_popup.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>";
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=760, height=450, scrollbars=yes, status=yes");
	}
	
	// 확인서 전자문서
	function view_confirm_edoc(){
		var url = "./confirm_doc_list.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=max_fee.getRent_st()%>";		
		window.open(url,"CONFIRM_POPUP", "left=0, top=0, width=760, height=450, scrollbars=yes, status=yes");
	}
	
	//심사자료
	function view_bus_review(){
		var client_id = '<%=base.getClient_id()%>';
		var url = "./lc_c_h_bus_review_popup.jsp?client_id="+client_id;
		window.open(url,"REVIEW_POPUP", "left=0, top=0, width=1800, height=950, scrollbars=yes");
	}
	
	//재리스 견적내기
	function EstiReReg(){
		var fm = document.form1;
		fm.action = 'get_esti_mng_i_re_rent.jsp';
		fm.target = "_blank";
		fm.submit();
	}	

	//예약이력
	function view_sh_res_h(){
		var SUBWIN="/acar/secondhand/reserveCarHistory.jsp?car_mng_id=<%=base.getCar_mng_id()%>";
		window.open(SUBWIN, "reserveCarHistory", "left=50, top=50, width=850, height=800, scrollbars=yes, status=yes");
	}	
	//특별할인
	function spedc_car_reg(){
		var SUBWIN="/acar/off_lease/newcar_special_discount_i.jsp?car_mng_id=<%=base.getCar_mng_id()%>";
		window.open(SUBWIN, "specialDiscount", "left=50, top=50, width=650, height=300, scrollbars=yes, status=yes");			
	}
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body leftmargin="15" <%if(base.getUse_yn().equals("N")){%>onLoad="javascript:display_h_in('cls');"<%}%>>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 		value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 		value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 		value='<%=gubun3%>'>    
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>    
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
  <input type='hidden' name="rent_mng_id" 	value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st" 		value="<%=fee_size%>">  
  <input type='hidden' name="from_page" 	value="<%=from_page%>">
  <input type='hidden' name="now_stat" 		value="<%=now_stat%>">  
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="car_st" 		value="<%=base.getCar_st()%>">
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">  
  <input type='hidden' name="cng_item"		value="">    
  <input type='hidden' name="est_st"		value="">      
  <input type='hidden' name="fee_opt_amt"	value="<%=max_fee.getOpt_s_amt()+max_fee.getOpt_v_amt()%>">        
  <input type='hidden' name="fee_rent_st"	value="<%=max_fee.getRent_st()%>">    

<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>계약서보기</span></span>
                        <%if(!base.getCar_st().equals("4")){%><%if(nm_db.getWorkAuthUser("관리자모드",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id)){%><a href="javascript:view_cont_b()" onMouseOver="window.status=''; return true">.</a><%}%><%}%>
                        <%if(base.getCar_st().equals("4")){%><%if(nm_db.getWorkAuthUser("전산팀",user_id)){%><a href="javascript:view_cont_b()" onMouseOver="window.status=''; return true">.</a><%}%><%}%>
                    </td>
                    <td class=bar style='text-align:right'>&nbsp;<font color="#996699">
            	          <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%><a href="javascript:display_c('suc_commi')">[계약승계]</a> 원계약 : <%=begin.get("FIRM_NM")%>, 승계일자 : <%=cont_etc.getRent_suc_dt()%><%if(cont_etc.getRent_suc_dt().equals("")){%><%=begin.get("CLS_DT")%><%}%>, 계약승계수수료 : <%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>원, 해지일자 : <%=begin.get("CLS_DT")%>, 등록일자 : <%=base.getReg_dt()%> <%}%>
            	          <%if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>[차종변경] 원계약 : <%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%>, 변경일자 : <%=begin.get("CLS_DT")%>, 등록일자 : <%=base.getReg_dt()%><%}%>
			                  </font>&nbsp;
			                  <%if(in_size > 0){%><span class=style5>[차량회수상태]</span><%}%>
			                  <%if(base.getReject_car().equals("Y")){%><span class=style5>[인수거부차량]</span><%}%>
		                </td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2" align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td align=right>
            <table width=100% border=0 cellspacing=0 cellpadding=0>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                            <tr> 
                                <td class=title width=13%>계약번호</td>
                                <td width=21%>&nbsp;<%=rent_l_cd%></td>
                                <td class=title width=10%>상호</td>
                                <td width=22%>&nbsp;<a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a>
                                <%	if(!base.getCar_mng_id().equals("") && base.getCar_st().equals("2")){	
                                		//대차관리 배차상태
                            			Hashtable reserv = rs_db.getResCarCase(base.getCar_mng_id(), "2");
                            			String use_st = String.valueOf(reserv.get("USE_ST"))==null?"":String.valueOf(reserv.get("USE_ST"));
                            			//대차관리 예약상태
                            			Hashtable reserv2 = rs_db.getResCarCase(base.getCar_mng_id(), "1");
                            			String use_st2 = String.valueOf(reserv2.get("USE_ST"))==null?"":String.valueOf(reserv2.get("USE_ST")); %>
                            			
                            			<%if(!use_st.equals("null")){%>
                              			( [배차] <%=reserv.get("RENT_ST")%> &nbsp;<%=reserv.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              			<%}else{ %>
                              			<%	if(!use_st2.equals("null")){%>
                              			( [예약] <%=reserv2.get("RENT_ST")%> &nbsp;<%=reserv2.get("FIRM_NM")%> &nbsp;<a href="javascript:view_sh_res_h()" title="이력"><img src=/acar/images/center/button_ir_ss.gif align=absmiddle border=0></a> )
                              			<%	} %>
                              			<%} %>
                              			                            			
                            	<%	} %>		
                                </td>
                                <td class=title width=10%><%if(cr_bean.getCar_no().equals("")){%>차명<%}else{%>차량번호<%}%></td>
                                <td width=25%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a>
                    		          &nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>
                    		        </td>
                            </tr>
                            <%if (!second_plate.getSecond_plate_yn().equals("")) {%>
                            <tr>
                            	<td class=title width=13%>보조번호판</td>
                                <td colspan="5" width=77%>&nbsp;<%if (second_plate.getSecond_plate_yn().equals("Y")) {%>보조번호판 발급<%} else if (second_plate.getSecond_plate_yn().equals("R")) {%>보조번호판 회수 (회수일 : <%=AddUtil.ChangeDate2(second_plate.getReturn_dt())%>)<%} else if (second_plate.getSecond_plate_yn().equals("N")) {%>보조번호판 미회수 (미회수 사유 : <%=second_plate.getEtc()%>)<%}%></td>
                            </tr>
	                    	<%}%>
						</table>
            	    </td>
            	</tr>
            </table>
        </td>
	      <td width=7>&nbsp;</td>
    </tr> 
    <tr>
        <td class=h></td>
    </tr> 	  	
    <%	int height = 160;
    		
    		if(base.getCar_gu().equals("2")) height = 135;
    %>
    <tr> 
        <td colspan="2">
    	    <table border="0" cellspacing="1" cellpadding='0' width=100%>
    		    <tr>
        		    <td width=32%>
        			  <iframe src="lc_c_h_dt.jsp<%=valus%>" name="head_dt" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                		</iframe>
        			</td>
        			<td width=2%>&nbsp;</td>
        			<td width=67%>
        			  	<iframe src="lc_c_h_in.jsp<%=valus%>" name="head_cont" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                		</iframe>	
        			</td>
    		    </tr>
    		</table>
	    </td>
    </tr>
    <%if(!base.getCar_gu().equals("2")){%>
    <tr>
        <td class=h></td>
    </tr>	
	<tr>
	    <td colspan="2" style='background-color:e3e3e3; height:1'></td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>
    <%}%>
    <%if(!base.getCar_st().equals("2")){%>	
    <tr>
		<td colspan="2" align="center">
    	  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    			<tr>
        	    <td align='center'>
        	    
        	    	    <!-- 파란버튼 -->
                        <a href="javascript:display_c('client')" title='고객'><img src=/acar/images/center/button_cnt_cust.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('car')" title='자동차&보험'><img src=/acar/images/center/button_cnt_carins.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('fee')" title='대여'><img src=/acar/images/center/button_cnt_lend.gif align=absmiddle border=0></a>&nbsp;
                        <a href="javascript:display_c('gur')" title='채권확보'><img src=/acar/images/center/button_cnt_cghb.gif align=absmiddle border=0></a>&nbsp;
                        
                        <%if(!base.getCar_st().equals("4") && !base.getReject_car().equals("Y")){%>
                        <a href="javascript:display_c('emp')" title='영업사원'><img src=/acar/images/center/button_cnt_sman.gif align=absmiddle border=0></a>&nbsp;
                        <%}%>
                        
                        <%if(!base.getCar_st().equals("4")){%>
                        <a href="javascript:display_c('tint')" title='용품'><img src=/acar/images/center/button_p_yp.gif align=absmiddle border=0></a>&nbsp;
                        <%}%>
                        
			            <a href="javascript:display_c('etc')" title='특이사항'><img src=/acar/images/center/button_p_sp.gif align=absmiddle border=0></a>&nbsp;
			            
			            &nbsp;&nbsp;&nbsp;&nbsp;
			            
        	    	    <!-- 검정버튼 -->
   						<a href="javascript:view_kakao_contract('<%=rent_mng_id%>','<%=rent_l_cd%>','<%=cm_bean.getCar_comp_id()%>');" class="btn" title='알림톡'><img src=/acar/images/center/button_ntalk.gif align=absmiddle border=0></a>&nbsp;
        			    <a href="javascript:view_memo('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='통화'><img src=/acar/images/center/button_th.gif align=absmiddle border=0></a>&nbsp;
        		        <a href="javascript:view_mail('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='메일'><img src=/acar/images/center/button_mail.gif align=absmiddle border=0></a>&nbsp;
        	            <a href="javascript:view_scan('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='스캔'><img src=/acar/images/center/button_scan.gif align=absmiddle border=0></a>&nbsp;
        	            
        	            <%if(!base.getCar_st().equals("4")){%> <!-- 월렌트아니면  -->
        	            <!-- 납품 -->
        	            <%		if(!base.getReject_car().equals("Y") && base.getRent_start_dt().equals("")){%>
                	    <a href="javascript:view_est('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='납품'><img src=/acar/images/center/button_np.gif align=absmiddle border=0></a>&nbsp;
                	    <%		}%>
                	    <!-- 미점검시 -->
			            <%		if(from_page.equals("/fms2/lc_rent/lc_n_frame.jsp")){//미점검현황%>
        		        <%			if(nm_db.getWorkAuthUser("관리자모드",user_id) || nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("지점장",user_id) || nm_db.getWorkAuthUser("지점장2",user_id)){%>
        		        <%				if(fee_etc.getChk_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id)){//계약서류점검%>
        			    <a href="javascript:cont_check();" class="btn" title='계약봉투 점검 완료처리'><img src=/acar/images/center/button_jg.gif align=absmiddle border=0></a>&nbsp;
        			    <a href="javascript:cont_check_memo();" class="btn" title='미결재서류 업무협조'><img src=/acar/images/center/button_mjcsr.gif align=absmiddle border=0></a>&nbsp;
        			    <%				}%>
        		        <%			}%>
			            <%		}%>
			            <!-- 계약변경미확인시 -->
			            <%		if(from_page.equals("/fms2/lc_rent/lc_n2_frame.jsp")){//계약변경미확인현황%>
        		        <%			if(nm_db.getWorkAuthUser("계약봉투점검자",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)  || nm_db.getWorkAuthUser("연장/승계담당자",user_id)  || nm_db.getWorkAuthUser("세금계산서담당자",user_id) ){%>
        			    <%				if(!fee_etc.getCng_chk_id().equals("") && fee_etc.getCng_chk_dt().equals("")){//계약변경확인%>
        			    <a href="javascript:cont_cng_check();" class="btn" title='계약변경 확인처리'><img src=/acar/images/center/button_modify_gy.gif align=absmiddle border=0></a>&nbsp;
        			    <%				}%>
        		        <%			}%>
			            <%		}%>
   			            <!-- 해지 - 말소,폐차, 매입옵션-->			            
			            <%		if(base.getUse_yn().equals("Y") ){%>	
			            <%			if(nm_db.getWorkAuthUser("총무팀남",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) ){%>		            
        		        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='해지'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;
        		         <%				}%>
        		        <%		}%>
			            <!-- 정산 - 장기대여차량(렌트/리스) -->
			            <%		if(base.getUse_yn().equals("Y") && (base.getCar_st().equals("1")||base.getCar_st().equals("3"))){%>			            
				        <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='정산'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;
        		        <%		}%>
        		        <!-- 해지내역 보기  -->
        		        <%		if(base.getUse_yn().equals("N")){%>
				               <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='해지하기'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;
        		        <% } %>        		        
        		        <!-- 해지부활 -->
        		        <%		if(base.getUse_yn().equals("N") && (nm_db.getWorkAuthUser("전산팀",user_id) && base.getUse_yn().equals("N"))){%>
        		        <%			if(cls.getCls_st().equals("계약만료") || cls.getCls_st().equals("중도해약") || cls.getCls_st().equals("매입옵션")){%>
        			    <a href="javascript:cancel_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='해지부활'><img src=/acar/images/center/button_cancel_hj.gif align=absmiddle border=0></a>&nbsp;
        			    <%			}%>
        		        <%		}%>
        		        <!-- 차량회수 -->
			            <%		if(base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("보유차관리자들",user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("매입옵션관리자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id) || nm_db.getWorkAuthUser("해지관리자",user_id)){%>		
			            <%			if(base.getUse_yn().equals("Y") && !fee.getRent_start_dt().equals("")){%>					  
        			    <a href="javascript:car_call_in('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='차량회수'><img src=/acar/images/center/button_hs.gif align=absmiddle border=0></a>&nbsp;					  
				        <%			}%>
			            <%		}%>
			            <!-- 미래 연장견적 -->
			            <%		if(base.getUse_yn().equals("Y") && (base.getCar_st().equals("1")||base.getCar_st().equals("3"))){%>
			            <a href="javascript:add_rent_esti_s();" class="btn" title='연장견적하기'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;					  
			            <%		}%>			
			            <!-- 신차개시후 견적다시내기 -->
			            <%		if(base.getUse_yn().equals("Y") && base.getCar_gu().equals("1") && cont_etc.getRent_suc_dt().equals("") && fee_size==1 && !base.getCar_mng_id().equals("") && !base.getRent_start_dt().equals("")){%>
			            <%			if(ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//전기,수소는 안함.%>
			            <%			}else{ %>
                        <!-- <input type="button" class="button" value="신차개시후 견적 다시내기" onclick="javascript:EstiReReg();">&nbsp; -->
                        <input type="button" class="button" value="신차개시후 약정거리 변경" onclick="javascript:EstiReReg();">&nbsp;
                        <%			} %>
                        <%		} %>
			            <%}%>
			            
			            
                        <!-- 재리스잔존가 - 자차 사고수리시 현재 재리스잔존가 확인 -->
			            <%if(base.getUse_yn().equals("Y") && !base.getCar_mng_id().equals("") && !base.getRent_start_dt().equals("")){%>			            
	                    <a href="javascript:sh_car_amt();" class="btn" title='재리스잔존가'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;
			            <%}%>

			            <!--월렌트 -->	
			            <%if(base.getCar_st().equals("4")){%>
			            
			            <%		if(base.getUse_yn().equals("Y")){%>
			            <!-- 정산 -->
				        <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='정산'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;
                        <!-- 재견적 -->
                        <a href="javascript:car_secondhand();" class="btn" title='재리스견적하기'><img src=/acar/images/center/button_slease.gif align=absmiddle border=0></a>&nbsp;
                        <!-- 승인취소 -->
                        <%			if(!cont_etc.getSpe_est_id().equals("") && base.getRent_start_dt().equals("")){%>
                        <%				if(base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사월렌트담당",user_id)){%>
                        <a href="javascript:rent_delete();" class="btn" title='취소하기'><img src=/acar/images/center/button_cancel_cont.gif align=absmiddle border=0></a>&nbsp;                        
                        <%				}%>
                        <%			}%>
                        <%		}%>
                        
			            <%		if(base.getUse_yn().equals("N")){%>
        		        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='해지하기'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp; 
        		        <%		}%>
        		        
			            <%		if(base.getUse_yn().equals("")){%>
			            <!-- 홈페이지 고객 월렌트 예약 연동 -->
			            <%			if(!cont_etc.getSpe_est_id().equals("")){%>
			            <!-- 계약승인 -->
			            <a href="javascript:rent_conform();" class="btn" title='승인하기'><img src=/acar/images/center/button_app_cont.gif align=absmiddle border=0></a>&nbsp;
			            <!-- 승인취소 -->
                        <a href="javascript:rent_delete();" class="btn" title='취소하기'><img src=/acar/images/center/button_cancel_cont.gif align=absmiddle border=0></a>&nbsp;
                        <!-- 영업대리인 -->
   		                <%				if(cont_etc.getBus_agnt_id().equals("")){%>                 
    					<input type="button" class="button" value="영업대리인 등록" onclick="javascript:update('bus_agnt_id');">&nbsp;
    					<%				}%>
    					<%			} %>
   		                <%		} %>
   		                  
   		                <%		if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
   		                <a href="javascript:rent_conform();" class="btn" title='승인하기'><img src=/acar/images/center/button_app_cont.gif align=absmiddle border=0></a>&nbsp;
   		                <%		}%>   		                  
                        <%} %>
                        
                        <!-- 확인서 출력 2018.1.2-->
                        <a href="javascript:view_confirm_popup();" class="btn"><img src=/acar/images/center/button_confirm.gif align=absmiddle border=0></a>&nbsp;
                        
                        <%//		if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                        <input type="button" class="button" value="전자확인서" onclick="javascript:view_confirm_edoc();">&nbsp;
                        <%//		}%>
                        
                        
                        <!-- 심사 -->
                        <%if(nm_db.getWorkAuthUser("계약결재",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
                        <input type="button" class="button" value="심사" onclick="javascript:view_bus_review();">&nbsp;
                        <%} %>
                        
                        <!--  업무협조 등록  -->
                        <input type="button" class="button" value="업무협조" onclick="javascript:reg_cooperation();">&nbsp;
                        
                        <%if(base.getCar_gu().equals("1") && cr_bean.getNcar_spe_dc_amt() > 0 && ck_acar_id.equals("000029")){%>
                        <input type="button" class="button" value="특별할인" onclick="javascript:spedc_car_reg();">&nbsp;
                        <%} %>
   	    </td>						
    		</tr>
    	    </table>
		</td>
    </tr>	
    <%}else{ //보유차%>
    <%	if(base.getCar_gu().equals("2")){%>
    <tr>
	      <td colspan="2" align="center">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        	    <td align="center">        	    	
                    <a href="javascript:display_c('car_ac')"><img src=/acar/images/center/button_cnt_carins.gif align=absmiddle border=0></a>&nbsp;
        	    </td>
    		    </tr>
    	    </table>
	      </td>
    </tr>    
    <%	}else{%>
    <tr>
	      <td colspan="2" align="center">
    	    <table border="0" cellspacing="0" cellpadding="0" width=100%>
    		    <tr>
        	    <td align="center">
        	        <a href="javascript:display_c('tint')"><img src=/acar/images/center/button_p_yp.gif align=absmiddle border=0></a>&nbsp;
        	        <a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='해지하기'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;         		
		            <%if(!base.getCar_mng_id().equals("")){%>
		            <a href="javascript:sh_car_amt();" class="btn" title='중고차가계산'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;					  
 	                <%}%>
        	    </td>
    		    </tr>
    	    </table>
	      </td>
    </tr>
    <%	}%>
    <%}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
