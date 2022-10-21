<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.*, acar.car_mst.*, acar.estimate_mng.*, acar.secondhand.*, acar.user_mng.*, acar.cont.*, acar.client.*" %>
<%@ page import="acar.kakao.*" %>
<jsp:useBean id="cc_bean" class="acar.car_office.CarCompBean" scope="page"/>
<jsp:useBean id="cm_bean" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="cm_bean2" class="acar.car_mst.CarMstBean" scope="page"/>
<jsp:useBean id="e_bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="a_db" class="acar.cont.AddContDatabase" scope="page"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="atp_db" class="acar.kakao.AlimTemplateDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"2":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String esti_m = request.getParameter("esti_m")==null?"":request.getParameter("esti_m");
	String esti_m_dt = request.getParameter("esti_m_dt")==null?"":request.getParameter("esti_m_dt");
	String esti_m_s_dt = request.getParameter("esti_m_s_dt")==null?"":request.getParameter("esti_m_s_dt");
	String esti_m_e_dt = request.getParameter("esti_m_e_dt")==null?"":request.getParameter("esti_m_e_dt");	
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String from_page2 = request.getParameter("from_page2")==null?"":request.getParameter("from_page2");
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String today_dist 	= request.getParameter("today_dist")==null?"":request.getParameter("today_dist");
	
	String white = "";
	String disabled = "";
	if(cmd.equals("")){
		white = "white";
		disabled = "disabled";
	}
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	
	if(est_id.equals("") || est_id.equals("null")){
		out.println("선택된 견적이 없습니다.");
		return;
	}
	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	e_bean = e_db.getEstimateCase(est_id);
	
	String a_a = "";
	String rent_way = "";
	
	if(!e_bean.getA_a().equals("")){
		a_a = e_bean.getA_a().substring(0,1);
		rent_way = e_bean.getA_a().substring(1);
	}
	String a_b = e_bean.getA_b();
	float o_13 = 0;
	
	//CAR_NM : 차명정보
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	cm_bean2 = a_cmb.getCarNmCase(e_bean.getCar_id(), e_bean.getCar_seq());
	
	String a_e = cm_bean2.getS_st();
	
	if(e_bean.getEst_st().equals("3")){
		if(car_mng_id.equals(""))	car_mng_id 	= est_id;
	}else{
		if(car_mng_id.equals(""))	car_mng_id 	= e_bean.getMgr_nm();
	}
	
	//차량정보
	Hashtable ht = shDb.getShBase(car_mng_id);
	
	String car_comp_id		= String.valueOf(ht.get("CAR_COMP_ID"));
	String car_id			= String.valueOf(ht.get("CAR_ID"));
	String car_seq			= String.valueOf(ht.get("CAR_SEQ"));
	String s_st 			= String.valueOf(ht.get("S_ST"));
	String jg_code 			= String.valueOf(ht.get("JG_CODE"));
	String car_no 			= String.valueOf(ht.get("CAR_NO"));
	String car_name			= String.valueOf(ht.get("CAR_NAME"));
	String init_reg_dt 		= String.valueOf(ht.get("INIT_REG_DT"));
	String secondhand_dt 	= String.valueOf(ht.get("SECONDHAND_DT"));
	String park		 		= String.valueOf(ht.get("PARK"));
	String dlv_dt 			= String.valueOf(ht.get("DLV_DT"));	
	String before_one_year 	= String.valueOf(ht.get("BEFORE_ONE_YEAR"));
	String tot_dist 		= String.valueOf(ht.get("TOT_DIST"));
	String serv_dt	 		= String.valueOf(ht.get("SERV_DT"));
	String lpg_yn	 		= String.valueOf(ht.get("LPG_YN"));
	String opt		 		= String.valueOf(ht.get("OPT"));
	String colo		 		= String.valueOf(ht.get("COL"));
	int car_amt 			= AddUtil.parseInt((String)ht.get("CAR_AMT"));
	int opt_amt 			= AddUtil.parseInt((String)ht.get("OPT_AMT"));
	int clr_amt 			= AddUtil.parseInt((String)ht.get("COL_AMT"));
	int tax_dc_amt 		= AddUtil.parseInt((String)ht.get("TAX_DC_AMT"));
	if(today_dist.equals(""))	today_dist 	= String.valueOf(ht.get("TODAY_DIST"));
	
	if(e_bean.getCar_amt()==0){
		e_bean.setCar_amt(car_amt);
		e_bean.setOpt_amt(opt_amt);
		e_bean.setCol_amt(clr_amt);
	}
	
	String stat = "";
	if(e_bean.getEst_st().equals("3") && car_amt == 0) stat = "신차가격불명";
	if(e_bean.getEst_st().equals("3") && AddUtil.parseInt((String)ht.get("O_L")) == 0) stat = "중고차가미정";
	
	//잔가 차량정보
	Hashtable sh_var = shDb.getShBaseVar(car_mng_id);
	
	int sh_car_amt			= AddUtil.parseInt((String)sh_var.get("SH_CAR_AMT"));
	int dlv_car_amt			= AddUtil.parseInt((String)sh_var.get("DLV_CAR_AMT"));
	
	sh_car_amt 	= e_bean.getO_1();
	dlv_car_amt = car_amt+opt_amt+clr_amt-tax_dc_amt-e_bean.getO_1();	
	
	//공통변수
	em_bean = e_db.getEstiCommVarCase(a_a, "");
	
	//중고차잔가변수
	EstiJgVarBean ej_bean = e_db.getEstiJgVarCase(jg_code, "");
	//친환경차 유무 체크 위한 변수
	String jg_g_7 = String.valueOf(ej_bean.getJg_g_7());
		
	//최대잔가
	o_13 = e_db.getJanga(e_bean.getCar_id(), e_bean.getCar_seq(), a_b, e_bean.getLpg_yn());			
	
	
	//자동차회사 리스트
	CarOfficeDatabase umd = CarOfficeDatabase.getInstance();
	CarCompBean cc_r [] = umd.getCarCompAll_Esti();
	
	//차종리스트
	CarMstDatabase cmb = CarMstDatabase.getInstance();
	CarMstBean cm_r [] = cmb.getCarKindAll_Esti(e_bean.getCar_comp_id());
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	CodeBean[] goods = c_db.getCodeAll2("0009", "Y"); /* 코드 구분:대여상품명 */
	int good_size = goods.length;
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();

	//담당자 추가	
	String u_nm ="";
	String u_mt ="";
	String u_ht ="";
	
	UserMngDatabase umdb = UserMngDatabase.getInstance();
	
	UsersBean user_bean = umdb.getUsersBean(e_bean.getReg_id());
	
	u_nm = user_bean.getUser_nm();
	u_mt = user_bean.getUser_m_tel();
	u_ht = user_bean.getHot_tel();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(e_bean.getRent_mng_id(), e_bean.getRent_l_cd());
	
	//고객관련자
	Vector car_mgrs = a_db.getCarMgrListNew(e_bean.getRent_mng_id(), e_bean.getRent_l_cd(), "Y");
	int mgr_size = car_mgrs.size();
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//카카오템플릿
	String send_msg = "";
	
	ArrayList<String> sendList = new ArrayList<String>();
	
	sendList.add(e_bean.getEst_nm());
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
  	
  	//주차장 정보
  	CodeBean[] car_goods = c_db.getCodeAll3("0027");
  	int car_goods_size = car_goods.length;	
	
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<style>
.over_auto {
	overflow: auto !important;
}
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//고객수정하기
	function CustUpate(){
		var fm = document.form1;
		if(!confirm('고객정보를 수정하시겠습니까?')){	return; }	
		
		fm.cmd.value = 'cust';
		
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}	
	
	//견적사후관리 수정
	function BusUpate(){
		var fm = document.form1;
		if(fm.bus_yn.value == '')	{ alert('계약여부를 확인하십시오.'); 		return;}
		if(!confirm('시장상황를 수정하시겠습니까?')){	return; }	
		fm.action = 'upd_esti_bus_a.jsp';		
		fm.target = 'i_no';
		fm.submit();				
	}
	
	//목록보기
	function go_list(){
		var fm = document.form1;
		if(fm.from_page2.value == '/fms2/bus_analysis/ba_esti_frame.jsp'){
			fm.action = '/fms2/bus_analysis/ba_esti_frame.jsp';										
		}else if(fm.from_page2.value == '/fms2/bus_analysis/ba_stat_frame.jsp'){
			fm.action = '/fms2/bus_analysis/ba_stat_frame.jsp';										
		}else{
			fm.action = 'esti_sh_frame.jsp';												
			//location='esti_sh_frame.jsp?auth_rw=<%=auth_rw%>&br_id=<%=br_id%>&user_id=<%=user_id%>&gubun1=<%=gubun1%>&gubun2=<%=gubun2%>&gubun3=<%=gubun3%>&gubun4=<%=gubun4%>&s_dt=<%=s_dt%>&e_dt=<%=e_dt%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&esti_m=<%= esti_m %>&esti_m_dt=<%= esti_m_dt %>&esti_m_s_dt=<%= esti_m_s_dt %>&esti_m_e_dt=<%= esti_m_e_dt %>';
		}
		fm.target = 'd_content';
		fm.submit();	
	}

	
	//재리스 견적내기
	function EstiReReg(){
		var fm = document.form1;
		fm.action = '/acar/secondhand/esti_mng_i_re.jsp';
		fm.target = "_blank";
		fm.submit();
	}
	
	//메일수신하기
	function open_mail(){
		var SUBWIN="";
		<%if(e_bean.getEst_st().equals("2")){%>
		SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms_ym";	
		<%}else{%>
		SUBWIN="/acar/apply/mail_input.jsp?est_id=<%=est_id%>&est_email=<%=e_bean.getEst_email()%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";	
		<%}%>
		window.open(SUBWIN, "openMail", "left=100, top=100, width=420, height=600, scrollbars=no, status=yes");
	}	
	
	//견적서보기
	function EstiView(){
		var SUBWIN="";
		<%if(e_bean.getEst_st().equals("2")){%>
		SUBWIN="/acar/secondhand_hp/estimate_fms_ym.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms_ym";
		<%}else{%>
		SUBWIN="/acar/secondhand_hp/estimate_fms.jsp?est_id=<%=est_id%>&acar_id=<%=user_id%>&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";
		<%}%>
		window.open(SUBWIN, "EstiPrint", "left=50, top=50, width=698, height=700, scrollbars=yes, status=yes");				
	}
		
	//견적결과 문자보내기
	function esti_result_sms(){
		var fm = document.form1;
		
		if (fm.est_tel.value != '' && fm.est_m_tel.value == '') { 
			fm.est_m_tel.value = fm.est_tel.value;
		}		
		
		if (fm.est_m_tel.value == '') {
			alert('수신번호를 입력하십시오');
			return;
		}		
		
		if (!confirm('결과문자를 발송하시겠습니까?')) {
			return;
		}
		
		fm.cmd.value = 'result_sms';
		
		fm.action = 'upd_esti_cust_a.jsp';		
		fm.target = 'i_no';					
		fm.submit();
	}
	
	//견적결과 선택 상세내용 문자보내기
	function select_esti_result_sms() {
		var fm = document.form1;
						
		if (fm.est_tel.value != '' && fm.est_m_tel.value == '') { 	
			fm.est_m_tel.value = fm.est_tel.value; 
		}
		
		if (fm.est_m_tel.value == '') {
			alert('수신번호를 입력하십시오');
			return;
		}
		
		if (!confirm('이 번호로 결과문자를 발송하시겠습니까?')) {
			return;
		}
		
		fm.cmd.value = 'result_select_sms_wap';
		
		fm.action = 'upd_esti_cust_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	//견적결과보기
	function estimates_view(reg_code) {
		var SUBWIN = "/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=1&rent_st=1&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}			
	
	//카카오템플릿 reload
	function reloadTemplateContent() {
		var customer_name = "<%=e_bean.getEst_nm()%>";
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
	
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="../car_mst/car_mst_null.jsp" name="form2" method="post">
    <input type="hidden" name="sel" value="">
    <input type="hidden" name="car_comp_id" value="">
    <input type="hidden" name="code" value="">
    <input type="hidden" name="mode" value="">
  </form>
  <form action="./esti_mng_u_a.jsp" name="form1" method="POST" >
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
    <input type="hidden" name="esti_m" value="<%=esti_m%>">
    <input type="hidden" name="esti_m_dt" value="<%=esti_m_dt%>">
    <input type="hidden" name="esti_m_s_dt" value="<%=esti_m_s_dt%>">
    <input type="hidden" name="esti_m_e_dt" value="<%=esti_m_e_dt%>">
    <input type="hidden" name="est_id" value="<%=est_id%>">
    <input type="hidden" name="car_mng_id" value="<%=car_mng_id%>">	
    <input type="hidden" name="cmd" value="<%=cmd%>">
    <input type="hidden" name="s_st" value="">
    <input type="hidden" name="a_e" value="">
	<input type="hidden" name="udt_st" value="<%=e_bean.getUdt_st()%>">
	<input type="hidden" name="spr_yn" value="<%=e_bean.getSpr_yn()%>">
	<input type="hidden" name="set_code" value="">	
	<input type="hidden" name="from_page" value="esti_sh_mng_u.jsp">
	<input type="hidden" name="from_page2" value="<%=from_page2%>">
	<input type="hidden" name="u_nm" value="<%=u_nm%>">
	<input type="hidden" name="u_mt" value="<%=u_mt%>">
	<input type="hidden" name="u_ht" value="<%=u_ht%>">
	<input type="hidden" name="dlv_car_amt" value="<%=dlv_car_amt%>">
	<input type="hidden" name="br_to_st" value="<%=e_bean.getBr_to_st()%>">
	<input type="hidden" name="br_to" value="<%=e_bean.getBr_to()%>">
	<input type="hidden" name="br_from" value="<%=e_bean.getBr_from()%>">
    <tr>
    	<td colspan=2>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업관리 > 견적관리 > <span class=style5>재리스 견적내기(<%=est_id%>)</span></span> : (<%=est_id%>)</td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right">
        <a href="javascript:go_list();"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellpadding=0 cellspacing="1" width=100%>
                <tr> 
                    <td class=title width=10%>상호/성명</td>
                    <td width=19%> 
                        &nbsp;<input type="text" name="est_nm" value="<%=e_bean.getEst_nm()%>" size="27" class=text onKeyDown='javascript:enter()' style='IME-MODE: active'>
						
                  </td>
                    <td class=title width=13%>사업자/생년월일</td>
                    <td width=14%> 
                        &nbsp;<input type="text" name="est_ssn" value="<%=e_bean.getEst_ssn()%>" size="15" class=text>
                    </td>
                    <td class=title width=10%>전화번호</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_tel" value="<%=e_bean.getEst_tel()%>" size="12" class=text>
                    </td>
                    <td class=title width=10%>FAX</td>
                    <td width=12%> 
                        &nbsp;<input type="text" name="est_fax" value="<%=e_bean.getEst_fax()%>" size="12" class=text>
                    </td>
                </tr>
                <tr>				
                    <td class=title>이메일</td>
                    <td colspan="7">
                    	&nbsp;<input type="text" name="est_email" value="<%=e_bean.getEst_email()%>" size="50" class=text style='IME-MODE: inactive'>
                      </td>
                </tr>					  
                <tr>				
                    <td class=title>고객구분</td>
                    <td colspan="7">&nbsp;<input type="radio" name="doc_type" value="1" <% if(e_bean.getDoc_type().equals("1")||e_bean.getDoc_type().equals("")) out.print("checked"); %>>
                      법인고객
					  <input type="radio" name="doc_type" value="2" <% if(e_bean.getDoc_type().equals("2")) out.print("checked"); %>>
                      개인사업자 
					  <input type="radio" name="doc_type" value="3" <% if(e_bean.getDoc_type().equals("3")) out.print("checked"); %>>
                      개인 					  
                      </td>
                </tr>					  
                <tr>
                    <td class=title>견적유효기간</td>
                    <td colspan="7">&nbsp;<input type="radio" name="vali_type" value="0" <% if(e_bean.getVali_type().equals("0")||e_bean.getVali_type().equals("")) out.print("checked"); %>>
                      날짜만표기(10일)
					  <input type="radio" name="vali_type" value="1" <% if(e_bean.getVali_type().equals("1")) out.print("checked"); %>>
                      메이커D/C 변경 가능성 언급 
					  <input type="radio" name="vali_type" value="2" <% if(e_bean.getVali_type().equals("2")) out.print("checked"); %>>
                      미확정견적 
                      </td>
                </tr>				
                <tr>
                    <td class=title>신용도</td>
                    <td colspan="7">&nbsp;<b><% if(e_bean.getSpr_yn().equals("2")){%>초우량기업<% }else if(e_bean.getSpr_yn().equals("1")){%>우량기업<% }else if(e_bean.getSpr_yn().equals("0")){%>일반기업<% }else if(e_bean.getSpr_yn().equals("3")){%>신설법인<%}%></b>
                      </td>
                </tr>	
                <tr>
                    <td class=title>담당자</td>
                    <td colspan="7">&nbsp;<select name='damdang_id' class=default>            
                        <option value="">미지정</option>
        		        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); 
        				%>
          			    <option value='<%=user.get("USER_ID")%>' <% if(e_bean.getReg_id().equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
                		<%		}
        					}%>
        			  </select>
                      </td>
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
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10%>제조사</td>
                    <td colspan="2">&nbsp;<select name="car_comp_id" onChange="javascript:GetCarCode()" <%=disabled%>>
                        <%for(int i=0; i<cc_r.length; i++){
        						        cc_bean = cc_r[i];%>
                        <option value="<%= cc_bean.getCode() %>" <%if(e_bean.getCar_comp_id().equals(cc_bean.getCode()))%>selected<%%>><%= cc_bean.getNm() %></option>
                        <%	}	%>
                      </select> </td>
                </tr>
                <tr> 
                    <td class=title>차명</td>
                    <td colspan="2">&nbsp;<select name="code" <%=disabled%>>
                        <option value="">선택</option>
                        <%for(int i=0; i<cm_r.length; i++){
        						        cm_bean = cm_r[i];%>
                        <option value="<%= cm_bean.getCode() %>" <%if(e_bean.getCar_cd().equals(cm_bean.getCode()))%>selected<%%>>[<%=cm_bean.getCar_cd()%>]<%=cm_bean.getCar_nm()%></option>
                        <%	}	%>
                      </select> 
					  (<%=cm_bean2.getJg_code()%>)
					  </td>
                </tr>
                <tr> 
                    <td class=title width=10%>차종</td>
                    <td width=65%> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('1');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a> 
                      <%}%>
                      &nbsp;<input type="text" name="car_name" value="<%=cm_bean2.getCar_name()%>" size="75" class=<%=white%>text>
                      <input type="hidden" name="car_id" value="<%=e_bean.getCar_id()%>"> 
                      <input type="hidden" name="car_seq" value="<%=e_bean.getCar_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="car_amt" value="<%=AddUtil.parseDecimal(e_bean.getCar_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>옵션</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('2');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="opt" value="<%=e_bean.getOpt()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="opt_seq" value="<%=e_bean.getOpt_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="opt_amt" value="<%=AddUtil.parseDecimal(e_bean.getOpt_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
                <tr> 
                    <td class=title>색상</td>
                    <td> 
                      <%if(!cmd.equals("")){%>
                      &nbsp;<a href="javascript:sub_list('3');"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a>  
                      <%}%>
                      &nbsp;<input type="text" name="col" value="<%=e_bean.getCol()%>" size="75" class=<%=white%>text> 
                      <input type="hidden" name="col_seq" value="<%=e_bean.getCol_seq()%>"> 
                    </td>
                    <td align="center"> <input type="text" name="col_amt" value="<%=AddUtil.parseDecimal(e_bean.getCol_amt())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
<%
	if(jg_g_7.equals("1") || jg_g_7.equals("2") || jg_g_7.equals("3") || jg_g_7.equals("4")){
%>                
                <tr>
                    <td class="title">신차 개소세 감면</td>
                    <td>&nbsp;</td>
                    <td align="center"><input type="text" name="car_amt" value="- <%= AddUtil.parseDecimal(tax_dc_amt) %>" size="15" class="whitenum">원</td>
                </tr>
<%
	}
%>                 
                <tr> 
                    <td class=title>감가상각</td>
                    <td>&nbsp;신차등록일 : <%=AddUtil.ChangeDate2(init_reg_dt)%>&nbsp;&nbsp;&nbsp;&nbsp;주행거리 : <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %> <%if(e_bean.getToday_dist()==0) out.println("*****");%> km
                    </td>
                    <td align="center"> -<input type="text" name="dc_amt" value="<%=AddUtil.parseDecimal(dlv_car_amt)%>" size="15" class=<%=white%>num onBlur='javscript:this.value = parseDecimal(this.value); set_amt();'>
                      원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">차량가격 (차량번호 : <%=car_no%>)</td>
                    <td align="center"><input type="text" name="o_1" value="<%=AddUtil.parseDecimal(e_bean.getO_1())%>" size="15" class=<%=white%>num>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약조건</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td width=10% colspan="2" class=title>견적일시</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(e_bean.getReg_dt())%> </td>
                </tr>
                <tr> 
                    <td colspan="2" class=title>대여상품</td>
                    <td colspan="3">&nbsp;<select name="a_a" <%=disabled%>>
                        <option value="">=선 택=</option>
                        <%for(int i = 0 ; i < good_size ; i++){
        					         CodeBean good = goods[i];
        					      %>
                        <option value='<%= good.getNm_cd()%>' <%if(e_bean.getA_a().equals(good.getNm_cd()))%>selected<%%>><%= good.getNm()%></option>
                        <%}%>
                      </select>                       
                      
                      <%if(e_bean.getEst_st().equals("2")){%>
                      - 연장 (<%=e_bean.getRent_l_cd()%>)
                      <%}%>
                    </td>
                </tr>
                <tr> 
                    <td width=10% colspan="2" class=title>약정주행거리</td>
                    <td colspan="3">&nbsp;<%=e_bean.getAgree_dist()%>km </td>
                </tr>                
                <tr> 
                    <td colspan="2" class=title>대여기간</td>
                    <td colspan="3">&nbsp;<input type="text" name="a_b" value="<%=e_bean.getA_b()%>" size="2" class=<%=white%>text>개월</td>
                </tr>				
                <tr> 
                    <td width="10%" rowspan="2" class=title>잔가</td>
                    <td width="10%" class=title>적용잔가율</td>
                    <td colspan="3"> &nbsp;차가의 
                      <input type="text" name="ro_13" value="<%=e_bean.getRo_13()%>" size="4" class=<%=white%>text  onblur="javascript:compare(this)">
                      % <font color="#666666">(최대잔가율 
                      <input type="text" name="o_13" value="<%=o_13*100%>" class=whitenum size="3">
                      % 내에서 선택)</font> , 적용잔가금액 
                      <input type="text" name="ro_13_amt" class=num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);' value="<%=AddUtil.parseDecimal(e_bean.getRo_13_amt())%>">
                      원 <font color="#666666">(매입옵션 금액임)</font>
					  </td>
                </tr>
                <tr>
                  <td class=title>매입옵션</td>
                  <td colspan="3">&nbsp;
				    <input type='radio' name="opt_chk" value='0' <%if(e_bean.getOpt_chk().equals("0")){%> checked <%}%>>
                      미부여
                      <input type='radio' name="opt_chk" value='1' <%if(e_bean.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		  부여
					</td>
                </tr>				
                <tr> 
                    <td rowspan="3" class=title>선수</td>
                    <td class=title>보증금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="rg_8" value="<%=e_bean.getRg_8()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용보증금액 <font color="#666666"> 
                      <input type="text" name="rg_8_amt" value="<%=AddUtil.parseDecimal(e_bean.getRg_8_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 (기본보증금율 
                      <input type="text" name="g_8" value="<%=em_bean.getG_8()%>" class=whitenum size="3">
                      % 이상에서 선택) </font> </td>
                </tr>
                <tr> 
                    <td class=title>선납금<br>
                    </td>
                    <td colspan="3">&nbsp;차가의 
                      <input type="text" name="pp_per" value="<%=e_bean.getPp_per()%>" class=<%=white%>num size="4" onBlur="javascript:compare(this)">
                      %, 적용선납금액<font color="#666666">&nbsp;</font> <input type="text" name="pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_amt())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);compare(this);'>
                      원 </td>
                </tr>
                <tr id="tr_ifee" style="display:''"> 
                    <td class=title>개시대여료</td>
                    <td colspan="3">&nbsp;<font color="#666666"> 
                    <input type="checkbox" name="pp_st" value="1" <%if(e_bean.getPp_st().equals("1"))%> checked<%%> <%=disabled%>>
                    <input type="text" name="g_10" class=<%=white%>num size="2" value="<%=e_bean.getG_10()%>">
                    개월치 대여료 선납 </font></td>
                </tr>
                 <tr> 
                    <td rowspan="3" class=title>보험</td>
                    <td class=title>대물,자손</td>
                    <td >&nbsp;<select name="ins_dj"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_dj().equals("1"))%>selected<%%>>5천만원/5천만원</option>
                        <option value="2" <%if(e_bean.getIns_dj().equals("2"))%>selected<%%>>1억원/1억원</option>
                        <option value="4" <%if(e_bean.getIns_dj().equals("4"))%>selected<%%>>2억원/1억원</option>
                    </select> </td>
                    <!--
                    <td class=title width=11%>애니카보험</td>
                    <td>&nbsp;<select name="ins_good" <%=disabled%>>
                        <option value="0" <%if(e_bean.getIns_good().equals("0"))%>selected<%%>>미가입</option>
                        <option value="1" <%if(e_bean.getIns_good().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                      -->
                      <td class=title width='11%'>보험계약자</td>
                    <td> 
                      &nbsp;<select name="insurant"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getInsurant().equals("1"))%>selected<%%>>아마존카</option>
                            <!--<option value="2" <%if(e_bean.getInsurant().equals("2"))%>selected<%%>>고객</option>-->
                          </select>
                    </td>	 
                </tr>
                <tr>
                  <td class=title>운전자연령</td> 
                    <td >&nbsp;<select name="ins_age"  <%=disabled%>>
                        <option value="1" <%if(e_bean.getIns_age().equals("1"))%>selected<%%>>만26세이상</option>
						<option value="3" <%if(e_bean.getIns_age().equals("3"))%>selected<%%>>만24세이상</option>
                        <option value="2" <%if(e_bean.getIns_age().equals("2"))%>selected<%%>>만21세이상</option>
                    </select> </td>
                    <td class=title width='11%'>피보험자</td>
                    <td> 
                      &nbsp;<select name="ins_per"  <%=disabled%>>
                            <option value="1" <%if(e_bean.getIns_per().equals("1"))%>selected<%%>>아마존카(보험포함)</option>
                            <option value="2" <%if(e_bean.getIns_per().equals("2"))%>selected<%%>>고객(보험미포함)</option>
                          </select>
                    </td>	
                </tr>
                <tr> 
                    <td class=title>보증보험</td>
                    <td>&nbsp;<select name="gi_yn"  <%=disabled%>>
                        <option value="0" <%if(e_bean.getGi_yn().equals("0"))%>selected<%%>>면제</option>
                        <option value="1" <%if(e_bean.getGi_yn().equals("1"))%>selected<%%>>가입</option>
                      </select> </td>
                    <td class=title>자차면책금</td>
                    <td>&nbsp;<input type="text" name="car_ja" value="<%=AddUtil.parseDecimal(e_bean.getCar_ja())%>" class=<%=white%>num size="10" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>					  
                </tr>
               <tr> 
                    <td rowspan="3" class=title>기타<br> </td>
                    <td class=title>등록지역</td>
                    <td>&nbsp;<%=c_db.getNameByIdCode("0032", "", e_bean.getA_h())%></td>
                    <td class=title style="display: none;">차량인수지</td>
                    <td style="display: none;">&nbsp;<select name="f_udt_st" <%=disabled%> >
                        <option value="">=선 택=</option>
                        <option value="1" <%if(e_bean.getUdt_st().equals("1"))%>selected<%%>>서울본사</option>
                        <option value="2" <%if(e_bean.getUdt_st().equals("2"))%>selected<%%>>부산지점</option>
                        <option value="3" <%if(e_bean.getUdt_st().equals("3"))%>selected<%%>>대전지점</option>
                        <option value="4" <%if(e_bean.getUdt_st().equals("4"))%>selected<%%>>고객</option>
                      </select> </td>
                    <td class=title>현위치</td>
                    <td>&nbsp;
                        <%-- <%if (e_bean.getBr_from().equals("0")) {%>서울<%}%>
                        <%if (e_bean.getBr_from().equals("1")) {%>대전<%}%>
                        <%if (e_bean.getBr_from().equals("2")) {%>대구<%}%>
                        <%if (e_bean.getBr_from().equals("3")) {%>광주<%}%>
                        <%if (e_bean.getBr_from().equals("4")) {%>부산<%}%> --%>
                        <%for(int i = 0 ; i < car_goods_size ; i++){
							CodeBean car_good = car_goods[i];
							if(park.equals(car_good.getNm_cd())){%>
								<%=car_good.getNm()%>
							<%}%>
						<%}%>
					</td>
                </tr>
                <tr> 
                    <td class=title>대여료D/C</td>
                    <td>&nbsp;대여료의 
                      <input type="text" name="fee_dc_per" value="<%=e_bean.getFee_dc_per()%>" size="4" class=<%=white%>text>
                      %</td>
					<td class=title style="display: none;">영업수당</td>
                    <td style="display: none;">&nbsp;차가의 
                      <input type="text" name="o_11" value="<%=e_bean.getO_11()%>" size="4" class=<%=white%>text>
                      %</td>  
                    <td class=title>고객주소지<br>(차량인도지역)</td>
                    <td>&nbsp;
                        <%if (e_bean.getBr_to_st().equals("0")) {%>수도권<%}%>
                        <%if (e_bean.getBr_to_st().equals("1")) {%>대전/세종/충남/충북<%}%>
                        <%if (e_bean.getBr_to_st().equals("2")) {%>대구/경북<%}%>
                        <%if (e_bean.getBr_to_st().equals("3")) {%>광주/전남/전북<%}%>
                        <%if (e_bean.getBr_to_st().equals("4")) {%>부산/울산/경남<%}%>
                        <%if (e_bean.getBr_to_st().equals("5")) {%>강원<%}%>
					</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적결과</span>
          <a href="javascript:estimates_view('<%=e_bean.getReg_code()%>');">(<%=e_bean.getReg_code()%>)</a>
		</td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1"  cellpadding=0 width=100%>
                <tr> 
                    <td class=title width=10% rowspan="2">&nbsp;</td>
                    <td class=title rowspan="2" width=18%>월대여요금</td>
                    <td class=title colspan="4">초기선납금</td>
                </tr>
                <tr> 
                    <td class=title width=18%>보증금</td>
                    <td class=title width=18%>선납금</td>
                    <td class=title width=18%>개시대여료</td>
                    <td class=title >계</td>
                </tr>
                <tr> 
                    <td class=title>공급가</td>
                    <td align="center"> <input type="text" name="fee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="pp_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="ifee_s_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>부가세<br> </td>
                    <td align="center"> <input type="text" name="fee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> -</td>
                    <td align="center"> <input type="text" name="pp_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="ifee_v_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class=title>계</td>
                    <td align="center"> <input type="text" name="t_fee_amt" value="<%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_gtr_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_pp_amt" value="<%=AddUtil.parseDecimal(e_bean.getPp_s_amt()+e_bean.getPp_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <input type="text" name="t_ifee_amt" value="<%=AddUtil.parseDecimal(e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td align="center"> <font color="#666666"> 
                      <input type="text" name="tot_p_amt" value="<%=AddUtil.parseDecimal(e_bean.getGtr_amt()+e_bean.getPp_s_amt()+e_bean.getPp_v_amt()+e_bean.getIfee_s_amt()+e_bean.getIfee_v_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </font></td>
                </tr>
                <tr> 
                    <td class=title colspan="2">월대여료 잔여 납입회수</td>
                    <td colspan="4">
                      &nbsp;<font color="#666666"><input type="text" name="tm" value="<%=AddUtil.parseInt(e_bean.getA_b())-e_bean.getG_10()%>" class=<%=white%>num size="2">
                      </font>회</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">보증보험가입금액 </td>
                    <td>&nbsp;<input type="text" name="gi_amt" value="<%=AddUtil.parseDecimal(e_bean.getGi_amt())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                    <td class=title>보증보험료</td>
                    <td colspan="2">&nbsp;<input type="text" name="gi_fee" value="<%=AddUtil.parseDecimal(e_bean.getGi_fee())%>" class=<%=white%>num size="12" onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원 </td>
                </tr>
                <tr> 
                    <td class=title colspan="2">중도해지위약금</td>
                    <td colspan="4">&nbsp;잔여기간 대여료총액의 
                      <input type="text" name="cls_per" value="<%=e_bean.getCls_per()%>" size="4" class=<%=white%>text>
                      %</td>
                </tr>				
            </table>
        </td>
    </tr>
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
    </tr>
    <tr> 
        <td align=center colspan="2"> 
          <a href="javascript:open_mail()" title='메일발송하기'><img src=/acar/images/center/button_send_mail.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;
    	    <a href="javascript:EstiView()" title='견적서보기'><img src=/acar/images/center/button_est_see.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp; 
    	    <%if(e_bean.getEst_st().equals("1")){%>
          <a href="javascript:EstiReReg();" title='재리스견적 다시 내기'><img src=/acar/images/center/button_again_gj.gif align=absmiddle border=0></a>
          <%}%>
        </td>
    </tr>    
    <tr> 
        <td align=right colspan="2">&nbsp; </td>
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
                    <td class=title width=20%>계약여부</td>
                    <td>&nbsp;<select name="bus_yn">
                        <option value="">선택</option>
                        <!--<option value="Y" <%if(e_bean.getBus_yn().equals("Y"))%>selected<%%>>계약</option>-->
                        <option value="N" <%if(e_bean.getBus_yn().equals("N"))%>selected<%%>>미계약</option>
                      </select></td>
                </tr>
                <tr> 
                    <td class=title width=20%>시장상황</td>
                    <td>&nbsp;<textarea name='bus_cau' rows='5' cols='100' maxlenght='500'><%=e_bean.getBus_cau()%></textarea></td>
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
		String url1 = "http://fms1.amazoncar.co.kr/acar/secondhand_hp/estimate_fms.jsp?est_id="+e_bean.getEst_id()+"&acar_id="+user_id+"&from_page=/acar/estimate_mng/esti_mng_u.jsp&content_st=sh_fms";
	%> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class=title>수신번호</td>
					<td>&nbsp;
						<select name="s_destphone" onchange="javascript:document.form1.est_m_tel.value=this.value;">
							<option value="" selected>선택</option>
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
	        				<%if (!e_bean.getEst_tel().equals("")) {%>
	        					<option value="<%=e_bean.getEst_tel()%>" selected>[상단 고객연락처] <%=e_bean.getEst_tel()%></option>
	        				<%}%>
        			  	</select>
        			  	&nbsp;&nbsp;
        			  	번호 : <input type="text" name="est_m_tel" value="<%=e_bean.getEst_tel()%>" size="20" class=text>
					</td>
				</tr>			
                <tr>
                  	<td width="10%" class=title>팩스/메일발송 알림톡</td>
                  	<td width="90%">&nbsp;
				  		<%-- <input type="text" name="sms_cont1" value="<%=e_bean.getEst_nm()%> 고객님께서 요청하신 견적서를" size="70" class=whitetext readOnly>
						<br>
						&nbsp;
						<select name='sms_cont2'>            
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
						
						<!-- &nbsp;<a href="javascript:esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a> -->				
				  	</td>
                </tr>
			</table>
		</td>
	</tr>
	<tr>
        <td colspan="2" align="right">
        	<a href="javascript:esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>
	<tr>                
		<td class=line colspan="2"> 
			<table border="0" cellspacing="1" width=100%>
                <tr>
                  	<td width="10%" class=title>
                  		<input type="checkbox" name="ch_mms_id" value="<%=e_bean.getEst_id()%>" checked>견적 알림톡
                  	</td>
                  	<td width="90%">&nbsp;
                  		<%
							String s_a_a = "";
							String s_rent_way = "";
							if (a_a.equals("1")) {
								s_a_a = "리스"; 
							} else {
								s_a_a = "장기렌트";
							}
							
							if (rent_way.equals("1")) {
								s_rent_way = "일반식(정비포함)"; 
							} else {
								s_rent_way = "기본식";
							}
							
							//조정대여료가 있다면
							if (e_bean.getCtr_s_amt() > 0) {
								e_bean.setFee_s_amt(e_bean.getCtr_s_amt());
								e_bean.setFee_v_amt(e_bean.getCtr_v_amt());
							}
                  		
							String msg = "";
							
							ArrayList<String> fieldList = new ArrayList<String>();
							
							fieldList.add("[재리스]"+car_no+" "+cm_bean2.getCar_nm());
							fieldList.add(AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt));
							
							if (!init_reg_dt.equals("") && init_reg_dt.length() == 8){
								fieldList.add(AddUtil.getDate3(init_reg_dt).substring(0,9) + "식 " +AddUtil.parseDecimal(e_bean.getToday_dist()) + "km " + s_a_a);
							} else {
								fieldList.add(AddUtil.parseDecimal(e_bean.getToday_dist()) + "km " + s_a_a);
							}
							//fieldList.add(c_db.getNameByIdCode("0009", "", e_bean.getA_a()));
							//fieldList.add(s_a_a);
							fieldList.add(s_rent_way);
							
							fieldList.add(e_bean.getA_b());
							
							fieldList.add(AddUtil.parseDecimal(e_bean.getGtr_amt()));
							fieldList.add(String.valueOf(e_bean.getRg_8()));						
							fieldList.add(AddUtil.parseDecimal(e_bean.getAgree_dist()));
							fieldList.add(AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt()));
							fieldList.add(ShortenUrlGoogle.getShortenUrl(url1));
							fieldList.add(u_nm);
							fieldList.add(u_mt);
							
							AlimTemplateBean templateBean = atp_db.selectTemplate("acar0223");
					    	String content = templateBean.getContent();
						  	for (String field : fieldList) {
					    		content = content.replaceFirst("\\#\\{.*?\\}", field);
					    	}
						  	
						  	msg = content;
                  		%>
					    <%-- <input type="text" name="wap_msg_body" readOnly value="고객님이 요청하신 견적안내. [재리스]<%=car_no%> <%=cm_bean2.getCar_nm()%> <%=AddUtil.parseDecimal(e_bean.getO_1()+dlv_car_amt)%>원 <%if(!init_reg_dt.equals("") && init_reg_dt.length() == 8){%><%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>식<%}%> <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km <%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%><%if(e_bean.getA_a().equals("11") || e_bean.getA_a().equals("21")){%>(정비포함)<%}%> <%=e_bean.getA_b()%>개월 보증금<%=e_bean.getRg_8()%>% <%=AddUtil.parseDecimal(e_bean.getFee_s_amt()+e_bean.getFee_v_amt())%>원 VAT포함(견적서 보기 : <%=ShortenUrlGoogle.getShortenUrl(url1) %>  ) 담당자는 <%=u_nm%> <%=u_mt%> 입니다. (주)아마존카" size="151" class=text> --%>
					    <textarea name='wap_msg_body' rows='5' cols='100' readOnly class="white_sizeFix over_auto"><%=msg%></textarea>
					    <input type="hidden" name="a_url" value="<%=ShortenUrlGoogle.getShortenUrl(url1)%>">                           
					    <input type="hidden" name="a_car_name" value="[재리스]<%=car_no%> <%=cm_bean2.getCar_nm()%>">
					    <input type="hidden" name="a_gubun1" value="<%if(!init_reg_dt.equals("") && init_reg_dt.length() == 8){%><%=AddUtil.getDate3(init_reg_dt).substring(0,9)%>식<%}%> <%= AddUtil.parseDecimal(e_bean.getToday_dist()) %>km <%=s_a_a%>">
					    <%-- <input type="hidden" name="a_gubun2" value="<%=c_db.getNameByIdCode("0009", "", e_bean.getA_a())%>"> --%>
	                  	<input type="hidden" name="a_gubun2" value="<%=s_rent_way%>">
					    
					    <!-- &nbsp;<a href="javascript:select_esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a> -->
				  	</td>
                </tr>	                 
            </table>
        </td>
    </tr>
    <tr>
        <td colspan="2" align="right">
        	<a href="javascript:select_esti_result_sms();" title='문자보내기'><img src=/acar/images/center/button_send_smsgo.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr>
        <td class="h" colspan="2"></td>
    </tr>	
    		
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>