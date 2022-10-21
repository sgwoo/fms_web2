<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.user_mng.*, acar.kakao.*, acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="ej_bean" class="acar.estimate_mng.EstiJgVarBean" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>

<jsp:useBean id="atp_db" class="acar.kakao.AlimTemplateDatabase" scope="page"/>
<jsp:useBean id="atl_db" class="acar.kakao.AlimTalkLogDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String est_id 	= request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	EstimateBean e_bean1 = new EstimateBean();
	EstimateBean e_bean2 = new EstimateBean();
	EstimateBean e_bean3 = new EstimateBean();
	EstimateBean e_bean4 = new EstimateBean();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	EstiDatabase e_db = EstiDatabase.getInstance();
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
			
	e_bean1 = e_db.getEstimateCase(est_id);
	
	cm_bean = a_cmb.getCarNmCase(e_bean1.getCar_id(), e_bean1.getCar_seq());
	
	//차종변수
    ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	Vector vars = new Vector();
	int size = 0;
	
	if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4") || e_bean1.getPrint_type().equals("5") || e_bean1.getPrint_type().equals("6")){
		vars = e_db.getABTypeEstIds2(set_code, est_id);
		size = vars.size();
	}else{
		vars = e_db.getABTypeEstIds(set_code, est_id);
		size = vars.size();
	}
	
	
	for(int i = 0 ; i < size ; i++){
		Hashtable var = (Hashtable)vars.elementAt(i);
		
		if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4") || e_bean1.getPrint_type().equals("5") || e_bean1.getPrint_type().equals("6")){
			if(i==0) e_bean1 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==3) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));		
		}else{
			if(i==0) e_bean2 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==1) e_bean3 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
			if(i==2) e_bean4 = e_db.getEstimateCase(String.valueOf(var.get("EST_ID")));
		}		
	}
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//제조사 목록의 비고 표시
	//String etc = umd.getCarCompOne(cm_bean.getCar_comp_id());
	Hashtable com_ht = umd.getCarCompCase(cm_bean.getCar_comp_id());
	String etc 	= String.valueOf(com_ht.get("ETC"));
	//String bigo = String.valueOf(com_ht.get("BIGO"));
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean1.getReg_id());
	
	u_nm = user_bean.getUser_nm();
	u_mt = user_bean.getUser_m_tel();
	u_ht = user_bean.getHot_tel();

	if(u_nm.equals("박규숙")) u_nm = "최수진";
	if(u_nm.equals("김지영")) u_mt = "";
	if(u_nm.equals("김설희")) u_mt = "";
	if(u_nm.equals("권웅철")) u_nm = "유재석 팀장";
	if(u_nm.equals("성장근")) u_nm = "항상다이렉트";
	if(u_nm.equals("강훈구")){ u_nm = "서경오토플랜"; u_mt = u_ht;}
	if(u_nm.equals("김주박")) u_nm = "오토뱅크";
	if(u_nm.equals("염정진2")) u_nm = "아마존플러스";
	
	if(e_bean1.getCaroff_emp_yn().equals("4")){
		u_nm = e_bean1.getDamdang_nm();
		u_mt = e_bean1.getDamdang_m_tel();
		u_ht = "";	
	}
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(e_bean1.getRent_mng_id(), e_bean1.getRent_l_cd());
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(e_bean1.getRent_mng_id(), e_bean1.getRent_l_cd(), "Y");
	int mgr_size = car_mgrs.size();
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//카카오템플릿
	String send_msg = "";
	
	ArrayList<String> sendList = new ArrayList<String>();
	
	sendList.add(e_bean1.getEst_nm());
	sendList.add("팩스");
	sendList.add(u_nm);
	sendList.add(u_mt);
	
	AlimTemplateBean sendTemplateBean = atp_db.selectTemplate("acar0072");
	String send_content_temp = sendTemplateBean.getContent();
	String send_content = sendTemplateBean.getContent();
  	for (String send : sendList) {
  		send_content = send_content.replaceFirst("\\#\\{.*?\\}", send);
	}
  	
  	send_msg = send_content;
	
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.over_auto {
	overflow: auto !important;
}
.num_weight {
	font-weight: 800 !important;
}
</style>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//목록보기
	function go_list(){
		var fm = document.form1;		
		<%if(from_page.equals("/acar/estimate_mng/esti_mng2_sc_in.jsp")){%>
		fm.action = 'esti_mng2_frame.jsp';
		<%}else if(from_page2.equals("/fms2/bus_analysis/ba_esti_frame.jsp")){%>
		fm.action = '/fms2/bus_analysis/ba_esti_frame.jsp';
		<%}else if(from_page2.equals("/fms2/bus_analysis/ba_stat_frame.jsp")){%>
		fm.action = '/fms2/bus_analysis/ba_stat_frame.jsp';
		<%}else{%>
		fm.action = 'esti_mng_frame.jsp';	
		<%}%>
		fm.target = 'd_content';					
		fm.submit();
	}

	function ReEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 're';
		fm.action = 'esti_mng_atype_i.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}
	
	//신규_TODO
	function ReEsti6(est_id, set_code){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.set_code.value = set_code;
		fm.cmd.value = 're';
		fm.action = 'esti_mng_atype_i.jsp';		
		fm.target = 'd_content';					
		fm.submit();
	}
	
	function DelEsti(est_id){
		var fm = document.form1;
		fm.est_id.value = est_id;
		fm.cmd.value = 'd';
		
		if(!confirm('삭제하시겠습니까? 삭제되면 복구되지 않습니다.')){	
			return; 
		}	
		
		fm.action = 'esti_mng_d_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}		

	//견적서보기
	function EstiView(idx, est_id){
		//보증금,선납금 과다입금시 월대여료 음수값 확인
		if      (idx == 1 && <%=e_bean1.getPp_amt()%> > 0 && <%=e_bean1.getFee_s_amt()%> < 0){
			alert('※ 월대여료는 음수값이 나오면 안됩니다./n/n(보증금 및 선납금 확인 후 견적내기 필요)');
		}else if(idx == 2 && <%=e_bean2.getPp_amt()%> > 0 && <%=e_bean2.getFee_s_amt()%> < 0){
			alert('※ 월대여료는 음수값이 나오면 안됩니다./n/n(보증금 및 선납금 확인 후 견적내기 필요)');		
		}else if(idx == 3 && <%=e_bean3.getPp_amt()%> > 0 && <%=e_bean3.getFee_s_amt()%> < 0){
			alert('※ 월대여료는 음수값이 나오면 안됩니다./n/n(보증금 및 선납금 확인 후 견적내기 필요)');		
		}else if(idx == 4 && <%=e_bean4.getPp_amt()%> > 0 && <%=e_bean4.getFee_s_amt()%> < 0){
			alert('※ 월대여료는 음수값이 나오면 안됩니다./n/n(보증금 및 선납금 확인 후 견적내기 필요)');		
		}else if(idx == 1 && <%=e_bean1.getPp_amt()%> == 0 && <%=e_bean1.getFee_s_amt()%> <= 0){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');
		}else if(idx == 2 && <%=e_bean2.getPp_amt()%> == 0 && <%=e_bean2.getFee_s_amt()%> <= 0){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');		
		}else if(idx == 3 && <%=e_bean3.getPp_amt()%> == 0 && <%=e_bean3.getFee_s_amt()%> <= 0){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');		
		}else if(idx == 4 && <%=e_bean4.getPp_amt()%> == 0 && <%=e_bean4.getFee_s_amt()%> <= 0){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');			
		}else if(idx == 1 && <%=e_bean1.getCls_per()%> > 100){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');
		}else if(idx == 2 && <%=e_bean2.getCls_per()%> > 100){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');		
		}else if(idx == 3 && <%=e_bean3.getCls_per()%> > 100){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');		
		}else if(idx == 4 && <%=e_bean4.getCls_per()%> > 100){
			alert('※ 보증금을 과다하게 입력하였습니다. 보증금을 줄여주세요');			
		}else{
			var SUBWIN="/acar/main_car_hp/estimate_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
			window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");
		}	
	}
		
	//다중견적서보기
	function EstiViewAll(print_type, est_id){
		var SUBWIN="/acar/main_car_hp/estimate_renew.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		if(print_type == 4){
			SUBWIN="/acar/main_car_hp/estimate_renew_all.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}else if(print_type == 5){
			SUBWIN="/acar/main_car_hp/estimate_comp_fms.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}else if(print_type == 6){
			SUBWIN="/acar/main_car_hp/estimate_eh_all.jsp?est_id="+est_id+"&acar_id=<%=ck_acar_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp";					
		}
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=798, height=800, scrollbars=yes, status=yes");								
	}
	
	//고객수정하기
	function CustUpate(){
		var fm = document.form1;
		if(!confirm('고객정보를 수정하시겠습니까?')){	
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}	
	
	//견적사후관리 수정
	function BusUpate(){
		var fm = document.form1;
		if(fm.bus_yn.value == '')	{ 
			alert('계약여부를 확인하십시오.'); 		
			return;
		}
		if(!confirm('시장상황를 수정하시겠습니까?')){	
			return; 
		}	
		fm.action = 'upd_esti_bus_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}
		
	//위약금 수정
	function EstiClsPerCng(idx, est_id){
		var fm = document.form1;
		fm.cng_est_id.value = est_id;
		fm.cng_cls_per.value = fm.cls_per[idx].value
		fm.cmd.value = 'cls_per_cng';
		if(!confirm('적용위약율를 수정하시겠습니까?')){	
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}	
	
	//조정대여료
	function EstiFeeAmtCng(idx, est_id){
		var fm = document.form1;
		
		if(est_id == ''){
			alert('조정할 대여료가 없습니다.');
			return;
		}
		
		fm.cng_est_id.value = est_id;		
		
		window.open('about:blank', "FeeAmtCng", "left=0, top=0, width=450, height=220, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "FeeAmtCng";				
		fm.action = 'upd_esti_amt.jsp';		
		fm.submit();	
	}
	
	//약정운행거리 조정 - 월대여료, 매입옵션금액 수정
	function EstiDistCng(idx, est_id){
		var fm = document.form1;
		
		if(est_id == ''){
			alert('조정할 약정운행거리가 없습니다.');
			return;
		}
		
		fm.cng_est_id.value = est_id;		
		
		window.open('about:blank', "DistCng", "left=0, top=0, width=450, height=420, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DistCng";				
		fm.action = 'upd_dist_esti_amt.jsp';		
		fm.submit();	
	}
	
	//선택출력하기
	function select_print(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적을 선택하세요.");
			return;
		}	
		
		alert("인쇄미리보기로 페이지 확인후 출력하시기를 권장합니다.");
		
		fm.target = "_blank";
		fm.action = "/acar/main_car_hp/esti_doc_select_print.jsp";
		fm.submit();	
	}	
	
	//선택메일발송
	function select_email(){
		var fm = document.form1;	
		var len=fm.elements.length;
		var cnt=0;
		var idnum="";
		for(var i=0 ; i<len ; i++){
			var ck=fm.elements[i];		
			if(ck.name == "ch_l_cd"){		
				if(ck.checked == true){
					cnt++;
					idnum=ck.value;
				}
			}
		}			
		if(cnt == 0){
		 	alert("견적을 선택하세요.");
			return;
		}	
		
		fm.target = "_blank";
		fm.action = "/acar/apply/select_mail_input.jsp";
		fm.submit();	
	}		
	
	//전체삭제하기
	function all_delete(){
		var fm = document.form1;
		fm.cmd.value = 'all_delete';		
		
		if(!confirm('일괄 삭제하시겠습니까? 삭제되면 복구되지 않습니다.')){	
			return; 
		}
		
		fm.action = 'esti_mng_d_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();				
	}			
	
	//견적결과 문자보내기
	function esti_result_sms(){
		var fm = document.form1;
		
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){
			fm.est_m_tel.value = fm.est_tel.value 
		}
		
		if(fm.est_m_tel.value == ''){ 	
			alert('수신번호를 입력하십시오'); 	
			fm.est_m_tel.focus();
			return;
		}		
		
		fm.cmd.value = 'result_sms';
		
		if(!confirm('이 번호로 결과문자를 발송하시겠습니까?')){
			return; 
		}	
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}
	
	//견적결과보기
	function estimates_view(reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=1&rent_st=1&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//견적결과 선택 상세내용 문자보내기
	function select_esti_result_sms(){
		var fm = document.form1;
						
		if(fm.est_tel.value != '' && fm.est_m_tel.value == ''){ 	
			fm.est_m_tel.value = fm.est_tel.value 
		}		
		
		if(fm.est_m_tel.value == ''){ 	
			alert('수신번호를 입력하십시오'); 		
			fm.est_m_tel.focus();
			return; 
		}
		
		var caroff_emp_yn = document.getElementsByName("caroff_emp_yn");
		var caroff_emp_yn_value;
		for(var i = 0; i < caroff_emp_yn.length; i++){
		    if(caroff_emp_yn[i].checked){
		    	caroff_emp_yn_value = caroff_emp_yn[i].value;
		    }
		}
		
		if (caroff_emp_yn_value != fm.caroff_emp_yn_origin.value) {
			alert("상단 담당자 표시구분이 기존 데이터와 일치하지 않습니다. \n담당자 표시구분을 수정 후 견적문자 발송 부탁드립니다.");			
			document.getElementById("caroff_emp_yn1").focus();
			return;
		}				
		
		if (!confirm('이 번호로 견적문자를 발송하시겠습니까?')){	
			return; 
		}	
		
		fm.cmd.value = 'result_select_sms_wap';
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';							
		fm.submit();	
	}
	
	//출고보전수당 보기
	function dlv_con_commi(){
		var fm = document.form1;
		
		window.open('about:blank', "DlvConCommi", "left=0, top=0, width=500, height=600, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "DlvConCommi";				
		fm.action = 'view_dlv_con_commi.jsp';		
		fm.submit();	
	}
	
	//자체탁송료 조회
	function search_cons_cost(){
		var fm = document.form1;
		
		window.open('about:blank', "SearchConsCost", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
		
		fm.target = "SearchConsCost";				
		fm.action = 'search_cons_cost.jsp';		
		fm.submit();	
	}
	
	//차종내역 보기
	function view_car_nm(car_id, car_seq){
		window.open("/acar/car_mst/car_mst_u.jsp?car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}
	
	//고객구분 - 법인일경우 특판출고 노출
	function doc_type_check() {
		var doc_type_value = $('input:radio[name="doc_type"]:checked').val();		
		/* if (doc_type_value != "1") {
			$("#doc_type_check_div").hide();
			//$('input:checkbox[name="dir_pur_commi_yn"]').attr("checked", "checked");
			$('input:checkbox[name="dir_pur_commi_yn"]').removeAttr("checked");
		} else {
			$("#doc_type_check_div").show();
		} */
	}
	
	//카카오템플릿 reload
	function reloadTemplateContent() {
		var customer_name = "<%=e_bean1.getEst_nm()%>";
		var esti_send_way = $("select[name=sms_cont2]").val();
		var manager_name = "<%=u_nm%>";
		var manager_phone = "<%=u_mt%>";
		
		var reg = /\#\{(.*?)\}/g;
	    var idx = 1;	    
		var searchFields = new Object();
	    
	    searchFields.customer_name = customer_name;
	    searchFields.esti_send_way = esti_send_way;
	    searchFields.manager_name = manager_name;
	    searchFields.manager_phone = manager_phone;
	     
	    JSON.stringify(searchFields);
	    
	 	var replace_send_content_temp = $("#send_content_temp").val();
	 	var newLine = String.fromCharCode(13, 10);
	 	var replace_send_content = replace_send_content_temp.replace(/\\n/g, newLine);
	 	
	    var empText = replace_send_content.replace(reg, function(match, p1, offset) {
	        var val = searchFields[p1];
	        /*
	        if (val == undefined || val == "") {
	            val = p1;
	        }
	        */
	        return val;
	    });
	    
	    $("#alim-textarea").val(empText);
	}
	
	function view_car_bbs(){
		var fm = document.form1;
		var car_comp_id = $("#car_comp_id option:selected").val();
		if (car_comp_id == '') {    alert('제조사를 선택하십시오');       return; }
		window.open('about:blank', "ViewCarBbs", "left=0, top=0, width=800, height=800, scrollbars=yes, status=yes, resizable=yes");		
		fm.target = "ViewCarBbs";				
		fm.action = 'view_car_bbs.jsp';		
		fm.submit();	
	}	
	
//-->
</script>
</head>
<body onload="javascript:document.form1.est_nm.focus();">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
<form action="" name="form1" method="POST">
	<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
	<input type="hidden" name="br_id" value="<%=br_id%>">
	<input type="hidden" name="user_id" value="<%=user_id%>">
	<input type="hidden" name="gubun1" value="<%=gubun1%>">
	<input type="hidden" name="gubun2" value="<%=gubun2%>">
	<input type="hidden" name="gubun3" value="<%=gubun3%>">
	<input type="hidden" name="gubun4" value="<%=gubun4%>">
	<input type="hidden" name="gubun5" value="<%=gubun5%>">
	<input type="hidden" name="gubun6" value="<%=gubun6%>">  
	<input type="hidden" name="s_dt" value="<%=s_dt%>">
	<input type="hidden" name="e_dt" value="<%=e_dt%>">
	<input type="hidden" name="s_kd" value="<%=s_kd%>">
	<input type="hidden" name="t_wd" value="<%=t_wd%>">
	<input type="hidden" name="est_id" value="<%=est_id%>">
	<input type="hidden" name="set_code" value="<%=set_code%>">
	<input type="hidden" name="cmd" value="">
	<input type="hidden" name="s_st" value="<%=cm_bean.getS_st()%>">
	<input type="hidden" name="a_e" value="">
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">		
	<input type="hidden" name="a_h" value="">					
	<input type="hidden" name="cng_cls_per" value="">					
	<input type="hidden" name="cng_est_id" value="">					
	<input type="hidden" name="wap_est_id" value="">
	<input type="hidden" name="wap_est_idx" value="">
	<input type="hidden" name="from_page" value="esti_mng_atype_u.jsp">					
	<input type="hidden" name="car_id" value="<%=e_bean1.getCar_id()%>">
	<input type="hidden" name="car_seq" value="<%=e_bean1.getCar_seq()%>">
	<input type="hidden" name="car_amt" value="<%=e_bean1.getCar_amt()%>">
	<input type="hidden" name="opt_amt" value="<%=e_bean1.getOpt_amt()%>">
	<input type="hidden" name="opt_amt_m" value="<%=e_bean1.getOpt_amt_m()%>">
	<input type="hidden" name="col_amt" value="<%=e_bean1.getCol_amt()%>">
	<input type="hidden" name="o_1" value="<%=e_bean1.getO_1()%>">
	<input type="hidden" name="print_type" value="<%=e_bean1.getPrint_type()%>">
	<input type="hidden" name="from_page2" value="<%=from_page2%>">
	<input type="hidden" name="u_nm" value="<%=u_nm%>">
	<input type="hidden" name="u_mt" value="<%=u_mt%>">
	<input type="hidden" name="u_ht" value="<%=u_ht%>">
	<input type="hidden" name="car_comp_id" value="<%=e_bean1.getCar_comp_id()%>">
	<input type="hidden" name="code" value="<%=e_bean1.getCar_cd()%>">
	
	
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>신차다중견적내기</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span> </td>
        <td align="right"><a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan=2> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=25%>상호 또는 성명</td>
                    <td class=title width=25%>호칭 또는 담당자이름+호칭</td>
                    <td rowspan='2' width=50%>&nbsp;* 상호 또는 성명란에는 사업자면 상호만을, 개인이면 성명만을 적습니다. <br>&nbsp;&nbsp;&nbsp;&nbsp; 단, (주) 또는 주식회사는 기재하여도 됩니다.</td>
                </tr>            
                <tr> 
                    <td align='center'> 
                        <input type="text" name="est_nm" value="<%=e_bean1.getEst_nm()%>" size="25" maxlength='50' class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
                    </td>
                    <td align='center'> 
                        <input type="text" name="mgr_nm" value="<%=e_bean1.getMgr_nm()%>" size="25" class=text>
                        &nbsp;님 귀하
                    </td>
                </tr>
            </table>
        </td>
    </tr>  
    <tr>
        <td class=h></td>
    </tr>           
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr>                   
                    <td class=title width=15%>사업자등록번호</td>
                    <td width=35%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean1.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>이메일주소</td>
                    <td colspan="3">&nbsp;<input type="text" name="est_email" value="<%=e_bean1.getEst_email()%>" size="30" class=text style='IME-MODE: inactive'>
                      </td>
                </tr>
                <tr>				
                    <td class=title >전화번호</td>
                    <td > 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean1.getEst_tel()%>" size="15" class=text>
                    </td>
                    <td class=title >FAX</td>
                    <td colspan="3"> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean1.getEst_fax()%>" size="15" class=text>
                    </td>
                </tr>									
                <tr>				
                    <td class=title>고객구분</td>
                    <td colspan="5">
                    <%-- &nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean1.getDoc_type().equals("1")||e_bean1.getDoc_type().equals("")) out.print("checked"); %>>
                      법인고객
					  <input type="radio" name="doc_type" value="2" <% if(e_bean1.getDoc_type().equals("2")) out.print("checked"); %>>
                      개인사업자 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean1.getDoc_type().equals("3")) out.print("checked"); %>>
                      개인 --%> 					  
                      <div style="float: left;">&nbsp;<label><input type="radio" name="doc_type" value="1" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("1")||e_bean1.getDoc_type().equals("")) out.print("checked"); %>>
	                      법인고객</label>
	            	  <label><input type="radio" name="doc_type" value="2" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("2")) out.print("checked"); %>>
	                      개인사업자</label> 
	            	  <label><input type="radio" name="doc_type" value="3" onClick="javascript:doc_type_check()" <% if(e_bean1.getDoc_type().equals("3")) out.print("checked"); %>>
	                      개인</label>&nbsp;(고객구분에 따라 견적서에 필요서류를 표기합니다.)    
                      </div>           		  
           		  	  <%-- <div style="float: left; <%if (e_bean1.getDoc_type().equals("2") || e_bean1.getDoc_type().equals("3")) {%>display: none;<%}%>" id="doc_type_check_div"> --%>
           		  	  <div style="float: left;" id="doc_type_check_div">
           		  	  &nbsp;&nbsp;&nbsp;
           		  	  <input type="checkbox" id="dir_pur_commi_yn" name="dir_pur_commi_yn" value="Y" <%if (e_bean1.getDir_pur_commi_yn().equals("Y")) out.print("checked"); %>><label for="dir_pur_commi_yn">특판출고(실적이관가능)</label>
           		  	  </div>
                    </td>
                </tr>					  
                <tr>
                    <td class=title>신용도</td>
                    <td>&nbsp;<b><% if(e_bean1.getSpr_yn().equals("2")){%>초우량기업<%} else if(e_bean1.getSpr_yn().equals("1")){%>우량기업<% }else if(e_bean1.getSpr_yn().equals("0")){%>일반기업<% }else if(e_bean1.getSpr_yn().equals("3")){%>신설법인<%}%></b>
                      </td>
                    <td width=10% class=title>영업구분</td>
                    <td width=10%>&nbsp;<select name="bus_st">
                        <option value="">선택</option>                        
                        <option value="1" <%if(e_bean1.getBus_st().equals("1")){%>selected<%}%>>인터넷</option>
                        <option value="8" <%if(e_bean1.getBus_st().equals("8")){%>selected<%}%>>모바일</option>
                        <option value="5" <%if(e_bean1.getBus_st().equals("5")){%>selected<%}%>>전화상담</option>
                        <option value="2" <%if(e_bean1.getBus_st().equals("2")){%>selected<%}%>>영업사원</option>
                        <option value="7" <%if(e_bean1.getBus_st().equals("7")){%>selected<%}%>>에이젼트</option>
                        <option value="6" <%if(e_bean1.getBus_st().equals("6")){%>selected<%}%>>기존업체</option>
                        <option value="3" <%if(e_bean1.getBus_st().equals("3")){%>selected<%}%>>업체소개</option>
                        <option value="4" <%if(e_bean1.getBus_st().equals("4")){%>selected<%}%>>catalog</option>
                      </select>
                      </td>                      
                    <td width=10% class=title>비용비교</td>
                    <td width=10%>&nbsp;<input type="radio" name="compare_yn" value="N" <% if(e_bean1.getCompare_yn().equals("N")||e_bean1.getCompare_yn().equals("")) out.print("checked"); %>>
                      없음
					  <input type="radio" name="compare_yn" value="Y" <% if(e_bean1.getCompare_yn().equals("Y")) out.print("checked"); %>>
                      있음 
                      </td>                      
                </tr>	
                <tr>
                    <td class=title>견적유효기간</td>
                    <td colspan="5">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean1.getVali_type().equals("0")||e_bean1.getVali_type().equals("")) out.print("checked"); %>>
                      날짜만표기(10일/당월, 기본 10일이나 10일전 익월로 넘어갈 경우에는 당월말 까지로 한다.)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean1.getVali_type().equals("1")) out.print("checked"); %>>
                      메이커D/C 변경 가능성 언급(10일) 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean1.getVali_type().equals("2")) out.print("checked"); %>>
                      미확정견적 
                      </td>
                </tr>				
                <tr>
                    <td class=title>초기납입금안내문구</td>
                    <td colspan="3">&nbsp;<input type="radio" name="pp_ment_yn" value="Y" <%if(e_bean1.getPp_ment_yn().equals("Y"))out.print("checked");%>>
                      표기(초기납입금은 고객님의 신용도에 따라 심사과정에서 조정될 수 있습니다.)
                      <input type="radio" name="pp_ment_yn" value="N" <% if(e_bean1.getPp_ment_yn().equals("N")||e_bean1.getPp_ment_yn().equals("")) out.print("checked");%>>
                      미표기
                    </td>
                    <td class=title>보증보험료산출 등급</td>
                    <td>&nbsp;
                    	<select name="gi_grade" id="gi_grade">               			
	               			<option value="" <%if(e_bean1.getGi_grade().equals("")){%>selected<%}%>>보험료미표기</option>
	               			<option value="1" <%if(e_bean1.getGi_grade().equals("1")){%>selected<%}%>>1등급</option>
	               			<option value="2" <%if(e_bean1.getGi_grade().equals("2")){%>selected<%}%>>2등급</option>
	               			<option value="3" <%if(e_bean1.getGi_grade().equals("3")){%>selected<%}%>>3등급</option>
	               			<option value="4" <%if(e_bean1.getGi_grade().equals("4")){%>selected<%}%>>4등급</option>
	               			<option value="5" <%if(e_bean1.getGi_grade().equals("5")){%>selected<%}%>>5등급</option>
	               			<option value="6" <%if(e_bean1.getGi_grade().equals("6")){%>selected<%}%>>6등급</option>
	               			<option value="7" <%if(e_bean1.getGi_grade().equals("7")){%>selected<%}%>>7등급</option>
                		</select>
                    </td>
                </tr>                
                <tr>
                    <td class=title>담당자</td>
                    <td colspan="4">&nbsp;<select name='damdang_id' class=default>            
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i);
        				%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean1.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
        			  
		        		&nbsp;&nbsp;&nbsp;
		        		<input type="radio" name="caroff_emp_yn" value="1" <%if(e_bean1.getCaroff_emp_yn().equals("1") || e_bean1.getCaroff_emp_yn().equals("")){%>checked<%}%>  id="caroff_emp_yn1">영업사원없음
		        		<input type="radio" name="caroff_emp_yn" value="2" <%if(e_bean1.getCaroff_emp_yn().equals("2")){%>checked<%}%>  >영업사원있음(당사 담당자 표기)
		        		<input type="radio" name="caroff_emp_yn" value="3" <%if(e_bean1.getCaroff_emp_yn().equals("3")){%>checked<%}%>  >영업사원있음(당사 담당자 미표기)
						<input type="hidden" name="caroff_emp_yn_origin" value="<%=e_bean1.getCaroff_emp_yn()%>">
						
						<!-- 20201020 개소세환원문구 모든차종에대해 표기로 변경됨에 따라 아래 견적서 개소세환원문구 표기여부 임시 주석처리 -->
			            <input type="hidden" name="info_st" id="info_st" value="">        			  
					</td>
					<td><%if(e_bean1.getCar_comp_id().equals("0001") || e_bean1.getCar_comp_id().equals("0002")){%><input type="button" class="button" value="자체탁송료 조회" onclick="javascript:search_cons_cost();"><%}%></td>
					<%-- <td class=title>개소세환원 안내문구</td>
                	<td>&nbsp;
                		<select name="info_st" id="info_st">
                			<option value="" <%if (e_bean1.getInfo_st().equals("")) {%>selected<%}%>>안내문표기</option>
                			<option value="N" <%if (e_bean1.getInfo_st().equals("N")) {%>selected<%}%>>안내문미표기</option>
                		</select>
                	</td> --%>
                </tr>															
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:CustUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=15%>제조사</td>
                    <td colspan="2"> 
                    	&nbsp;<%=cm_bean.getCar_comp_nm()%>
                    	<% if (!e_bean1.getImport_pur_st().equals("1")) { %>
                    	&nbsp;&nbsp;<input type="text" name="etc" value="<%=etc%>" size="150" class="whitetext" readonly>  
                    	<% } %>
                    </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td> 
                      &nbsp;<%=cm_bean.getCar_nm()%> (차종코드:<%=cm_bean.getJg_code()%>)
                      <%if(nm_db.getWorkAuthUser("전산팀",user_id)){%>
                      <a href="javascript:view_car_nm('<%= e_bean1.getCar_id() %>','<%=e_bean1.getCar_seq()%>');"><%= e_bean1.getCar_id() %>, <%=e_bean1.getCar_seq()%></a>
                      <%}%>
                    </td>
                    <td align="center"><input type="button" class="button" value="해당차종 관련 공지사항" onclick="javascript:view_car_bbs();"></td>
                </tr>
                <tr> 
                    <td class=title>차종</td>
                    <td width=70%> 
                      &nbsp;<%=cm_bean.getCar_name()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_amt())%>원</td>
                </tr>
                <tr> 
                    <td class=title>옵션</td>
                    <td> 
                      &nbsp;<%=e_bean1.getOpt()%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getOpt_amt())%>원</td>
                </tr>
                <tr> 
                    <td class=title>색상</td>
                    <td> 
                      &nbsp;<%if(!e_bean1.getIn_col().equals("")){%>외장: <%}%><%=e_bean1.getCol()%><%if(!e_bean1.getIn_col().equals("")){%>&nbsp;/&nbsp;내장: <%=e_bean1.getIn_col()%><%}%><%if(!e_bean1.getGarnish_col().equals("")){%>&nbsp;/&nbsp;가니쉬: <%=e_bean1.getGarnish_col()%><%}%></td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getCol_amt())%>원</td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td>
                		<%=e_bean1.getConti_rat()%>
                	</td>
                	<td></td>
                </tr>
                <tr> 
                    <td class=title>제조사DC</td>
                    <td>&nbsp;<input type="text" name="bigo" value="<%=e_bean1.getBigo()%>" size="45" class=whitetext>
                      </td>
                    <td align="right"> 
                      -<%=AddUtil.parseDecimal(e_bean1.getDc_amt())%>원</td>
                </tr>
                <%if(e_bean1.getTax_dc_amt()>0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
                <tr> 
                    <td class=title>개소세 감면</td>
                    <td>&nbsp;개별소비세 및 교육세 감면 
                      </td>
                    <td align="right"> 
                      -<%=AddUtil.parseDecimal(e_bean1.getTax_dc_amt())%>원</td>
                </tr>                
                <%}%>
                <%if(e_bean1.getTax_dc_amt()<0){%>
                <tr> 
                    <td class=title>개별소비세</td>
                    <td>&nbsp;감면 미적용 개별소비세 (개별소비세 인하한도 초과금액) 
                      </td>
                    <td align="right"> 
                      <%=AddUtil.parseDecimal(-1*e_bean1.getTax_dc_amt())%>원</td>
                </tr>                
                <%}%>
                <tr> 
                    <td class=title>비고</td>
                    <td>
                    <% if (!e_bean1.getImport_pur_st().equals("1")) { %>
                      &nbsp;<%=cm_bean.getEtc()%>
                    <% } %>
                    <%
                    	// 1차 탁송 시 TP 탁송 불가차량 주행거리 발생 안내
						// 차량정보 - 비고란
						String car_etc_ment = "";
						// 1차 탁송 시 TP 불가 차량(100% 로드 탁송 차량)
						String[] first_tp_code = {
							"6014711", "6014712", "7014311", "7014312", "7014313", "7014314", "8014311", "8014312",
							"9014311", "9014312", "9014313", "9014314", "9015433", "9015436", "9025433", "9025437", "9025439",
							"6024413", "6024414", "6024415", "7024413", "7024414"
						};
						// 비고란에 아무 표기도 하지 않는 차종(출고지->고객에게 로드로 바로 인도하는 차량).
						String[] empty_etc_code = {
							"9017311", "9017312", "9017313", "9017314", "9017315", "9018111", "9018112"
						};
						
						if(Arrays.asList(first_tp_code).indexOf(cm_bean.getJg_code()) > -1){
							car_etc_ment = "1차 탁송(출고지 → 당사 신차인수지)시 차종 특성으로 인해 TP(TransPorter) 탁송이 불가하여 로드(Road)로 탁송되며 탁송거리만큼 주행거리가 발생됩니다.";
						} else if(Arrays.asList(empty_etc_code).indexOf(cm_bean.getJg_code()) > -1){
							car_etc_ment = "";
						} else if(Integer.parseInt(cm_bean.getJg_code()) > 9000000 && Integer.parseInt(cm_bean.getJg_code()) < 9900000){
							car_etc_ment = "1차 탁송(출고지 → 당사 신차인수지)시 차종 특성으로 인해 TP(TransPorter) 탁송이 불가할 수 있으며 로드(Road) 탁송시 탁송거리만큼 주행거리가 발생됩니다.";
						}
                    %>
                    <% if(!car_etc_ment.equals("")){%>
                    	<%if(!cm_bean.getEtc().equals("")){%><br><%}%><%=car_etc_ment %>
                    <%} %>
                    </td>
                    <td align="center"> &nbsp;
                      </td>
                </tr>                    
                <tr> 
                    <td class=title colspan="2">차량가격</td>
                    <td align="right"> 
                      &nbsp;<%=AddUtil.parseDecimal(e_bean1.getO_1())%>원</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr>
        <td></td>
        <td align="right"><a href="javascript:dlv_con_commi();"><img src=/acar/images/center/button_sd_cg.gif align=absmiddle border=0 alt='출고보전수당'></a></td>
    </tr>        
    
    
    <!-- START_수입차 -->
    <% if (!e_bean1.getImport_pur_st().equals("")) { %>
    <tr id="import_content_1">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
        			<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차</span></td>
        		</tr>
        	</table>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr> 
			                    <td class=title width="15%">수입차출고</td>
						        <td align="left">&nbsp;
						        	<% if (e_bean1.getImport_pur_st().equals("0")) { %>
						        		자체출고
						        	<% } else if (e_bean1.getImport_pur_st().equals("1")) {%>
						        		영업사원출고 (자체출고 견적외)
						        	<% }%>
						        </td>
			                </tr>
			            </table>
        			</td>
        		</tr>
        	</table>
        </td>
    </tr>
    <% } %>
    <% if (e_bean1.getImport_pur_st().equals("1")) { %>
    <tr id="import_content_2">
        <td>
        	<table border=0 cellspacing=0 cellpadding=0 width=100%>
        		<tr>
			        <td class=h></td>
			    </tr>
        		<tr>
			        <td class=line2></td>
			    </tr>
        		<tr>
        			<td class="line">
        				<table border="0" cellspacing="1" width=100%>
			            	<tr>
			                    <td class=title width="15%">적용면세차가</td>
			                    <td align="left">&nbsp;
			                    	<%=AddUtil.parseDecimal(e_bean1.getCar_b_p2())%>원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">세금계산서D/C</td>
			                    <td align="left">&nbsp;
			                    	렌트&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_dc_amt())%> 원 /&nbsp;
			                    	리스&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_dc_amt())%> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">카드결제금액</td>
			                    <td align="left">&nbsp;
			                    	렌트&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_card_amt())%> 원 /&nbsp;
			                    	리스&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_card_amt())%> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">Cash Back</td>
			                    <td align="left">&nbsp;
			                    	렌트&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_cash_back())%> 원 /&nbsp;
			                    	리스&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_cash_back())%> 원
			                    </td>
			                </tr>
			            	<tr> 
			                    <td class=title width="15%">탁송썬팅비용등</td>
			                    <td align="left">&nbsp;
			                    	렌트&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getR_bank_amt())%> 원 /&nbsp;
			                    	리스&nbsp;&nbsp;<%=AddUtil.parseDecimal(e_bean1.getL_bank_amt())%> 원
			                    </td>
			                </tr>
			            </table>
        			</td>
        		</tr>        		
        	</table>
        </td>
    </tr>
    <%}%>
    <tr>
        <td class=h></td>
    </tr>
    <!-- END_수입차 -->
    
        
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span>		
		(견적기준일 : <%=AddUtil.ChangeDate3(e_bean1.getRent_dt())%>, 등록일자 : <%=AddUtil.ChangeDate3(e_bean1.getReg_dt())%> <%=c_db.getNameById(e_bean1.getReg_id(),"USER")%> 
		 -<%=set_code%>
		 <%=e_bean1.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean1.getReg_code()%>');">[견적1]</a>&nbsp;
		 <%if(!e_bean2.getEst_id().equals("")){%> <%=e_bean2.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean2.getReg_code()%>');">[견적2]</a><%}%>&nbsp;
		 <%if(!e_bean3.getEst_id().equals("")){%> <%=e_bean3.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean3.getReg_code()%>');">[견적3]</a><%}%>&nbsp;
		 <%if(!e_bean4.getEst_id().equals("")){%> <%=e_bean4.getReg_code()%> <a href="javascript:estimates_view('<%=e_bean4.getReg_code()%>');">[견적4]</a><%}%>&nbsp;
		)
		</td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>구분</td>
                  <td width="22%" class=title>견적1</td>
                  <td width="21%" class=title><%if(!e_bean2.getEst_id().equals("")){%>견적2<%}%></td>
                  <td width="21%" class=title><%if(!e_bean3.getEst_id().equals("")){%>견적3<%}%></td>
                  <td width="21%" class=title><%if(!e_bean4.getEst_id().equals("")){%>견적4<%}%></td>
                </tr>
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td colspan='2' class=title>인수/반납 유형</td>
                    <td>&nbsp;<%if(e_bean1.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean1.getReturn_select().equals("1")){%>반납형<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean2.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean2.getReturn_select().equals("1")){%>반납형<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean3.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean3.getReturn_select().equals("1")){%>반납형<%}else{%><%}%>
                    </td>
                    <td>&nbsp;<%if(e_bean4.getReturn_select().equals("0")){%>인수/반납 선택형<%}else if(e_bean4.getReturn_select().equals("1")){%>반납형<%}else{%><%}%>
                    </td>
                </tr>
                <%}%>	                	
                <tr> 
                    <td colspan='2' class=title>대여상품</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%>
                    </td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%>
                    </td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>대여기간</td>
                    <td>&nbsp;<%=e_bean1.getA_b()%>개월</td>
                    <td>&nbsp;<%=e_bean2.getA_b()%>개월</td>
                    <td>&nbsp;<%=e_bean3.getA_b()%>개월</td>
                    <td>&nbsp;<%=e_bean4.getA_b()%>개월</td>
                </tr>
                <tr> 
                    <td colspan='2' class=title>제조사DC</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getDc_amt())%>원
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getDc_amt())%>원
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getDc_amt())%>원
                    </td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getDc_amt())%>원
                    </td>
                </tr>
                <%if(AddUtil.parseInt(AddUtil.replace(AddUtil.getDate(),"-","")) >= 20141223){%>
                <tr> 
                    <td width='3%' rowspan="6" class=title>잔<br>가</td>
                    <td class=title width='12%'>표준 최대잔가</td>
                    <td>&nbsp;<%=e_bean1.getB_o_13()%>%
                    <%if(e_bean1.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;환급대여료적용<%}else if(e_bean1.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;환급대여료미적용<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean2.getB_o_13()%>%
                    <%if(e_bean2.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;환급대여료적용<%}else if(e_bean2.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;환급대여료미적용<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean3.getB_o_13()%>%
                    <%if(e_bean3.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;환급대여료적용<%}else if(e_bean3.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;환급대여료미적용<%}%>
                    </td>
                    <td>&nbsp;<%=e_bean4.getB_o_13()%>%
                    <%if(e_bean4.getRtn_run_amt_yn().equals("0")){%>&nbsp;&nbsp;환급대여료적용<%}else if(e_bean4.getRtn_run_amt_yn().equals("1")){%>&nbsp;&nbsp;환급대여료미적용<%}%>
                    </td>															
                </tr>	                               
                <tr> 
                    <td class=title>표준 약정운행거리</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getB_agree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getB_agree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getB_agree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getB_agree_dist())%>km/년</td>
                </tr>	                			
                <tr> 
                    <td class=title>적용 약정운행거리</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km/년</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/년</td>
                </tr>	
                <tr> 
                    <td class=title>조정 최대잔가</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean1.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean2.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean3.getO_13()%>%</span></td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean4.getO_13()%>%</span></td>															
                </tr>									                
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td class=title>적용잔가</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean1.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean1.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean2.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean2.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean3.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean3.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean4.getOpt_chk().equals("1")){%><span class="num_weight"><%=e_bean4.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>원<%}%></td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title>적용잔가</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean1.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>원</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean2.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>원</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean3.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>원</td>
                    <td>&nbsp;<span class="num_weight"><%=e_bean4.getRo_13()%>%</span> &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>원</td>
                </tr>									
                <%}%>	                                			
                <tr> 
                    <td class=title>매입옵션</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean1.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean2.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean3.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean4.getOpt_chk().equals("1")){%>부여<%}%></td>
                </tr>	
                
                <%}else{%>                
                <tr> 
                    <td width='3%' rowspan="3" class=title>잔<br>가</td>
                    <td class=title width='7%'>최대잔가</td>
                    <td>&nbsp;<%=e_bean1.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean2.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean3.getO_13()%>%</td>
                    <td>&nbsp;<%=e_bean4.getO_13()%>%</td>															
                </tr>
                <%if(e_bean1.getPrint_type().equals("6")){%>
                <tr> 
                    <td class=title width='7%'>적용잔가</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean1.getOpt_chk().equals("1")){%><%=e_bean1.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean2.getOpt_chk().equals("1")){%><%=e_bean2.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean3.getOpt_chk().equals("1")){%><%=e_bean3.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>원<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>미공개<%}else if(e_bean4.getOpt_chk().equals("1")){%><%=e_bean4.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>원<%}%></td>
                </tr>
                <%}else{%>
                <tr> 
                    <td class=title width='7%'>적용잔가</td>
                    <td>&nbsp;<%=e_bean1.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRo_13_amt())%>원</td>
                    <td>&nbsp;<%=e_bean2.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRo_13_amt())%>원</td>
                    <td>&nbsp;<%=e_bean3.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRo_13_amt())%>원</td>
                    <td>&nbsp;<%=e_bean4.getRo_13()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRo_13_amt())%>원</td>
                </tr>									
                <%}%>
                <tr> 
                    <td class=title>매입옵션</td>
                    <td>&nbsp;<%if(e_bean1.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean1.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean2.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean3.getOpt_chk().equals("1")){%>부여<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getOpt_chk().equals("0")){%>미부여<%}else if(e_bean4.getOpt_chk().equals("1")){%>부여<%}%></td>
                </tr>	
                <%}%>			  		  		
                <tr> 
                    <td rowspan="3" class=title>선<br>수</td>
                    <td class=title>보증금</td>
                    <td>&nbsp;<%=e_bean1.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getRg_8_amt())%>원</td>
					<td>&nbsp;<%=e_bean2.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getRg_8_amt())%>원</td>
					<td>&nbsp;<%=e_bean3.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getRg_8_amt())%>원</td>
					<td>&nbsp;<%=e_bean4.getRg_8()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getRg_8_amt())%>원</td>                    
                </tr>
                <tr> 
                    <td class=title>선납금</td>
					<td>&nbsp;<%=e_bean1.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getPp_amt())%>원</td>
					<td>&nbsp;<%=e_bean2.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getPp_amt())%>원</td>
					<td>&nbsp;<%=e_bean3.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getPp_amt())%>원</td>
					<td>&nbsp;<%=e_bean4.getPp_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getPp_amt())%>원</td>
                </tr>
                <tr> 
                    <td class=title>개시대여료</td>
                    <td>&nbsp;<%=e_bean1.getG_10()%>개월치</td>
                    <td>&nbsp;<%=e_bean2.getG_10()%>개월치</td>
                    <td>&nbsp;<%=e_bean3.getG_10()%>개월치</td>
                    <td>&nbsp;<%=e_bean4.getG_10()%>개월치</td>															
                </tr>
                <tr> 
                    <td rowspan="6" class=title>보<br>험</td>
                    <td class=title>보험계약자</td>
					<td>&nbsp;<%if(e_bean1.getInsurant().equals("1")){%>아마존카<%}else if(e_bean1.getInsurant().equals("2")){%>고객<%}%></td>
					<td>&nbsp;<%if(e_bean2.getInsurant().equals("1")){%>아마존카<%}else if(e_bean2.getInsurant().equals("2")){%>고객<%}%></td>
					<td>&nbsp;<%if(e_bean3.getInsurant().equals("1")){%>아마존카<%}else if(e_bean3.getInsurant().equals("2")){%>고객<%}%></td>
					<td>&nbsp;<%if(e_bean4.getInsurant().equals("1")){%>아마존카<%}else if(e_bean4.getInsurant().equals("2")){%>고객<%}%></td>					
                </tr>
                <tr>                     
                    <td class=title>피보험자</td>
					<td>&nbsp;<%if(e_bean1.getIns_per().equals("1")){%>아마존카(보험포함)<%}else if(e_bean1.getIns_per().equals("2")){%>고객(보험미포함)<%}%></td>
					<td>&nbsp;<%if(e_bean2.getIns_per().equals("1")){%>아마존카(보험포함)<%}else if(e_bean2.getIns_per().equals("2")){%>고객(보험미포함)<%}%></td>
					<td>&nbsp;<%if(e_bean3.getIns_per().equals("1")){%>아마존카(보험포함)<%}else if(e_bean3.getIns_per().equals("2")){%>고객(보험미포함)<%}%></td>
					<td>&nbsp;<%if(e_bean4.getIns_per().equals("1")){%>아마존카(보험포함)<%}else if(e_bean4.getIns_per().equals("2")){%>고객(보험미포함)<%}%></td>					
                </tr>
                <tr>
                  <td class=title>대물/자손</td>
                  <td>&nbsp;<%if(e_bean1.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean1.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean1.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean1.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean1.getIns_dj().equals("3")){%>5억원/1억원<%}%></td>
                  <td>&nbsp;<%if(e_bean2.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean2.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean2.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean2.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean2.getIns_dj().equals("3")){%>5억원/1억원<%}%></td>
                  <td>&nbsp;<%if(e_bean3.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean3.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean3.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean3.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean3.getIns_dj().equals("3")){%>5억원/1억원<%}%></td>
                  <td>&nbsp;<%if(e_bean4.getIns_dj().equals("1")){%>5천만원/5천만원<%}else if(e_bean4.getIns_dj().equals("2")){%>1억원/1억원<%}else if(e_bean4.getIns_dj().equals("4")){%>2억원/1억원<%}else if(e_bean4.getIns_dj().equals("8")){%>3억원/1억원<%}else if(e_bean4.getIns_dj().equals("3")){%>5억원/1억원<%}%></td>				  				  				  
                </tr>
                <tr>
                  <td class=title>운전자연령</td>
				  <td>&nbsp;<%if(e_bean1.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean1.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean1.getIns_age().equals("3")){%>만24세이상<%}%></td>
				  <td>&nbsp;<%if(e_bean2.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean2.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean2.getIns_age().equals("3")){%>만24세이상<%}%></td>
				  <td>&nbsp;<%if(e_bean3.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean3.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean3.getIns_age().equals("3")){%>만24세이상<%}%></td>
				  <td>&nbsp;<%if(e_bean4.getIns_age().equals("1")){%>만26세이상<%}else if(e_bean4.getIns_age().equals("2")){%>만21세이상<%}else if(e_bean4.getIns_age().equals("3")){%>만24세이상<%}%></td>
                </tr>
                <tr> 
                    <td class=title>자차면책금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCar_ja())%>원</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCar_ja())%>원</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCar_ja())%>원</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCar_ja())%>원</td>										
                </tr>
                <tr> 
                    <td class=title>보증보험</td>
					<td>&nbsp;<%=e_bean1.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean1.getGi_amt())%>원</td>
					<td>&nbsp;<%=e_bean2.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean2.getGi_amt())%>원</td>
					<td>&nbsp;<%=e_bean3.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean3.getGi_amt())%>원</td>
					<td>&nbsp;<%=e_bean4.getGi_per()%>% &nbsp;<%=AddUtil.parseDecimal(e_bean4.getGi_amt())%>원</td>
                </tr>
                <tr id=tr_com_emp_yn style="display:<%if(e_bean1.getCom_emp_yn().equals("")&&e_bean2.getCom_emp_yn().equals("")&&e_bean3.getCom_emp_yn().equals("")&&e_bean4.getCom_emp_yn().equals("")){%>'none'<%}else{%>''<%}%>">
                  <td colspan='2' class=title><!-- 법인 -->임직원 한정운전특약</td>
                    <td>&nbsp;<%if(e_bean1.getCom_emp_yn().equals("Y")){%>가입<%}else if(e_bean1.getCom_emp_yn().equals("N")){%>미가입<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getCom_emp_yn().equals("Y")){%>가입<%}else if(e_bean2.getCom_emp_yn().equals("N")){%>미가입<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getCom_emp_yn().equals("Y")){%>가입<%}else if(e_bean3.getCom_emp_yn().equals("N")){%>미가입<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getCom_emp_yn().equals("Y")){%>가입<%}else if(e_bean4.getCom_emp_yn().equals("N")){%>미가입<%}%></td>
                </tr> 
                <tr> 
                    <td rowspan="8" class=title>기<br>타</td>				
                    <td class=title>용품</td>
                    <td>&nbsp;<%if(e_bean1.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%><br>&nbsp;<%if(e_bean1.getTint_s_yn().equals("Y")){%>전면 썬팅(기본형)<%}%><br>&nbsp;<%if(e_bean1.getTint_ps_yn().equals("Y")){%>고급썬팅(전면포함)<%}%><%if(e_bean1.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">내용 : <%=e_bean1.getTint_ps_nm()%></span><%}%><%if(e_bean1.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">용품점 지급금액(공급가) : <%=AddUtil.parseDecimal(e_bean1.getTint_ps_amt())%> 원</span><%}%><br>&nbsp;<%if(e_bean1.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br>&nbsp;<%if(e_bean1.getTint_sn_yn().equals("Y")){%>전면썬팅 미시공 할인<%}%><br>&nbsp;<%if(e_bean1.getTint_bn_yn().equals("Y")){%>블랙박스 미제공할인(빌트인캠,고객장착)<%}%><br>&nbsp;<%if(e_bean1.getTint_eb_yn().equals("Y")){%>이동형 충전기(전기차)<%}%><%if (e_bean1.getTint_cons_amt() != 0) {%><br>&nbsp;추가탁송료등 : <%=AddUtil.parseDecimal(e_bean1.getTint_cons_amt())%> 원<%}%><br>&nbsp;
                    	<%if(e_bean1.getNew_license_plate().equals("1") || e_bean1.getNew_license_plate().equals("2")){%>신형번호판<%} else if(e_bean1.getNew_license_plate().equals("0")){%>구형번호판<%} %>
<%--                     	<%if(e_bean1.getNew_license_plate().equals("1")){%>신형번호판신청(수도권)<%} else if (e_bean1.getNew_license_plate().equals("2")){%>신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    	<%-- <%if(e_bean1.getNew_license_plate().equals("1") || e_bean1.getNew_license_plate().equals("2")){%>신형번호판신청<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean2.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%><br>&nbsp;<%if(e_bean2.getTint_s_yn().equals("Y")){%>전면 썬팅(기본형)<%}%><br>&nbsp;<%if(e_bean2.getTint_ps_yn().equals("Y")){%>고급썬팅(전면포함)<%}%><%if(e_bean2.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">내용 : <%=e_bean2.getTint_ps_nm()%></span><%}%><%if(e_bean2.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">용품점 지급금액(공급가) : <%=AddUtil.parseDecimal(e_bean2.getTint_ps_amt())%> 원</span><%}%><br>&nbsp;<%if(e_bean2.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br>&nbsp;<%if(e_bean2.getTint_sn_yn().equals("Y")){%>전면썬팅 미시공 할인<%}%><br>&nbsp;<%if(e_bean2.getTint_bn_yn().equals("Y")){%>블랙박스 미제공할인(빌트인캠,고객장착)<%}%><br>&nbsp;<%if(e_bean2.getTint_eb_yn().equals("Y")){%>이동형 충전기(전기차)<%}%><%if (e_bean2.getTint_cons_amt() != 0) {%><br>&nbsp;추가탁송료등 : <%=AddUtil.parseDecimal(e_bean2.getTint_cons_amt())%> 원<%}%><br>&nbsp;
                    	<%if(e_bean2.getNew_license_plate().equals("1") || e_bean2.getNew_license_plate().equals("2")){%>신형번호판<%} else if(e_bean2.getNew_license_plate().equals("0")){%>구형번호판<%} %>
<%--                     	<%if(e_bean2.getNew_license_plate().equals("1")){%>신형번호판신청(수도권)<%} else if (e_bean2.getNew_license_plate().equals("2")){%>신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    	<%-- <%if(e_bean2.getNew_license_plate().equals("1") || e_bean2.getNew_license_plate().equals("2")){%>신형번호판신청<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean3.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%><br>&nbsp;<%if(e_bean3.getTint_s_yn().equals("Y")){%>전면 썬팅(기본형)<%}%><br>&nbsp;<%if(e_bean3.getTint_ps_yn().equals("Y")){%>고급썬팅(전면포함)<%}%><%if(e_bean3.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">내용 : <%=e_bean3.getTint_ps_nm()%></span><%}%><%if(e_bean3.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">용품점 지급금액(공급가) : <%=AddUtil.parseDecimal(e_bean3.getTint_ps_amt())%> 원</span><%}%><br>&nbsp;<%if(e_bean3.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br>&nbsp;<%if(e_bean3.getTint_sn_yn().equals("Y")){%>전면썬팅 미시공 할인<%}%><br>&nbsp;<%if(e_bean3.getTint_bn_yn().equals("Y")){%>블랙박스 미제공할인(빌트인캠,고객장착)<%}%><br>&nbsp;<%if(e_bean3.getTint_eb_yn().equals("Y")){%>이동형 충전기(전기차)<%}%><%if (e_bean3.getTint_cons_amt() != 0) {%><br>&nbsp;추가탁송료등 : <%=AddUtil.parseDecimal(e_bean3.getTint_cons_amt())%> 원<%}%><br>&nbsp;
                    <%if(e_bean3.getNew_license_plate().equals("1") || e_bean3.getNew_license_plate().equals("2")){%>신형번호판<%} else if(e_bean3.getNew_license_plate().equals("0")){%>구형번호판<%} %>
<%--                     <%if(e_bean3.getNew_license_plate().equals("1")){%>신형번호판신청(수도권)<%} else if (e_bean3.getNew_license_plate().equals("2")){%>신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    <%-- <%if(e_bean3.getNew_license_plate().equals("1") || e_bean3.getNew_license_plate().equals("2")){%>신형번호판신청<%}%> --%>
                    </td>
                    <td>&nbsp;<%if(e_bean4.getTint_b_yn().equals("Y")){%>2채널 블랙박스<%}%><br>&nbsp;<%if(e_bean4.getTint_s_yn().equals("Y")){%>전면 썬팅(기본형)<%}%><br>&nbsp;<%if(e_bean4.getTint_ps_yn().equals("Y")){%>고급썬팅(전면포함)<%}%><%if(e_bean4.getTint_ps_nm()!=""){%><br><span style="margin-left:100px;">내용 : <%=e_bean4.getTint_ps_nm()%></span><%}%><%if(e_bean4.getTint_ps_amt()!=0){%><br><span style="margin-left:30px;">용품점 지급금액(공급가) : <%=AddUtil.parseDecimal(e_bean4.getTint_ps_amt())%> 원</span><%}%><br>&nbsp;<%if(e_bean4.getTint_n_yn().equals("Y")){%>거치형 내비게이션<%}%><br>&nbsp;<%if(e_bean4.getTint_sn_yn().equals("Y")){%>전면썬팅 미시공 할인<%}%><br>&nbsp;<%if(e_bean4.getTint_bn_yn().equals("Y")){%>블랙박스 미제공할인(빌트인캠,고객장착)<%}%><br>&nbsp;<%if(e_bean4.getTint_eb_yn().equals("Y")){%>이동형 충전기(전기차)<%}%><%if (e_bean4.getTint_cons_amt() != 0) {%><br>&nbsp;추가탁송료등 : <%=AddUtil.parseDecimal(e_bean4.getTint_cons_amt())%> 원<%}%><br>&nbsp;
                    <%if(e_bean4.getNew_license_plate().equals("1") || e_bean4.getNew_license_plate().equals("2")){%>신형번호판<%} else if(e_bean4.getNew_license_plate().equals("0")){%>구형번호판<%} %>
<%--                     <%if(e_bean4.getNew_license_plate().equals("1")){%>신형번호판신청(수도권)<%} else if (e_bean4.getNew_license_plate().equals("2")){%>신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    <%-- <%if(e_bean4.getNew_license_plate().equals("1") || e_bean4.getNew_license_plate().equals("2")){%>신형번호판신청<%}%> --%>
                    </td>
                </tr>
                <%-- <tr> 
                    <td class=title>전기차 고객주소지</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%></td>
                </tr> --%>
                <%if (ej_bean.getJg_g_7().equals("3")) {%>
                <tr>
                    <td class=title>전기차 고객주소지</td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%><%}%></td>
                    <td>&nbsp;<%if(!( cm_bean.getJg_code().equals("4218111") || cm_bean.getJg_code().equals("5315113") )){%><%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%><%}%></td>
                </tr>
                <%} else if (ej_bean.getJg_g_7().equals("4")) {%>
                <tr>
                    <td class=title>수소차 고객주소지</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean1.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean2.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean3.getHcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0037", "", e_bean4.getHcar_loc_st())%></td>
                </tr>
                <%} else {%>
                <tr>
                    <td class=title>전기차 고객주소지</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean1.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean2.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean3.getEcar_loc_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0034", "", e_bean4.getEcar_loc_st())%></td>
                </tr>
                <%}%>
                <%if (!e_bean1.getEco_e_tag().equals("") && !(ej_bean.getJg_g_7().equals("3") || ej_bean.getJg_g_7().equals("4"))) {%>
                <tr> 
                    <td class=title>맑은서울스티커 발급</td>
                    <td>&nbsp;<%if(e_bean1.getEco_e_tag().equals("0")){%>미발급<%}else if(e_bean1.getEco_e_tag().equals("1")){%>발급<%}%></td>
                    <td>&nbsp;<%if(e_bean2.getEco_e_tag().equals("0")){%>미발급<%}else if(e_bean2.getEco_e_tag().equals("1")){%>발급<%}%></td>
                    <td>&nbsp;<%if(e_bean3.getEco_e_tag().equals("0")){%>미발급<%}else if(e_bean3.getEco_e_tag().equals("1")){%>발급<%}%></td>
                    <td>&nbsp;<%if(e_bean4.getEco_e_tag().equals("0")){%>미발급<%}else if(e_bean4.getEco_e_tag().equals("1")){%>발급<%}%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class=title>차량인도지역</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean1.getLoc_st())%><%-- <span <%if (!e_bean1.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(서울강서서비스센터에서 교육 후 인도)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean2.getLoc_st())%><%-- <span <%if (!e_bean2.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(서울강서서비스센터에서 교육 후 인도)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean3.getLoc_st())%><%-- <span <%if (!e_bean3.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(서울강서서비스센터에서 교육 후 인도)</span> --%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0033", "", e_bean4.getLoc_st())%><%-- <span <%if (!e_bean4.getCar_comp_id().equals("0056")) {%>style="display: none;"<%}%>>(서울강서서비스센터에서 교육 후 인도)</span> --%></td>
                </tr>
                <tr> 
                    <td class=title>차량인수지점</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean1.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean2.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean3.getUdt_st())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0035", "", e_bean4.getUdt_st())%></td>
                </tr>	                		                                
                <tr> 
                    <td class=title>실등록지역</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean1.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean2.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean3.getA_h())%></td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean4.getA_h())%></td>
                </tr>			
                <tr> 
                    <td class=title>영업수당</td>
                    <td>&nbsp;차가의<%=e_bean1.getO_11()%>%</td>
                    <td>&nbsp;차가의<%=e_bean2.getO_11()%>%</td>
                    <td>&nbsp;차가의<%=e_bean3.getO_11()%>%</td>
                    <td>&nbsp;차가의<%=e_bean4.getO_11()%>%</td>
                </tr>											
                <tr> 
                    <td class=title>대여료D/C</td>
                    <td>&nbsp;대여료의<%=e_bean1.getFee_dc_per()%>%</td>
                    <td>&nbsp;대여료의<%=e_bean2.getFee_dc_per()%>%</td>
                    <td>&nbsp;대여료의<%=e_bean3.getFee_dc_per()%>%</td>
                    <td>&nbsp;대여료의<%=e_bean4.getFee_dc_per()%>%</td>
                </tr>	                
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적결과</span>
		</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr>
                  <td colspan='2' class=title>구분</td>
                  <td colspan='12'>&nbsp;<%if(e_bean1.getPrint_type().equals("1")){%>상품별<%}%>
					<%if(e_bean1.getPrint_type().equals("2")){%>렌트<%}%>
					<%if(e_bean1.getPrint_type().equals("3")){%>리스<%}%>
					<%if(e_bean1.getPrint_type().equals("4")){%>종합<%}%>
					<%if(e_bean1.getPrint_type().equals("5")){%>견적별 종합<%}%>
					<%if(e_bean1.getPrint_type().equals("6")){%>전기차 인수/ 반납 선택형 및 반납형 견적<%}%>
					<%if(e_bean1.getPrint_type().equals("2")||e_bean1.getPrint_type().equals("3")||e_bean1.getPrint_type().equals("4")||e_bean1.getPrint_type().equals("5")||e_bean1.getPrint_type().equals("6")){%>
						<%if(e_bean1.getPrint_type().equals("2") || e_bean1.getPrint_type().equals("3") || e_bean1.getPrint_type().equals("4")){ // 렌트, 리스, 종합 견적 시 견적별 종합 견적서 사용  %>
					&nbsp;<a href="javascript:EstiViewAll('5','<%=e_bean1.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
						<%}else{ %>
					&nbsp;<a href="javascript:EstiViewAll('<%=e_bean1.getPrint_type()%>','<%=e_bean1.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
						<%}%>
					<%}%>
                  </td>
                </tr>	            
                <tr>
                  <td colspan='2' class=title>선택</td>
                  <td colspan="3" class=title><%if(!e_bean1.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean1.getEst_id()%>" checked ><%}%>견적1</td>
                  <td colspan="3" class=title><%if(!e_bean2.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean2.getEst_id()%>" checked><%}%><%}%>견적2</td>
                  <td colspan="3" class=title><%if(!e_bean3.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean3.getEst_id()%>" checked><%}%><%}%>견적3</td>
                  <td colspan="3" class=title><%if(!e_bean4.getEst_id().equals("")){%><%if(!e_bean2.getPrint_type().equals("6")){%><input type="checkbox" name="ch_l_cd" value="<%=e_bean4.getEst_id()%>" checked><%}%><%}%>견적4</td>
                </tr>		
                <tr> 
                    <td width='3%' rowspan="3" class=title>대<br>여<br>요<br>금</td>				
                    <td class=title>공급가</td>
                    <td width="13%">&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getDriver_add_amt()*0.9)%>원<%}%></td>
                    <td width="3%" rowspan="3" align="center">조<br>
                    정<br>
                    후</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_s_amt())%>원</td>
                    <td width="11%">&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getDriver_add_amt()*0.9)%>원<%}%></td>
                    <td width="3%" rowspan="3" align="center">조<br>
                      정<br>
                    후</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_s_amt())%>원</td>
                    <td width="11%">&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getDriver_add_amt()*0.9)%>원<%}%></td>
                    <td width="3%" rowspan="3" align="center">조<br>
                      정<br>
                    후</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_s_amt())%>원</td>
                    <td width="11%">&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getDriver_add_amt()*0.9)%>원<%}%></td>
                    <td width="3%" rowspan="3" align="center">조<br>
                      정<br>
                    후</td>
                    <td width="8%">&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_s_amt())%>원</td>
                </tr>
                <tr> 
                    <td class=title>부가세</td>
                    <td>&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()*0.1)%>원<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()*0.1)%>원<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()*0.1)%>원<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()*0.1)%>원<%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_v_amt())%>원</td>
                </tr>						
                <tr> 
                    <td class=title>월대여료</td>
                    <td>&nbsp;<%if(e_bean1.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%>원&nbsp;<a href="javascript:EstiFeeAmtCng(0, '<%=e_bean1.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean1.getCtr_s_amt()+e_bean1.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean2.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%>원&nbsp;<a href="javascript:EstiFeeAmtCng(1, '<%=e_bean2.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean2.getCtr_s_amt()+e_bean2.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean3.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%>원&nbsp;<a href="javascript:EstiFeeAmtCng(2, '<%=e_bean3.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a><%}%></td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean3.getCtr_s_amt()+e_bean3.getCtr_v_amt())%>원</td>
                    <td>&nbsp;<%if(e_bean4.getFee_s_amt() == -1){%>미운영<%}else{%><%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%>원&nbsp;<a href="javascript:EstiFeeAmtCng(3, '<%=e_bean4.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a><%}%></td>															
                    <td>&nbsp;<%=AddUtil.parseDecimal(e_bean4.getCtr_s_amt()+e_bean4.getCtr_v_amt())%>원</td>
                </tr>		
                <tr> 
                    <td rowspan="2" class=title>위<br>약<br>금</td>				
                    <td class=title>필요위약율</td>
                    <td colspan="3">&nbsp;<%=e_bean1.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean2.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean3.getCls_n_per()%>%</td>
                    <td colspan="3">&nbsp;<%=e_bean4.getCls_n_per()%>%</td>
                </tr>
                <tr> 
                    <td class=title>적용위약율</td>
                    <td>
                    &nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean1.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(0, '<%=e_bean1.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a></td>
                    <td align="center">조<br/>정<br/>후</td>
                    <td>&nbsp;<%=e_bean1.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean2.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(1, '<%=e_bean2.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a></td>
                    <td align="center">조<br/>정<br/>후</td>
                    <td>&nbsp;<%=e_bean2.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean3.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(2, '<%=e_bean3.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a></td>
                    <td align="center">조<br/>정<br/>후</td>
                    <td>&nbsp;<%=e_bean3.getCtr_cls_per()%>%</td>
                    <td>&nbsp;<input type="text" name="cls_per" size="4" value='<%=e_bean4.getCls_per()%>' class=num>%&nbsp;<a href="javascript:EstiClsPerCng(3, '<%=e_bean4.getEst_id()%>')"><img src=/acar/images/center/button_in_jgj.gif align="absmiddle" border="0" alt="조정"></a></td>
                	<td align="center">조<br/>정<br/>후</td>
                    <td>&nbsp;<%=e_bean4.getCtr_cls_per()%>%</td>
                </tr>	
                <%if(e_bean1.getPrint_type().equals("1")){ //견적구분이 상품 인 경우만 각 견적의 견적서보기가 가능(20181002) %>	       
                <tr> 
                    <td colspan='2' class=title>견적서</td>
                    <td colspan="3">&nbsp;<a href="javascript:EstiView(1,'<%=e_bean1.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></td>
                    <td colspan="3">&nbsp;<%if(!e_bean2.getEst_id().equals("")){%><a href="javascript:EstiView(2,'<%=e_bean2.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                    <td colspan="3">&nbsp;<%if(!e_bean3.getEst_id().equals("")){%><a href="javascript:EstiView(3,'<%=e_bean3.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                    <td colspan="3">&nbsp;<%if(!e_bean4.getEst_id().equals("")){%><a href="javascript:EstiView(4,'<%=e_bean4.getEst_id()%>')" title='견적서 보기'><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a><%}%></td>
                </tr>
                <%} %>
                			
                <tr> 
                    <td colspan='2' class=title>비교견적</td>
                    <td colspan="3">&nbsp;
                    	<%if (e_bean1.getPrint_type().equals("6")) {%>
                    	<%-- <a href="javascript:ReEsti6('<%=e_bean1.getEst_id()%>','<%=e_bean1.getSet_code()%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a> --%>
                    	<%} else {%>
                    	<a href="javascript:ReEsti('<%=e_bean1.getEst_id()%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a>
                    	<%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean2.getEst_id().equals("") && !e_bean2.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean2.getEst_id()%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean3.getEst_id().equals("") && !e_bean3.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean3.getEst_id()%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean4.getEst_id().equals("") && !e_bean4.getPrint_type().equals("6")){%><a href="javascript:ReEsti('<%=e_bean4.getEst_id()%>');" title='비교견적'><img src=/acar/images/center/button_in_esti.gif align=absmiddle border=0></a><%}%>
                    </td>
                </tr>
                
                <%if(!e_bean1.getUse_yn().equals("N")){%>
                <tr style="display: <%if(e_bean1.getPrint_type().equals("6")){%>none<%}else{%><%}%>"> 
                    <td colspan='2' class=title>삭제</td>
                    <td colspan="3">&nbsp;
                    	<a href="javascript:DelEsti('<%=e_bean1.getEst_id()%>');" title='삭제'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean2.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean2.getEst_id()%>');" title='삭제'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean3.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean3.getEst_id()%>');" title='삭제'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                    <td colspan="3">&nbsp;
                    	<%if(!e_bean4.getEst_id().equals("")){%><a href="javascript:DelEsti('<%=e_bean4.getEst_id()%>');" title='삭제'><img src=/acar/images/center/button_in_delete.gif align=absmiddle border=0></a><%}%>
                    </td>
                </tr>
                <%}%>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적사후관리 (계약미체결 사유 입력)</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=15%>계약여부</td>
                    <td>&nbsp;<select name="bus_yn">
                        <option value="">선택</option>
                        <!--<option value="Y" <%if(e_bean1.getBus_yn().equals("Y"))%>selected<%%>>계약</option>-->
                        <option value="N" <%if(e_bean1.getBus_yn().equals("N"))%>selected<%%>>미계약</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title>시장상황</td>
                    <td>&nbsp;<textarea name='bus_cau' rows='5' cols='100' maxlenght='500'><%=e_bean1.getBus_cau()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr> 
        <td></td>
        <td align="right"><a href="javascript:BusUpate();"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    </tr>    
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    
    <%if(!e_bean1.getUse_yn().equals("N")){%>
	
    <tr> 
        <td align=center colspan="2"> 
	<%if(size>0){%>
		<%if(!e_bean1.getPrint_type().equals("6")){%>
            <a href="javascript:select_print();" title='선택 출력하기'><img src=/acar/images/center/button_print_se.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
            <a href='javascript:select_email();' title='선택메일발송하기'><img src=/acar/images/center/button_send_smail.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;        
            <a href='javascript:all_delete();' title='전체 삭제하기'><img src=/acar/images/center/button_delete_s.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;
        <%}%>	            
	<%}%>	
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2">
        	<img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>결과알림톡 발송</span>
        	&nbsp;&nbsp;* 알림톡 내용중 고객명과 고객 수신번호는 상단에서 입력된 고객정보를 바탕으로 표기됩니다.
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr>
    <%
		String url1 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url2 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean2.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url3 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean3.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		String url4 = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_fms.jsp?est_id="+e_bean4.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
		//통합견적 short url 추가 (20181002)
		String url_total = "";
		if(!e_bean1.getPrint_type().equals("1")){
			if(e_bean1.getPrint_type().equals("4")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew_all.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}else if(e_bean1.getPrint_type().equals("5")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_comp_fms.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}else if(e_bean1.getPrint_type().equals("6")){
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_eh_all.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";	
			}else{
				url_total = "http://fms1.amazoncar.co.kr/acar/main_car_hp/estimate_renew.jsp?est_id="+e_bean1.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp";
			}
		}
	%>
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>수신번호</td>
					<td>&nbsp;
						<select name="s_destphone" onchange="javascript:document.form1.est_m_tel.value=this.value;">
							<option value="">선택</option>
	        				<%if(!client.getM_tel().equals("")){%>
	        				<option value="<%=client.getM_tel()%>">[대&nbsp;&nbsp;&nbsp;표&nbsp;&nbsp;&nbsp;자] <%=client.getM_tel()%> <%=client.getClient_nm()%></option>
	        				<%}%>
	        				<%if(!client.getCon_agnt_m_tel().equals("")){%>
	        				<option value="<%=client.getCon_agnt_m_tel()%>">[세금계산서] <%=client.getCon_agnt_m_tel()%> <%=client.getCon_agnt_nm()%></option>
	        				<%}%>
	        				<%for(int i = 0 ; i < mgr_size ; i++){
	        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
	        					if(!mgr.getMgr_m_tel().equals("")){%>
	        					<option value="<%=mgr.getMgr_m_tel()%>" >[<%=mgr.getMgr_st()%>] <%=mgr.getMgr_m_tel()%> <%=mgr.getMgr_nm()%> <%=mgr.getMgr_title()%></option>
	        				<%}}%>
	        				<%if (!e_bean1.getEst_tel().equals("")) {%>
	        					<option value="<%=e_bean1.getEst_tel()%>" selected>[상단 고객연락처] <%=e_bean1.getEst_tel()%></option>
	        				<%}%>
        			  	</select>
        			  	&nbsp;&nbsp;
						번호 : <input type="text" name="est_m_tel" value="<%=e_bean1.getEst_tel()%>" size="20" class="text">
					</td>
				</tr>			
                <tr>
                  	<td width="10%" class=title>팩스/메일발송 알림톡</td>
                  	<td width="90%">&nbsp;
				  		<%-- <input type="text" name="sms_cont1" value="<%=e_bean1.getEst_nm()%> 고객님께서 요청하신 견적서를" size="70" class=whitetext readOnly>
						<br>
						&nbsp;
						<select name='sms_cont2' id="'send_sms_cont2'" onchange="reloadTemplateContent();">            
	                        <option value="">없음</option>					
	                        <option value="팩스" selected>팩스</option>
	                        <option value="메일">메일</option>
						</select>
						<input type="text" name="sms_cont3" value="로 보냈으니 확인 바랍니다. 궁금한 점이 있으면 언제든지 전화주세요. 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카" size="120" class=whitetext readOnly> --%>
						견적서 발송 방식 :&nbsp;
                  		<select name='sms_cont2' id="send_sms_cont2" onchange="reloadTemplateContent();">
	                        <option value="">없음</option>
	                        <option value="팩스" selected>팩스</option>
	                        <option value="메일">메일</option>
						</select><br><br>&nbsp;
						<textarea id="send_content_temp" style="display: none;"><%=send_content_temp%></textarea>						
						<textarea id="alim-textarea" rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=send_msg%></textarea>
				  	</td>
                </tr>	
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="right">
        	<a href="javascript:esti_result_sms();" title='문자보내기'>
        		<img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0>
        	</a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>
    <tr>
        <td class="line2" colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
            	<input type="hidden" name="a_car_name" value="<%=cm_bean.getCar_nm()%>">
         	<%if (e_bean1.getPrint_type().equals("1")) {%>
         		<%if (!e_bean1.getEst_id().equals("")) {
						// String a_a = e_bean1.getA_a().substring(0,1);
						// String rent_way = e_bean1.getA_a().substring(1);
						String s_a_a = "";
						String s_rent_way = "";
						
						String a_a = "";
						String rent_way = "";
						if(!e_bean1.getA_a().equals("")){
							a_a = e_bean1.getA_a().substring(0,1);
							rent_way = e_bean1.getA_a().substring(1);
						}
						
						
						if (a_a.equals("1")) {
							s_a_a="리스플러스";
						} else {
							s_a_a="장기렌트";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="일반식(정비포함)";
						} else {
							s_rent_way="기본식";
						}
						//조정대여료가 있다면
						if (e_bean1.getCtr_s_amt()>0) {
							e_bean1.setFee_s_amt(e_bean1.getCtr_s_amt());
							e_bean1.setFee_v_amt(e_bean1.getCtr_v_amt());
						}
						
						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean1.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean1.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean1.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt()));
						fieldList.add(url1);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						//System.out.println(fieldList);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
				<tr>
					<td width="10%" class=title>
						<input type="checkbox" name="ch_mms_id" value="<%=e_bean1.getEst_id()%>" checked>견적 알림톡1
					</td>
                  	<td width="90%">&nbsp;
	                  	<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">고객님이 요청하신 견적안내. <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean1.getO_1())%>원 <%=c_db.getNameByIdCode("0009", "", e_bean1.getA_a())%><%if(e_bean1.getA_a().equals("11") || e_bean1.getA_a().equals("21")){%>(정비포함)<%}%> <%=e_bean1.getA_b()%>개월 보증금<%=e_bean1.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean1.getAgree_dist())%>km/년 <%=AddUtil.parseDecimal(e_bean1.getFee_s_amt()+e_bean1.getFee_v_amt()+e_bean1.getDriver_add_amt())%>원 VAT포함 (견적서 보기 : <%=url1 %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 </textarea> --%>
	                  	<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
	                  	<input type="hidden" name="a_url" value="<%=url1%>">
	                  	<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
	                  	<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
				</tr>	                
                <%}%>
                <%if (!e_bean2.getEst_id().equals("")) {
						// String a_a = e_bean2.getA_a().substring(0,1);
						// String rent_way = e_bean2.getA_a().substring(1);
						String a_a = "";
						String rent_way = "";
						if(!e_bean2.getA_a().equals("")){
							a_a = e_bean2.getA_a().substring(0,1);
							rent_way = e_bean2.getA_a().substring(1);
						}
						String s_a_a = "";
						String s_rent_way = "";
						
						if (a_a.equals("1")) {
							s_a_a = "리스플러스";
						} else {
							s_a_a = "장기렌트";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="일반식(정비포함)";
						} else {
							s_rent_way="기본식";
						}
						//조정대여료가 있다면
						if (e_bean2.getCtr_s_amt()>0) {
							e_bean2.setFee_s_amt(e_bean2.getCtr_s_amt());
							e_bean2.setFee_v_amt(e_bean2.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean2.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean2.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean2.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean2.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean2.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt()));
						fieldList.add(url2);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
					<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean2.getEst_id()%>" checked>견적 알림톡2</td>
        	        <td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">고객님이 요청하신 견적안내.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean2.getO_1())%>원 <%=c_db.getNameByIdCode("0009", "", e_bean2.getA_a())%><%if(e_bean2.getA_a().equals("11") || e_bean2.getA_a().equals("21")){%>(정비포함)<%}%> <%=e_bean2.getA_b()%>개월 보증금<%=e_bean2.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean2.getAgree_dist())%>km/년 <%=AddUtil.parseDecimal(e_bean2.getFee_s_amt()+e_bean2.getFee_v_amt()+e_bean2.getDriver_add_amt())%>원 VAT포함 (견적서 보기 : <%=url2 %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 </textarea> --%>
						<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url2%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>	                
                <%}%>
                <%if (!e_bean3.getEst_id().equals("")) {
						String a_a = "";
						String rent_way = "";
						if(!e_bean3.getA_a().equals("")){
							a_a = e_bean3.getA_a().substring(0,1);
							rent_way = e_bean3.getA_a().substring(1);
						}
						String s_a_a = "";
						String s_rent_way = "";
						
						if (a_a.equals("1")) {
							s_a_a="리스플러스"; 
						} else {
							s_a_a="장기렌트";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="일반식(정비포함)";
						} else {
							s_rent_way="기본식";
						}
						//조정대여료가 있다면
						if (e_bean3.getCtr_s_amt()>0) {
							e_bean3.setFee_s_amt(e_bean3.getCtr_s_amt());
							e_bean3.setFee_v_amt(e_bean3.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean3.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean3.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean3.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean3.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean3.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt()));
						fieldList.add(url3);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean3.getEst_id()%>" checked>견적 알림톡3</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">고객님이 요청하신 견적안내.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean3.getO_1())%>원 <%=c_db.getNameByIdCode("0009", "", e_bean3.getA_a())%><%if(e_bean3.getA_a().equals("11") || e_bean3.getA_a().equals("21")){%>(정비포함)<%}%> <%=e_bean3.getA_b()%>개월 보증금<%=e_bean3.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean3.getAgree_dist())%>km/년 <%=AddUtil.parseDecimal(e_bean3.getFee_s_amt()+e_bean3.getFee_v_amt()+e_bean3.getDriver_add_amt())%>원 VAT포함 (견적서 보기 : <%=url3 %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url3%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>
                <%}%>
                
                <%if (!e_bean4.getEst_id().equals("")) {
						// String a_a = e_bean4.getA_a().substring(0,1);
						// String rent_way = e_bean4.getA_a().substring(1);
						String s_a_a = "";
						String s_rent_way = "";
						
						String a_a = "";
						String rent_way = "";
						if(!e_bean4.getA_a().equals("")){
							a_a = e_bean4.getA_a().substring(0,1);
							rent_way = e_bean4.getA_a().substring(1);
						}
						
						if (a_a.equals("1")) {
							s_a_a="리스플러스";
						} else {
							s_a_a="장기렌트";
						}
						
						if (rent_way.equals("1")) {
							s_rent_way="일반식(정비포함)";
						} else {
							s_rent_way="기본식";
						}
						//조정대여료가 있다면
						if (e_bean4.getCtr_s_amt()>0) {
							e_bean4.setFee_s_amt(e_bean4.getCtr_s_amt());
							e_bean4.setFee_v_amt(e_bean4.getCtr_v_amt());
						}						

						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean4.getO_1()));
						fieldList.add(s_a_a);
						fieldList.add(s_rent_way);
						fieldList.add(e_bean4.getA_b());
						fieldList.add(AddUtil.parseDecimal(e_bean4.getGtr_amt()));
						fieldList.add(String.valueOf(e_bean4.getRg_8()));						
						fieldList.add(AddUtil.parseDecimal(e_bean4.getAgree_dist()));
						fieldList.add(AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt()));
						fieldList.add(url4);
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
                %>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean4.getEst_id()%>" checked>견적 알림톡4</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">고객님이 요청하신 견적안내.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean4.getO_1())%>원 <%=c_db.getNameByIdCode("0009", "", e_bean4.getA_a())%><%if(e_bean4.getA_a().equals("11") || e_bean4.getA_a().equals("21")){%>(정비포함)<%}%> <%=e_bean4.getA_b()%>개월 보증금<%=e_bean4.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean4.getAgree_dist())%>km/년 <%=AddUtil.parseDecimal(e_bean4.getFee_s_amt()+e_bean4.getFee_v_amt()+e_bean4.getDriver_add_amt())%>원 VAT포함 (견적서 보기 : <%=url4 %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=url4%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
		  			</td>
                </tr>	                
                <%}%>
          <%} else {	//통합견적 short url 추가 (20181002) %>
	          	<%if (!e_bean1.getEst_id().equals("")) { 
	        	  		String s_a_a = "";
						String s_rent_way = "";
						
						String msg = "";
						
						ArrayList<String> fieldList = new ArrayList<String>();
						
						fieldList.add(cm_bean.getCar_nm());
						fieldList.add(AddUtil.parseDecimal(e_bean1.getO_1()));
						fieldList.add(ShortenUrlGoogle.getShortenUrl(url_total));
						fieldList.add(u_nm);
						fieldList.add(u_mt);
						
						AlimTemplateBean templateBean = atp_db.selectTemplate("acar0144");
				    	String content = templateBean.getContent();
					  	for (String field : fieldList) {
				    		content = content.replaceFirst("\\#\\{.*?\\}", field);
				    	}
					  	
					  	msg = content;
	          	%>
                <tr>
                	<td width="10%" class=title><input type="checkbox" name="ch_mms_id" value="<%=e_bean1.getEst_id()%>" checked>견적 알림톡<br>
                  	<%if (e_bean1.getPrint_type().equals("2")) {%>(렌트)<%}%>
					<%if (e_bean1.getPrint_type().equals("3")) {%>(리스)<%}%>
					<%if (e_bean1.getPrint_type().equals("4")) {%>(종합)<%}%>
					<%if (e_bean1.getPrint_type().equals("5")) {%>(견적별 종합)<%}%>
                  	</td>
                  	<td width="90%">&nbsp;
                  		<%-- <textarea name='wap_msg_body' rows='2' cols='100' readOnly class="white_sizeFix">고객님이 요청하신 견적안내.  <%=cm_bean.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean1.getO_1())%>원 (견적서 보기 : <%=ShortenUrlGoogle.getShortenUrl(url_total) %> ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카 </textarea> --%>
                  		<textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
                  		<input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url_total)%>">
                  		<input type="hidden" name="a_gubun1" value="<%=s_a_a%>">
                  		<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
					</td>
               	</tr>	                
               	<%}%>
       		<%} %>
            </table>
        </td>
    </tr>	
    <tr>
    	<td></td>
        <td align="right"><a href="javascript:select_esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a></td>
    </tr>  
    <%}%>	
</form>
</table>
<script>
<%//if (e_bean1.getCls_per() > 100 || e_bean2.getCls_per() > 100 || e_bean3.getCls_per() > 100 || e_bean4.getCls_per() > 100) {%>
//alert("위약금율이 100%를 초과하였습니다. 위약금율이 100% 이내가 되도록 견적 보증금을 줄여주세요.");
<%//}%>
</script>
<script>
<!--
	<%if(from_page.equals("/acar/estimate_mng/esti_mng_atype_proc.jsp")){%>
//	EstiView('<%=e_bean1.getEst_id()%>');
	<%}%>
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
