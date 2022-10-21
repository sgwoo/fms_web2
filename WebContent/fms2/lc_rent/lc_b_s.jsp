<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*, acar.im_email.*,acar.insur.*"%>
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
<jsp:useBean id="ac_db" class="acar.cost.CostDatabase" scope="page"/>
<jsp:useBean id="ae_db" class="acar.ext.AddExtDatabase" scope="page"/>
<jsp:useBean id="ImEmailDb" class="acar.im_email.ImEmailDatabase" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="oh_db" 	class="acar.off_ls_hpg.OfflshpgDatabase" 	scope="session"/>	
<%@ include file="/acar/cookies.jsp" %>
<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
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
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st = request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String now_stat = request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st = request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	if(rent_l_cd.equals("") || rent_l_cd.equals("null")) return;
		
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
	ContFeeBean max_fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
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
	ContEvalBean eval1 = new ContEvalBean();
	ContEvalBean eval2 = new ContEvalBean();
	ContEvalBean eval3 = new ContEvalBean();
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = new ContEvalBean();
	ContEvalBean eval6 = new ContEvalBean();
	ContEvalBean eval7 = new ContEvalBean();
	ContEvalBean eval8 = new ContEvalBean();
	//이행보증보험	
	ContGiInsBean max_gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(fee_size));
	
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
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	//사전계출계약
	CarOffPreBean cop_bean = cop_db.getCarOffPreCont(rent_l_cd);
	
	//특판계출관리
	Hashtable pur_com = cod.getPurComCont(rent_mng_id, rent_l_cd);
	
	//예약자리스트
	Vector cop_res_vt = cop_db.getCarOffPreSeqResUseList(String.valueOf(cop_bean.getSeq()));
	int cop_res_vt_size = cop_res_vt.size();
	
	//잔가변수NEW
	ej_bean = e_db.getEstiJgVarCase(cm_bean.getJg_code(), "");
		
	String a_e = ej_bean.getJg_a();
	if(a_e.equals("")) a_e = cm_bean.getS_st();
		
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
		
	
	
	//스캔파일 체크여부
	String scan_chk = "Y";
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&gubun5="+gubun5+"&st_dt="+st_dt+"&end_dt="+end_dt+"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page+"&now_stat="+now_stat+"&san_st="+san_st;
	String valus_t = valus;
	
	
	//영업효율
	Hashtable cost_cmp = ac_db.getSaleCostCampaignCase("1", rent_mng_id, rent_l_cd, rent_st);
	//출고전대차 영업효율
	Hashtable t_cost_cmp = ac_db.getSaleCostCampaignCase("9", rent_mng_id, rent_l_cd, "t");
	//월렌트 영업효율
	Hashtable rm_cost_cmp = ac_db.getSaleCostCampaignCase("14", rent_mng_id, rent_l_cd, "1");	
	
	
	int alink_count1 = ln_db.getALinkCnt("lc_rent_link",   rent_l_cd)+ln_db.getALinkCnt("lc_rent_link_m",   rent_l_cd);
	//장기전자계약서
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, rent_st);		
	
	Hashtable hp_2d = new Hashtable();
	String max_over_yn = "";
	String max_use_mon = "0";
	//재리스 신규계약
	if(base.getUse_yn().equals("") && base.getCar_gu().equals("0") && !base.getCar_mng_id().equals("") && cont_etc.getRent_suc_dt().equals("") && fee_size==1){
		//최근 홈페이지 적용대여료 약정주행거리 20000
		hp_2d = oh_db.getSecondhandCaseDist("", "", base.getCar_mng_id(), "20000");
		max_use_mon = hp_2d.get("MAX_USE_MON")+"";
		if(AddUtil.parseInt(fee.getCon_mon()) > AddUtil.parseInt((String)hp_2d.get("MAX_USE_MON")) ){
			max_over_yn = "Y";
		}
	}
	
	//고객연락처 점검
	int client_tel_cnt = 0;
	String client_tel_1 = "";
	String client_tel_2 = "";
	String client_tel_3 = "";
	String client_tel_4 = "";
	//사무실전화 확인 client_tel_cnt = 0
	if(!client.getO_tel().equals("") && client.getO_tel().length() > 6){
	 client_tel_cnt++;
	 client_tel_1 = AddUtil.replace(client.getO_tel(),"-","");
	}
	//휴대폰번호 확인 client_tel_cnt = 0 or 1
	if(!client.getM_tel().equals("") && client.getM_tel().length() > 9){
		if(client_tel_cnt == 0){
			client_tel_cnt++;
			client_tel_1 = AddUtil.replace(client.getM_tel(),"-","");
		}else{
			if(!client_tel_1.equals(AddUtil.replace(client.getM_tel(),"-",""))){
				client_tel_cnt++;
				client_tel_2 = AddUtil.replace(client.getM_tel(),"-","");
			}
		}
	}
	//자택번호 확인 client_tel_cnt = 0 or 1 or 2
	if(!client.getClient_st().equals("1")){
		if(!client.getH_tel().equals("") && client.getH_tel().length() > 6){
			if(client_tel_cnt == 0){
				client_tel_cnt++;
				client_tel_1 = AddUtil.replace(client.getH_tel(),"-","");
			}else if(client_tel_cnt == 1){
				if(!client_tel_1.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_2 = AddUtil.replace(client.getH_tel(),"-","");
				}
			}else{
				if(!client_tel_1.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_2 = AddUtil.replace(client.getH_tel(),"-","");
				}			
				if(!client_tel_3.equals(AddUtil.replace(client.getH_tel(),"-",""))){
					client_tel_cnt++;
					client_tel_3 = AddUtil.replace(client.getH_tel(),"-","");
				}
			}
		}
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
	
	function replaceFloatRound(per){return Math.round(per*1000)/10;}
	function replaceFloatRound2(per){return Math.round(per*10)/10;}
	//리스트
	function list(){
		var fm = document.form1;
		if(fm.from_page.value==''){fm.action='lc_b_frame.jsp';}
		else{fm.action=fm.from_page.value;}
		fm.target='d_content';
		fm.submit();
	}
	//고객 보기
	function view_client(){if('<%=base.getClient_id()%>'==''){alert("선택된 고객이 없습니다.");return;}window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>","CLIENT","left=10,top=10,width=1010,height=750,scrollbars=yes,status=yes,resizable=yes");}
	//지점/현장 보기
	function view_site(){if('<%=base.getR_site()%>'==''){alert("선택된 지점이 없습니다.");return;}window.open("/fms2/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id=<%=base.getClient_id()%>&site_id=<%=base.getR_site()%>","CLIENT_SITE","left=10,top=10,width=1010,height=500");}
	//자동차등록정보 보기
	function view_car(){window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=1010, height=750, scrollbars=yes");}		
	//차종내역 보기
	function view_car_nm(car_id, car_seq){window.open("/acar/car_mst/car_mst_u.jsp?from_page=lc_rent&car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=10, top=10, width=1010, height=750, scrollbars=yes");}
	//해당 차량 상위차종 기본사양 보기
	function open_car_b(car_id, car_seq, car_name){window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=10, top=10, width=1010, height=600, scrollbars=yes");}
	//차종수정
	function reset_car(){window.open('reset_car.jsp<%=valus%>&from_page2=/fms2/lc_rent/lc_b_s.jsp', "reset_car", "left=10, top=10, width=1200, height=600, scrollbars=yes");}
	//결재하기
	function sanction(){
		var fm = document.form1;
		<%if(!ck_acar_id.equals("000029")){%>
		if(toInt(fm.chk_cnt.value) > 0){ alert('입력값 체크 결과 확인이 필요한 항목이 '+toInt(fm.chk_cnt.value)+'건 발생했습니다.'); return; }
		<%}%>
		fm.idx.value = 'sanction';
		fm.action='lc_b_u_a.jsp';
		fm.target='i_no';
		fm.submit();
	}
	//결재요청하기
	function sanction_req(){
		var fm = document.form1;
		if(toInt(fm.chk_cnt.value) > 0){ alert('입력값 체크 결과 확인이 필요한 항목이 '+toInt(fm.chk_cnt.value)+'건 발생했습니다.'); return; }
		//연장인 경우 연장계약 영업효율 관련 정상요금 재계산 확인
		if(<%=fee_etc.getRent_st()%> > 1){//연장
			if(toInt(<%=fee_etc.getBc_s_a()%>) == 0){ alert('연장계약 영업효율과 관련하여 정상요금을 재계산하고 수정한 후 결재요청하십시오.'); return; }
		}

		fm.idx.value = 'sanction_req';
		if(confirm('결재요청하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//계약삭제 요청하기
	function sanction_req_delete(){
		var fm = document.form1;
		if(fm.sanction_req_delete_cont.value == ''){ alert('계약삭제 요청사유를 입력하십시오.'); return; }
		fm.idx.value = 'sanction_req_delete';
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
	//결재 취소하기
	function sanction_cancel(){
		var fm = document.form1;
		fm.idx.value = 'sanction_cancel';
		if(confirm('결재 취소하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	//거래치 기존스캔 동기화
	function scan_sys(){
		var fm = document.form1;
		fm.idx.value = 'scan_sys';
		if(confirm('스캔파일 동기화하시겠습니까?')){	
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	//전산팀 계약삭제하기
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		if(confirm('삭제하시겠습니까?')){ if(confirm('계약관련 모든 데이타를 삭제하게 됩니다. \n\n삭제하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}
	//전산팀 계약삭제하기
	function rent_stat_delete(){
		var fm = document.form1;
		fm.idx.value = 'step1_delete';
		if(confirm('미사용처리 하시겠습니까?')){ 
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}
	}
	//전산팀 연장계약삭제하기
	function rent_delete_ext(){
		var fm = document.form1;
		fm.idx.value = 'delete_ext';
		if(confirm('삭제하시겠습니까?')){ if(confirm('연장계약관련 데이타를 삭제하게 됩니다. \n\n삭제하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}	
	//전산팀 보유차생성
	function rent_delete_recar(){
		var fm = document.form1;
		fm.idx.value = 'delete_recar_reg';
		if(confirm('보유차생성하시겠습니까?')){ if(confirm('정말 보유차생성하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='d_content';
			fm.submit();
		}}
	}
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	//스캔등록
	function scan_reg(file_st){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&file_st="+file_st, "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	
	//스캔등록-일괄
	function scan_all_reg(){
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
		if(cnt == 0){ alert("일괄 등록할 스캔항목을 선택하세요."); return; }
		window.open('about:blank', "SCAN_ALL", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");
		fm.target = "SCAN_ALL";
		fm.action = "reg_scan_all.jsp";
		fm.submit();
	}	
	//전체선택
	function AllSelect(){
		var len = fm.elements.length;
		var cnt = 0;
		var idnum ="";
		for(var i=0; i<len; i++){
			var ck = fm.elements[i];
			if(ck.name == "ch_l_cd"){
				if(ck.checked == false){
					ck.click();
				}else{
					ck.click();
				}
			}
		}
	}	
	//마감보기
	function view_sale_cost_lw(){
		window.open("/fms2/mis/view_sale_cost_cont_lw.jsp<%=valus%>", "VIEW_SALE_COST_LW", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//마감보기
	function view_sale_cost_lw_base(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_base.jsp<%=valus%>", "VIEW_SALE_COST_LW_BASE", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//마감보기
	function view_sale_cost_lw_add(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=base.getRent_l_cd()%>&add_rent_st=t", "VIEW_SALE_COST_LW_ADD", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
	}
	//차종내역 보기
	function view_car_service(car_id){
		window.open("/acar/secondhand_hp/service_history.jsp?c_id=<%=base.getCar_mng_id()%>&from_page=/fms2/lc_rent/lc_b_s.jsp", "VIEW_CAR_SERV", "left=100, top=100, width=630, height=500, scrollbars=yes");		
	}
	function estimates_view(rent_st, reg_code){
		var SUBWIN="/acar/estimate_mng/esti_mng_i_a_3_result_20090901.jsp?car_gu=<%=base.getCar_gu()%>&rent_st="+rent_st+"&est_code="+reg_code+"&esti_table=estimate";
		window.open(SUBWIN, "ResultView", "left=100, top=100, width=<%=s_width%>, height=<%=s_height%>, scrollbars=yes, status=yes, resizable=yes");
	}
	//연장견적
	function add_rent_esti_s(){
		window.open("search_car_esti_s.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_ESTI_S", "left=0, top=0, width=1128, height=950, status=yes, scrollbars=yes");	
	}
	//메일수신하기
	function go_mail(content_st, rent_st){			
		var SUBWIN="mail_input.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st="+rent_st+"&content_st="+content_st;	
		window.open(SUBWIN, "openMail", "left=100, top=100, width=440, height=500, scrollbars=no, status=yes");
	}
	//변경이력관리항목 수정
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=10, top=10, width=1028, height=650, status=yes, scrollbars=yes");
		}
	}
	//중고차가
	function sh_car_amt(){
		window.open("search_sh_car_amt.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "CAR_AMT_S", "left=0, top=0, width=1028, height=550, status=yes, scrollbars=yes");	
	}
	//중도해지
	function view_cls(m_id, l_cd){
		window.open("/acar/cls_con/cls_i_tax.jsp?m_id="+m_id+"&l_cd="+l_cd, "CLS_I", "left=50, top=50, width=840, height=650, status=yes, scrollbars=yes");
	}	
	//중도해지정산  보기
	function view_settle(m_id, l_cd){
		window.open("/acar/cls_con/cls_settle.jsp?m_id="+m_id+"&l_cd="+l_cd+"&br_id=<%=br_id%>", "VIEW_SETTLE", "left=100, top=10, width=700, height=650, scrollbars=yes, status=yes");		
	}

	//계약승계내용보기
	function update_suc_commi(){
		window.open("/fms2/lc_rent/lc_b_u_suc_commi.jsp<%=valus%>", "UPDATE_SUC_COMMI", "left=0, top=0, width=1280, height=520, scrollbars=yes, status=yes, resizable=yes");
	}
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );
	}
	//차량 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	//만나이계산하기
	function age_search(){
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();
	}	
	//수정
	function update(st, rent_st){
		var fm = document.form1;	
		if(rent_st!=''){
			fm.fee_rent_st.value = rent_st;
		}
		var v_heigth = 250;
		if(st == '1' || st == '2' || st == '8' || st == '8_1' || st == '13' || st == '15'){
			v_heigth = 650;
		}else if(st == '3' || st == '7' || st == '14'){
			v_heigth = 350;
		}else if(st == '4' || st == '9' || st == '10'){
			v_heigth = 550;
		}else if(st == '12'){
			v_heigth = 750;
		}
		window.open("about:blank",'update_s','scrollbars=yes,status=yes,resizable=yes,width=1280,height='+v_heigth+',left=0,top=0');
		fm.action = "/fms2/lc_rent/lc_b_s_"+st+".jsp";
		fm.target = "update_s";
		fm.submit();
	}		
	//전자문서 전송하기
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=700, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();
	}
	
	//테스트 - 전자문서 전송하기2
	function go_edoc2(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK2", "left=0, top=0, width=900, height=800, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK2";
		fm.action = "reg_edoc_link2.jsp";
		fm.submit();
	}
	
	// bh.sim 임시 테스트용 start del
	function sanction_req_temp(){
		var fm = document.form1;
		//연장인 경우 연장계약 영업효율 관련 정상요금 재계산 확인
		if(<%=fee_etc.getRent_st()%> > 1){//연장
			if(toInt(<%=fee_etc.getBc_s_a()%>) == 0){ alert('연장계약 영업효율과 관련하여 정상요금을 재계산하고 수정한 후 결재요청하십시오.'); return; }
		}
		
		fm.idx.value = 'sanction_req';
		if(confirm('결재요청하시겠습니까?')){
			fm.action='lc_b_u_a.jsp';
			fm.target='i_no';
			fm.submit();
		}
	}
	// bh.sim 임시 테스트용 end
	
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
	
	//특약요청서 열기
	function reqdoc(rent_l_cd, rent_mng_id, rent_st){
		var url = 'lc_b_s_reqdoc.jsp?rent_l_cd='+rent_l_cd+'&rent_mng_id='+rent_mng_id+'&rent_st='+rent_st;
		window.open(url, "popupView", "left=0, top=0, width=1024, height=768, scrollbars=yes, status=yes, resizable=yes");		
		
	}
	
	//제조사 할인 후 차량가격표기 폼
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
	}
	
	function P_cont_copy(){
		var fm = document.form1;
		window.open('about:blank', "ContCopy", "left=0, top=0, width=600, height=400, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "ContCopy";
		fm.action = "reg_cont_copy.jsp";
		fm.submit();		
	}
	
	function search_test_lic(){
		var url = "http://211.174.180.104/fms2/car_api/car_api.jsp";
		window.open(url,"TESTLIC_POPUP", "left=0, top=0, width=850, height=850, scrollbars=yes");
	}
	
	//동일거래처 기존거래 보기
	function view_lc_rent(){
		var height = 400;
		window.open("view_rent_list.jsp?client_id=<%=base.getClient_id()%>", "VIEW_LC_RENT", "left=0, top=0, width=1150, height="+height+", scrollbars=yes");		
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
  <input type='hidden' name="auth_rw" value="<%=auth_rw%>">
  <input type='hidden' name="user_id" value="<%=user_id%>">
  <input type='hidden' name="br_id"   value="<%=br_id%>">
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='from_page'	 	value='<%=from_page%>'>
  <input type='hidden' name='from_page2'	 	value='/fms2/lc_rent/lc_b_s.jsp'>
  <input type='hidden' name="rent_mng_id" value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 	value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_st"			value="<%=rent_st%>">
  <input type='hidden' name="now_stat"		value="<%=now_stat%>">
  <input type='hidden' name="san_st"			value="<%=san_st%>">
  <input type='hidden' name="scan_cnt"			value="">
  <input type='hidden' name="chk_cnt"			value="">
  <input type='hidden' name="fee_rent_st"	value="<%=rent_st%>">
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">    
  <input type='hidden' name="idx"		value="">    
  <input type='hidden' name="client_id" 	value="<%=base.getClient_id()%>">
  <input type='hidden' name="firm_nm" 	value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="car_mng_id" 	value="<%=base.getCar_mng_id()%>">
  <input type='hidden' name="msg_st"		value="">
     
  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
      <td>
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
      <td align='right'><a href='javascript:list()' onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_list.gif align=absmiddle border=0></a></td>
    </tr>
    <%if(AddUtil.getDate(4).equals(base.getReg_dt()) && fee_size == 1 && base.getCar_gu().equals("1") && cont_etc.getRent_suc_dt().equals("")){ //신차계약 당일계약분 %>
    <%//if(user_id.equals("000029") && base.getCar_gu().equals("1")){ //신차계약 당일계약분 %>
    <tr>
      <td class=h></td>
    </tr>
    <tr>
      <td align='right'><input type="button" class="button" value="신차계약 동일고객,동일차종&트림,동일차가,동일계약조건 일때 계약 다중등록 처리" onclick="javascript:P_cont_copy();"></td>
    </tr>    
    <%} %>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
          <tr> 
            <td class=title width=13%>품의구분</td>
            <td width=20%>&nbsp;
              <%if(now_stat.equals("연장")){%>연장계약
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
              <%if(String.valueOf(alink_lc_rent.get("RENT_L_CD")).equals(rent_l_cd)){%>[전자계약서]<%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
	    <td>(등록일 : <%=AddUtil.ChangeDate2(base.getReg_dt())%>)</td>
	</tr>	
    <!--계약관리-->
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr> 
                    <td class=title width=13%>계약번호</td>
                    <td width=20%>&nbsp;<%=rent_l_cd%>&nbsp;(<%=rent_mng_id%>)</td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(base.getRent_dt())%></td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;<%String cont_rent_st = base.getRent_st();%><%if(cont_rent_st.equals("1")){%>신규<%}else if(cont_rent_st.equals("3")){%>대차<%}else if(cont_rent_st.equals("4")){%>증차<%}%>
                    	<%if(base.getRent_st().equals("4")||base.getRent_st().equals("3")){%>
                        &nbsp;
                        <a href="javascript:view_lc_rent()" title="이력"><img src=/acar/images/center/button_in_ir.gif align=absmiddle border=0></a>
                        <%}%>
                    </td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%></td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("5")){%>업무대여<%}%></td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = max_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id(), "USER")%></td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%></td>
                    <td class=title>예비배정자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getMng_id2(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>영업담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getBus_id2(), "USER")%></td>
                    <td class=title>관리담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getMng_id(), "USER")%></td>
                    <td class=title>차량인도일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%></td>
                </tr>
                <tr>
                    <td class=title>계약진행담당자</td>
                    <td>&nbsp;<%=c_db.getNameById(base.getAgent_emp_id(), "CAR_OFF_EMP")%>(에이전트계약)</td>
                    <td class=title>차량이용지역</td>
                    <td colspan='3'>&nbsp;<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                    	<input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
                    	<input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
                    	</td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td align="right"><%if(!san_st.equals("요청") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('0','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <!--계약승계-->
    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약승계</span>
        &nbsp;<%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_suc_commi()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
      </td>
    </tr>
    <tr>
      <td class=h></td>
    </tr>
    <%}%>
    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>변경전 원계약</span></td>
    </tr>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
      <td class=line>
        <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr> 
                    <td class=title width=13%>변경구분</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_ST")%> <%=begin.get("RENT_L_CD")%></td>
                    <td class=title width=10%>변경일자</td>
                    <td width=20%>&nbsp;<%=begin.get("CLS_DT")%></td>
                    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
                    <td class=title width=10%>고객</td>
                    <td>&nbsp;<%=begin.get("FIRM_NM")%>&nbsp;<%=begin.get("CLIENT_NM")%></td>
                    <%}else if(String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
                    <td class=title width=10%>자동차</td>
                    <td>&nbsp;<%=begin.get("CAR_NO")%>&nbsp;<%=begin.get("CAR_NM")%></td>
                    <%}%>
                </tr>
                <tr>
                  <td class=title>해지내역</td>
                  <td colspan="5">&nbsp;<%=begin.get("CLS_CAU")%></td>
                </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
    <%}%>
        
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
                    <td <%if(client.getClient_st().equals("2")){%>colspan='3'<%}%>>&nbsp;<%=client.getFirm_nm()%>
                    	(
                    	<%if(client.getClient_st().equals("2")){%>
                    	  <%=client.getSsn1()%>-<%=client.getSsn2().substring(0,1)%>
                    	<%}else{%>
                    	  <%=client.getEnp_no1()%>-<%=client.getEnp_no2()%>-<%=client.getEnp_no3()%>
                    	<%}%>
                    	)
                      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    </td>
                    <%if(!client.getClient_st().equals("2")){%>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;<%=client.getClient_nm()%></td>
                    <%}%>
                </tr>
                <tr>
                    <td class='title'>연락처</td>
                    <td colspan='3'>&nbsp;
                    	<%if(!client.getClient_st().equals("2")){%>
                    	회사전화 : <%=AddUtil.phoneFormat(client.getO_tel())%>, 대표자핸드폰 : <%=AddUtil.phoneFormat(client.getM_tel())%><%if(!client.getClient_st().equals("1")){%>, 자택전화 : <%=AddUtil.phoneFormat(client.getH_tel())%><%}%>
                    	<%}else{%>
                    	고객휴대폰 : <%=AddUtil.phoneFormat(client.getM_tel())%>, 자택전화 : <%=AddUtil.phoneFormat(client.getH_tel())%>, 직장전화 : <%=AddUtil.phoneFormat(client.getO_tel())%>
                    	<%}%>
                    </td>
                </tr>                
                <tr>
                    <td class='title'>지점/현장</td>
                    <td width='50%' height="26" class='left'>&nbsp;<%=site.getR_site()%>
                    	<%if(!site.getR_site().equals("")){%>
                    	  <%if(site.getSite_st().equals("1")){//지점%>
                    	    <%if(site.getEnp_no().length()==10){%>
                    	      (<%=AddUtil.ChangeEnt_no(site.getEnp_no())%>)
                    	    <%}else if(site.getEnp_no().length()==13){%>
                    	      (<%=site.getEnp_no().substring(0,6)%>-<%=site.getEnp_no().substring(7,1)%>)
                    	    <%}%>
                    	  <%}%>
                      <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
                    	<%}%>
                    </td>
                    <td width='10%' class='title'>개업년월일</td>
                    <td align='left'>&nbsp;<%=client.getOpen_year()%></td>
                </tr>
                <tr>
                    <td class='title'>우편물주소</td>
                    <td colspan=>&nbsp;<%=base.getP_zip()%>&nbsp;<%=base.getP_addr()%></td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;<%=base.getTax_agnt()%></td>
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
                <%		CarMgrBean mgr1 = new CarMgrBean();
                		CarMgrBean mgr5 = new CarMgrBean();
                		for(int i = 0 ; i < mgr_size ; i++){
        					CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
        					if(mgr.getMgr_st().equals("차량이용자")){
        						mgr1 = mgr;
        						if(!client.getClient_st().equals("2") && !mgr1.getMgr_m_tel().equals("") && mgr1.getMgr_m_tel().length() > 9){
	                        		//차량이용자 번호 client_tel_cnt = 0 or 1 or 2 or 3 : 최대 2개 까지만 체크하면 된다.
                   			  		if(client_tel_cnt == 0){
                  				  		client_tel_cnt++;
				                    	client_tel_1 = AddUtil.replace(mgr1.getMgr_m_tel(),"-","");
			                    	}else if(client_tel_cnt == 1){
				                    	if(!client_tel_1.equals(AddUtil.replace(mgr1.getMgr_m_tel(),"-",""))){
					                    	client_tel_cnt++;
					                    	client_tel_2 = AddUtil.replace(mgr1.getMgr_m_tel(),"-","");
				                    	}
		                      		}
		                    	}
        					}
        					if(mgr.getMgr_st().equals("추가운전자")){
                				mgr5 = mgr;
                			}
						}                       
                %>
                
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
                </tr>
    		  			<%
    		  				for(int i = 0 ; i < mgr_size ; i++){
    								CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);
    						%>
                <tr>
                    <td align='center'><%=mgr.getMgr_st()%></td>
                    <td align='center'><%=mgr.getCom_nm()%></td>
                    <td align='center'><%=mgr.getMgr_dept()%></td>
                    <td align='center'><%=mgr.getMgr_nm()%></td>
                    <td align='center'><%=mgr.getMgr_title()%></td>
                    <td align='center'><%=mgr.getMgr_tel()%></td>
                    <td align='center'><%=mgr.getMgr_m_tel()%></td>
                    <td align='center'><%=mgr.getMgr_email()%></td>
                </tr>
    		  			<%}%>
                <tr>
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
					          <td colspan=8>&nbsp;<%=mgr1.getMgr_zip()%>&nbsp;<%=mgr1.getMgr_addr()%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!base.getCar_st().equals("2") && (!san_st.equals("요청") || auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))) {%><a href="javascript:update('1','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
    <tr>
        <td class=h></td>
    </tr>
<%--     <%if(client.getClient_st().equals("1")){%> --%>
	  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td>
                    <td colspan="4" align='left'>&nbsp;<%if(cont_etc.getClient_share_st().equals("1")){%>있다<%}else{%>없다<%}%></td>
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
	  <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getClient_guar_st().equals("1")){%>입보<%}else if(cont_etc.getClient_guar_st().equals("2")){%>면제<%}%></td>
                </tr>
                <%if(cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <%if(cont_etc.getGuar_con().equals("1")){%>신용우수고객<%}%>
                      <%if(cont_etc.getGuar_con().equals("2")){%>선수금으로대체<%}%>
                      <%if(cont_etc.getGuar_con().equals("3")){%>보증보험으로대체<%}%>
                      <%if(cont_etc.getGuar_con().equals("4")){%>기타 결재획득<%}%>
                      <%if(cont_etc.getGuar_con().equals("5")){%>전문경영인<%}%>
                      <%if(cont_etc.getGuar_con().equals("6")){%>대표공동임차<%}%>
                    </td>
                    <td width="10%" class='title'>결재자</td>
                    <td class='left'>&nbsp;<%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%></td>
                </tr>
                <%}%>
            </table>  
        </td>
    </tr>
<%--     <%}%> --%>
    
    <%if(!base.getCar_st().equals("5")){%>    
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>연대보증인 <%if(client.getClient_st().equals("1")){%>(대표 외)<%}%></span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증유무</td>
                    <td colspan="3" align='left'>&nbsp;<%if(cont_etc.getGuar_st().equals("1")){%>가입<%}else if(cont_etc.getGuar_st().equals("2")){%>면제<%}%></td>
                </tr>
                <%if(cont_etc.getGuar_st().equals("1")){%>
                <tr>
                    <td height="26" colspan="4" class=line>
        			          <table border="0" cellspacing="1" cellpadding="0" width=100%>
                            <tr>
                                <td width="13%" class=title>구분</td>
                                <td width="15%" class=title>성명</td>
                                <td width="15%" class='title'>생년월일</td>
                                <td width="28%" class='title'>주소</td>
                                <td width="13%" class='title'>연락처</td>
                                <td width="16%" class='title'>관계</td>
                            </tr>
                            <%for(int i = 0 ; i < gur_size ; i++){
        					              Hashtable gur = (Hashtable)gurs.elementAt(i);%>	
                            <tr>
                                <td class=title>연대보증인</td>
                                <td align="center"><%=gur.get("GUR_NM")%></td>
                                <td align="center"><%=AddUtil.ChangeEnpH(String.valueOf(gur.get("GUR_SSN")))%></td>
                                <td align="center"><%=gur.get("GUR_ZIP")%>&nbsp;<%=gur.get("GUR_ADDR")%></td>
                                <td align="center"><%=gur.get("GUR_TEL")%></td>
                                <td align="center"><%=gur.get("GUR_REL")%></td>
                            </tr>
                            <%}%>
                        </table>
        			      </td>			
                </tr>
                <%}%>
            </table>  
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('2', '')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	</tr>	
	<tr>
	    <td class=h></td>
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
                    <td width=20%>&nbsp;<%=client.getJob()%></td>
                    <td class=title width=10%>소득구분</td>
                    <td colspan="3">&nbsp;
                    	<%if(client.getPay_st().equals("1")) out.println("급여소득");%>
                      <%if(client.getPay_st().equals("2")) out.println("사업소득");%>
                      <%if(client.getPay_st().equals("3")) out.println("기타사업소득");%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>직장명</td>
                    <td>&nbsp;<%=client.getCom_nm()%></td>
                    <td class=title width=10%>근속연수</td>
                    <td width=20%>&nbsp;<%=client.getWk_year()%>년</td>
                    <td class=title width=10%>연소득</td>
                    <td>&nbsp;<%=client.getPay_type()%>만원</td>
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
		            <td width="42%" class=title>당기(<%=c_fin.getC_kisu()%>기)</td>
		            <td width="43%" class=title>전기(<%=c_fin.getF_kisu()%>기)</td>
		        </tr>
		        <tr>
		            <td class='title'>(<%=c_fin.getC_ba_year_s()%>~<%=c_fin.getC_ba_year()%>)</td>
		            <td class='title'>(<%=c_fin.getF_ba_year_s()%>~<%=c_fin.getF_ba_year()%>)</td>
		              
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
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('3', '')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>신용등급</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr> 
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
        		    	//개인
        		  		if(client.getClient_st().equals("2")){
        		  			eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
        		    %>
                <tr>
                    <td class=title>계약자</td>
                    <td align="center"><%=eval3.getEval_nm()%></td>
                    <td align="center" >
                      <%if(eval3.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval3.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval3.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval3.getEval_score()%></td>
                    <td align="center">
                      <%if(eval3.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval3.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval3.getEval_gr().equals("없음") && !eval3.getEval_gr().equals("생략")){
	                      	if(eval3.getEval_off().equals("3")){
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
                      		<%=c_db.getNameByIdCode("0013","",eval3.getEval_gr())%><%=scope%>
	                      <%
	                      	} else{
	                      %>
	                      	<%=c_db.getNameByIdCode("0013","",eval3.getEval_gr())%>
	                      <%}
	                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%></td>
                </tr>
        		    <%
        		  			eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
        		    %>
                <tr>
                    <td class=title>계약자</td>
                    <td align="center"><%=eval5.getEval_nm()%></td>
                    <td align="center" >
                      <%if(eval5.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval5.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval5.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval5.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval5.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval5.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval5.getEval_gr().equals("없음") && !eval5.getEval_gr().equals("생략")){
                      	if(eval5.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval5.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval5.getEval_gr())%>
                      <%}
                      	}%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%></td>
                </tr>      
        		    <%
        		    	}else{
        		    		//법인
     		  					if(client.getClient_st().equals("1")){	
        		  				eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
        				%>
                <tr>
                    <td class=title>법인</td>
                    <td align="center"><%=eval1.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval1.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval1.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval1.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"></td>
                    <td align="center">
                    	<%if(eval1.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval1.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval1.getEval_gr().equals("없음") && !eval1.getEval_gr().equals("생략")){
                      	if(eval1.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval1.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval1.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%></td>
                </tr>
                <%	} %>
        		  	<%	//대표연대보증 면제가 아닌
        		  			if(!cont_etc.getClient_guar_st().equals("2")){
        		  				eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
        				%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
                    <td align="center"><%=eval2.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval2.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval2.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval2.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval2.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval2.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval2.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval2.getEval_gr().equals("없음") && !eval2.getEval_gr().equals("생략")){
                      	if(eval2.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval2.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval2.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%></td>
                </tr>
                
                <%	  
                			eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
        				%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
                    <td align="center"><%=eval6.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval6.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval6.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval6.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval6.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval6.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval6.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval6.getEval_gr().equals("없음") && !eval6.getEval_gr().equals("생략")){
                      	if(eval6.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval6.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval6.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%></td>
                </tr>
                                
        		  	<%	}%>
        		  
        		  	<%	//법인 대표자 공동임차인
        		  			if(!cont_etc.getClient_guar_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
        		  			
        		  				eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
        				%>
                <tr>
                    <td class=title>공동임차인</td>
                    <td align="center"><%=eval7.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval7.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval7.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval7.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval7.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval7.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval7.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval7.getEval_gr().equals("없음") && !eval7.getEval_gr().equals("생략")){
                      	if(eval7.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval7.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval7.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%></td>
                </tr>
        		  	<%	
        		  				eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
        				%>
                <tr>
                    <td class=title>공동임차인</td>
                    <td align="center"><%=eval8.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval8.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval8.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval8.getEval_off().equals("3")) out.println("KCB");%>
                    </td>
                    <td align="center"><%= eval8.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval8.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval8.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval8.getEval_gr().equals("없음") && !eval8.getEval_gr().equals("생략")){
                      	if(eval8.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval8.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>>
                      <%=c_db.getNameByIdCode("0013","",eval8.getEval_gr())%>
                      <%}
                      }%>
        			      </td>
					          <td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%></td>
                </tr>                
        		  	<%	}%>
        		          		  
        		  	<%}%>
        		  	
        		  	<%if(gur_size > 0){
        		  			for(int i = 0 ; i < gur_size ; i++){
        							Hashtable gur = (Hashtable)gurs.elementAt(i);
        							eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));
        				%>
                <tr>
                    <td class=title>연대보증인</td>
                    <td align="center"><%=eval4.getEval_nm()%></td>
                    <td align="center">
                      <%if(eval4.getEval_off().equals("1")) out.println("크레탑");%>
                      <%if(eval4.getEval_off().equals("2")) out.println("NICE");%>
                      <%if(eval4.getEval_off().equals("3")) out.println("KCB");%>                    	
                    </td>
                    <td align="center"><%= eval4.getEval_score()%></td>
                    <td align="center">
                    	<%if(eval4.getEval_gr().equals("없음")) out.println("없음");%>
                      <%if(eval4.getEval_gr().equals("생략")) out.println("생략");%>
                      <%if(!eval4.getEval_gr().equals("없음") && !eval4.getEval_gr().equals("생략")){
                      	if(eval4.getEval_off().equals("3")){
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
                      <%=c_db.getNameByIdCode("0013","",eval4.getEval_gr())%><%=scope%>
                      <%
                      	} else{
                      %>
                      <%=c_db.getNameByIdCode("0013","",eval4.getEval_gr())%>
                      <%}
                      }%>
        						</td>
										<td align="center">&nbsp;</td>
                    <td align="center"><%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%></td>
                </tr>
        		  	<%	}
        		  	  }
        		  	%>
            </table>
        </td>
    </tr>
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
        			      <td align="center"><%=c_db.getNameByIdCode("0014","",eval3.getAss1_type())%></td>
					          <td>&nbsp;<%=eval3.getAss1_zip()%>&nbsp;<%=eval3.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval3.getAss2_type())%></td>
					          <td>&nbsp;<%=eval3.getAss2_zip()%>&nbsp;<%=eval3.getAss2_addr()%></td>
                </tr> 
                <% }else{%>
                <% 		if(client.getClient_st().equals("1")){%>
                <tr>
                    <td class=title>법인</td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval1.getAss1_type())%></td>
					          <td>&nbsp;<%=eval1.getAss1_zip()%>&nbsp;<%=eval1.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval1.getAss2_type())%></td>
					          <td>&nbsp;<%=eval1.getAss2_zip()%>&nbsp;<%=eval1.getAss2_addr()%></td>
                </tr>
                <%		}%>
        		    <%		if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval2.getAss1_type())%></td>
					          <td>&nbsp;<%=eval2.getAss1_zip()%>&nbsp;<%=eval2.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval2.getAss2_type())%></td>
					          <td>&nbsp;<%=eval2.getAss2_zip()%>&nbsp;<%=eval2.getAss2_addr()%></td>
                </tr>
        		  	<% 		}%>

        		  	<%		
        		  		
        		  		if(!cont_etc.getClient_guar_st().equals("1") && cont_etc.getClient_share_st().equals("1")){
        		  	%>
                <tr>
                    <td class=title>공동임차인</td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval7.getAss1_type())%></td>
										<td colspan=>&nbsp;<%=eval7.getAss1_zip()%>&nbsp;<%=eval7.getAss1_addr()%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval7.getAss2_type())%></td>
					          <td colspan=>&nbsp;<%=eval7.getAss2_zip()%>&nbsp;<%=eval7.getAss2_addr()%></td>
                </tr>               
        		  	<% 		} %>

        		  	<% } %>
        		  	
        		  	<% if(gur_size > 0){
        		  				for(int i = 0 ; i < gur_size ; i++){
        								Hashtable gur = (Hashtable)gurs.elementAt(i);
        								eval4 = a_db.getContEval(rent_mng_id, rent_l_cd, "4", String.valueOf(gur.get("GUR_NM")));%>
                <tr>
                    <td class=title>연대보증인<%=i+1%></td>
                    <td align="center"><%=c_db.getNameByIdCode("0014","",eval4.getAss1_type())%></td>
					          <td colspan=>&nbsp;<%=eval4.getAss1_zip()%>&nbsp;<%=eval4.getAss1_addr()%></td>
        			      <td align="center"><%=c_db.getNameByIdCode("0014","",eval4.getAss2_type())%></td>
					          <td colspan=>&nbsp;<%=eval4.getAss2_zip()%>&nbsp;<%=eval4.getAss2_addr()%></td>
                </tr>
        		  	<%		}
        		  			}
        		  	%>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('4','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타참고사항</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
	<tr>
	    <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>기타</td>
                    <td>&nbsp;<%=cont_etc.getDec_etc()%></td>
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
                      <%if(cont_etc.getDec_gr().equals("3")){%>신설법인<%}%>
                      <%if(cont_etc.getDec_gr().equals("0")){%>일반고객<%}%>
                      <%if(cont_etc.getDec_gr().equals("1")){%>우량기업<%}%>
                      <%if(cont_etc.getDec_gr().equals("2")){%>초우량기업<%}%>
                    </td>
                    <td align="center"><%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%></td>
                    <td align="center"><%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('7','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
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
        		        <td width="20%">&nbsp;<a href='javascript:view_car()' onMouseOver="window.status=''; return true" title="클릭하세요"><%=cr_bean.getCar_no()%></a> (<%=cr_bean.getCar_mng_id()%>)</td>
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
                    <td>&nbsp;<%if(ej_bean.getJg_g_16().equals("1")){ %>[저공해]<%}%><a href="javascript:view_car_nm('<%=cm_bean.getCar_id()%>', '<%=cm_bean.getCar_seq()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=cm_bean.getCar_name()%></a></td>
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
                    <td class='title'>GPS위치추적정치</td>
                    <td colspan="5">&nbsp;<%if(cr_bean.getGps().equals("Y")){%>장착<%}else{%>미장착<%}%></td>
                </tr>
                <tr>
                    <td class='title'>옵션</td>
                    <td colspan="5">&nbsp;<%=car.getOpt()%></td>
                </tr>
                <tr>
                	<td class="title">연비</td>
                	<td colspan="5">&nbsp;<%=car.getConti_rat() %></td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
		  <td align="right"><a href="javascript:reset_car()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
		<tr>	
		<%}%>
		<tr></tr><tr></tr>
		<tr>
	    <td class=line2></td>
		</tr>		
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title'>색상</td>
                    <td colspan="5">&nbsp;<%=car.getColo()%>
					              &nbsp;&nbsp;&nbsp;
					              (내장색상(시트): <%=car.getIn_col()%>)  
					              &nbsp;&nbsp;&nbsp;
					              (가니쉬: <%=car.getGarnish_col()%>)  
        			      </td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>	
                <tr>
                    <td class='title'>전기차 고객주소지</td>
                    <td colspan="5">&nbsp;
                    	  <%=c_db.getNameByIdCode("0034", "", pur.getEcar_loc_st())%>
        			      </td>
                </tr>
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("4")){//수소차%>	
                <tr>
                    <td class='title'>수소차 고객주소지</td>
                    <td colspan="5">&nbsp;
                    	  <%=c_db.getNameByIdCode("0037", "", pur.getHcar_loc_st())%>
        			      </td>
                </tr>
                <%}%>                
          <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차-연료종류%>
          <!-- 
          <tr <%if ((ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")) && !car.getEco_e_tag().equals("1")) {%>style="display: none;"<%}%>>
            <td class='title'>맑은서울스티커 발급<br>(남산터널 이용 전자태그)</td>
            <td colspan="5">&nbsp;<%String eco_e_tag = car.getEco_e_tag(); if(eco_e_tag.equals("1")){%>발급<%}else{%>미발급<%}%>
            	&nbsp;※ 친환경차 고객 중 남산터널 실이용자만 발급 선택, 하이브리드/플러그인 하이브리드 차량의 경우 서울등록으로 대여료가 소폭 상승됨.
            </td>            
          </tr>
           -->
          <%}%>                
                <tr>
                    <td class='title'>차량인수지</td>
                    <td colspan="5">&nbsp;
        						    <%=c_db.getNameByIdCode("0035", "", pur.getUdt_st())%>        						    
        			          &nbsp; 인수시 탁송료 : <%=AddUtil.parseDecimal(pur.getCons_amt1())%>원 (고객인수일 때는 직접 입력하세요.)
        			  </td>
                </tr>
                <tr>
                    <td width='13%' class='title'>등록지역</td>
                    <td colspan="5">&nbsp;
                    	<%=c_db.getNameByIdCode("0032", "", car.getCar_ext())%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8_1','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%}%>
    <tr> 
        <td class='line'>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width='13%' class='title'>썬팅</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;<%=car.getSun_per()%>%</td>
                    <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %>
	                    <td width='13%' class='title'>블루링크여부</td>
	                    <td colspan="3">&nbsp;
	                        <%if(car.getBluelink_yn().equals("")){%><%}%>
	                        <%if(car.getBluelink_yn().equals("Y")){%>있음<%}%>
	                        <%if(car.getBluelink_yn().equals("N")){%>없음<%}%>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;※ 있음선택시 블루링크 가입 안내문 알림톡발송(스케줄생성시)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'><span class="title1">출고후추가장착</span></td>
                    <td colspan="5">&nbsp;<%=car.getAdd_opt()%>&nbsp;금액:<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적반영분,LPG키트제외,네비게이션등)</font></span></td>
                </tr>
                <tr>
                    <td class='title'><span class="title1">견적반영용품</span></td>
                    <td colspan="5">&nbsp;
                    	<%if(car.getTint_b_yn().equals("Y")){%>&nbsp;2채널 블랙박스<%}%>
						<%if(car.getTint_s_yn().equals("Y")){%>&nbsp;전면 썬팅(기본형)
						가시광선투과율 : <%=car.getTint_s_per()%>% 
						<%}%>
						<%if(car.getTint_ps_yn().equals("Y")){%>&nbsp;고급썬팅(전면포함)
						내용 <%=car.getTint_ps_nm()%>
						용품점 지급금액 <%=AddUtil.parseDecimal(car.getTint_ps_amt())%> 원 (부가세별도)
						<%}%>
                      <%if(car.getTint_n_yn().equals("Y")){%>&nbsp;거치형 내비게이션<%}%>
                      <%if(car.getTint_sn_yn().equals("Y")){%>&nbsp;전면 썬팅 미시공 할인<%}%>
                      <%if(car.getTint_bn_yn().equals("Y")){%>&nbsp;블랙박스 미제공 할인 (<%if(car.getTint_bn_nm().equals("1")){%>빌트인캠<%}else if(car.getTint_bn_nm().equals("2")){%>고객장착<%}else{%>빌트인캠,고객장착..<%}%>)<%}%>
					  <%if(car.getTint_cons_yn().equals("Y")){%>&nbsp;추가탁송료등
						&nbsp;<%=AddUtil.parseDecimal(car.getTint_cons_amt())%> 원
					  <%}%>
                      <%if(car.getTint_eb_yn().equals("Y")){%>&nbsp;이동형 충전기(전기차)<%}%>
                      <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>
                      	&nbsp;신형번호판
                      <%} else if(car.getNew_license_plate().equals("0")){%>
                      	&nbsp;구형번호판
                      <%} %>
                      <%-- <%if(car.getNew_license_plate().equals("1") || car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("1")){%>&nbsp;신형번호판신청(수도권)<%}%> --%>
<%--                       <%if(car.getNew_license_plate().equals("2")){%>&nbsp;신형번호판신청(대전/대구/광주/부산)<%}%> --%>
                    </td>
                </tr>   
                <tr>
                    <td class='title'><span class="title1">서비스품목</span></td>
                    <td colspan="5">&nbsp;<%=car.getExtra_set()%>&nbsp;금액:<%=AddUtil.parseDecimal(car.getExtra_amt())%>원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적미반영분)</font></span><br>
        					  <%if(car.getServ_b_yn().equals("Y")){%>블랙박스 (2015년8월1일부터)<%}%>
        					  <%if(ej_bean.getJg_g_7().equals("3")){%>
        					  	<%if(car.getServ_sc_yn().equals("Y")){%>고정형충전기<%}%>
        					  <%} %>	
                    </td>
                </tr>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;<%=car.getRemark()%></td>
                </tr>
                <%if(!cr_bean.getDist_cng().equals("")){%>
                <tr>
                  <td class='title'>계기판교체</td>
                  <td colspan="5">&nbsp;<font color=green><%=cr_bean.getDist_cng()%></font></td>
                </tr>                
                <%}%>

            </table>
        </td>
    </tr>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>    
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('8','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%}%>
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
		</tr>
		<tr>
	    <td class=line2></td>
		</tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>과세구분</td>
                    <td colspan="3">&nbsp;
                        <%if(car.getPurc_gu().equals("1")){%> 과세 <%}%>
                        <%if(car.getPurc_gu().equals("0")){%> 면세 <%}%>
                    </td>
                    <td class='title'>출처</td>
                    <td colspan="3">&nbsp;
                        <%if(car.getCar_origin().equals("1")){%> 국산 <%}%>
                        <%if(car.getCar_origin().equals("2")){%> 수입 <%}%>
                    </td>
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
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='whitenum' >
             			원</td>
                    <td class=title>차량가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='whitenum'>
             			원</td>
                </tr>
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='whitenum'  >
             			원</td>
                    <td class=title>탁송료</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='whitenum' >
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='whitenum' >
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='whitenum'  >
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='whitenum' >
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='whitenum'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='whitenum'  >
             			원</td>
                    <td class=title>매출D/C</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' maxlength='10' class='whitenum' >
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' maxlength='10' class='whitenum' >
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' maxlength='10' class='whitenum'  >
        				원</td>
                </tr>
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'>개소세 감면액</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='whitenum' >
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum' >
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='whitenum'  >
         			원</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr> 
                <tr>
                    <td align="center" class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cs_amt' size='10' value='' class='whitenum' >
        			    원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_cv_amt' size='10' value='' class='whitenum' >
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_c_amt' size='10' value='' class='whitenum'  >
        				원</td>
                    <td align='center' class='title_p'>합계</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fs_amt' size='10' value='' class='whitenum' >
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_fv_amt' size='10' value='' class='whitenum' >
        				원</td>
                    <td class='title_p' style='text-align:left'>&nbsp;
                      <input type='text' name='tot_f_amt' size='10' value='' class='whitenum'  >
        				원</td>
                </tr>
                <tr>
                    <td class='title'>납부여부</td>
                    <td>&nbsp;
                        <%if(car.getPay_st().equals("1")){%> 과세 <%}%>
                        <%if(car.getPay_st().equals("2")){%> 면세 <%}%>
                    </td>
                    <td class='title'>특소세</td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='whitenum' >
        				원</td>
                    <td class='title'>교육세</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='whitenum' >
        				원</td>
                    <td class='title'>합계</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='whitenum' >
        				원</td>
                </tr>
            </table>		
	    </td>
    </tr>
    <!-- 제조사 할인 후 차량가격 표시(20190911)- 신차이고 신규계약인 경우만 -->
    <%if(base.getCar_gu().equals("1") && fee_size<=1){ %>
    <tr>
  		<td>
  			<font color="#666666">* 전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">제조사 할인 후 차량가격 :  
  					<%=AddUtil.parseDecimal(String.valueOf(cont_etc.getView_car_dc()))%> 원
  				</font>
  			</span>
  		</td>
  	</tr>
  	<%}%>
    <%if(ej_bean.getJg_w().equals("1")){//수입차%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>수입차 견적시 적용</span></td>
    </tr>    
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>카드결제금액</td>
                    <td width="27%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_card_amt())%>원
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_cash_back())%>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>원
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
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>원
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
                    <td width="27%">&nbsp;<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>원
                    </td>
                    <td width="10%" class='title'>보조금수령방식</td>
                    <td>&nbsp;
                          <%if(car.getEcar_pur_sub_st().equals("1")){%> 제조사 차량대금 공제 <%}%>
                          <%if(car.getEcar_pur_sub_st().equals("2")){%> 아마존카 직접 수령 <%}%>
        	          </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%}%>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
	  <tr>
	    <td align="right"></td>
	  <tr>	    
    <%}else{%>
	  <tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><%if( base.getRent_start_dt().equals("") || nm_db.getWorkAuthUser("전산팀",user_id)||nm_db.getWorkAuthUser("계약변경관리",user_id)||nm_db.getWorkAuthUser("엑셀견적관리자",user_id)||nm_db.getWorkAuthUser("수입차출고담당",user_id)||nm_db.getWorkAuthUser("수입차출고담당2",user_id)||nm_db.getWorkAuthUser("수입차출고담당3",user_id)) {%><a href="javascript:update('9','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%><%}%></td>
	  <tr>	
		<%}%>
    <%if(!base.getCar_gu().equals("1") || fee_size > 1){%>
    <%	for(int f=1; f<=fee_size; f++){
					ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
					
					if(base.getCar_gu().equals("1") && f==1) continue;
		%>	    
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>차 연장 <%}%>중고차가</span></td>
    </tr>
		<tr>
	    <td class=line2></td>
		</tr>		
    <tr>
        <td class=line> 			  
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='13%' class='title'> 신차소비자가 </td>
                    <td width="20%">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getSh_car_amt())%></td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="10%">&nbsp;<%= AddUtil.parseFloatCipher(fee_etcs.getSh_ja(),2) %>%</td>
                    <td class='title' width='10%'>중고차가</td>
                    <td width="37%">&nbsp;<%= AddUtil.parseDecimal(fee_etcs.getSh_amt()) %>원</td>
                </tr>
                <tr>
                  <td class='title'>차령</td>
                  <td colspan="5">&nbsp;<%=fee_etcs.getSh_year()%>년<%=fee_etcs.getSh_month()%>개월<%=fee_etcs.getSh_day()%>일 (최초등록일<%=AddUtil.ChangeDate2(fee_etcs.getSh_init_reg_dt())%>~계약일<%=AddUtil.ChangeDate2(fee_etcs.getSh_day_bas_dt())%>)</td>
                </tr>
                <tr>
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;<%= AddUtil.parseDecimal(fee_etcs.getSh_km()) %>km 
                  	( <%if(f==1){%>계약일 <%}else{%> 대여개시일<%}%><%=AddUtil.ChangeDate2(fee_etcs.getSh_day_bas_dt())%> )
					            / 확인주행거리 <%= AddUtil.parseDecimal(fee_etcs.getSh_tot_km()) %>km 
					            ( 최종확인일 <%= AddUtil.ChangeDate2(fee_etcs.getSh_km_bas_dt()) %> )
					        </td>
                </tr>
            </table>
	    </td>
    </tr>
    <%	}%>
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('9_2','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
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
                          <%if(ins.getConr_nm().equals("아마존카")){%> 아마존카 <%}%>
                          <%if(!ins.getConr_nm().equals("아마존카")){%> 고객 <%}%>
                    </td>
                    <td width="10%" class=title >피보험자</td>
                    <td>&nbsp;
                          <%if(ins.getCon_f_nm().equals("아마존카")){%> 아마존카 <%}%>
                          <%if(!ins.getCon_f_nm().equals("아마존카")){%> 고객 <%}%>
                    </td>
                    <td width="10%" class=title >임직원운전한정특약</td>
                    <td>&nbsp;
                          <%if(ins.getCom_emp_yn().equals("Y")){%> 가입 <%}%>
                          <%if(ins.getCom_emp_yn().equals("N")){%> 미가입 <%}%>
                    </td>
                </tr>                  
                <tr>
                    <td width="13%" class=title >운전자연령</td>
                    <td width="20%">&nbsp;
                            <%if(ins.getAge_scp().equals("1")){%>21세이상<%}%>
                            <%if(ins.getAge_scp().equals("4")){%>24세이상<%}%>
                            <%if(ins.getAge_scp().equals("2")){%>26세이상<%}%>
                            <%if(ins.getAge_scp().equals("3")){%>전연령<%}%>
                            <%if(ins.getAge_scp().equals("5")){%>30세이상<%}%>
                            <%if(ins.getAge_scp().equals("6")){%>35세이상<%}%>
                            <%if(ins.getAge_scp().equals("7")){%>43세이상<%}%>
						                <%if(ins.getAge_scp().equals("8")){%>48세이상<%}%>
						                <%if(ins.getAge_scp().equals("9")){%>22세이상<%}%>
						                <%if(ins.getAge_scp().equals("10")){%>28세이상<%}%>
						                <%if(ins.getAge_scp().equals("11")){%>35세이상~49세이하<%}%>
                    </td>
                    <td width="10%" class=title >대물배상</td>
                    <td width="15%">&nbsp;
                            <%if(ins.getVins_gcp_kd().equals("9")){%>10억원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("6")){%>5억원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("8")){%>3억원<%}%>
			                      <%if(ins.getVins_gcp_kd().equals("7")){%>2억원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("3")){%>1억원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("4")){%>5000만원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("1")){%>3000만원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("2")){%>1500만원<%}%>
                            <%if(ins.getVins_gcp_kd().equals("5")){%>1000만원<%}%>
                    </td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td>&nbsp;
                            <%if(ins.getVins_bacdt_kd().equals("1")){%>3억원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("2")){%>1억5천만원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("6")){%>1억원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("5")){%>5000만원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("3")){%>3000만원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("4")){%>1500만원<%}%>
                            <%if(ins.getVins_bacdt_kd().equals("9")){%>미가입<%}%>
                    </td>
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
                          <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> 아마존카 <%}%>
                          <%if(cont_etc.getInsurant().equals("2")){%> 고객 <%}%>
                    </td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='3'>&nbsp;
                          <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> 아마존카 <%}%>
                          <%if(cont_etc.getInsur_per().equals("2")){%> 고객 <%}%>
                    </td>
                </tr>            
                <tr> 
                    <td width="13%" class=title>운전자범위</td>
                    <td width="20%" class=''>&nbsp;
        			            <%if(base.getDriving_ext().equals("1")){%> 모든사람 <%}%>
                          <%if(base.getDriving_ext().equals("2")){%> 가족한정 <%}%>
                          <%if(base.getDriving_ext().equals("3")){%> 기타 <%}%>
                      
        			</td>
                    <td width="10%" class=title >운전자연령</td>
                    <td>&nbsp;
                          <%if(base.getDriving_age().equals("0")){%> 26세이상 <%}%>
                          <%if(base.getDriving_age().equals("3")){%> 24세이상 <%}%>
                          <%if(base.getDriving_age().equals("1")){%> 21세이상 <%}%>
                          <%if(base.getDriving_age().equals("2")){%> 모든운전자 <%}%>
                          <%if(base.getDriving_age().equals("5")){%>30세이상<%}%>
                          <%if(base.getDriving_age().equals("6")){%>35세이상<%}%>
                          <%if(base.getDriving_age().equals("7")){%>43세이상<%}%>
					                <%if(base.getDriving_age().equals("8")){%>48세이상<%}%>
					                <%if(base.getDriving_age().equals("9")){%>22세이상<%}%>
					                <%if(base.getDriving_age().equals("10")){%>28세이상<%}%>
					                <%if(base.getDriving_age().equals("11")){%>35세이상~49세이하<%}%>
                          &nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
                    </td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
                    <%if(cont_etc.getCom_emp_yn().equals("Y")){%> 가입 <%}%>
                    <%if(cont_etc.getCom_emp_yn().equals("N")){%> 미가입 <%}%>
                    <%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
                      <%if(!cont_etc.getCom_emp_sac_id().equals("")){%>
                      [승인]<%=c_db.getNameById(cont_etc.getCom_emp_sac_id(),"USER")%>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCom_emp_sac_dt())%>
                      <%}%>
                    <%}%>
                </td>                        
                </tr>
                <tr>
                    <td class=title>대인배상</td>
                    <td>&nbsp; 무한(대인배상Ⅰ,Ⅱ)</td>
                    <td class=title>대물배상</td>
                    <td class=''>&nbsp;
                          <% if(base.getGcp_kd().equals("1")) out.print("5천만원"); %>
                          <% if(base.getGcp_kd().equals("2")) out.print("1억원"); %>
						              <% if(base.getGcp_kd().equals("4")) out.print("2억원"); %>
						              <% if(base.getGcp_kd().equals("8")) out.print("3억원"); %>
                          <% if(base.getGcp_kd().equals("3")) out.print("5억원"); %>
                          <% if(base.getGcp_kd().equals("9")) out.print("10억원"); %>
                    </td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td class=''>&nbsp;
                          <% if(base.getBacdt_kd().equals("1")) out.print("5천만원"); %>
                          <% if(base.getBacdt_kd().equals("2")) out.print("1억원"); %>
                          <% if(base.getBacdt_kd().equals("9")) out.print("미가입"); %>
                    </td>
                </tr>
                <tr>
                    <td  class=title>무보험차상해</td>
                    <td>&nbsp;
                        <%if(cont_etc.getCanoisr_yn().equals("Y")){%> 가입 <%}%>
                        <%if(cont_etc.getCanoisr_yn().equals("N")){%> 미가입 <%}%>
                    </td>
                    <td class=title>자기차량손해</td>
                    <td class=''>&nbsp;
                        <%if(cont_etc.getCacdt_yn().equals("Y")){%> 가입 <%}%>
                        <%if(cont_etc.getCacdt_yn().equals("N")){%> 미가입 <%}%>
                    </td>
                    <td class=title >긴급출동</td>
                    <td class=''>&nbsp;
                        <%if(cont_etc.getEme_yn().equals("Y")){%> 가입 <%}%>
                        <%if(cont_etc.getEme_yn().equals("N")){%> 미가입 <%}%>
                    </td>
                </tr>
                <tr>
                    <td  class=title>자차면책금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(base.getCar_ja())%>원</td>
                    <td class=title>변경사유</td>
                    <td class=''>&nbsp;<%=cont_etc.getJa_reason()%></td>
                    <td class=title >결재자</td>
                    <td class=''>&nbsp;<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>
                        (기본 <%if(base.getCar_st().equals("5")){%>100,000<%}else{%><%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%><%}%>원) 
                    </td>
                </tr>
                <tr>
                    <td  class=title>자동차</td>
                    <td colspan="5">&nbsp;
                    	  운전석에어백 : 
                        <%if(cont_etc.getAir_ds_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getAir_ds_yn().equals("N")){%> 무 <%}%>
        		            &nbsp;&nbsp;&nbsp;
        		            조수석에어백 : 
                        <%if(cont_etc.getAir_as_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getAir_as_yn().equals("N")){%> 무 <%}%>
        		            &nbsp;&nbsp;&nbsp;
        		            블랙박스 : 
                        <%if(cont_etc.getBlackbox_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getBlackbox_yn().equals("N")){%> 무 <%}%>
						<br/>&nbsp;
						차선이탈(제어형) : 
                        <%if(cont_etc.getLkas_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getLkas_yn().equals("N")){%> 무 <%}%>
                       		&nbsp;&nbsp;&nbsp;
                      	 차선이탈(경고형) : 
                        <%if(cont_etc.getLdws_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getLdws_yn().equals("N")){%> 무 <%}%>
                       		&nbsp;&nbsp;&nbsp;
                       	긴급제동(제어형) : 
                        <%if(cont_etc.getAeb_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getAeb_yn().equals("N")){%> 무 <%}%>
                       		&nbsp;&nbsp;&nbsp;
                     	긴급제동(경고형) : 
                        <%if(cont_etc.getFcw_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getFcw_yn().equals("N")){%> 무 <%}%>
                       		&nbsp;&nbsp;&nbsp;
                      	 전기자동차	 : 
                        <%if(cont_etc.getEv_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getEv_yn().equals("N")){%> 무 <%}%>
							&nbsp;&nbsp;&nbsp;
                      	 견인고리(트레일러용) : 
                        <%if(cont_etc.getHook_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getHook_yn().equals("N")){%> 무 <%}%>
							&nbsp;&nbsp;&nbsp;
                      	 법률비용지원금(고급형) : 
                        <%if(cont_etc.getLegal_yn().equals("Y")){%> 가입 <%}%>
                        <%if(cont_etc.getLegal_yn().equals("N")){%> 미가입 <%}%>
                        	&nbsp;&nbsp;&nbsp;
                      	 탑차(구조변경) : 
                        <%if(cont_etc.getTop_cng_yn().equals("Y")){%> 유 <%}%>
                        <%if(cont_etc.getTop_cng_yn().equals("N")){%> 무 <%}%>
                        <br/>&nbsp;
                        	기타장치 : <%=cont_etc.getOthers_device()%>
                      </td>
                </tr>               
                <tr>
                    <td  class=title>차량관리<br>서&nbsp;비&nbsp;스<br>제공범위</td>
                    <td colspan="5">&nbsp;
                    	<%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
                      		<input type="checkbox" name="ac_dae_yn" 	value="Y" <%if(cont_etc.getAc_dae_yn().equals("Y")){%>checked<%}%>>
                      	<%} else {%>
                      		  	&nbsp;* 
                      	<%} %> 
                      		  사고대차서비스(피해사고시 제외)<br>
        			  &nbsp;
        			  <%if(Integer.parseInt(base.getRent_dt()) < 20210322){%>
        			  	<input type="checkbox" name="pro_yn" 		value="Y" <%if(cont_etc.getPro_yn().equals("Y")){%>checked<%}%>> 
        			  <%} else {%>
                      		  	&nbsp;* 
                      <%} %> 
        			  교통사고 발생시 사고처리 업무대행 (보험사 관련 업무 등) <br>
        			  &nbsp;
        			  <%if(cont_etc.getCyc_yn().equals("Y")){%>
        			  <input type="checkbox" name="cyc_yn" 		value="Y" <%if(cont_etc.getCyc_yn().equals("Y")){%>checked<%}%>> 
                      		  매 7,000km 또는 고객요청시 순회점검 서비스 실시 <br>
        			  &nbsp;        			  
        			  <%}%>
        			  <input type="checkbox" name="main_yn" 	value="Y" <%if(cont_etc.getMain_yn().equals("Y")){%>checked<%}%>> 
                      		  일체의 정비서비스(내부구성부품 및 소모품 교환, 엔진오일 교환 등) <br>
        			  &nbsp;
        			  <input type="checkbox" name="ma_dae_yn" 	value="Y" <%if(cont_etc.getMa_dae_yn().equals("Y")){%>checked<%}%>> 
                      		  정비대차서비스(4시간 이상 정비공장 입고시) <br>
        			  </td>
                </tr>
                <%if(cont_etc.getInsur_per().equals("2")){%>
                <tr>
                    <td  class=title>입보회사</td>
                    <td colspan="5">
                        <table width="100%" border="0" cellpadding="0">
                            <tr>
                                <td width="100%">
                                	&nbsp;보험사  :<%=cont_etc.getIp_insur()%>
                      				    &nbsp;&nbsp;&nbsp;&nbsp;대리점 : <%=cont_etc.getIp_agent()%>
                      				    &nbsp;&nbsp;&nbsp;&nbsp;담당자 :<%=cont_etc.getIp_dam()%>
                					        &nbsp;&nbsp;&nbsp;&nbsp;연락처 :<%=cont_etc.getIp_tel()%>
                			    </td>
                            </tr>
                        </table>
                    </td>
                </tr>
              <tr>
                <td  class=title>차량손해</td>
                <td colspan="5">
                    <table width="100%" border="0" cellpadding="0">
                      <tr>
                        <td width="100%">&nbsp;물적사고할증기준
					                <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>50만원<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==100){%>100만원<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==150){%>150만원<%}%>
					                <%if(cont_etc.getCacdt_mebase_amt()==200){%>200만원<%}%>

					  / (최대)자기부담금 <%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>만원 
					  / (최소)자기부담금  
                        <%if(cont_etc.getCacdt_memin_amt()==5 ){%>5만원<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==10){%>10만원<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==15){%>15만원<%}%>
                        <%if(cont_etc.getCacdt_memin_amt()==20){%>20만원<%}%>
                			    </td>
                      </tr>
                    </table>
                 </td>
                </tr>
                <%}%>
                <tr>
                    <td class='title'>비고</td>
                    <td colspan="5">&nbsp;<%=base.getOthers()%></td>
                </tr>
            </table>
        </td>
    </tr>	
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('10','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>	
		<%if(!base.getCar_st().equals("2")){%>
		
		<%	for(int f=1; f<=fee_size; f++){
					ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));
					if(ext_gin.getRent_mng_id().equals("")) continue;
		%>
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>차 연장 <%}%>보증보험</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
		</tr>
		<tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="9">&nbsp;
                        <%if(ext_gin.getGi_st().equals("1")){%> 가입 <%}%>
                  		  <%if(ext_gin.getGi_st().equals("0")){%> 면제 <%}%>
                  	</td>
                </tr>
                <%if(!ext_gin.getGi_jijum().equals("")||ext_gin.getGi_amt()!=0||ext_gin.getGi_fee()!=0||!ext_gin.getGi_dt().equals("")){%>
                <tr>
                    <%if(now_stat.equals("계약승계")){ %>
	                    <td width="13%" class=title>발행지점</td>
	                    <td width="12%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
	                    <td width="9%" class='title'>가입금액</td>
	                    <td width="10%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>원</td>
	                    <td width="9%" class=title >보증보험료</td>
	                    <td width="10%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>원</td>
	                    <td width="9%" class=title >가입일자</td>
	                    <td width="10%">&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
	                    <!-- 보증보험 가입개월 추가(2018.03.21) -->
	                    <td width="9%" class=title >가입기간</td>
	                    <td width="9%">&nbsp;<%=ext_gin.getGi_month()%><%if(!ext_gin.getGi_month().equals("")){%>개월<%}%></td>
	                <%}else{%>
	                	<td width="13%" class=title>발행지점</td>
	                    <td width="15%">&nbsp;<%=ext_gin.getGi_jijum()%></td>
	                    <td width="10%" class='title'>가입금액</td>
	                    <td width="15%" >&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>원</td>
	                    <td width="10%" class=title >보증보험료</td>
	                    <td width="15%">&nbsp;<%=AddUtil.parseDecimal(ext_gin.getGi_fee())%>원</td>
	                    <td width="10%" class=title >가입일자</td>
	                    <td width="15%">&nbsp;<%=AddUtil.ChangeDate2(ext_gin.getGi_dt())%></td>
	                <%}%>    
                </tr>
                <%}%>
            </table>
        </td>
    </tr>
		<%	}%>
		<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('11','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
		<tr>
		<%for(int f=1; f<=fee_size; f++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
		%>
		<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(f>1){%><%=f-1%>차 연장 <%}%>대여요금</span></td>
    </tr>
		<tr>
	    <td class=line2></td>
		</tr>
    <tr> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <%if(f==1 && base.getCar_gu().equals("0")){ %>
              <tr>
                <td width="13%" align="center" class=title>차량인도예정일</td>
                <td colspan='5'>&nbsp;<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_est_dt())%>                    
					 (재리스계약일 때 차량인도예정일 전날 보험변경합니다. 인도 확정시 다시 확인하십시오.)
					 </td>
              </tr>   
              <%} %>
              <tr>
                <td width="13%" align="center" class=title>계약일자</td>
                <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_dt())%></td>
                <td width="10%" align="center" class=title>계약담당자</td>
                <td >&nbsp;<%=c_db.getNameById(fees.getExt_agnt(), "USER")%></td>
                <td width="10%" align="center" class=title>영업대리인</td>
                <td >&nbsp;<%=c_db.getNameById(fee_etcs.getBus_agnt_id(), "USER")%></td>
              </tr>
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td width="20%">&nbsp;<%=fees.getCon_mon()%>개월</td>
                <td width="10%" align="center" class=title>대여개시일</td>
                <td width="20%">&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%></td>
                <td width="10%" align="center" class=title>대여만료일</td>
                <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%></td>
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
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_gur_p_per' class='whitenum' value='<%=fees.getF_gur_p_per()%>' readonly>
    				            %
        				    </td>
                    <td align='center'>
					            <%if(fee_size==1 && base.getRent_st().equals("3")){%>
					              대차 보증금 승계여부 :
                              <%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}%>
                              <%if(fees.getGrt_suc_yn().equals("1")){%>별도<%}%>                            
					            <%}%>
 			                <%if(f>1){%>
                              <%if(fees.getGrt_suc_yn().equals("0")){%>승계<%}%>
                              <%if(fees.getGrt_suc_yn().equals("1")){%>별도<%}%>                            
   				            <%}%>
        				    </td>
                </tr>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' >
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_pere_r_per' class='whitenum' value='<%=fees.getF_pere_r_per()%>' readonly>
    				            %  
        				    </td>
                    <td align='center'>
           선납금 계산서발행구분 :
					<select name='pp_chk' disabled>
                              <option value="">선택</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>납부일시발행</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>매월균등발행</option>
                            </select>                      	
                    	</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ifee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' >
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2")%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='whitenum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료 </td>
                    <td align='center'></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_s_amt' maxlength='11' class='whitenum' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='tot_pp_v_amt' maxlength='10' class='whitenum' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='tot_pp_amt' maxlength='11' class='whitenum' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">입금예정일 : <%=AddUtil.ChangeDate2(fees.getPp_est_dt())%></td>
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
                        결재자 : <%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>
                  			&nbsp;&nbsp;&nbsp;&nbsp;
			                  결재일자 : <%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>
                    </td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='whitenum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='whitenum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>              
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>원/1km (부가세별도)
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <%} %>  
                  <br>&nbsp;                
                  (약정초과운행시) 초과운행대여료 <%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                                    
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <!-- 
                    <%if(fee_etcs.getAgree_dist_yn().equals("1")){%>전액면제(기본식)<%}%>
                    <%if(fee_etcs.getAgree_dist_yn().equals("2")){%>50%만 납부(일반식)<%}%>
                    <%if(fee_etcs.getAgree_dist_yn().equals("3")){%>매입옵션 없음(기본식,일반식)<%}%>
                  -->
                  <!--
                  <br>&nbsp;※ 예상 운행거리 <%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>km/1년
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
                    <%} %>
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">보유차주행거리</td>
                    <%if (f==1 && base.getCar_gu().equals("0")) {%>
                    <td colspan="4">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>km (재리스 계약시점 대여차량 주행거리, 계약서 기재 값)
                    </td>
                    <td colspan="2" align="center">
                    	※ 재리스 지점간 이동 :&nbsp;
                    	출발&nbsp;-&nbsp;
                    	<%if (fee_etcs.getBr_from().equals("")) {%>지점간이동없음<%}%>
                    	<%if (fee_etcs.getBr_from().equals("0")) {%>서울<%}%>
                    	<%if (fee_etcs.getBr_from().equals("1")) {%>대전<%}%>
                    	<%if (fee_etcs.getBr_from().equals("2")) {%>대구<%}%>
                    	<%if (fee_etcs.getBr_from().equals("3")) {%>광주<%}%>
                    	<%if (fee_etcs.getBr_from().equals("4")) {%>부산<%}%>
                    	&nbsp;&nbsp;
                    	도착&nbsp;-&nbsp;
                    	<%if (fee_etcs.getBr_to().equals("")) {%>지점간이동없음<%}%>
                    	<%if (fee_etcs.getBr_to().equals("0")) {%>서울<%}%>
                    	<%if (fee_etcs.getBr_to().equals("1")) {%>대전<%}%>
                    	<%if (fee_etcs.getBr_to().equals("2")) {%>대구<%}%>
                    	<%if (fee_etcs.getBr_to().equals("3")) {%>광주<%}%>
                    	<%if (fee_etcs.getBr_to().equals("4")) {%>부산<%}%>
                    </td>
                    <%} else {%>
                    <td colspan="6">&nbsp;<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>km (재리스 계약시점 대여차량 주행거리, 계약서 기재 값)
                    <%}%>  
                    <input type="hidden" name="over_bas_km" value='<%=fee_etcs.getOver_bas_km()%>'>                  
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
        			  <input type='text' size='4' name='b_max_ja' maxlength='10' class='whitenum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'>                        
                        <input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1년                        
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">조정 최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' class='whitenum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'>
                                  <input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1년
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)">
        				  % 
        				        &nbsp;&nbsp;&nbsp;신차의
    				            <input type='text' size='4' name='f_opt_per' class='whitenum' value='<%=fees.getF_opt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)">
    				            %  
        				    </td>
                    <td align='center'>
        			        <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%>>
                      없음
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%>>
        	 		        있음
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차제외 %>
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
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' >
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_r_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' >
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' class="whitenum" value='<%=fees.getApp_ja()%>' >
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' >
        				  원</td>
                    <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' >
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					월대여료납입방식 :
                              <%if(fees.getFee_chk().equals("0")){%>매월납입<%}%>
                              <%if(fees.getFee_chk().equals("1")){%>일시완납<%}%>
					</td>
                </tr>
                <!-- 운전자추가요금/월보험료(고객피보험) 적용 (2018.03.30)-->
                <tr>
                	<td class='title' rowspan="4" width="40px">정<br>상<br>대<br>여<br>료</td>
                    <td class='title'>정상요금</td>
                    <td align="center" ><input type='text' size='10' name='inv_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' >
        				  원</td>
                    <td align="center" ><input type='text' size='10' name='inv_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' >
        				  원</td>
                    <td align='center' ><input type='text' size='10' maxlength='10' name='inv_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' >
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>&nbsp;
                            <%EstimateBean esti = e_db.getEstimateCase(fee_etcs.getBc_est_id()); 	%>
			                  <%if(!esti.getReg_code().equals("")){%>
			                  <%if(fee_etc.getBc_dlv_yn().equals("Y")){%>(출고일기준)<%}%>
			                  &nbsp;&nbsp;
      			              <span class="b"><a href="javascript:estimates_view('<%=fees.getRent_st()%>', '<%=esti.getReg_code()%>')" onMouseOver="window.status=''; return true" title="견적결과 보기"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					                  
			                  <%}%>                    	
                    </td>
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
                    <td align='center'>자동차보험 관련 특약 약정서<br>
                    	<a href="javascript:reqdoc('<%=fees.getRent_l_cd()%>','<%=fees.getRent_mng_id()%>','<%=fees.getRent_st()%>')"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                    </td>
              	</tr> 
               	<tr>
                    <td class='title'>운전자추가요금</td>
                    <td align="center">
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
                    <td align="center">
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
	                <td colspan='3'>&nbsp; 결재자 : <%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>
			                &nbsp;&nbsp;&nbsp;&nbsp;결재일자 : 	<%=AddUtil.ChangeDate2(fees.getBas_dt())%></td>                    
	                <td align='center'>-</td>            
	                <td align="center">적용근거 : 
	                        <%if(fee_etcs.getDc_ra_st().equals("1")){%>정상DC조건<%}%>
	                        <%if(fee_etcs.getDc_ra_st().equals("2")){%>특별DC<%}%>
	                    &nbsp;기타 : <%=fee_etcs.getDc_ra_etc()%>
	                </td>
	                <td align='center'>
	                    DC율 <%=fees.getDc_ra()%>%
	                    DC금액 <%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()+fees.getIns_s_amt()+fees.getIns_v_amt()+fee_etcs.getDriver_add_amt()+fee_etcs.getDriver_add_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>원
	                </td>
	            </tr>
                                    
				      <%		int fee_etc_rowspan = 1;
				      			if(fees.getRent_st().equals("1")) fee_etc_rowspan++;//신규에 영업수당
				    				if(fees.getRent_st().equals("1") && cont_rent_st.equals("3")) fee_etc_rowspan++;//대차계약일때 원계약정보
				    				//운전자추가요금추가
		    						fee_etc_rowspan++;
							%>       
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>기<br>
                      타</td>                     
                    <td class='title' style="font-size : 8pt;" colspan="2">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의 <%=fees.getCls_r_per()%>%</td>
                    <td align='center'><font color="#FF0000"><%=fees.getCls_per()%>%, 필요위약금율[<%=fees.getCls_n_per()%>%]</font></span></td>
                </tr>
                
				        <%if(fees.getRent_st().equals("1")){%>
                <tr>
                    <td class='title' colspan="2">영업수당</td>
                    <td colspan="2" align="center">
        			        산출기준: 차량가격</td>
                    <td align='center'><input type='text' size='10' name='commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>'>원</td>
                    <td align='center'>-</td>
                    <td align="center"><input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='whitenum'>%</td>
                    <td align='center'><input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' size="4" class='whitenum'>%</td>
                </tr>
                <%}%>
                
                <tr>
                    <td class='title' colspan="2">운전자추가요금</td>
                    <td colspan="6">&nbsp;
                    	<input type='text' size='10' name='driver_add_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>'>
        				      원 (공급가)</td>                  
                </tr>
                
				        <%if(fees.getRent_st().equals("1") && cont_rent_st.equals("3")){
										//대차원계약정보
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>                                  
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">대차원계약</td>
                    <td colspan="6">&nbsp;
					            <b>[원계약정보]</b>
					            &nbsp;계약번호 : <%=cont_etc.getGrt_suc_l_cd()%>
					            &nbsp;차량번호 : <%=cont_etc.getGrt_suc_c_no()%>
					            &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					            <br>
					            &nbsp;
					            <b>[대차보증금승계]</b>
					            &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					            승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='whitenum' >원
					            <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>	
					  			
					  			<%if(ck_acar_id.equals("000029") && fees.getGrt_amt_s()>0 && fees.getGrt_suc_yn().equals("1") && !cont_etc.getRent_suc_dt().equals("") && fees.getRent_st().equals(cont_etc.getSuc_rent_st()) && cont_etc.getGrt_suc_o_amt() >0) { %>
					  			&nbsp; ** 계약승계시 보증금  별도 입금
					  			<%} %>					            
        			      </td>
                </tr>
				        <%}%>
				        <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차 제외 %>
                <tr>
                    <td colspan="3" class='title'>전기차 인수/반납 유형</td>
                    <td colspan="6">&nbsp;
                    	<select name='return_select' disabled>
                        <option value=''>선택</option>
                        <option value='0' <%if(fee_etcs.getReturn_select().equals("0")){%>selected<%}%>>인수/반납 선택형</option>
                        <option value='1' <%if(fee_etcs.getReturn_select().equals("1")){%>selected<%}%>>반납형</option>
                    	</select>
                    </td>
                </tr>
                <%}%>			     				        
                <tr>
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">&nbsp;<%=fee_etcs.getCon_etc()%></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;<%=fees.getFee_cdt()%></td>
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
                    <td width="20%">&nbsp;<%=fees.getFee_pay_tm()%>회 </td>
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
                    <td>&nbsp;<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>~<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%></td>
                </tr>
            </table>
	    </td>
    </tr>
    <%		if(acar_de.equals("1000")){ %>
	<input type='hidden' name="bc_s_a"	value="<%=fee_etcs.getBc_s_a()%>">
	<input type='hidden' name="bc_b_e1"	value="<%=fee_etcs.getBc_b_e1()%>">
	<input type='hidden' name="bc_b_e2"	value="<%=fee_etcs.getBc_b_e2()%>">
	<input type='hidden' name="bc_b_u"	value="<%=fee_etcs.getBc_b_u()%>">
	<input type='hidden' name="bc_b_g"	value="<%=fee_etcs.getBc_b_g()%>">
	<input type='hidden' name="bc_b_ac"	value="<%=fee_etcs.getBc_b_ac()%>">
	<input type='hidden' name="bc_etc"	value="<%=fee_etcs.getBc_etc()%>">
	<input type='hidden' name="bc_b_t"	value="<%=fee_etcs.getBc_b_t()%>">
	<input type='hidden' name="bc_b_u_cont"	value="<%=fee_etcs.getBc_b_u_cont()%>">
	<input type='hidden' name="bc_b_g_cont"	value="<%=fee_etcs.getBc_b_g_cont()%>">
	<input type='hidden' name="bc_b_ac_cont" value="<%=fee_etcs.getBc_b_ac_cont()%>">
	<%		}else{ %>	
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
            		        <tr>
            				    <td align="center">E-1</td>
            				    <td align="center">bc_b_e1</td>				  
            				    <td>&nbsp;낙찰예상가대비현재가치산출승수의기간반영율</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e1' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		    <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;경매장예상낙찰가격</td>
            				    <td align="center"><input type='text' size='12' name='bc_b_e2' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		    <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;기타비용</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_u' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_u()%>' >&nbsp;내용: <%=fee_etcs.getBc_b_u_cont()%></td>
            				</tr>							
            		    <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;기타수익</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_g' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_g()%>' >&nbsp;내용: <%=fee_etcs.getBc_b_g_cont()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='bc_b_ac' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_ac()%>' >&nbsp;내용: <%=fee_etcs.getBc_b_ac_cont()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;정산유의사항</td>
            				  <td align="center"><%=fee_etcs.getBc_etc()%></td>
            				</tr>
            		    <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_b_t</td>				  
            				  <td>&nbsp;용품사양</td>
            				  <td align="center"><%=AddUtil.parseDecimal(fee_etcs.getBc_b_t())%></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>	
    <%		}%>		    
	<%	}%>

	
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('12','<%=fee_size%>')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	
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
                        <%if(fee.getFee_sh().equals("0")){%> 후불 <%}%>
                        <%if(fee.getFee_sh().equals("1")){%> 선불 <%}%>
                    </td>
                    <td width="10%" class='title'>납부방법</td>
                    <td width="20%">&nbsp;
                        <%if(fee.getFee_pay_st().equals("1")){%> 자동이체 <%}%>
                        <%if(fee.getFee_pay_st().equals("2")){%> 무통장입금 <%}%>
                        <%if(fee.getFee_pay_st().equals("4")){%> 수금 <%}%>
                        <%if(fee.getFee_pay_st().equals("5")){%> 기타 <%}%>
                        <%if(fee.getFee_pay_st().equals("6")){%> 카드 <%}%>
                    </td>
        			  <td width="10%" class='title'>CMS미실행</td>
        			  <td>&nbsp;사유 : <%=f_fee_etc.getCms_not_cau()%></td>
                </tr>
                <tr>
                    <td class='title'>거치여부</td>
                    <td colspan="3">&nbsp;
                      <%if(fee.getDef_st().equals("N")){%> 없음 <%}%>
                      <%if(fee.getDef_st().equals("Y")){%> 있음 <%}%>
        			        사유 : <%=fee.getDef_remark()%></td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%></td>
                </tr>
                  <tr>
                    <td class='title'>자동이체</td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						        계좌번호 : <%=cms.getCms_acc_no()%>
        			      (은행:<%=cms.getCms_bank()%>) </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
						        예 금 주 : <%=cms.getCms_dep_nm()%>
        				  &nbsp;&nbsp;
        				  / 결제일자 : 매월 <%=cms.getCms_day()%>일</td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
					          예금주 생년월일/사업자번호 : <%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>
    				        &nbsp;&nbsp;예금주 주소 : <%=cms.getCms_dep_post()%> <%=cms.getCms_dep_addr()%></td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
					          연락전화 : <%=cms.getCms_tel()%>
    			      &nbsp;&nbsp;휴대폰 : <%=cms.getCms_m_tel()%>
    			      &nbsp;&nbsp;이메일 : <%=cms.getCms_email()%>
        				  </td>
        			    </tr>
        			</table>
        			</td>
                  </tr>
                <tr>
                    <td class='title'>통장입금</td>
                    <td colspan="5">&nbsp;<%=c_db.getNameById(fee.getFee_bank(), "BANK")%></td>
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
                        <% if(cont_etc.getRec_st().equals("1")) out.print("이메일"); %>
                        <% if(cont_etc.getRec_st().equals("2")) out.print("우편"); %>
                        <% if(cont_etc.getRec_st().equals("3")) out.print("수령안함"); %>
                    </td>
                    <td width="10%" class='title' style="font-size : 8pt;">전자세금계산서</td>
                    <td>&nbsp;
                        <% if(cont_etc.getEle_tax_st().equals("1")) out.print("당사시스템"); %>
                        <% if(cont_etc.getEle_tax_st().equals("2")) out.print("별도시스템"); %>
                        &nbsp;<%=cont_etc.getTax_extra()%>
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
					   ){//'100','101','601','602','701','702','801','802','803','811','812'%>
			  <tr>
                <td width="13%" class='title'>계산서별도발행구분</td>			  
			    <td colspan='5'>&nbsp;
                    <%if(client.getPrint_car_st().equals("")) out.println("없음");%>
                    <%if(client.getPrint_car_st().equals("1")) out.println("승합/화물/9인승/경차");%>
				  <font color=red>* '<%=cm_bean.getCar_nm()%>' 차량은 부가세환급대상 차량입니다. 부가세환급할경우 계산별도발행구분을 [승합/화물/9인승/경차]로 선택하십시오.</font>
				</td>	
			  </tr>
			  <%	}%>						
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('13','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
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
                    <td width="20%">&nbsp;
                      <input type='radio' name="prv_dlv_yn" value='N' <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      없다
                      <input type='radio' name="prv_dlv_yn" value='Y' <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
        	 		        있다
        		    </td>
                    <td width="10%" class=title style="font-size : 7pt;">대차기간포함여부</td>
                    <td>&nbsp; &nbsp;
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
    <tr id=tr_tae2 style="display:<%if(fee.getPrv_dlv_yn().equals("Y") && !base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_no()%></td>
                    <td width="10%" class='title'>차명</td>
                    <td width="20%">&nbsp;<%=taecha.getCar_nm()%></td>
                    <td width="10%" class='title'>최초등록일</td>
                    <td>&nbsp;<%=taecha.getInit_reg_dt()%></td>
                </tr>
                <tr>
                    <td class=title>대여개시일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%></td>
                    <td class='title'>대여만료일</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%></td>
                    <td class='title'>대여료선입금여부</td>
                <td>&nbsp;
                	<%if(taecha.getF_req_yn().equals("Y")){%> 선입금 <%}%>
                  <%if(taecha.getF_req_yn().equals("N")||taecha.getF_req_yn().equals("")){%> 후입금 <%}%>
    	 		        </td>
                </tr>
                <tr>
                    <td class=title>월대여료</td>
                    <td colspan='3' >&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원(vat포함)</td>
                    <td class=title>정상요금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(taecha.getRent_inv())%>원(vat포함)</td>
              </tr>
              <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              <%}else{%>
              <tr>
                    <td class=title >신차해지시요금정산</td>
                    <td colspan='5'> 
                      <%if(taecha.getRent_fee_st().equals("1")){%> 월렌트정상요금                                      
                      <%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>
        			  원(vat포함)                 
        			  <%}%>
                      <%if(taecha.getRent_fee_st().equals("0")){%> 견적서에 표기되어 있지 않음    <%}%>    	 		           
        			</td>
                </tr>	
              <%} %>  		
              <tr>
                <td class=title>청구여부</td>
                <td>&nbsp;
                    <% if(taecha.getReq_st().equals("1")) out.print("청구");%>
                    <% if(taecha.getReq_st().equals("0")) out.print("무상대차");%>
                </td>
                <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                <td>&nbsp;
                    <% if(taecha.getTae_st().equals("1")) out.print("발행");%>
                    <% if(taecha.getTae_st().equals("0")) out.print("미발행");%>
                </td>
                <td class='title'>결재자</td>
                <td>&nbsp;<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%></td>
              </tr>
              <%if(!cont_etc.getGrt_suc_l_cd().equals("")){//만기매칭대차 이관스케줄 변경 결재자%>
              <tr>
                <td class='title'>만기매칭대차 이관스케줄<br>변경 결재자</td>
                <td colspan='5'>&nbsp;<%=c_db.getNameById(taecha.getEnd_rent_link_sac_id(), "USER")%></td>
              </tr>    
              <%} %>
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('14','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	
	<%if(base.getCar_gu().equals("0") && base.getCar_st().equals("5")){%>
	<%}else{ %>
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
		              <input type='radio' name="pur_bus_st" value='1' <%if(pur.getPur_bus_st().equals("1")){%>checked<%}%>>
                  자체영업
                  <input type='radio' name="pur_bus_st" value='2' <%if(pur.getPur_bus_st().equals("2")){%>checked<%}%>>
                  영업사원영업
                   <input type='radio' name="pur_bus_st" value='4' <%if(pur.getPur_bus_st().equals("4")){%>checked<%}%>>
                  에이전트
                   </td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>출고보전수당 지급여부</td>
					<td colspan="5" >&nbsp;
						<%-- <label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() == 0){%>checked<%}%>> --%>
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%>>
              			없음</label>　　
              			<%-- <label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")||emp1.getDlv_con_commi() > 0){%>checked<%}%>> --%>
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
                    <td width="20%" >&nbsp;<%=emp1.getEmp_nm()%></td>
                    <td width="10%" class='title'>상호/영업소명</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(emp1.getCar_comp_id(),"CAR_COM")%></td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;<%=emp1.getEmp_m_tel()%></td>
                </tr>
                <tr>
                    <td class='title'>소득구분</td>
                    <td >&nbsp;<%=emp1.getCust_st()%></td>
                    <td class='title'>최대수수료율</td>
                    <td>&nbsp;<%=emp1.getComm_rt()%>%</td>
                    <td class='title'>적용수수료율</td>
                    <td>&nbsp;<%=emp1.getComm_r_rt()%>% <%=AddUtil.parseDecimal(emp1.getCommi())%>원</td>
                </tr>
                <tr>
                    <td class='title'>변경사유</td>
                    <td colspan="3" >&nbsp;<%=emp1.getCh_remark()%></td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%></td>
                </tr>
                <tr>
                    <td class='title'>은행명</td>
                    <td >&nbsp;<%=emp1.getEmp_bank()%></td>
                    <td class='title'>계좌번호</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_no()%></td>
                    <td class='title'>예금주명</td>
                    <td>&nbsp;<%=emp1.getEmp_acc_nm()%></td>
                </tr>		  		  
            </table>
        </td>
    </tr>
    <%}%>
	<%}%>
	<%if(base.getCar_gu().equals("0") && base.getCar_st().equals("5")){%>
	<%}else{ %>	
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
				          <input type='radio' name="one_self" value='Y' <%if(pur.getOne_self().equals("Y")){%>checked<%}%>>
        				  자체출고
        		      <input type='radio' name="one_self" value='N' <%if(pur.getOne_self().equals("N")){%>checked<%}%>>
        				  영업사원출고
    			      </td>
    		        <td class='title'>특판출고여부</td>
                <td>&nbsp;
                  <input type='radio' name="dir_pur_yn" value='Y' <%if(pur.getDir_pur_yn().equals("Y")){%>checked<%}%>>
        				  특판
        	        <input type='radio' name="dir_pur_yn" value='' <%if(pur.getDir_pur_yn().equals("")){%>checked<%}%>>
        				  기타(자체)
    			      </td>
    		        <td class='title'>출고요청일</td>
                <td>&nbsp;<%=pur.getPur_req_dt()%>
                		&nbsp;
        		        <input type="checkbox" name="pur_req_yn" value="Y" <%if(pur.getPur_req_yn().equals("Y")){%>checked<%}%>>				  
        				    출고요청한다
    			      </td>
              </tr>
                <tr>
                    <td width="10%" class='title'>출고담당</td>
                    <td width="20%" >&nbsp;<%=emp2.getEmp_nm()%></td>
                    <td width="10%" class='title'>영업소명</td>
                    <td width="20%">&nbsp;<%=emp2.getCar_off_nm()%></td>
                    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;<%=emp2.getEmp_m_tel()%></td>
                </tr>
    		  <%if(!base.getCar_gu().equals("2")){%>    		  
              <tr>
                <td class='title'>계출번호</td>
                <td >&nbsp;<%=pur.getRpt_no()%>
                	<%if(!cop_bean.getRent_l_cd().equals("")){%>
                	<br>&nbsp;<font color=red>
                	(사전계약 <%=cop_bean.getCom_con_no()%>
                	
                	<%	if(cop_res_vt_size>0){
                			for (int i = 0 ; i < 1 ; i++) {
								Hashtable cop_res_ht = (Hashtable)cop_res_vt.elementAt(i);
					%>
					<%=cop_res_ht.get("FIRM_NM")%><%=cop_res_ht.get("CUST_Q")%>
					<%		}
						}
					%>
					
                	)
                	</font>
                	<%}%>
                </td>
                <td class='title'>출고예정일</td>
                <td>&nbsp;<%=pur.getDlv_est_dt()%>&nbsp;<%=pur.getDlv_est_h()%>시 </td>
                <td class='title'>출고일자</td>
                <td>&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
              </tr>              
    		  <%}else if(base.getCar_gu().equals("2")){%>
              <tr>
                <td class='title'>매매일자</td>
                <td >&nbsp;<%= AddUtil.ChangeDate2(base.getDlv_dt())%></td>
                <td class='title'>매매금액</td>
                <td colspan="3">&nbsp;<%=AddUtil.parseDecimal(pur.getTrf_amt1())%></td>
              </tr>
              <tr>
                <td class='title'>전차량번호</td>
                <td >&nbsp;<%=pur.getRpt_no()%></td>
                <td class='title'>차대번호</td>
                <td colspan="3">&nbsp;<%=pur.getCar_num()%></td>
              </tr>
    		  <%}%>
    		  
               
              <tr>
                <td class='title'>계약금</td>
                <td colspan="5">&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='whitenum' size='7' onBlur='javascript:this.value=parseDecimal(this.value);'>원
				     <%if(pur.getCon_amt() > 0 && pur.getCon_pay_dt().equals("") && pur.getCon_amt_pay_req().equals("")){%>
                	<a href="javascript:SendMsg('con_amt_pay_req')"><img src=/acar/images/center/button_in_ask_rem.gif border=0 align=absmiddle></a>
                	<%	if(emp2.getCar_off_id().equals("00588") || emp2.getCar_off_id().equals("04514")){ %>
                	<font color=red>※ 송금요청을 해야 출금진행합니다. 카드는 당일 오후4시에 마감합니다. 오후4시 이후에는 내일 신청하세요. </font><br>
                	<%	}%>
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
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('15','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%if(base.getUse_yn().equals("") && !now_stat.equals("계약승계") && !now_stat.equals("차종변경")){%>
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
                    <td>&nbsp;<%=f_fee_etc.getBus_cau()%></td>
                </tr>
            </table>
        </td>
    </tr>				
	<tr>
	    <td align="right"><%if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('16','')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%}%>
	
	<%}%>
		
	<%
		int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;
		int add_rent_mail_yn = 0;
	%>
	<%if(!base.getCar_st().equals("2")){%>
    <tr> 
        <td colspan="2"><a name="scan"><img src=/acar/images/center/icon_arrow.gif align=absmiddle></a> <span class=style2>기본스캔파일
		  &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a></span>
		  &nbsp;<a href ="javascript:scan_all_reg()" title='스캔일괄등록'><img src=/acar/images/center/button_reg_scan_ig.gif align=absmiddle border=0></a>
		  
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
                  <td width="5%" class=title>연번</td>
                  <td width="5%" class=title><input type="checkbox" name="ch_all" value="Y" onclick="javascript:AllSelect();"></td>
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
			String content_seq  = ""; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			
		 	String alink_scan_1_yn = "";
        	
        	
        	
        	%>
        		
		<!--변경후-->	
		<%	for(int f=1; f<=fee_size; f++){
				ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
				ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));%>	

        	
        	<%		if(!acar_de.equals("1000") && AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f>1 && f==fee_size ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">자동차대여이용계약서(연장)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>
                  <td align="center">
                      <%if(now_stat.equals("연장") && AddUtil.parseInt(fees.getRent_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                        		<%-- 파피리스 : <a href=javascript:go_edoc('lc_rent_link','3','<%=f%>','');><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                   			<%-- <%} %> --%>
                   			<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
                        		<a href=javascript:go_edoc2('lc_rent_link','3','<%=f%>','');><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                        	<%} %>	
                      <%}%>
                  </td>		  
                </tr>	        	
        	<%		}%>
        	
        	
        	<%		if(AddUtil.parseInt(fees.getRent_dt()) > 20140101 && f==1 ){ //!base.getRent_st().equals("1") && %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">자동차대여이용계약서(신규,대차,증차)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/privacy_agree.pdf' target="_blank"><img src=/acar/images/center/button_in_sj.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
                      <%if(!acar_de.equals("1000") && !now_stat.equals("연장") && !now_stat.equals("계약승계") && AddUtil.parseInt(fees.getRent_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                       			<%-- 파피리스 : <a href=javascript:go_edoc('lc_rent_link','1','<%=f%>',''); title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                       		<%-- <%} %> --%>
                       		<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>
                        		<a href=javascript:go_edoc2('lc_rent_link','1','<%=f%>',''); title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                        	<%} %>	
                      <%}%>    
                      <%if(AddUtil.parseInt(base.getReg_dt()) >= 20200303 && user_id.equals("000284")){ //에이전트 염정진 허용%>
                        		<a href=javascript:go_edoc2('lc_rent_link','1','<%=f%>',''); title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>              
                  </td>		  
                </tr>	        	
        	<%		}%>        	
        	
        	
        	
        	<%		if(now_stat.equals("계약승계") && cont_etc.getSuc_rent_st().equals(String.valueOf(f)) && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > 20140101 ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">자동차대여이용계약서(계약승계)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
                      <%if(now_stat.equals("계약승계") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20160101){%>
                   			<%-- <%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) < 20190514){ %> --%>
                       			<%-- 파피리스 : <a href=javascript:go_edoc('lc_rent_link','2','<%=f%>',''); title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a><br> --%>
                       		<%-- <%} %> --%>
                       		<%if(AddUtil.parseInt(AddUtil.getDate().replaceAll("-","")) >= 20190514 || nm_db.getWorkAuthUser("전산팀",ck_acar_id)){ %>	
	                       		<a href=javascript:go_edoc2('lc_rent_link','2','<%=f%>',''); title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
	                       	<%} %>
                      <%}%>                                    
                  </td>		  
                </tr>	        	
        	<%		}%>        	
        	

        	

		<%		if((now_stat.equals("계약승계") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("차종변경") && fee_etcs.getReg_dt().equals(base.getReg_dt())) || (now_stat.equals("연장") && fee_size==f)){//jpg%>
		
		<!--개시후계약서(jpg)-->				
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"17";
                	  attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	  attach_vt_size = attach_vt.size();
                	  if(attach_vt_size > 0){
            				  for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					
 					              if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && (String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg") || String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
							            add_rent_mail_yn++; 
					              }                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('17')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="17">
                
		<!--개시후계약서(jpg)-->				
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"18";
                  	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                  	attach_vt_size = attach_vt.size();
                  	if(attach_vt_size > 0){
				              for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
 					              if(AddUtil.parseInt(fees.getRent_dt()) >= 20140101 && (String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg") || String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
							            add_rent_mail_yn++; 
					              }                      	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('18')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="18">
                

		<!--개인(신용)정보 수집·이용·제공·조회동의서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"37";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:scan_reg('37')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20140801부터 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20140731 && fee_size == 1){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//법인 대표자연대면제는 제외
					}else{
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				}				
			%>    
											<%	}%>                
											<%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">    
                
                	
		<!--개인(신용)정보 수집·이용·제공·조회동의서(공동임차인) - 개인/개인사업자-->		
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"51";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:scan_reg('51')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20210601부터 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20210601 && fee_size == 1){
						scan_cnt++;
						out.println("<font color=red>불충</font>");
				}				
			%>    
											<%	}%>                
											<%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">  
        <%	}%>                  
                	                	
                	
		<!--CMS동의서jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"38";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	String cms_scan_yn = "";
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            
 					            if(cms_scan_yn.equals("") && AddUtil.parseInt(String.valueOf(ht.get("FILE_SIZE"))) <= 300000  && (String.valueOf(ht.get("FILE_TYPE")).equals("image/tiff")||String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")||String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
 					            	cms_scan_yn = "Y";
 					            }
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>
<%	//20170801 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(이미지파일이 아니거나 300kb 초과입니다.)</font>"); }
					}
				}				
			%>                       	
                    	</td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('38')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%	if(f < fee_size && AddUtil.parseInt(cont_etc.getRent_suc_dt())>0 && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > AddUtil.parseInt(fees.getRent_dt()) ){%><%}else{%>
			<%	//20170801 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				}				
			%>                 
											<%	}%>                
			       	
			                </td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="38">	
									
		<%		}else{%>
		
		<!--최초계약서(pdf)-->			
                <% 	scan_num++; 
                		content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"1";
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%if(f==1){%>신규<%}else{%><%=f-1%>차 연장<%}%> 계약서</td>
                    <td align="center"><a href="javascript:scan_reg('1')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && alink_count1==0 && base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="1">   
                		

		<%			if(f==1 && AddUtil.parseInt(fee_etcs.getReg_dt()) >= 20100501){%>
		
		<!--대여개시후계약서(앞)-jpg파일-->			
                <% 	scan_num++; 
                    content_seq = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"17";
                  	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                  	attach_vt_size = attach_vt.size();
                	
                  	if(attach_vt_size > 0){
				              for (int j = 0 ; j < 1 ; j++){
 					              Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('17')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && (alink_count1>0) && alink_scan_1_yn.equals("") && !base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="17">   
                
		<!--대여개시후계약서(뒤)-jpg파일-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"18";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
             				for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일</td>
                    <td align="center"><a href="javascript:scan_reg('18')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 && (alink_count1>0) && alink_scan_1_yn.equals("") && !base.getCar_mng_id().equals("")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="18">                   
                		
													
		<%			}%>
		
		<!--개인(신용)정보 수집·이용·제공·조회동의서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"37";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:scan_reg('37')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
			<%	//20140801부터 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20140731 && fee_size == 1){
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//법인 대표자연대면제는 제외
					}else{
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				}				
			%>    
			               <%	}%>                
			               <%}%>                
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">
                
		<!--개인(신용)정보 수집·이용·제공·조회동의서(공동임차인) - 개인/개인사업자-->		
		<%if(!client.getClient_st().equals("1") && cont_etc.getClient_share_st().equals("1")){%>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"51";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);           					
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:scan_reg('51')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    	<%if(!base.getCar_st().equals("5")){%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
			<%	//20210601부터 필수
				if(AddUtil.parseInt(base.getReg_dt()) >= 20210601 && fee_size == 1){
						scan_cnt++;
						out.println("<font color=red>불충</font>");
				}				
			%>    
			               <%	}%>                
			               <%}%>               
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="37">  
        <%	}%>                      
                	
                	
		<!--CMS동의서jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+Integer.toString(f)+""+"38";
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	String cms_scan_yn = "";
                	if(attach_vt_size > 0){
            				for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            
 					            if(cms_scan_yn.equals("") && AddUtil.parseInt(String.valueOf(ht.get("FILE_SIZE"))) <= 300000  && (String.valueOf(ht.get("FILE_TYPE")).equals("image/tiff")||String.valueOf(ht.get("FILE_TYPE")).equals("image/jpeg")||String.valueOf(ht.get("FILE_TYPE")).equals("image/pjpeg"))){
 					            	cms_scan_yn = "Y";
 					            }
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%>
                    	<%	if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0){%>
<%	//20170801 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(이미지파일이 아니거나 300kb 초과입니다.)</font>"); }
					}
				}				
			%>          
			               <%	}%>                			             	
                    	</td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('38')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//20170801 필수
				if(AddUtil.parseInt(base.getReg_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				}				
			%>                        	
			                </td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="38">
                		
		<%		}%>		
		<%	}//for end%>			
				
				


		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
		
		<!--임직원운전한정특약가입요청서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"40";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "40", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">임직원운전한정특약가입요청서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">임직원운전한정특약가입요청서</td>
                    <td align="center"><a href="javascript:scan_reg('40')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                        &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/insdoc_comemp.pdf' target="_blank"><img src=/acar/images/center/button_in_carins_c.gif align="absmiddle" border="0"></a>
                    </td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="40">   				
			
		<%}%>	
		                
                                				
       		<tr>
 		    <td class=line2 colspan="6"></td>
		</tr>
				
		<%	if(!client.getClient_st().equals("2")){%>
		
		<!--사업자등록증jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"2";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "2", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">사업자등록증jpg</td>
                    <td align="center"><a href="javascript:scan_reg('2')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="2">    
                		
       		<%	}%>
        		
       		<%	if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>
       		
		<!--법인등기부등본-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"3";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "3", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인등기부등본</td>
                    <td align="center"><a href="javascript:scan_reg('3')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="3">
                
		<!--법인인감증명서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"6";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "6", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인인감증명서</td>
                    <td align="center"><a href="javascript:scan_reg('6')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="6">
       		
       		<%	}%>
        		
       		<%	if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2") && cont_etc.getClient_share_st().equals("2")){%>
       		<%	}else{%>
       		<%		if(scan_chk.equals("Y")){%>
       		
		<!--<%=scan_mm%>신분증jpg-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"4";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "4", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>신분증jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>신분증jpg</td>
                    <td align="center"><a href="javascript:scan_reg('4')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(!base.getCar_st().equals("5")){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="4">
                       		
		<!--<%=scan_mm%>주민등록등본-->
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"7";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "7", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>주민등록등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>주민등록등본</td>
                    <td align="center"><a href="javascript:scan_reg('7')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="7">     
                
		<!--<%=scan_mm%>인감증명서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"8";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "8", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center"><%=scan_mm%>인감증명서</td>
                    <td align="center"><a href="javascript:scan_reg('8')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="8">                                        		
       				        		
       		<%		}%>
       		<%	}%>
       		

                <%	//연대보증인 구비서류-----------------------------------
        		if(cont_etc.getGuar_st().equals("1")){
		%>
		
		<!--연대보증서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"14";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "14", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증서</td>
                    <td align="center"><a href="javascript:scan_reg('14')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="14">

		<!--사업자등록증/신분증-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"11";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "11", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">사업자등록증/신분증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">사업자등록증/신분증</td>
                    <td align="center"><a href="javascript:scan_reg('11')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="11">
                
		<!--법인등기부등본/주민등록등본-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"12";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "12", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인등기부등본/주민등록등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인등기부등본/주민등록등본</td>
                    <td align="center"><a href="javascript:scan_reg('12')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="12"> 
                
		<!--법인인감증명서/인감증명서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"13";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "13", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인인감증명서/인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">법인인감증명서/인감증명서</td>
                    <td align="center"><a href="javascript:scan_reg('13')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="13">
		
		
		<%	}%>	
		

		<!--통장사본-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"9";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				          for (int j = 0 ; j < 1 ; j++){
 					          Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">통장사본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">통장사본</td>
                    <td align="center"><a href="javascript:scan_reg('9')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
                <input type='hidden' name="h_file_st" value="9">
                
		<%if(ej_bean.getJg_g_7().equals("3")){%>                
		<!--전기차확약서-->			
                <% 	scan_num++; 
                		content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"44";
	                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "44", 0);
  	              	attach_vt_size = attach_vt.size();
                	
    	            	if(attach_vt_size > 0){
											for (int j = 0 ; j < 1 ; j++){
 												Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">전기차확약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">전기차확약서</td>
                    <td align="center"><a href="javascript:scan_reg('44')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"19";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "19", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험가입특약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험가입특약서</td>
                    <td align="center"><a href="javascript:scan_reg('19')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="19">
                
		<!--보험청약서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"36";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "36", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험청약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험청약서</td>
                    <td align="center"><a href="javascript:scan_reg('36')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="36">  
                
		<!--보험가입증명서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"39";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "39", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < attach_vt_size ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험가입증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">보험가입증명서</td>
                    <td align="center"><a href="javascript:scan_reg('39')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="39">
                
                <%}%>
			
		<%if(now_stat.equals("계약승계")){%>
		
		<!--이전계약자인감증명서-->			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"20";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "20", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);          
                %>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">이전계약자인감증명서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}
                	}else{%>
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">이전계약자인감증명서</td>
                    <td align="center"><a href="javascript:scan_reg('20')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>
                <%	}%>
                <input type='hidden' name="h_file_st" value="20">
                		
		<%}%>
		
		<!--심사자료-->				
                <% 	scan_num++; 
                content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"49";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "49", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">심사자료</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">심사자료</td>
                    <td align="center"><a href="javascript:scan_reg('49')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="49">    
                
		<!--개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)-->	
		<%if(fee_etc.getDriver_add_amt()>0){ %>			
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+fee_etc.getRent_st()+""+"52";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "52", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집.이용.제공.조회동의서jpg(추가운전자)</td>
                    <td align="center"><a href="javascript:scan_reg('52')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="52">        
                
                <% 	scan_num++; 
                	content_seq  = rent_mng_id+""+rent_l_cd+""+fee_etc.getRent_st()+""+"32";
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "32", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">추가운전자운전면허증</td>
                    <td align="center"><a href="javascript:scan_reg('32')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="32">                                  
        <%	}%>                   									
		
		<!--세금계산서-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"10";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "10", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);
 					            scan_num++; 
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">세금계산서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
                <%		}%>
                <%	}%>
                
		<!--매매주문서-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"15";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "15", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					            scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">매매주문서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>
                
		<!--임시운행보험료 영수증-->				
                <%
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"26";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "26", 0);
                	attach_vt_size = attach_vt.size();
                	if(attach_vt_size > 0){
				            for (int j = 0 ; j < 1 ; j++){
 					            Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					            scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">임시운행보험료 영수증<input type="hidden" name="temp_insur_receipt" value="<%=attach_vt_size%>"></td>
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
                    <td align="center">&nbsp;</td>
                    <td align="center"><%=c_db.getNameByIdCode("0028", "", file_st)%></td> 
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>       
                                
		<!--기타-->				
                <% 	
                	content_seq  = rent_mng_id+""+rent_l_cd+""+"1"+""+"5";
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "5", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);    
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">기타</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}%>
                <%	}%>       				
						

        	<!--추가-->		
                <tr>
                  <td align="center"><%=scan_num+1%></td>  
                  <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>                
                  <td align="center">추가</td>                  
                  <td align="center"><a href="javascript:scan_reg('')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                  <td align="center">&nbsp;</td>
                  <td align="center"></td>		  
                </tr>                
        	
		
            </table>
        </td>
    </tr>
    <tr> 
        <td colspan="2" align=right>
		  <span class="b"><a href="javascript:location.reload()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a></span>
		  &nbsp;&nbsp;&nbsp;
		  <span class="b"><a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="클릭하세요">[동기화]</a> (동일 거래처 타계약 스캔파일과 동기화))</span>		  
	</td>
    </tr>   
    
     
	<%for(int i=1; i<=20; i++){//입력값 점검%>
	<tr id=tr_chk<%=i%> style='display:none'>
	    <td><input type='text' name="chk<%=i%>" value='' size="150" class='redtext'></td>
	</tr>	
	<%}%>
	
	<%for(int i=1; i<=20; i++){//결재자%>
	<tr id=tr_sanc<%=i%> style='display:none'>
	    <td><input type='text' name="sanc<%=i%>" value='' size="150" class='chktext'></td>
	</tr>	
	<%}%>	    
	
	
	<%}%>
	
    <%
	//계약서 이메일발송 저장 리스트
	Vector ime_vt =  ImEmailDb.getReNewInfoMailDocSendList(rent_l_cd+""+String.valueOf(fee_size));
	int ime_vt_size = ime_vt.size();
	
	if(!acar_de.equals("1000") && ime_vt_size>0){
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
    

   	<%
					//전자계약서발송
					int d_chk1 = alink_count1;
					//당월이전계약등록분
					int d_chk2 = 0;
					if(AddUtil.parseInt(AddUtil.getDate(5)) > AddUtil.parseInt(base.getReg_dt().substring(0,6))){
						d_chk2 = 1;
					}
					//자체출고연동분
					int d_chk3 = 0;
					if(!cop_bean.getRent_l_cd().equals("")){
						d_chk3 = d_chk3+1;
					}
					if(!String.valueOf(pur_com.get("RENT_L_CD")).equals("") && !String.valueOf(pur_com.get("RENT_L_CD")).equals("null") && !String.valueOf(pur_com.get("USE_YN_ST")).equals("해지")){
						d_chk3 = d_chk3+1;
					}
					
	%>			
    
	<%	if(!san_st.equals("요청") ||  auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>    	
    <%		String sanction_date = base.getSanction_date();
 	    	if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);
    %>
    <tr>
	    <td align='center'>                 

        <!-- 연장계약서 메일보내기 -->
        <%	if(!acar_de.equals("1000") && now_stat.equals("연장") && add_rent_mail_yn==2){%>
	        <a href=javascript:go_mail('newcar_doc','<%=fee_size%>');><img src=/acar/images/center/button_email_renew.gif border=0></a>
	        <br><br>
        <%	}%>
        
		<!-- 계약담당자 -->
        <%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date)){%>
        <!--    계약승계 직접 처리 -->
        <%		if(!acar_de.equals("1000") && !nm_db.getWorkAuthUser("계약결재",ck_acar_id) && now_stat.equals("계약승계")){%>
            <a href="javascript:sanction();" title='계약결재하기'><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <!--    계약결재 요청 -->    		
        <%		}else{%>
            <a href="javascript:sanction_req();" title='계약결제 요청하기'><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <%		}%>
        <!--    계약삭제 요청 -->
        <%		if(from_page.equals("/fms2/lc_rent/lc_b_frame.jsp") || from_page.equals("/agent/lc_rent/lc_b_frame.jsp")){%>
    	<%
					if(d_chk1+d_chk2+d_chk3 > 0 && !now_stat.equals("계약승계") && !now_stat.equals("연장") ){
						out.println("<br><br>※ 전자계약서 발송("+d_chk1+")이 되었거나, 당월 이전 계약등록분("+d_chk2+")이거나, 자체출고관리 연동분("+d_chk3+")입니다. 삭제요청할 수 없습니다. 계약취소 하려면 신차는 출고전해지, 재리스는 개시전해지 등록하십시오.<br><br>");	
					}else{
    		%>        
            <br><br>계약삭제요청사유 : <input type='text' name="sanction_req_delete_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_delete();" title='계약삭제 요청하기'>[계약삭제요청 메시지발송]</a><br><br>
            <!-- ※ 전자계약서 발송이 되었거나, 당월 이전 계약분, 자체출고관리 연동분은 삭제할 수 없습니다. -->
            <br> 
        <%			}%>
        <%		}%>
	    <%	}%>        

		<!-- 계약결재자 --> 		 
		<%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date) && nm_db.getWorkAuthUser("계약결재",ck_acar_id)){%>	    
	    	<a href="javascript:sanction();" title='계약결재하기'><img src=/acar/images/center/button_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		<%		if(san_st.equals("요청")){%>
		    <br><br>결재요청취소사유 : <input type='text' name="sanction_req_cancel_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_cancel();" title='결제요청 취소하기'>[결제요청취소하기]</a><br><br>
		<%		}%>
		<%		if(base.getUse_yn().equals("Y") && !base.getCar_mng_id().equals("")){%>
            <a href="javascript:add_rent_esti_s();" class="btn" title='연장견적하기'><img src=/acar/images/center/button_est_yj.gif align=absmiddle border=0></a>&nbsp;&nbsp;			
            <a href="javascript:sh_car_amt();" class="btn" title='중고차가계산'><img src=/acar/images/center/button_fee_jg.gif align=absmiddle border=0></a>&nbsp;&nbsp;
            <a href="javascript:view_settle('<%=rent_mng_id%>','<%=rent_l_cd%>');" class="btn" title='정산하기'><img src=/acar/images/center/button_js.gif align=absmiddle border=0></a>&nbsp;&nbsp;    
		<%		}%>
	    <%	}%>
	    <%	if(fee_size == 1 && sanction_date.length() > 0 && nm_db.getWorkAuthUser("계약결재",ck_acar_id)){%>
            <a href="javascript:sanction_cancel();" title='계약결제 취소하기'><img src=/acar/images/center/button_cancel_gj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
        <%	}%>
		
	    <%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약변경",ck_acar_id)){%>
	    	<a href="javascript:view_cls('<%=rent_mng_id%>','<%=rent_l_cd%>');" title='계약 해지하기'><img src=/acar/images/center/button_hj.gif align=absmiddle border=0></a>&nbsp;&nbsp;
	    <%	}%>
	    
		<!-- 관리자 -->
	    <%	if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("계약삭제",ck_acar_id)){%>
	    <%    	Vector fee_scd = ScdMngDb.getFeeScdTaxScd("", "3", rent_st, "", "", rent_mng_id, rent_l_cd, base.getCar_mng_id(), "", "");
				int fee_scd_size = fee_scd.size();
	            if(base.getUse_yn().equals("")){
	            	if(fee_scd_size == 0){ //대여료스케줄생성여부 확인
	            		
	            		if(d_chk1+d_chk2+d_chk3 > 0 && !now_stat.equals("계약승계") && !now_stat.equals("연장") ){
	    %>
	        <br>※ 삭제요건이 안됩니다.<br>
	    <% 				}else{%>
	    	<a href="javascript:rent_delete();" title='계약 삭제하기'>[삭제]</a>&nbsp;&nbsp;
	    	<%				if(base.getCar_gu().equals("1") && base.getClient_id().equals("000228") && base.getReg_step().equals("1")){ //신차아마존카1단계%>
	    	<a href="javascript:rent_stat_delete();" title='계약 삭제하기'>[미사용처리]</a>&nbsp;&nbsp;
	    	<%				} %>
        <%					if(now_stat.equals("계약승계")){%> 
	        <select name='suc_rent_delete_yn'>
                <option value="0">정상처리(계약승계취소)</option>
                <option value="1">본건만 처리(중복건삭제)</option>
            </select>&nbsp;&nbsp;	
	    <%					}%>
	    <%				}%>
	    <%			}else{%>
	        <br>※ 스케줄이 있습니다. 청구서 및 스케줄을 정리하고 처리하십시오.<br>
	    <%			}%>
	    <%		}%>
	    <%		if(base.getUse_yn().equals("N")){%>
	        <a href="javascript:rent_delete_recar();" title='계약해지후 보유차 생성하기'>[보유차 생성]</a>&nbsp;&nbsp;
	    <%		}%>
	    <%		if(base.getUse_yn().equals("Y") && !fee_etc.getRent_st().equals("1") && now_stat.equals("연장")){
					if(fee_scd_size == 0){
	    %>
	        <a href="javascript:rent_delete_ext();" title='연장계약 삭제하기'>[연장삭제(<%=fee_etc.getRent_st()%>)]</a>&nbsp;&nbsp;
	    <%			}else{%>
	        <br>※ 연장대여료 스케줄이 있습니다. 청구서 및 스케줄을 정리하고 처리하십시오.(<%=fee_etc.getRent_st()%>)<br>
	    <%			}%>
	    <%		}%>
	    <%	}%>		
		
        </td>
    </tr>   
     
    <tr>
	<td></td>
    </tr>		
    <tr>
        <td align='right'>
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("에이전트관리",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1")) ){%>	  
	    <a href="lc_reg_step2.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("에이전트관리",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("2")) ){%>	  
	    <a href="lc_reg_step3.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_3step.gif align=absmiddle border=0></a>&nbsp;	  
          <%}%>	
	  <%if( nm_db.getWorkAuthUser("전산팀",ck_acar_id) || ((base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id) || cont_etc.getBus_agnt_id().equals(user_id) || nm_db.getWorkAuthUser("에이전트관리",ck_acar_id)) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("3")) ){%>	  
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
    <%	}%>
    
    <%if(!acar_de.equals("1000") && !fee_etc.getBc_est_id().equals("")){%>	
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
		<%if(base.getCar_st().equals("4") && !String.valueOf(rm_cost_cmp.get("RENT_L_CD")).equals("") && !String.valueOf(rm_cost_cmp.get("RENT_L_CD")).equals("null")){%>
		<a href="javascript:view_sale_cost_lw_add()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_p_yuhy.gif border=0 align=absmiddle>(월렌트)</a>		
		<%}%>	
		/ cost_cmp <%=String.valueOf(cost_cmp.get("RENT_L_CD"))%>
		/ t_cost_cmp <%=String.valueOf(t_cost_cmp.get("RENT_L_CD"))%>
		/ rm_cost_cmp <%=String.valueOf(rm_cost_cmp.get("RENT_L_CD"))%>
	</td>
    </tr>			
    <%}%>	  
</table>
  
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--

	var fm = document.form1;

	sum_car_c_amt();
	sum_car_f_amt();
	
	<%if(!base.getCar_st().equals("2")){%>
		
	fm.scan_cnt.value = <%=scan_cnt%>;
	
	cont_chk();
	
	function cont_chk(){

		if(<%=fee_etc.getReg_dt()%> >= 20100501 && toInt(fm.scan_cnt.value) > 0){
			fm.chk1.value = '* 미등록 스캔이 <%=scan_cnt%>건 있습니다. --> 결재 조건이 충족되지 않습니다.';
			<%if(client.getFirm_type().equals("7")){%>
			fm.chk1.value = fm.chk1.value + ' -> 지방자체단체일 경우라도 다른 파일을 대체해서 스캔등록하십시오.';
			<%}%>
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		//재리스 최대개월수 확인
		if(<%=base.getRent_dt()%> > 20211101 && '<%=max_over_yn%>'=='Y' && '<%=base.getCar_st()%>'!='5'){
			fm.chk18.value = '* 재리스 계약기간이 최대개월수 <%=max_use_mon%>개월을 경과합니다.  --> 결재 조건이 충족되지 않습니다.';
			tr_chk18.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		//재리스 최대개월수 확인
		if(<%=base.getRent_dt()%> > 20211101 && '<%=max_over_yn%>'=='' && <%=max_use_mon%> > 0 && '<%=user_id%>'=='000029' && '<%=base.getCar_st()%>'!='5'){
			fm.sanc1.value = '* 재리스 최대개월수는 <%=max_use_mon%>개월 입니다.';
			tr_sanc1.style.display = '';			
		}
		
		//결재자 입력값 확인
		if(<%=base.getRent_dt()%> > 20070831){
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if('<%=base.getDriving_age()%>'=='1' && '<%=ins.getAge_scp()%>'!='1'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='3' && '<%=ins.getAge_scp()%>'!='4'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='0' && '<%=ins.getAge_scp()%>'!='2'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getDriving_age()%>'=='2' && '<%=ins.getAge_scp()%>'!='3'){
				fm.sanc7.value = '* 보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc7.style.display = '';
			}
			if('<%=base.getGcp_kd()%>'=='2' && '<%=ins.getVins_gcp_kd()%>'!='3'){
				fm.sanc8.value = '* 보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc8.style.display = '';
			}
			if('<%=base.getGcp_kd()%>'=='1' && '<%=ins.getVins_gcp_kd()%>'!='4'){
				fm.sanc8.value = '* 보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc8.style.display = '';
			}
			if('<%=base.getBacdt_kd()%>'=='2' && '<%=ins.getVins_bacdt_kd()%>'!='6'){
				fm.sanc9.value = '* 보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc9.style.display = '';
			}
			if('<%=base.getBacdt_kd()%>'=='1' && '<%=ins.getVins_bacdt_kd()%>'!='5'){
				fm.sanc9.value = '* 보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.';
				tr_sanc9.style.display = '';
			}
			<%}%>
		}
		
		<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
		//필수이력 체크
		if(<%=base.getRent_dt()%> > 20150201){
			if('<%=max_gins.getGi_st()%>' == '1' && ( '<%=max_gins.getGi_jijum()%>' == '' || '<%=max_gins.getGi_amt()%>' == '0' )){
				fm.chk2.value = '* 보증보험 가입이나 가입정보가 없습니다.';
				tr_chk2.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			if('<%=fee.getFee_pay_st()%>' == '1'){
				if('<%=cms.getCms_bank()%>' == '' || '<%=cms.getCms_acc_no()%>' == '' || '<%=cms.getCms_dep_nm()%>' == '' || '<%=cms.getCms_dep_ssn()%>' == ''	){
					fm.chk8.value = '* 자동이체인데 은행정보가 없습니다. 은행,계좌,예금주명,예금주 생년월일/사업자번호를 확인하세요';
					tr_chk8.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			}
		}
		<%}else{%>
		//필수이력 체크
		if(<%=base.getRent_dt()%> > 20070831){
			<%if(!base.getCar_st().equals("5")){%>
				<%	if(fee_size==1){%>
					if('<%=client.getClient_st()%>' == '1' && '<%=cont_etc.getClient_guar_st()%>' == ''){
						fm.chk2.value = '* 대표이사보증 유무가 없습니다.';
						tr_chk2.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=client.getClient_st()%>' == '1' && '<%=cont_etc.getClient_guar_st()%>'=='2' && ('<%=cont_etc.getGuar_con()%>' == '' || '<%=cont_etc.getGuar_sac_id()%>' == '')){
						fm.chk2.value = '* 대표이사보증 면제조건 및 결재자가 없습니다.';
						tr_chk2.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=cont_etc.getGuar_st()%>' == ''){
						fm.chk3.value = '* 연대보증인 유무가 없습니다.';
						tr_chk3.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					var imm_amt = <%if(base.getCar_st().equals("5")){%>100000<%}else{%><%if(car.getCar_origin().equals("2")){%>500000<%}else{%>300000<%}%><%}%>;
					<%if(ej_bean.getJg_w().equals("1")){//수입차%>
						if('<%=base.getCar_ja()%>' != imm_amt && ('<%=cont_etc.getJa_reason()%>' == '' || '<%=cont_etc.getRea_appr_id()%>' == '')){
								fm.chk6.value = '* 자차면책금 변경사유 또는 결재자가 없습니다.';
								tr_chk6.style.display = '';
								fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
						}						
					<%}else{%>
						if('<%=base.getCar_ja()%>' != '300000' && '<%=base.getCar_ja()%>' != '200000'<%if(base.getCar_st().equals("3")){%> && '<%=base.getCar_ja()%>' != '100000'<%}%>){
							if('<%=base.getCar_ja()%>' != imm_amt && ('<%=cont_etc.getJa_reason()%>' == '' || '<%=cont_etc.getRea_appr_id()%>' == '')){
								fm.chk6.value = '* 자차면책금 변경사유 또는 결재자가 없습니다.';
								tr_chk6.style.display = '';
								fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
							}
						}
					<%}%>
				<%	}%>
				
				if('<%=fee_etc.getCredit_sac_id()%>' == ''){
					fm.chk9.value = '* 채권확보 결재자가 없습니다.';
					tr_chk9.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				<%	if(fee_size==1){%>
					if('<%=fee.getDef_st()%>' == 'Y' && ('<%=fee.getDef_remark()%>' == '' || '<%=fee.getDef_sac_id()%>' == '')){
						fm.chk10.value = '* 거치여부가 있으나 거치사유 또는 거치 결재자가  없습니다.';
						tr_chk10.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					if('<%=fee.getPrv_dlv_yn()%>' == 'Y' && '<%=taecha.getTae_sac_id()%>' == ''){
						fm.chk12.value = '* 출고전대차 결재자가 없습니다.';
						tr_chk12.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
				<%	}%>
            
            	<%if(fee_size ==1 && base.getCar_gu().equals("0")){%>
					//보유차계약시점주행거리                   
            		var over_bas_km = toInt(parseDigit(fm.over_bas_km.value));
            		if(over_bas_km == 0){
	            		fm.sanc10.value = '* 재리스 보유차 계약시점 주행거리가 없습니다.';
	            		tr_sanc10.style.display = '';
	            		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;                              
            		}
            	<%}%>
            
				if('<%=max_fee.getOpt_chk()%>' == ''){
					fm.chk7.value = '* 매입옵션 유무가 없습니다.';
					tr_chk7.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=max_fee.getOpt_chk()%>' == '1' && ('<%=max_fee.getOpt_per()%>' == '' || '<%=max_fee.getOpt_s_amt()%>'==0) && fm.rent_l_cd.value != 'S111HHGR00245'){
					fm.chk7.value = '* 매입옵션율 또는 매입옵션금액이 없습니다.';
					tr_chk7.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			
				if('<%=max_fee.getFee_s_amt()%>'=='0' && '<%=max_fee.getPp_s_amt()+max_fee.getGrt_amt_s()+max_fee.getIfee_s_amt()%>'=='0'){
					fm.chk17.value = '* 선수금과 대여료 계약요금이 없습니다.';
					tr_chk17.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=fee.getFee_pay_st()%>' == '1' && ('<%=cms.getCms_bank()%>' == '' || '<%=cms.getCms_acc_no()%>' == '' || '<%=cms.getCms_dep_nm()%>' == '' || '<%=cms.getCms_dep_ssn()%>' == '') ){
					fm.chk8.value = '* 자동이체인데 은행정보가 없습니다. 은행,계좌,예금주명,예금주 생년월일/사업자번호를 확인하세요';
					tr_chk8.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if('<%=base.getBus_id2()%>' == ''){
					fm.chk5.value = '* 영업담당자가 없습니다.';
					tr_chk5.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
				if(<%=client_tel_cnt%> < 2 ){
					fm.chk15.value = '* 고객 연락처는 중복되지 않는 번호가 2개 이상이여야 합니다.<%if(client.getClient_st().equals("1")){%>(법인고객:회사전화,대표자휴대폰,차량이용자휴대폰)<%}else if(client.getClient_st().equals("2")){%>(개인고객:고객휴대폰,자택전화,직장전화)<%}else{%>(개인사업자:회사전화,대표자휴대폰,자택전화,차량이용자휴대폰)<%}%>';
					tr_chk15.style.display = '';
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}		
				<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
					//영업담당 영업구분 체크
					if('<%=pur.getPur_bus_st()%>' == ''){
						fm.chk12.value = '* 영업담당 영업구분이 없습니다.';
						tr_chk12.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
					//출고담당 출고구분 체크
					if('<%=pur.getOne_self()%>' == ''){
						fm.chk13.value = '* 출고담당 출고구분이 없습니다.';
						tr_chk13.style.display = '';
						fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
					}
				<%}%>
			<%}%>
		}
		<%}%>
		
		
		if(fm.est_area.value == ''){
			fm.chk4.value = '* 차량이용지역이 없습니다.';
			tr_chk4.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		
		if(<%=base.getCar_ja()%> == 0){
			fm.chk6.value = '* 자차면책금이 없습니다.';
			tr_chk6.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		<%if(!base.getCar_st().equals("5")){%>
		if('<%=max_fee.getCls_r_per()%>' == ''){
			fm.chk8.value = '* 중도해지위약율이 없습니다.';
			tr_chk8.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}
		<%}%>
		if('<%=cont_etc.getRec_st()%>' == ''){
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
    	
    	<%if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("Y")){%>
    	<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
		fm.chk16.value = '* 개입사업자 고객의 임직원운전한정특약이 가입입니다. 승인처리하십시오.';
		tr_chk16.style.display = '';
		fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    	<%	}else{%>
    	<%		if(base.getOthers().equals("")){%>	
		fm.chk16.value = '* 개입사업자 고객의 임직원운전한정특약이 가입입니다. 가입사유를 보험관리-비고에 입력하십시오.';
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
	
	<%if(base.getCar_gu().equals("1")){%>
	//페이지 로드 시 출고보전수당 지급여부 초기화						2017. 12. 05
	//DB에서 값을 가져오면 출력하는 것으로 수정(일부소스 제거)		2017. 12. 13
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
			}	
		}else {		// 영업구분 선택이 안되있는 경우 출고보전수당 지급여부를 보여준다 2017.12.18
			$("#dlv_con_commi_yn_tr").show();
		}
	});	
	<%}%>
	
	
	//바로가기
	var s_fm 	= parent.top_menu.document.form1;
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
