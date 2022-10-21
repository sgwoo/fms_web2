<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*"%>
<%@ page import="acar.car_office.*, acar.user_mng.*, acar.cls.*, acar.con_tax.*, acar.insur.*, acar.fee.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ins" class="acar.insur.InsurBean" scope="page"/>
<jsp:useBean id="ai_db2" scope="page" class="acar.con_ins.AddInsurDatabase"/>
<jsp:useBean id="s_db" scope="page" class="acar.settle_acc.SettleDatabase"/>
<jsp:useBean id="em_bean" class="acar.estimate_mng.EstiCommVarBean" scope="page"/>
<jsp:useBean id="shDb" class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="ac_db" scope="page" class="acar.credit.AccuDatabase"/>
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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	if(rent_l_cd.equals("")) return;
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "01", "01", "11");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	EstiDatabase edb = EstiDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
	
	if(base.getUse_yn().equals("N"))	return;
	
	
	
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);

	//1. 고객 ---------------------------
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
	
	//지점정보
	ClientSiteBean site = al_db.getClientSite(base.getClient_id(), base.getR_site());
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
	
	EstiJgVarBean ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db2.getInsSt(base.getCar_mng_id());
		ins = ai_db.getInsCase(base.getCar_mng_id(), ins_st);
	}
	
	
	//3. 대여-----------------------------
	
	//대여료갯수조회(연장여부)
	int fee_size 			= af_db.getMaxRentSt(rent_mng_id, rent_l_cd);
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	ContFeeBean ext_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));

	//초과운행부담금
	ContCarBean f_fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
	
	Hashtable sh_ht = shDb.getShBase(base.getCar_mng_id());
	
	//만기매칭대차인 경우는 대차시작일부터 주행거리계산--
	String taecha_st_dt = "";
	taecha_st_dt = ac_db.getClsEtcTaeChaStartDt(rent_mng_id, rent_l_cd, base.getCar_mng_id() );	
	
	
	
	
	//gua_ins
	ContGiInsBean gins 	= a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));	
	
	Vector ht = af_db.getFeeScdCng(rent_l_cd, "", "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//운전자격검증결과
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
	
	
	//채권여부----------------------------------------
	
	Vector settles = s_db.getSettleList_20091001("", "", "", "", "", "", "9", rent_l_cd);
	int settle_size = settles.size();
	
	long amt[]   = new long[13];
	long settle_amt = 0;
	long r_settle_amt = 0;
	
	for (int i = 0 ; i < settle_size ; i++){
		Hashtable settle = (Hashtable)settles.elementAt(i);
		for(int j=0; j<9; j++){
			amt[j]  += AddUtil.parseLong(String.valueOf(settle.get("EST_AMT"+j)));
			if(j>0){
				settle_amt = settle_amt + amt[j];
			}
		}
		r_settle_amt = settle_amt-amt[6];
			
	}
	
	int car_amt = car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt();
	
	String a_a = "2";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	String var_seq = "";
	//공통변수
	if(a_a.equals("1")) var_seq = "92";
	if(a_a.equals("2")) var_seq = "93";
	em_bean = edb.getEstiCommVarCase(a_a, "");
		
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<style type-"text/css>
<!--	
input.whitetextredb		{ text-align:left; font-size : 9pt; background-color:#ffffff; border-color:##ffffff; border-width:0; color:#ff0000;  font-weight:bold;}
//-->
</style>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

	//고객 조회
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		

	//지점/현장 조회
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			
	
	//고객 보기
	function view_client(client_id)
	{
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+client_id, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 보기
	function view_site(client_id, site_id)
	{
		window.open("/fms2/client/client_site_i_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_cng_client_c.jsp&client_id="+client_id+"&site_id="+site_id, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			

	//관계자 조회
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//연대보증인
	function cng_input(){
		var fm = document.form1;		
		if(fm.guar_st[0].checked == true){ 				//가입
			tr_guar2.style.display	= '';
		}else{											//면제
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//대표이사보증
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ 		//가입
			tr_client_guar.style.display = 'none';		
		}else{											//면제
			tr_client_guar.style.display = '';				
		}
	}
	
	//공동임차인 운전면허검증
	function cng_input4(){
		if(document.form1.client_st.value == '2' && document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//가입
		}else{
			tr_client_share_st_test.style.display='none';//면제
		}
	}	

	//관계자 조회
	function search_gur(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//주소 조회
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//자동차등록정보 보기
	function view_car()
	{		
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	
	//대여요금
	function view_fee(rent_mng_id, rent_l_cd, rent_st)
	{		
		window.open("/fms2/lc_rent/view_fee.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&cmd=view", "VIEW_FEE", "left=100, top=100, width=850, height=650, scrollbars=yes");
	}		
	
	//변경된 해지일자로 다시 계산
	function set_day(){
		var fm = document.form1;	
		if(fm.cls_dt.value == ''){ 	alert('해지일자를 입력하십시오'); 	fm.cls_dt.focus(); 	return;	}
		if(!isDate(fm.cls_dt.value)){ fm.cls_dt.focus(); return;	}					
		fm.action='/acar/cls_con/cls_settle_nodisplay.jsp';		
		fm.target='i_no';
		fm.submit();
	}
	
	
	function save(){
		var fm = document.form1;

		if(fm.cls_dt.value == '')		{ alert('해지일자를 입력하십시오.');			return;}
		
		if(fm.r_mon.value.length > 3 || fm.r_day.value.length > 3){
			alert('이용기간-월 혹은 일이 3자리를 넘어갑니다. 확인하십시오.'); return;
		}
		
		var est_day1 = getRentTime('l', '<%=fee.getRent_start_dt()%>', fm.cls_dt.value);
		//해지일자 체크
		if(est_day1 < 0){ 
			alert('해지일자가  대여개시일보다 작습니다. 확인하십시오.');			return;
		}
		<%if(!cont_etc.getRent_suc_dt().equals("")){%>
		var est_day2 = getRentTime('l', '<%=cont_etc.getRent_suc_dt()%>', fm.cls_dt.value);
		//해지일자 체크
		if(est_day1>=0 && est_day2 < 0){ 
			alert('해지일자가  이전 승계일자보다 작습니다. 확인하십시오.');			return;
		}
		<%}%>
		

		
		
		if(fm.client_id.value == '')		{ alert('고객을 선택하십시오.'); 			return;}
		
		if(fm.client_id.value == fm.client_id_old.value)		{ alert('선택한 고객이 원계약고객입니다. 승계하는 고객을 선택하십시오.'); 			return;}
		
		<%if(!ck_acar_id.equals("000029")){%>
		
		//20150417 개인,개인사업자는 운전면허번호 필수
		if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){		
			
				if(fm.lic_no.value == '' && fm.mgr_lic_no.value == ''){
					alert('개인,개인사업자는 운전면허번호를 입력하십시오.');
					return;
				}
				if(fm.lic_no.value != '' && fm.lic_no.value.length < 12){
					alert('계약자 운전면허번호를 정확히 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_no.value.length < 12){
					alert('차량이용자 운전면허번호를 정확히 입력하십시오.');
					return;
				}			
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_emp.value == ''){
					alert('차량이용자 운전면허번호 이름을 입력하십시오.');
					return;
				}
				if(fm.mgr_lic_no.value != '' && fm.mgr_lic_rel.value == ''){
					alert('차량이용자 운전면허번호 관계를 입력하십시오.');
					return;
				}
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_emp5.value == ''){
			alert('추가운전자 운전면허번호 이름을 입력하십시오.');
			return;
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_rel5.value == ''){
			alert('추가운전자 운전면허번호 관계를 입력하십시오.');
			return;
		}
		if(fm.mgr_lic_no5.value != '' && fm.mgr_lic_result5.value != '1'){
			alert('추가운전자의 운전면허검증결과를 확인해주세요. 운전자격 없는 자에게 차량을 대여할 수 없습니다.');
			return;
		}
		
		//개인&개인사업자 운전자격검증
		if(fm.client_st.value == '2' || fm.client_st.value == '3' || fm.client_st.value == '4' || fm.client_st.value == '5'){	
			if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
				alert('운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
				return;
			}
			if(fm.test_lic_result.value != '1'){
				alert('운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
				return;
			}
		}
		//법인 운전자격검증
		if(fm.client_st.value == '1'){	
			if(fm.test_lic_emp.value == '' || fm.test_lic_rel.value == '' || fm.test_lic_result.value == ''){
				alert('운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
				return;
			}
			if(fm.test_lic_result.value != '1'){
				alert('운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
				return;
			}
		}
		//개인-공동임차인 있음
		if(fm.client_st.value == '2' && fm.client_share_st[0].checked == true){	
			if(fm.test_lic_emp2.value == '' || fm.test_lic_rel2.value == '' || fm.test_lic_result2.value == ''){
				alert('개인-공동임차인 운전면허정보검증 대상자정보 및 검증결과를 입력하십시오.');
				return;
			}
			if(fm.test_lic_result2.value != '1'){
				alert('개인-공동임차인 운전자격 없는 자에게 차량을 대여할 수 없습니다. 운전자격 검증결과를 확인해주세요.');
				return;
			}
		}

		if(fm.t_addr[0].value == '')		{ alert('우편물주소를 확인하십시오.'); 			return;}
		if(fm.guar_st[0].checked == true){
			if(fm.gur_nm[0].value == '')	{ alert('연대보증인 성명을 입력하십시오.'); 		return;}
			if(fm.gur_ssn[0].value == '')	{ alert('연대보증인 생년월일을 입력하십시오.'); 	return;}
			if(fm.t_addr[2].value == '')	{ alert('연대보증인 주소를 입력하십시오.'); 		return;}
			if(fm.gur_tel[0].value == '')	{ alert('연대보증인 연락처를 입력하십시오.'); 		return;}
			if(fm.gur_rel[0].value == '')	{ alert('연대보증인 관계를 입력하십시오.'); 		return;}												
		}
		if(fm.client_guar_st[1].checked == true){		
			if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')			{ alert('대표이사보증 면제조건을 선택하십시오.'); 	return;}			
			if(fm.guar_sac_id.options[fm.guar_sac_id.selectedIndex].value == '')		{ alert('대표이사보증 면제 결재자를 선택하십시오.'); 	return;}						
		}
		
		if(fm.est_area.value == '')		{ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
		if(fm.county.value == '')		{ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		if(fm.est_area.value == '시/도')	{ alert('차량이용지역(시/도)을 확인하십시오.'); 	return;}
		if(fm.county.value == '구/군')		{ alert('차량이용지역(구/군)을 확인하십시오.'); 	return;}
		
		if(fm.ext_agnt.value == '')				{ alert('계약담당자를 입력하십시오.'); 					fm.ext_agnt.focus(); 		return; }

		var rent_suc_commi 	= toInt(parseDigit(fm.rent_suc_commi.value));
		var rent_suc_commi_est 	= toInt(parseDigit(fm.rent_suc_commi_est.value));
		
		if(rent_suc_commi>0 && fm.rent_suc_commi_est_dt.value == '')				{ alert('승계수수료 입금예정일을 입력하십시오.');	return;}
		
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value == '')							{ alert('승계수수료 승계수수료감면사유를 입력하십시오.');	return;}
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value == '4' && fm.rent_suc_exem_cau_sub.value == '')		{ alert('승계수수료 승계수수료감면사유-기타인 경우 직접 입력하십시오.');	return;}
		if(rent_suc_commi_est>0 && rent_suc_commi < rent_suc_commi_est && fm.rent_suc_exem_cau.value !== '' && fm.rent_suc_exem_id.value == '')			{ alert('승계수수료 수수료감면 결재자를 입력하십시오.');	return;}
		
		if(fm.car_deli_dt.value == '')		{ alert('차량인도일를 입력하십시오.');				return;}				
		
		est_day1 = getRentTime('l', '<%=fee.getRent_start_dt()%>', fm.car_deli_dt.value);
		//차량인도일 체크
		if(est_day1 < 0){ 
			alert('차량인도일이  대여개시일보다 작습니다. 확인하십시오.');			return;
		}
		<%if(!cont_etc.getRent_suc_dt().equals("")){%>
		est_day2 = getRentTime('l', '<%=cont_etc.getRent_suc_dt()%>', fm.car_deli_dt.value);
		//해지일자 체크
		if(est_day1>=0 && est_day2 < 0){ 
			alert('차량인도일이  이전 승계일자보다 작습니다. 확인하십시오.');			return;
		}
		<%}%>
		
		var est_day3 = getRentTime('l', fm.rent_suc_dt.value, fm.rent_suc_commi_est_dt.value);
		//입금예정일 체크
		if(rent_suc_commi>0 && est_day3 < 0){ 
			fm.rent_suc_commi_est_dt.value = fm.rent_suc_dt.value;
		}		
		
		if(fm.rent_suc_route.value == '')	{ alert('비고-승계루트를 입력하십시오.');			return;}								
		
		<%if(ht_size>0){%>
		if(fm.fee_tm.value == '')		{ alert('스케줄 이관회차를 선택하십시오.'); 			return;}		
		
		fm.cng_fee_tm.value = fm.fee_tm.options[fm.fee_tm.selectedIndex].text;
		<%}%>
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=ext_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(<%=fee_size%>==1 && fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}		
		
		//임직원전용체크
		if(fm.client_st.value == '1' && <%=a_e%> > 101 && <%=a_e%> < 600 && <%=a_e%> != 409 ){	
			if(fm.com_emp_yn.value == '')					{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		}else if(toInt(fm.client_st.value) > 2 && <%=a_e%> > 101 && <%=a_e%> < 600 && <%=a_e%> != 409 ){	
			//개인사업자 업무전용차량 제한없음
			if(fm.com_emp_yn.value == '')					{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');		fm.com_emp_yn.focus(); 		return; }
		}else{
			if(fm.com_emp_yn.value == 'Y')				{ alert('보험사항-임직원운전한정특약 가입대상이 아닌데 가입으로 되어 있습니다. 확인하십시오.');	fm.com_emp_yn.focus(); 	return; }
		}
		
		//보증금 숭계관련
		var grt_amt = toInt(parseDigit(fm.grt_s_amt.value));
		
		if (grt_amt > 0 ) {
			if(fm.grt_suc_yn.value == '')			{ alert('보증금-승계여부를 선택하십시오.'); 			fm.grt_suc_yn.focus(); 		return; }
			//직전계약의 보증금이 없다면 별도 20180711
			//if(toInt(parseDigit(fm.o_grt_s_amt.value))==0)				{ fm.grt_suc_yn.value = '1'; }
			//직전계약의 보증금과 연장계약의 보증금이 같다면 승계 20180711
			//if(grt_amt == toInt(parseDigit(fm.o_grt_s_amt.value))){ fm.grt_suc_yn.value = '0'; }
		}else{
			if(fm.grt_suc_yn.value != '')			{ fm.grt_suc_yn.value = '' }
		}	
		
		//선납금 숭계관련
		var pp_amt = toInt(parseDigit(fm.pp_amt.value));
		
		if (pp_amt > 0 ) {
			if(fm.pp_suc_yn.value == '')			{ alert('선납금-승계여부를 선택하십시오.'); 			fm.pp_suc_yn.focus(); 		return; }
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));
		}else{
			if(fm.pp_suc_yn.value != '')			{ fm.pp_suc_yn.value = '' }
		}		
		
		//개시대여료 숭계관련
		var ifee_amt = toInt(parseDigit(fm.ifee_amt.value));
		
		if (ifee_amt > 0 ) {
			if(fm.ifee_suc_yn.value == '')			{ alert('개시대여료-승계여부를 선택하십시오.'); 			fm.ifee_suc_yn.focus(); 		return; }
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));
		}else{
			if(fm.ifee_suc_yn.value != '')			{ fm.ifee_suc_yn.value = '' }
		}				
		
   		if(fm.gi_st[0].checked == false && fm.gi_st[1].checked == false){	
   			alert('보증보험 가입여부를 선택하십시오.'); fm.gi_st[0].focus(); return; 
   		}		
		
		if(toInt(parseDigit(fm.grt_s_amt.value))+toInt(parseDigit(fm.pp_amt.value))+toInt(parseDigit(fm.ifee_amt.value))==0 && fm.gi_st[1].checked == true){
			if(!confirm('보증금,선납금이 없고 보증보험 면제로 되어 있습니다. 승계 등록을 진행하시겠습니까?')){	return;	}	
		}
		
		if(fm.dec_gr.value == '')			{ alert('적용신용등급을 선택하십시오.'); 			return;}
		if(fm.dec_f_dt.value == '')			{ alert('판정일자를 입력하십시오.'); 			return;}
		
		<%}%>
		
		if(confirm('등록하시겠습니까?')){		
		
			fm.commi_s_amt.value = sup_amt(toInt(parseDigit(fm.rent_suc_commi.value)));
			fm.commi_v_amt.value = toInt(parseDigit(fm.rent_suc_commi.value)) - toInt(fm.commi_s_amt.value);			
			fm.cms_bank_cd.value = fm.fee_bank.options[fm.fee_bank.selectedIndex].text;
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");

			fm.action='lc_cng_client_c_a.jsp';
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
			
			link.getAttribute('href',originFunc);
		}		
	}
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
	function getSucCommi()
	{
		var fm = document.form1;
		
		<%if(AddUtil.parseInt(AddUtil.getDate(4)) < 20170220){//20170220 이전 0.7*1.1%>
  	fm.rent_suc_commi.value = parseDecimal(<%=car_amt%>*0.7/100*1.1);
  	fm.rent_suc_commi_est.value = fm.rent_suc_commi.value;
  	<%}else{%>
  	fm.rent_suc_commi.value = parseDecimal(<%=car_amt%>*0.8/100);
  	fm.rent_suc_commi_est.value = fm.rent_suc_commi.value;
  	<%}%>
    
  	if(fm.rent_suc_exem_cau.value == '1'){
  		fm.rent_suc_commi.value = 0;
  	}else if(fm.rent_suc_exem_cau.value == '2'){
  		fm.rent_suc_commi.value = parseDecimal(toInt(parseDigit(fm.rent_suc_commi.value)) * 0.5);
  	}
 	}
	
	//보증보험료 자동계산
	function set_gi_amt(){
		var fm = document.form1;
		//var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
		//var oa_g 	= <%//=em_bean.getOa_g()%>/100;
		//var a_b 	= toInt(parseDigit(fm.gi_month.value));
		//var gi_fee 	= <%//=gi_fee%>;
		//fm.gi_fee.value = parseDecimal(gi_fee);	
	}
	
	//초과운행거리 상세보기	
	function view_over_agree(){
		var fm = document.form1;
		var SUBWIN="view_over_agree.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=ext_fee.getRent_st()%>&tot_dist=<%=sh_ht.get("TODAY_DIST")%>";
		window.open(SUBWIN, "ViewOverAgree", "left=50, top=50, width=850, height=700, scrollbars=yes, status=yes");
	}	
	
			
	//정비이력보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}	
		
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.cls_dt.value == ''){	alert('해지일을 입력하십시오.'); return;}
		if(fm.r_mon.value == ''){	alert('이용기간(개월)이 없습니다.'); return;}	
		if(fm.r_day.value == ''){	alert('이용기간(일)이 없습니다.'); return;}
		
		//미사용기간
		var n_mon = <%=ext_fee.getCon_mon()%>-toInt(fm.r_mon.value);
		var n_day = 0;
		if(toInt(fm.r_day.value) >0){
			n_mon = n_mon-1;
			n_day = 30-toInt(fm.r_day.value);
		}
		
		if(st == 'pp_amt'){
			var mon_amt	= toInt(parseDigit(fm.o_pp_amt.value))/<%=ext_fee.getCon_mon()%>;
			var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
			fm.pp_amt.value	= parseDecimal(amt);
		}

		if(st == 'ifee_amt'){
			//기간계산
			var ifee_cnt = <%=ext_fee.getPere_r_mth()%>;
			var r_mon = <%=ext_fee.getCon_mon()%>-ifee_cnt;
			var r_day = 0;
			//미사용분이 있다.
			if(n_mon < ifee_cnt){				
				var mon_amt	= toInt(parseDigit(fm.o_ifee_amt.value))/ifee_cnt;
				var amt 	= Math.round( (mon_amt*n_mon) + (mon_amt/30*n_day) );
				fm.ifee_amt.value = parseDecimal(amt);				
			}
		}
		
		fm.n_mon.value = n_mon;
		fm.n_day.value = n_day;
	}			
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
//-->
</script> 
<script language='javascript'>
<!--
     	var cnt = new Array();
     	cnt[0] = new Array('구/군');
     	cnt[1] = new Array('구/군','강남구','강동구','강북구','강서구','관악구','광진구','구로구','금천구','노원구','도봉구','동대문구','동작구','마포구','서대문구','서초구','성동구','성북구','송파구','양천구','영등포구','용산구','은평구','종로구','중구','중랑구');
     	cnt[2] = new Array('구/군','강서구','금정구','남구','동구','동래구','부산진구','북구','사상구','사하구','서구','수영구','연제구','영도구','중구','해운대구','기장군');
     	cnt[3] = new Array('구/군','남구','달서구','동구','북구','서구','수성구','중구','달성군');
     	cnt[4] = new Array('구/군','계양구','남구','남동구','동구','미추홀구','부평구','서구','연수구','중구','강화군','옹진군');
     	cnt[5] = new Array('구/군','광산구','남구','동구','북구','서구');
     	cnt[6] = new Array('구/군','대덕구','동구','서구','유성구','중구');
     	cnt[7] = new Array('구/군','남구','동구','북구','중구','울주군');
     	cnt[8] = new Array('구/군','세종특별자치시');
     	cnt[9] = new Array('구/군','고양시','과천시','광명시','구리시','군포시','남양주시','동두천시','부천시','성남시','수원시','시흥시','안산시','안양시','오산시','의왕시','의정부시','평택시','하남시','가평군','광주시','김포시','안성시','양주시','양평군','여주군','연천군','용인시','이천시','파주시','포천시','화성시');
     	cnt[10] = new Array('구/군','강릉시','동해시','삼척시','속초시','원주시','춘천시','태백시','고성군','양구군','양양군','영월군','인제군','정선군','철원군','평창군','홍천군','화천군','횡성군');
     	cnt[11] = new Array('구/군','제천시','청주시','충주시','괴산군','단양군','보은군','영동군','옥천군','음성군','진천군','청원군','증평군');
     	cnt[12] = new Array('구/군','공주시','보령시','서산시','아산시','천안시','금산군','논산군','당진군','부여군','서천군','연기군','예산군','청양군','태안군','홍성군');
     	cnt[13] = new Array('구/군','군산시','김제시','남원시','익산시','전주시','정읍시','고창군','무주군','부안군','순창군','완주군','임실군','장수군','진안군');
     	cnt[14] = new Array('구/군','광양시','나주시','목포시','순천시','여수시','여천시','강진군','고흥군','곡성군','구례군','담양군','무안군','보성군','신안군','여천군','영광군','영암군','완도군','장성군','장흥군','진도군','함평군','해남군','화순군');
     	cnt[15] = new Array('구/군','경산시','경주시','구미시','김천시','문경시','상주시','안동시','영주시','영천시','포항시','고령군','군위군','봉화군','성주군','영덕군','영양군','예천군','울릉군','울진군','의성군','청도군','청송군','칠곡군');
     	cnt[16] = new Array('구/군','거제시','김해시','마산시','밀양시','사천시','울산시','진주시','진해시','창원시','통영시','거창군','고성군','남해군','산청군','양산시','의령군','창녕군','하동군','함안군','함양군','합천군');
     	cnt[17] = new Array('구/군','서귀포시','제주시','남제주군','북제주군');

     	function county_change(add) {
     		var sel=document.form1.county
       		/* 옵션메뉴삭제 */
       		for (i=sel.length-1; i>=0; i--){
        		sel.options[i] = null
        	}
       		/* 옵션박스추가 */
       		for (i=0; i < cnt[add].length;i++){                     
        		sel.options[i] = new Option(cnt[add][i], cnt[add][i]);
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
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="m_id" 				value="<%=rent_mng_id%>">
  <input type='hidden' name="l_cd" 				value="<%=rent_l_cd%>">
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">  
  <input type='hidden' name="client_id_old"		value="<%=client.getClient_id()%>">    
  <input type='hidden' name="from_page" 	value="/fms2/lc_rent/lc_cng_client_frame.jsp">
  <input type='hidden' name="cng_fee_tm"  value="">
  <input type='hidden' name="cms_bank"    value="">
  <input type='hidden' name="cms_bank_cd"    value="">
  <input type='hidden' name="o_insur_per" value="<%=cont_etc.getInsur_per()%>">
  <input type='hidden' name="o_gi_st"     value="<%=gins.getGi_st()%>">
  <input type='hidden' name="o_gi_amt"     value="<%=gins.getGi_amt()%>">
  <input type="hidden" name="lkas_yn" id="lkas_yn" value="<%=cont_etc.getLkas_yn()%>"><!-- 차선이탈 제어형 -->
  <input type="hidden" name="ldws_yn" id="ldws_yn" value="<%=cont_etc.getLdws_yn()%>"><!-- 차선이탈 경고형 -->
  <input type="hidden" name="aeb_yn" id="aeb_yn" value="<%=cont_etc.getAeb_yn()%>"><!-- 긴급제동 제어형 -->
  <input type="hidden" name="fcw_yn" id="fcw_yn" value="<%=cont_etc.getFcw_yn()%>"><!-- 긴급제동 경고형 -->
  <input type="hidden" name="ev_yn" id="ev_yn" value="<%=cont_etc.getEv_yn()%>"><!-- 전기차 여부 -->
  <input type="hidden" name="hook_yn" id="hook_yn" value="<%=cont_etc.getHook_yn()%>"><!-- 견인고리 -->
  <input type='hidden' name="car_no"    value="<%=cr_bean.getCar_no()%>">  
  <input type='hidden' name="st"    value="">
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
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
                    <td>&nbsp;<%String rent_st = base.getRent_st();%><%if(rent_st.equals("1")){%>신규<%}else if(rent_st.equals("3")){%>대차<%}else if(rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
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
                    <td>&nbsp;<a href="javascript:view_client('<%=client.getClient_id()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=client.getFirm_nm()%></a></td>
                    <td class=title>대표자</td>
                    <td>&nbsp;<%=client.getClient_nm()%></td>
                    <td class=title>지점/현장</td>
                    <td>&nbsp;<a href="javascript:view_site('<%=client.getClient_id()%>','<%=base.getR_site()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=site.getR_site()%></a></td>
                </tr>
                <tr>
                    <td class=title>차량번호</td>
                    <td width=20%>&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a></td>
                    <td class=title width=10%>차명</td>
                    <td colspan="3" >&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%>&nbsp;<%=cm_bean.getCar_name()%>&nbsp;
        			<font color="#999999">(차종코드:<%=cm_bean.getJg_code()%>)</font>
        			</td>
                </tr>		  
            </table>
	    </td>
    </tr>
	<%if(!cont_etc.getRent_suc_dt().equals("")){%>
	<tr>
	    <td>&nbsp;* 계약승계일자 : <%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%></td>
	</tr>
	<%}else{%>
	<tr>
	    <td>&nbsp;</td>
	</tr>
	<%} %>
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td class=line>
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
                    <td style="font-size : 8pt;" align="center"><%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}else if(fees.getGrt_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>			
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%if(fees.getIfee_suc_yn().equals("0")){%>승계<%}else if(fees.getIfee_suc_yn().equals("1")){%>별도<%}else{%>-<%}%></td>
                    <td style="font-size : 8pt;" align="right"><%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>원&nbsp;</td>
                    <td style="font-size : 8pt;" align="center"><%=fees.getOpt_per()%></td>
                </tr>
    		  <%}}%>
            </table>
	    </td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>초과운행부담금</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <!--초과운행부담금 산출-->
                <tr>
                    <td class='title' width='13%'>연간약정운행거리</td>
                    <td width='15%'>&nbsp;
						<input type='text' name='o_agree_dist' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getAgree_dist())%>' class='whitenum' readonly>
					km이하/1년
					</td>
                    <td class='title' width='13%'>약정운행거리(한도)</td>
                    <td width='35%'>&nbsp;
						<input type='text' name='o_y_agree_dist' size='6' value='' class='whitenum' readonly>
					km (연장약정운행거리*대여일수<input type='text' name='o_rent_days' size='2' value='' class='whitenum' readonly>/365)
					</td>					
                    <td class='title' width='13%'>최초주행거리(보유차)</td>
                    <td width='11%'>&nbsp;
						<input type='text' name='o_over_bas_km' size='6' value='<%=AddUtil.parseDecimal(f_fee_etc.getOver_bas_km())%>' class='whitenum' readonly>
					km
					</td>
                </tr>
                <tr>
                    <td class='title'>초과운행거리 산출기준</td>
                    <td colspan='5'>&nbsp;
						<input type='text' name='o_b_agree_dist' size='6' value='' class='whitenum' readonly>
					km (약정운행거리(한도)+최초주행거리(보유차)+서비스마일리지(1000km))
					</td>
                </tr>                
                
                <tr>
                    <td class='title'>예상주행거리</td>
                    <td colspan='5'>&nbsp;                      
						<input type='text' name='o_sh_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TODAY_DIST")) %>' class='whitenum' readonly>
					km
					&nbsp;&nbsp; 
					(실견적은 아래의 "적용주행거리" 값 기준으로 계산됩니다.)
					</td>
                </tr>				
                
                <tr>
                    <td class='title'>초과운행거리</td>
                    <td colspan='5'>&nbsp;
						<input type='text' name='o_over_agree_dist' size='6' value='' class='whitenum' readonly>
					km &nbsp;&nbsp; 
					<input type='text' name='o_over_agree_dist_nm' size='6' value='' class='whitetextredb' readonly>
					&nbsp;&nbsp; 
					<input type="button" class="button" id="over_agree_pop" value='상세보기' onclick="javascript:view_over_agree();">
					&nbsp;&nbsp; 
					(예상주행거리-초과운행거리 산출기준(주행거리)
					</td>
                </tr>   
                <tr>
                    <td width="13%" class='title'> 최근주행거리 </td>
                    <td  colspan='5'>&nbsp;
        			  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal((String)sh_ht.get("TOT_DIST")) %>' class='whitenum' >
					km
					(
					기준일자 <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2((String)sh_ht.get("SERV_DT")) %>' class='whitetext' onBlur='javascript:this.value=ChangeDate(this.value);'>
					)
					
					  <span class="b"><a href="javascript:view_car_service('')" onMouseOver="window.status=''; return true" title="주행거리이력"><img src=/acar/images/center/button_in_jhir.gif align=absmiddle border=0></a></span>
					</td>
                </tr>			                
                                
            </table>
	    </td>
    </tr>
    <tr>
        <td>* 위 초과운행거리는 예상주행거리를 기준으로 계산한 참고값입니다.</td>
    </tr>			
	<tr>
	    <td class=h></td>
	</tr>	     	
	<%if(settle_size>0 && settle_amt>0 ){ //미납채권이 있으면%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>미납채권</span></td>
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title' rowspan='2'>구분</td>
                    <td class='title'>선수금</td>
                    <td class='title'>대여료</td>                    
                    <td class='title'>연체이자</td>					
                    <td class='title'>과태료</td>
                    <td class='title'>면책금</td>
                    <td class='title'>휴/대차료</td>
                    <td class='title'>해지정산금</td>
                    <td class='title'>단기요금</td>	
                </tr>
                <tr> 
                    <%	for(int j=1; j<9; j++){%>
                    <td align='right'><%=Util.parseDecimal(amt[j])%></td>
                    <%  } %>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <%if(settle_size>0 && r_settle_amt>0 && !user_id.equals("000029")){ //휴대차료를 제외한 미납채권이 있을때%>	
	<tr>
	    <td> * 휴대차료를 제외한 미납채권이 있습니다. 미납채권 해결후 승계등록하십시오. </td>
	</tr>    
</table>
</form>

	<%}else{%>
	<tr>
	    <td></td>
	</tr>
	<tr>
	    <td style='background-color:e5e5e5; height:1;'></td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약해지</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>		
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='13%' class='title'>해지구분</td>
                    <td width="20%">&nbsp;
        			  <input type='hidden' name="cls_st" value="5">
        			  계약승계 
        			  </td>
                    <td width='10%' class='title'>해지일</td>
                    <td width="20%">&nbsp;
        			  <input type='text' name='cls_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value); set_day();'> 
                    </td>
                    <td class='title' width="10%">이용기간</td>
                    <td>&nbsp;
        			  <input type='text' name='r_mon' value='' class='text' size="2">
                      개월 
                      <input type='text' name='r_day' value='' class='text' size="2">
                      일 </td>
                </tr>
                <tr> 
                    <td class='title'>해지내역 </td>
                    <td colspan="5">&nbsp;
        			  <textarea name="cls_cau" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약승계자</span></td>
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
                      <input type='text' name="firm_nm" size='50' class='text' readonly>
        			  <input type='hidden' name='client_id' value=''>
        			  <input type='hidden' name='client_st' value=''>
        			  <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                      <input type='text' name="client_nm" value='' size='22' class='whitetext' readonly></td>
                </tr>
                <tr>
                    <td class='title'>지점/현장</td>
                    <td height="26" colspan="3" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value=''>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			</td>
                </tr>
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
                <tr>
                    <td class='title'>우편물주소</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="">
                    </td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>	
                <tr>
                    <td class=title width=13%>차량이용지역</td>
                    <td  colspan="3">&nbsp;
								<select name='est_area' onchange="county_change(this.selectedIndex);">
								   <option value=''>시/도</option>
								   <option value='서울'>서울특별시</option>
								   <option value='부산'>부산광역시</option>
								   <option value='대구'>대구광역시</option>
								   <option value='인천'>인천광역시</option>
								   <option value='광주'>광주광역시</option>
								   <option value='대전'>대전광역시</option>
								   <option value='울산'>울산광역시</option>
								   <option value='세종'>세종특별자치시</option>
								   <option value='경기'>경기도</option>
								   <option value='강원'>강원도</option>
								   <option value='충북'>충청북도</option>
								   <option value='충남'>충청남도</option>
								   <option value='전북'>전라북도</option>
								   <option value='전남'>전라남도</option>
								   <option value='경북'>경상북도</option>
								   <option value='경남'>경상남도</option>
								   <option value='제주'>제주도</option>
								</select>&nbsp;
								<select name='county'>
								   <option value=''>구/군</option>
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
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>         
                <tr id=tr_lic_no1 style="display:''">
                    <td class='title'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="">
					</td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자의 운전면허번호를 기재</td>
                </tr>
                <tr id=tr_lic_no2 style="display:''">
                    <td class='title' width='13%'>차량이용자 운전면허번호</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;이름 : <input type='text' name='mgr_lic_emp' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'</td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='mgr_lic_rel' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(개인사업자)&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력</td>
                </tr>  
                <tr id=tr_lic_no3 style="display:''">
                    <td class='title'>추가운전자 운전면허번호</td>
		            <td>&nbsp;<input type='text' name='mgr_lic_no5' value=''  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;이름 : <input type='text' name='mgr_lic_emp5' value=''  size='10' class='text'></td>
		            <td>&nbsp;관계 : <input type='text' name='mgr_lic_rel5' value=''  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td>&nbsp;검증결과 : <select name='mgr_lic_result5'>
        		          		<option value=''>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;※ 계약서의 "운전자범위" 외의 운전자를 추가운전자로 허용하는 경우에는 추가운전자 운전가격을 검증</td>
                </tr>                
                <!-- 운전자격검증결과 -->
                <tr>
                    <td class='title' rowspan='2' width='13%'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
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
                    <td width="3%" rowspan="7" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">근무처</td>			
                    <td class=title width="10%">부서</td>
                    <td class=title width="10%">성명</td>
                    <td class=title width="10%">직위</td>
                    <td class=title width="13%">전화번호</td>
                    <td class=title width="13%">휴대폰</td>
                    <td width="16%" class=title>E-MAIL</td>
                    <td width="5%" class=title>조회</td>
                </tr>
    		  <%for(int i=0; i<=3; i++){%>
                <tr> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%if(i==0) out.println("차량이용자"); else if(i==1) out.println("차량관리자"); else if(i==2) out.println("회계관리자"); else if(i==3) out.println("계약담당자");%>' class='white' readonly ></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_email' size='18' class='text' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: inactive'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr> 
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
					<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.address;
								
							}
						}).open();
					}
				</script>
                    <td colspan="7">&nbsp;
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="65" value="<%=base.getP_addr()%>">
					</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_share_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' onClick="javascript:cng_input4()">
        				있다
        	      <input type='radio' name="client_share_st" value='2' onClick="javascript:cng_input4()">
        				없다</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:none"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                     
                <tr>
                    <td width='13%' class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp2' value=''  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel2' value=''  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value=''>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>'><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(개인)&nbsp;※ 개인고객의 공동임차인이 있는 경우 운전자격을 검증</td>
                </tr>  
            </table>  
        </td>
    </tr>           	    
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr id=tr_client_guar_st style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" checked>
        				입보
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()">
        				면제</td>
                </tr>
                <tr id=tr_client_guar style='display:none'>
                    <td class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
                          <option  value="">선택</option>
                          <option value="6">대표공동임차</option>
                          <option value="1">신용우수법인</option>
                          <option value="2">선수금으로대체</option>
                          <option value="3">보증보험으로대체</option>
                          <option value="5">전문경영인</option>
                          <option value="4">기타 결재획득</option>
                        </select>
                    </td>
                    <td width="10%" class='title'>결재자</td>
                    <td class='left'>&nbsp;
        			  <select name="guar_sac_id">
        			    <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인 (대표 외)</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증유무</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="guar_st" value='1' onClick="javascript:cng_input()">
        				입보
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:cng_input()" checked>
        				면제</td>
                </tr>
                <tr id=tr_guar2 style='display:none'>
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
                            <%for(int i=0; i<3; i++){%>
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value=''></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value=''>&nbsp;<input type='text' name="t_addr" size='25' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value=''></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객신용등급판정</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
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
                     <select name='dec_gr'>
                          <%if(base.getCar_gu().equals("1")){//신차%>
                          <option value="2" >초우량기업</option>
                          <option value="1" >우량기업</option>
                          <%}else if(base.getCar_gu().equals("0")){//재리스%>
                          <option value="1" >우량기업</option>
                          <option value="0" >일반고객</option>
                          <%}%>
                      </select>
                    </td>
                    <td align="center">
                        -
                     <input type="hidden" name="dec_f_id" value="">
                   </td>
                   <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                   <td align="center">
                        -                         
                     <input type="hidden" name="dec_l_id" value="">
                   </td>
                   <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value="" disabled ></td>
                </tr>
            </table>
        </td>
    </tr>	
	<tr>
        <td class=h></td>
    </tr>
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
                    <td width='13%' class='title'>계약승계일</td>
                    <td width='20%'>&nbsp;
        			  <input type='text' name='rent_suc_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
                    </td>
                    <td width='10%' class='title'>차량인도일</td>
                    <td>&nbsp;
        			  <input type='text' name='car_deli_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
		<tr>
                    <td class=title width=13%>승계시점 주행거리</td>
                    <td colspan='3'>&nbsp;
    			    	<input type='text' size='11' name='rent_suc_dist' maxlength='10' class='defaultnum' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  km
		    </td>					
		</tr>    		                  						
		<tr>
                    <td class=title width=13%>비고-승계루트</td>
                    <td colspan='3'>&nbsp;
    			    	<textarea name="rent_suc_route" cols="100" class="text" style="IME-MODE: active" rows="3"></textarea> 						
		    </td>					
		</tr>    		                  						
                <tr>
                    <td width='13%' class='title'>계약담당자</td>
                    <td width='20%'>&nbsp;
        			  <select name='ext_agnt'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                    </td>
                    <td width='10%' class='title'>영업대리인</td>
                    <td>&nbsp;
                    	<%if(acar_de.equals("1000")){%>
                    	<input type='hidden' name='bus_agnt_id' 		value=''>
                    	<%}else{%>
        			  <select name='bus_agnt_id'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>
                      <%}%>
                    </td>
                </tr>	
    		</table>
	    </td>
    </tr>
    <tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>승계수수료</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>승계수수료</td>
                    <td colspan='3'>&nbsp;
                        <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='defaultnum' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                        <input type='hidden' name='commi_s_amt' value='0'>
                        <input type='hidden' name='commi_v_amt' value='0'>	
                        <!--
                        <br>&nbsp;
                        <input type="checkbox" name="tax_req" value="Y" checked> 계산서 발행한다. <b><font color=red>(고객이 승계수수료 계산서 발행을 원할 경우 체크해주세요.)</font></b>
                        -->
                        <br>
                        <hr>
                        &nbsp;
                        * 정상승계수수료 : <input type='text' size='11' name='rent_suc_commi_est' maxlength='10' class='whitenum' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원
                        <%if(AddUtil.parseInt(AddUtil.getDate(4)) < 20170220){//20170220 이전 0.7*1.1%>
                        (신차소비자가 <%=AddUtil.parseDecimal(car_amt)%>원*0.7%*1.1, 부가세포함)                        
                        <%}else{%>                        
                        (신차소비자가 <%=AddUtil.parseDecimal(car_amt)%>원의 0.8%, 부가세포함)
                        <%}%> 
                    </td>
                </tr>
                <tr>
                    <td width='13%' class='title'>승계수수료 감면사유</td>
                    <td width='37%'>&nbsp;
                        <select name='rent_suc_exem_cau' onChange="javascript:getSucCommi();">
                            <option value="">선택</option>
                            <option value="1">법인 전환 (전액감면)</option>
                            <option value="2">이용자 동일 (50%감면)</option>
                            <option value="3">기존고객과 특수관계</option>
                            <option value="4">기타 (내용 직접 입력)</option>
                        </select>       
                        <input type='text' name='rent_suc_exem_cau_sub' size='30' class='text'>               
                    </td>
                    <td width='10%' class='title'>수수료감면 결재자</td>
                    <td width='40%'>&nbsp;
                      <select name='rent_suc_exem_id'>
                        <option value="">선택</option>
                        <%if(user_size > 0){
        					for(int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                        <%	}
        				}		%>
                      </select>        			  
                    </td>                
                </tr>                     
                <tr>
                    <td width='13%' class='title'>비용부담자</td>
                    <td colspan='3'>&nbsp;
        			  <input type="radio" name="rent_suc_commi_pay_st" value="1" >
        			    원계약자 (<%=client.getFirm_nm()%>)
        		      <input type="radio" name="rent_suc_commi_pay_st" value="2" checked>
        		    	계약승계자 
						&nbsp;&nbsp;
						<b><font color=red>(비용부담자 선택에 따라 승계수수료 스케줄이 관리됩니다.)</font></b>
                    </td> 
                </tr>						
                <tr>
                    <td class='title'>입금예정일</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' name='rent_suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
					  <b><font color=red>(승계수수료 입금예정일 - 기한 경과시 선수금 채권에 나타납니다.)</font></b>
                    </td>
                </tr>								
    		</table>
	    </td>
    </tr>    	 
    <tr>
	    <td class=h></td>
	</tr> 	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 스케줄 이관</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>이관회차</td>
                    <td>&nbsp;
        			  <%	if(ht_size > 0){%>
        						<select name='fee_tm'>
        						   <option value="">선택</option>
        					<%		for(int i = 0 ; i < ht_size ; i++){
        								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
        								if(i==0){
        									fee_scd = bean;
        								}
        								if(bean.getTm_st2().equals("4")) continue;			
        					%>
        							<option value='<%=bean.getFee_tm()%>'>[<%=AddUtil.addZero(bean.getFee_tm())%>회차] <%=AddUtil.ChangeDate2(bean.getFee_est_dt())%> <%if(bean.getRc_yn().equals("0")){%>미입금<%}else{%>입금<%}%></option>
        					<%		}%>
								  <option value="9999">이관회차없음</option>
        						</select> 회
                		      &nbsp;(선택회차부터 모든 회차 이관)
							  <!--
							  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;							  
							  <input type="checkbox" name="tax_cng_yn" value="Y" checked> 기발행 계산서가 있을 경우 승계하는 계약번호로 변경
							  -->
        					<%	}else{%>
        						선택가능한 회차가 없습니다.
        					<%	}%>	
        					
        		&nbsp;
        		/ 일자계산기준일자 : <input type='text' name='rent_suc_fee_tm_b_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>			
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	  
    <tr>
	    <td class=h></td>
	</tr> 		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>선수금 승계여부</span>&nbsp; (미사용기간 <input type='text' name='n_mon' value='' class='whitetext' size="2" readonly>
                      개월 
                      <input type='text' name='n_day' value='' class='whitetext' size="2" readonly>
                      일)</td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증금</td>
                    <td>&nbsp; 
					  금액 : <input type='text' size='11' maxlength='10' name='grt_s_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  원, 
					  승계여부 : 
        			  <select name='grt_suc_yn'>
                              <option value="">선택</option>
                              <option value="0">승계</option>
                              <option value="1">별도</option>
                            </select>	
							
					 &nbsp;(승계여부를 승계로 하면 기존 보증금 스케줄을 연동시키고, 별도를 선택하면 신규 스케줄이 생성됩니다.)
					 <input type='hidden' name="o_grt_s_amt" value="<%=AddUtil.parseDecimal(ext_fee.getGrt_amt_s())%>">
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>선납금</td>
                    <td>&nbsp; 
					  금액 : <input type='text' size='11' maxlength='10' name='pp_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  원, 
        				   승계여부 : 
        			  <select name='pp_suc_yn'>
                              <option value="">선택</option>
                              <option value="0">승계</option>
                              <option value="1">별도</option>
                            </select>	
                            &nbsp;&nbsp;
							<span class="b"><a href="javascript:set_reqamt('pp_amt')" onMouseOver="window.status=''; return true" title="선납금 계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
					 &nbsp;&nbsp;
					 &nbsp;(승계여부를 승계로 하면 기존 선납금 스케줄을 연동시키고, 별도를 선택하면 신규 스케줄이 생성됩니다.)
					 <input type='hidden' name="o_pp_amt" value="<%=AddUtil.parseDecimal(ext_fee.getPp_s_amt()+ext_fee.getPp_v_amt())%>">
					 <input type='hidden' name="pp_s_amt" value="">
					 <input type='hidden' name="pp_v_amt" value="">
                    </td>
                </tr>
    		</table>
	    </td>
    </tr>	
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>개시대여료</td>
                    <td>&nbsp; 
					  금액 : <input type='text' size='11' maxlength='10' name='ifee_amt' class='num' value='<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        				  원, 
        				 승계여부 : 
        			  <select name='ifee_suc_yn'>
                              <option value="">선택</option>
                              <option value="0">승계</option>
                              <option value="1">별도</option>
                            </select>	
                             &nbsp;&nbsp;
							 <span class="b"><a href="javascript:set_reqamt('ifee_amt')" onMouseOver="window.status=''; return true" title="선납금 계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        				  &nbsp;&nbsp;					  
					 &nbsp;(승계여부를 승계로 하면 기존 개시대여료 스케줄을 연동시키고, 별도를 선택하면 신규 스케줄이 생성됩니다.)
					 <input type='hidden' name="o_ifee_amt" value="<%=AddUtil.parseDecimal(ext_fee.getIfee_s_amt()+ext_fee.getIfee_v_amt())%>">
					 <input type='hidden' name="ifee_s_amt" value="">
					 <input type='hidden' name="ifee_v_amt" value="">
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
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="3%" rowspan="4" class='title'>대<br>여<br>료<br>납<br>입<br>방<br>법</td>				
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
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>카드</option>
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
        									}%>
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
    <tr> 
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
                      <select name='rec_st'>
                        <option value="">선택</option>					
                        <option value="1" <% if(cont_etc.getRec_st().equals("1")) out.print("selected"); %>>이메일</option>
                        <option value="2" <% if(cont_etc.getRec_st().equals("2")) out.print("selected"); %>>우편</option>
                        <option value="3" <% if(cont_etc.getRec_st().equals("3")) out.print("selected"); %>>수령안함</option>
                      </select>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                    <td>&nbsp;<%if(cont_etc.getEle_tax_st().equals("") && cont_etc.getRec_st().equals("1")) cont_etc.setEle_tax_st("1");%>
                      <select name='ele_tax_st'>
                        <option value="">선택</option>
                        <option value="1" <% if(cont_etc.getEle_tax_st().equals("1")) out.print("selected"); %>>당사시스템</option>
                        <option value="2" <% if(cont_etc.getEle_tax_st().equals("2")) out.print("selected"); %>>별도시스템</option>
                      </select>
                      <input type='text' name='tax_extra' maxlength='10' size='15' value='<%=cont_etc.getTax_extra()%>' class='text'>
        			</td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험사항</span></td>
	</tr>
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
                    <td width="15%">&nbsp;
                        <input type='text' name='conr_nm' value='<%=ins.getConr_nm()%>' size='30' class='whitetext'>
					</td>
                    <td width="10%" class=title >피보험자</td>
                    <td>&nbsp;
                        <input type='text' name='con_f_nm' value='<%=ins.getCon_f_nm()%>' size='30' class='whitetext'>
					</td>
                    <td width="10%" class=title >임직원운전한정특약</td>
                    <td width="15%">&nbsp;
                        <select name='i_com_emp_yn'>
                          <option value="">선택</option>
                          <option value="Y" <%if(ins.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                          <option value="N" <%if(ins.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>
					</td>
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
	<tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
              <tr> 
                    <td width="13%" class=title >보험계약자</td>
                    <td width="15%">&nbsp;
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select>					  
		    </td>			  
                    <td width="10%" class=title >피보험자</td>
                    <td>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(car_st.equals("3") && cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                        </select>
		       	<b><font color=red>(피보험자가 고객->아마존카, 아마존카->고객으로 변경될 경우 보험담당자에게 메시지 발송합니다.)</font></b>
		    </td>	
                <td width="10%" class=title >임직원운전한정특약</td>
                <td width="15%">&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y">가입</option>
                    <option value="N">미가입</option>
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
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="7">&nbsp;
                        <input type='radio' name="gi_st" value='1' >
                  		가입
                  		<input type='radio' name="gi_st" value='0' >
                  		면제 </td>
                </tr>                
                <tr>
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value=''>
        			   <input type='text' name='gi_jijum' value='' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                  	<!-- 보증보험 가입개월 추가(2018.03.16) -->
                  	<td class=title >가입기간</td>
                  	<td>&nbsp;	
                  		<input type='text' name='gi_month' size='5' maxlength='2' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt()'>
                  	개월</td>
                    <td class=title >보증보험료</td>
                    <td>&nbsp;
                        <input type='text' name='gi_fee' size='9' maxlength='20' class='whitenum' readonly value='' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  		원</td>
                </tr>	
            </table>
        </td>
    </tr>      		
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
    <tr>
		<td align="right"><a id="submitLink" href="javascript:save();" onMouseOver="window.status=''; return true"><img src=/acar/images/center/button_reg.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
</table>
</form>
<script language="JavaScript">
<!--	
	getSucCommi();
//-->
</script>
<%}%>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--		
	var fm = document.form1;
	
	//초과운행
	var fw_917 = getRentTime('l', '<%=fee.getRent_start_dt()%>', '<%=ext_fee.getRent_end_dt()%>');
	
	if ( '<%=taecha_st_dt%>'  != '' )  {
		fw_917 = getRentTime('l', '<%=taecha_st_dt%>', '<%=ext_fee.getRent_end_dt()%>');
	}
	
	fm.o_rent_days.value = fw_917;
	
	fm.o_y_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_agree_dist.value))*fw_917/365);
	
	fm.o_b_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_y_agree_dist.value))+toInt(parseDigit(fm.o_over_bas_km.value))+1000);
	
	fm.o_over_agree_dist.value = parseDecimal(toInt(parseDigit(fm.o_sh_km.value))-toInt(parseDigit(fm.o_b_agree_dist.value)));
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) <=0){
		fm.o_over_agree_dist_nm.value = '한도내';
	}
	if(toInt(parseDigit(fm.o_over_agree_dist.value)) >0){
		fm.o_over_agree_dist_nm.value = '한도초과';
	}	
	
	//일수 구하기
	function getRentTime(gubun, d1, d2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var t1;
		var t2;
		var t3;		
		t1 = getDateFromString(replaceString('-','',d1)).getTime();
		t2 = getDateFromString(replaceString('-','',d2)).getTime();
		t3 = t2 - t1;
		if(gubun=='m') return parseInt(t3/m);
		if(gubun=='l') return parseInt(t3/l);
		if(gubun=='lh') return parseInt(t3/lh);
		if(gubun=='lm') return parseInt(t3/lm);	
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}			
		
//-->
</script>
</body>
</html>	
