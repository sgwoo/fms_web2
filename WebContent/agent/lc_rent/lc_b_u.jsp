<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.user_mng.*, acar.estimate_mng.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.car_register.*, acar.car_office.*, acar.con_ins.*, acar.ext.*, card.*"%>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     	scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    	scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               	scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"		scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase" 	scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean" 		scope="page"/>
<jsp:useBean id="ae_db"     class="acar.ext.AddExtDatabase" 		scope="page"/>
<jsp:useBean id="ln_db" scope="page" class="acar.alink.ALinkDatabase"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?""        :request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")  ==null?acar_br   :request.getParameter("br_id");
	
	String s_kd 		= request.getParameter("s_kd")	==null? "":request.getParameter("s_kd");
	String t_wd 		= request.getParameter("t_wd")	==null? "" :request.getParameter("t_wd");
	String andor 		= request.getParameter("andor")	==null?"":request.getParameter("andor");
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 		= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 		= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();	
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	
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
	}
	
	if(!base.getCar_mng_id().equals("")){
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
	ContEvalBean eval1 = new ContEvalBean();
	ContEvalBean eval2 = new ContEvalBean();
	ContEvalBean eval3 = new ContEvalBean();
	ContEvalBean eval4 = new ContEvalBean();
	ContEvalBean eval5 = new ContEvalBean();
	ContEvalBean eval6 = new ContEvalBean();
	ContEvalBean eval7 = new ContEvalBean();
	ContEvalBean eval8 = new ContEvalBean();
	
	//이행보증보험
	ContGiInsBean gins = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, "1");
	int gin_size 	= a_db.getGinCnt(rent_mng_id, rent_l_cd);
	if(gin_size==0) gin_size = 1;
	
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
	
	
	//장기전자계약서
	Hashtable alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, "1");	
	
	if(now_stat.equals("계약승계")){
		alink_lc_rent = ln_db.getAlinkEndLcRent(rent_l_cd, cont_etc.getSuc_rent_st());
	}
	
	
	
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
	
	//스캔파일 체크여부
	String scan_chk = "Y";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page;
	
	String valus_t = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st=t&from_page="+from_page;
	
	int fee_opt_amt = 0;
	
	int zip_cnt =4;
	
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}
	
	//기본DC 가져오기
	String car_d_dt = "";	
	car_d_dt = e_db.getDc_b_dt(cm_bean.getCar_comp_id()+""+cm_bean.getCode(), "dc", base.getRent_dt(), cm_bean.getCar_b_dt());
	CarDcBean cd_bean = cmb.getCarDcBaseCase(cm_bean.getCar_comp_id(), cm_bean.getCode(), car_d_dt, cm_bean.getCar_b_dt());	
	
	//이름조회
	int user_idx = 0;	
	
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
	
	//차량등록지역
	CodeBean[] code32 = c_db.getCodeAll3("0032");
	int code32_size = code32.length;

	//차량인수지
	CodeBean[] code35 = c_db.getCodeAll3("0035");
	int code35_size = code35.length;
	
  	//전기차 고객주소지
  	CodeBean[] code34 = c_db.getCodeAll3("0034");
  	int code34_size = code34.length;	
	
  	//수소차 고객주소지
  	CodeBean[] code37 = c_db.getCodeAll3("0037");
  	int code37_size = code37.length;	
  	
  	//운전자격검증결과
  	CodeBean[] code50 = c_db.getCodeAll3("0050");
  	int code50_size = code50.length;	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
//반올림
function getCutRoundNumber(num, place){
	var returnNum;
	var st="1";
	return Math.round( num * Math.pow(10,parseInt(place,10)) ) / Math.pow(10,parseInt(place,10));
}

	function replaceFloatRound(per){		return Math.round(per*1000)/10;		}
	//대차보증금승계조회
	function search_grt_suc(){		var fm = document.form1;	window.open("/agent/car_pur/s_grt_suc.jsp?from_page=/agent/car_pur/pur_doc_u.jsp&t_wd=<%=base.getClient_id()%>&rent_l_cd=<%=rent_l_cd%>&rent_dt=<%=base.getRent_dt()%>", "SERV_GRT_OFF", "left=10, top=10, width=800, height=500, scrollbars=yes, status=yes, resizable=yes");	}
	//대차보증금승계취소
	function cancel_grt_suc()	{		var fm = document.form1;		fm.grt_suc_l_cd.value = '';		fm.grt_suc_m_id.value = '';		fm.grt_suc_c_no.value = '';		fm.grt_suc_o_amt.value = '';		fm.grt_suc_r_amt.value = '';	}
	//리스트
	function list(){
		var fm = document.form1;	
		if(fm.from_page.value == '')	fm.action = 'lc_b_frame.jsp';
		else				fm.action = fm.from_page.value;
		fm.target = 'd_content';
		fm.submit();
	}	

	//2단계 -----------------------------------------------------------
	
	//고객 조회
	function search_client(){		window.open("/agent/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp", "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");	}
	//고객 보기
	function view_client(){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}			window.open("/agent/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");	}
	//지점/현장 조회
	function search_site()	{		var fm = document.form1;		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}		window.open("/agent/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=500, scrollbars=yes, status=yes, resizable=yes");	}
	//지점/현장 보기
	function view_site()	{		var fm = document.form1;		if(fm.site_id.value == ""){ alert("선택된 지점이 없습니다."); return;}		window.open("/agent/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/agent/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");	}
	//관계자 조회
	function search_mgr(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}			window.open("search_mgr.jsp?idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	}
	//주소 조회
	function search_post(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}			window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		}
	//대표이사보증
	function cng_input2(){	
		var fm = document.form1;		
		if(fm.client_guar_st[0].checked == true){ //가입
			tr_client_guar.style.display = 'none';
		}else{	//면제
			tr_client_guar.style.display = '';
		}
	}
	//공동임차인 운전면허검증
	function cng_input4(){
		<%if(client.getClient_st().equals("2")){%>
		if(document.form1.client_share_st[0].checked==true){
			tr_client_share_st_test.style.display='';//가입
		}else{
			tr_client_share_st_test.style.display='none';//면제
		}
		<%}%>
	}	
	//연대보증인
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 	//가입
			tr_guar2.style.display	= '';
		}else{	//면제
			tr_guar2.style.display	= 'none';
		}
	}	
	function gur_display_add(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(size == 0){				tr_gur_info0.style.display	= '';			tr_gur_eval0.style.display	= '';			tr_gur_ass0.style.display	= '';
		}else if(size == 1){	tr_gur_info1.style.display	= '';			tr_gur_eval1.style.display	= '';			tr_gur_ass1.style.display	= '';
		}else if(size == 2){	tr_gur_info2.style.display	= '';			tr_gur_eval2.style.display	= '';			tr_gur_ass2.style.display	= '';
		}else{								alert('연대보증인은 최대 3인까지 입니다.');		}
		fm.gur_size.value = size+1;
	}
	//관계자 조회
	function search_gur(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}			window.open("search_gur.jsp?idx="+idx+"&client_id="+fm.client_id.value, "GUR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		}
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	
	//3단계 -----------------------------------------------------------
		
	//판정기관별 신용등급 디스플레이
	function SetEval_gr(idx){
		var fm = document.form1;
		var gr_size = toInt(fm.eval_cnt.value)+1;	
		if(gr_size > 1){
			if(fm.eval_off[idx].value == '2' || fm.eval_off[idx].value == '3'){		
				fm.eval_gr[idx].length = <%= gr_cd1.length+1 %>;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '선택';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off[idx].value == '1'){		
				if(fm.eval_gu[idx].value == '1'){
					fm.eval_gr[idx].length = <%= gr_cd3.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '선택';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr[idx].length = <%= gr_cd2.length+1 %>;
					fm.eval_gr[idx].options[0].value = '';
					fm.eval_gr[idx].options[0].text = '선택';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr[idx].options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr[idx].options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr[idx].length = 1;
				fm.eval_gr[idx].options[0].value = '';
				fm.eval_gr[idx].options[0].text = '선택';							
			}
		}else{
			if(fm.eval_off.value == '2' || fm.eval_off.value == '3'){		
				fm.eval_gr.length = <%= gr_cd1.length+1 %>;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '선택';			
				<%for(int i =0; i<gr_cd1.length; i++){
					CodeBean cd = gr_cd1[i];%>
				fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
				fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
				<%}%>				
			}else if(fm.eval_off.value == '1'){		
				if(fm.eval_gu.value == '1'){
					fm.eval_gr.length = <%= gr_cd3.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '선택';			
					<%for(int i =0; i<gr_cd3.length; i++){
						CodeBean cd = gr_cd3[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>								
				}else{
					fm.eval_gr.length = <%= gr_cd2.length+1 %>;
					fm.eval_gr.options[0].value = '';
					fm.eval_gr.options[0].text = '선택';			
					<%for(int i =0; i<gr_cd2.length; i++){
						CodeBean cd = gr_cd2[i];%>
					fm.eval_gr.options[<%=i+1%>].value = '<%=cd.getNm_cd()%>';
					fm.eval_gr.options[<%=i+1%>].text  = '<%=cd.getNm()%>';
					<%}%>		
				}
			}else{
				fm.eval_gr.length = 1;
				fm.eval_gr.options[0].value = '';
				fm.eval_gr.options[0].text = '선택';							
			}
		}
	} 

	
	//4단계 -----------------------------------------------------------

		
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_car(obj)	{		var keyValue = event.keyCode;		if (keyValue =='13') set_car_amt(obj);	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_car_amt(obj)
	{
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.car_cs_amt){ 	//차량기본가격 공급가
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) * 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cs_amt){ 	//선택사항 공급가
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) * 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cs_amt){ 	//색상 공급가
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) * 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cs_amt){ 	//탁송료 공급가
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) * 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cs_amt){ 	//매출DC 공급가
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) * 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));			
		}else if(obj==fm.car_fs_amt){ 	//면세차량가격 공급가
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) * 0.1 );
			fm.car_f_amt.value	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));			
		}else if(obj==fm.tax_dc_s_amt){ 	//친환경차 개소세 감면액 공급가
			fm.tax_dc_v_amt.value = parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) * 0.1 );
			fm.tax_dc_amt.value		= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));			
		

		}else if(obj==fm.car_cv_amt){ 	//차량기본가격 부가세
			fm.car_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) / 0.1 );
			fm.car_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.car_cv_amt.value)));
		}else if(obj==fm.opt_cv_amt){ 	//선택사항 부가세
			fm.opt_cs_amt.value = parseDecimal(toInt(parseDigit(fm.opt_cv_amt.value)) / 0.1 );
			fm.opt_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)));
		}else if(obj==fm.col_cv_amt){ 	//색상 부가세
			fm.col_cs_amt.value = parseDecimal(toInt(parseDigit(fm.col_cv_amt.value)) / 0.1 );
			fm.col_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.col_cs_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)));
		}else if(obj==fm.sd_cv_amt){ 	//탁송료 부가세
			fm.sd_cs_amt.value = parseDecimal(toInt(parseDigit(fm.sd_cv_amt.value)) / 0.1 );
			fm.sd_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.sd_cs_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)));
		}else if(obj==fm.dc_cv_amt){ 	//매출DC 부가세
			fm.dc_cs_amt.value = parseDecimal(toInt(parseDigit(fm.dc_cv_amt.value)) / 0.1 );
			fm.dc_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.dc_cs_amt.value)) + toInt(parseDigit(fm.dc_cv_amt.value)));
		}else if(obj==fm.car_fv_amt){ 	//면세차량가격 부가세
			fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) / 0.1 );
			fm.car_f_amt.value 	= parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.car_fv_amt.value)));
		}else if(obj==fm.tax_dc_v_amt){ 	//친환경차 개소세 감면액 부가세
			fm.tax_dc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_v_amt.value)) / 0.1 );
			fm.tax_dc_amt.value 	= parseDecimal(toInt(parseDigit(fm.tax_dc_s_amt.value)) + toInt(parseDigit(fm.tax_dc_v_amt.value)));
		

		}else if(obj==fm.car_c_amt){ 	//차량기본가격 합계
			fm.car_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_cs_amt.value)));			
		}else if(obj==fm.opt_c_amt){ 	//선택사항 합계
			fm.opt_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.opt_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.opt_cs_amt.value)));			
		}else if(obj==fm.col_c_amt){ 	//색상 합계
			fm.col_cs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.col_cv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.col_cs_amt.value)));			
		}else if(obj==fm.sd_c_amt){ 	//탁송료 합계
			fm.sd_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.sd_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.sd_cs_amt.value)));			
		}else if(obj==fm.dc_c_amt){ 	//매출DC 합계
			fm.dc_cs_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.dc_cv_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.dc_cs_amt.value)));			
		}else if(obj==fm.car_f_amt){ 	//면세차량가격 합계
			fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.car_fs_amt.value)));
		}else if(obj==fm.tax_dc_amt){ 	//친환경차 개소세 감면액 합계
			fm.tax_dc_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(obj.value))));
			fm.tax_dc_v_amt.value 	= parseDecimal(toInt(parseDigit(obj.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));			
		}
		
		sum_tax_amt();
		sum_car_c_amt();
		sum_car_f_amt();
	
	}

	//차량 특소세 자동계산
	function set_tax_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;
		
		if(obj==fm.spe_tax){ 	//특소세
			fm.edu_tax.value = parseDecimal(toInt(parseDigit(obj.value))*(30/100));		
		}
		fm.tot_tax.value 	= parseDecimal(toInt(parseDigit(fm.spe_tax.value)) + toInt(parseDigit(fm.edu_tax.value)) );					
	}

	//보증보험료 자동계산
	function set_gi_amt(){
		var fm = document.form1;
		sum_pp_amt();			
	}
	
	//특소세전차량가 가져가기
	function setVar_o_123(car_price){
		var fm = document.form1;
		var o_1 = car_price;
		//차종별 특소세율
		var o_2 = <%=ej_bean.getJg_3()%>;	
		//특소세전차량가 o_3 = o_1/(1+o_2), 차량가격/(1+특소세율);
		var o_3 = Math.round(o_1/(1+o_2));	
		fm.v_o_1.value = o_1;
		fm.v_o_2.value = o_2;
		fm.v_o_3.value = o_3;
	}

	//차량 특소세 합계
	function sum_tax_amt(){
		var fm = document.form1;
		
		if(toInt(parseDigit(fm.car_f_amt.value)) == 0){	sum_car_f_amt(); }
		
		var purc_gu 		= fm.purc_gu.value;		
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_c_price = setCarPrice('car_c_price');
		var car_f_price = setCarPrice('car_f_price');
		var a_e = toInt(s_st);
		setVar_o_123(car_f_price);
		if(purc_gu == '1'){//과세1
			fm.tot_tax.value = parseDecimal(car_c_price-toInt(fm.v_o_3.value));
			fm.pay_st[1].selected = true;
		}else{//과세2(면세)	 	
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
				fm.tot_tax.value = parseDecimal(Math.round(toInt(fm.v_o_1.value)*toFloat(fm.v_o_2.value)));
			}else{
				fm.tot_tax.value = parseDecimal(car_c_price-toInt(parseDigit(fm.car_f_amt.value)));
			}				
			fm.pay_st[2].selected = true;
		}
		fm.spe_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value))/6.5*5);	
		fm.edu_tax.value 	= parseDecimal(toInt(parseDigit(fm.tot_tax.value)) - toInt(parseDigit(fm.spe_tax.value)) );		
	}
	
	//차량 소비자가 합계
	function sum_car_c_amt(){
		var fm = document.form1;
		
		fm.tot_cs_amt.value = parseDecimal(toInt(parseDigit(fm.car_cs_amt.value)) + toInt(parseDigit(fm.opt_cs_amt.value)) + toInt(parseDigit(fm.col_cs_amt.value)) - toInt(parseDigit(fm.tax_dc_s_amt.value)));
		fm.tot_cv_amt.value = parseDecimal(toInt(parseDigit(fm.car_cv_amt.value)) + toInt(parseDigit(fm.opt_cv_amt.value)) + toInt(parseDigit(fm.col_cv_amt.value)) - toInt(parseDigit(fm.tax_dc_v_amt.value)));
		fm.tot_c_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)) + toInt(parseDigit(fm.tot_cv_amt.value)) );		
	}
	
	//차량 구입가 합계
	function sum_car_f_amt_b(){
		var fm = document.form1;
		fm.tot_fs_amt.value = parseDecimal(toInt(parseDigit(fm.car_fs_amt.value)) + toInt(parseDigit(fm.sd_cs_amt.value)) - toInt(parseDigit(fm.dc_cs_amt.value)) );
		fm.tot_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_fv_amt.value)) + toInt(parseDigit(fm.sd_cv_amt.value)) - toInt(parseDigit(fm.dc_cv_amt.value)) );
		fm.tot_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_fs_amt.value)) + toInt(parseDigit(fm.tot_fv_amt.value)) );
	}
	
	//차가 구입가 합계
	function sum_car_f_amt(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		sum_car_f_amt_b();
		var car_price2 = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price2);
    	car_price2 = car_price2 - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));
		if(fm.car_gu.value != '1'){
			car_price2 	= toInt(parseDigit(fm.sh_amt.value));
		}
		//채권확보
		if(car_price2 <= 45000000)			fm.credit_per.value = '20';
		else if(car_price2 > 45000000)	fm.credit_per.value = '25';
		//전기차는 기본 보증금에서 10% 빼준다
   	if('<%=ej_bean.getJg_g_7()%>' == '3'){ fm.credit_per.value = toInt(fm.credit_per.value)-10; }
		//수소차는 기본 보증금에서 15% 빼준다
   	if('<%=ej_bean.getJg_g_7()%>' == '4'){ fm.credit_per.value = toInt(fm.credit_per.value)-15; }
		var credit_per = toInt(fm.credit_per.value)/100;
		fm.credit_amt.value = parseDecimal(car_price2*credit_per);
	}	
	

	//차가 구입가 합계
	function sum_car_f_amt2(){
		var fm = document.form1;
		
		var purc_gu 		= fm.purc_gu.value;
		var car_st 		= fm.car_st.value;
		var s_st 		= fm.s_st.value;
		var dpm 		= fm.dpm.value;
		var car_price = setCarPrice('car_c_price');
		if(fm.dc_cs_amt.value == '' && fm.dc_c_amt.value != '0') set_car_amt(fm.dc_c_amt);
		fm.car_fs_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cs_amt.value)));
		fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.tot_cv_amt.value)));
		fm.car_f_amt.value  = parseDecimal(toInt(parseDigit(fm.tot_c_amt.value)));
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }	
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세)
			//수입차
			if('<%=ej_bean.getJg_w()%>'=='1'){	
				fm.car_f_amt.value  = parseDecimal(<%=cm_bean.getCar_b_p2()%>);
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));	
			}else if('<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				fm.car_f_amt.value  = parseDecimal(toInt(fm.v_o_3.value));
				fm.car_fs_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.car_f_amt.value))));
				fm.car_fv_amt.value = parseDecimal(toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.car_fs_amt.value)));			
			}
		}
		sum_car_f_amt_b();
		sum_tax_amt();
	}
	
	//매출DC
	function search_dc(){
		var fm = document.form1;
		window.open("search_dc.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&car_fs_amt="+fm.car_fs_amt.value+"&car_fv_amt="+fm.car_fv_amt.value, "COMP_DC", "left=100, top=100, height=200, width=800, scrollbars=yes, status=yes");
	}
	
	//피보험자-고객 디스플레이
	function display_ip(){
		var fm = document.form1;
		var insur_per = fm.insur_per.options[fm.insur_per.selectedIndex].value;
		if(insur_per == '1'){ 						//아마존카
			tr_ip.style.display		= 'none';
			tr_ip2.style.display		= 'none';
		}else{								//고객
			tr_ip.style.display		= '';
			tr_ip2.style.display		= '';
		}		
	}	
	
	//보증보험 디스플레이
	function display_gi(){
		var fm = document.form1;
		if(fm.gi_st[0].checked == true){				//가입
			<%for(int f=1; f<=gin_size ; f++){%>
			tr_gi<%=f+1%>.style.display		= '';
			<%}%>
		}else{								//면제
			<%for(int f=1; f<=gin_size ; f++){%>
			tr_gi<%=f+1%>.style.display		= 'none';
			<%}%>			
		}		
	}	
		
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		var rent_way = fm.rent_way.value;
		if(fm.con_mon.value == ''){
			return;
		}
		fm.action='/fms2/lc_rent/get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();	
	}
	
	//등록/수정: 차량가격 입력시 자동계산으로 가게..
	function enter_fee(obj, rent_dt)	{		var keyValue = event.keyCode;		if (keyValue =='13') set_fee_amt(obj, rent_dt);	}	
	//등록/수정: 공급가, 부가세, 합계 입력시 자동계산
	function set_fee_amt(obj, rent_dt)
	{
		var fm = document.form1;	
		var car_price = setCarPrice('car_price2');
		var s_dc_amt = setDcAmt2(car_price);
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		//특판출고
		//20190513 미사용
		//if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
		//	s_dc_amt = <%=cd_bean.getCar_d_p()%>;
		//	var s_dc_per = <%=cd_bean.getCar_d_per()%>;
		//	if(s_dc_per > 0){ s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt; }
		//}
		car_price = car_price - s_dc_amt;
		
		
		//보증금---------------------------------------------------------------------------------
		if(obj==fm.grt_s_amt){ 			//보증금 공급가
			obj.value = parseDecimal(obj.value);
			fm.grt_amt.value 	= fm.grt_s_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
			}
			sum_pp_amt();			
		}else if(obj==fm.grt_amt){ 		//보증금 합계
			obj.value = parseDecimal(obj.value);
			fm.grt_s_amt.value 	= fm.grt_amt.value;
			if(car_price > 0){
				fm.gur_p_per.value 	= replaceFloatRound(toInt(parseDigit(fm.grt_s_amt.value)) / car_price );
				
			}
			sum_pp_amt();		
		//선납금---------------------------------------------------------------------------------
		}else if(obj==fm.pp_s_amt){ 	//선납금 공급가
			obj.value = parseDecimal(obj.value);
			fm.pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) * 0.1 );
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}
			sum_pp_amt();			
		}else if(obj==fm.pp_v_amt){ 	//선납금 부가세
			obj.value = parseDecimal(obj.value);
			fm.pp_amt.value		= parseDecimal(toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.pp_v_amt.value)));			
		
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}		
			sum_pp_amt();	
		}else if(obj==fm.pp_amt){ 		//선납금 합계
			obj.value = parseDecimal(obj.value);
			fm.pp_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.pp_amt.value))));
			fm.pp_v_amt.value = parseDecimal(toInt(parseDigit(fm.pp_amt.value)) - toInt(parseDigit(fm.pp_s_amt.value)));			
					
			if(car_price > 0){
				fm.pere_r_per.value 	= replaceFloatRound(toInt(parseDigit(fm.pp_amt.value)) / car_price );
			}			
			sum_pp_amt();
		//개시대여료---------------------------------------------------------------------------------			
		}else if(obj==fm.ifee_s_amt){ 	//개시대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ifee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) * 0.1 );
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}			
			sum_pp_amt();
		}else if(obj==fm.ifee_v_amt){ 	//개시대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.ifee_amt.value		= parseDecimal(toInt(parseDigit(fm.ifee_s_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)));			
		
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
				
			}	
			sum_pp_amt();					
		}else if(obj==fm.ifee_amt){ 	//개시대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ifee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ifee_amt.value))));
			fm.ifee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ifee_amt.value)) - toInt(parseDigit(fm.ifee_s_amt.value)));			
					
			if(toInt(parseDigit(fm.ifee_amt.value)) > 0 && toInt(parseDigit(fm.fee_amt.value)) > 0){
				fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));	
				fm.fee_pay_tm.value 	= toInt(fm.con_mon.value)-toInt(fm.pere_r_mth.value);
			}	
			sum_pp_amt();	
		//최대잔가율---------------------------------------------------------------------------------			
		}else if(obj==fm.max_ja){ 		//최대잔가율
			fm.ja_amt.value 	= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.max_ja.value) /100,-3) );
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));			
		}else if(obj==fm.ja_s_amt){ 	//최대잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) * 0.1 );
			fm.ja_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
			//fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_v_amt){ 	//최대잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_s_amt.value)) + toInt(parseDigit(fm.ja_v_amt.value)));			
		}else if(obj==fm.ja_amt){		//최대잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_s_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_amt.value))));
			fm.ja_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ja_amt.value)) - toInt(parseDigit(fm.ja_s_amt.value)));		
			if(car_price > 0){	
				fm.max_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
			}

				
		//적용잔가율---------------------------------------------------------------------------------			
		}else if(obj==fm.app_ja){ 		//적용잔가율
			fm.ja_r_amt.value 		= parseDecimal(getCutRoundNumber(car_price * toFloat(fm.app_ja.value) /100,-3) );
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));			
		}else if(obj==fm.ja_r_s_amt){ 	//적용잔가 공급가
			obj.value = parseDecimal(obj.value);
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) * 0.1 );
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
			//fm.app_ja.value 		= replaceFloatRound(toInt(parseDigit(fm.ja_amt.value)) / car_price );
		}else if(obj==fm.ja_r_v_amt){ 	//적용잔가 부가세
			obj.value = parseDecimal(obj.value);
			fm.ja_r_amt.value		= parseDecimal(toInt(parseDigit(fm.ja_r_s_amt.value)) + toInt(parseDigit(fm.ja_r_v_amt.value)));			
		}else if(obj==fm.ja_r_amt){		//적용잔가 합계
			obj.value = parseDecimal(obj.value);
			fm.ja_r_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.ja_r_amt.value))));
			fm.ja_r_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.ja_r_amt.value)) - toInt(parseDigit(fm.ja_r_s_amt.value)));		
			if(car_price > 0){	
				fm.app_ja.value 	= replaceFloatRound(toInt(parseDigit(fm.ja_r_amt.value)) / car_price );
			}
		//매입옵션율---------------------------------------------------------------------------------			
		}else if(obj==fm.opt_s_amt){ 	//매입옵션 공급가
			obj.value = parseDecimal(obj.value);
			fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) * 0.1 );
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));		
			if(car_price > 0){	
				fm.opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
			}
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){				
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked 	= true;				
			}
		}else if(obj==fm.opt_v_amt){ 	//매입옵션 부가세
			obj.value = parseDecimal(obj.value);
			fm.opt_amt.value		= parseDecimal(toInt(parseDigit(fm.opt_s_amt.value)) + toInt(parseDigit(fm.opt_v_amt.value)));
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;		
				}else{				
					fm.app_ja.value		= fm.opt_per.value;
					fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
					fm.ja_r_amt.value 	= fm.opt_amt.value;
				}
				fm.opt_chk[1].checked = true;
			}else{
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;
				fm.opt_chk[0].checked 	= true;				
			}			
		}else if(obj==fm.opt_amt){ 		//매입옵션 합계
			obj.value = parseDecimal(obj.value);
			if(toInt(parseDigit(fm.opt_amt.value)) >0){
				fm.opt_s_amt.value 		= parseDecimal(sup_amt(toInt(parseDigit(fm.opt_amt.value))));
				fm.opt_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.opt_amt.value)) - toInt(parseDigit(fm.opt_s_amt.value)));	
				if(car_price > 0){		
					fm.opt_per.value 	= replaceFloatRound(toInt(parseDigit(fm.opt_amt.value)) / car_price );
				}
				if(toInt(parseDigit(fm.opt_amt.value)) >0){
					if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
						fm.app_ja.value		= fm.max_ja.value;
						fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
						fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
						fm.ja_r_amt.value 	= fm.ja_amt.value;		
					}else{				
						fm.app_ja.value		= fm.opt_per.value;
						fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
						fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
						fm.ja_r_amt.value 	= fm.opt_amt.value;
					}
					fm.opt_chk[1].checked = true;
				}else{
					fm.app_ja.value		= fm.max_ja.value;
					fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
					fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
					fm.ja_r_amt.value 	= fm.ja_amt.value;
					fm.opt_chk[0].checked 	= true;				
				}
			}
		//계약대여료---------------------------------------------------------------------------------
		}else if(obj==fm.fee_s_amt){ 	//계약대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.fee_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1 );
			fm.fee_amt.value	= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		}else if(obj==fm.fee_v_amt){ 	//계약대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.fee_amt.value		= parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value)));			
			dc_fee_amt();
		}else if(obj==fm.fee_amt){ 		//계약대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));			
			dc_fee_amt();
			fm.pere_r_mth.value 	= Math.round(toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value)));
		
		//원보험대여료---------------------------------------------------------------------------------
		}else if(obj==fm.ins_s_amt){ 	//원보험대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.ins_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) * 0.1 );
			fm.ins_amt.value	= parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));			
			
			dc_fee_amt();
			setTinv_amt();
	 	}else if(obj==fm.ins_v_amt){ 
	 		//원보험대여료 부가세
	 		obj.value = parseDecimal(obj.value);
			fm.ins_amt.value = parseDecimal(toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.ins_amt){ 		//원보험대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.ins_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_amt.value))));
			fm.ins_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_amt.value)) - toInt(parseDigit(fm.ins_s_amt.value)));	
			dc_fee_amt();
			setTinv_amt();
		//총보험료---------------------------------------------------------------------------------
		}else if(obj==fm.ins_total_amt){
			obj.value = parseDecimal(obj.value);
			fm.ins_total_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_total_amt.value)));
				
		//규정대여료---------------------------------------------------------------------------------
		}else if(obj==fm.inv_s_amt){ 	//규정대여료 공급가
			obj.value = parseDecimal(obj.value);
			fm.inv_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) * 0.1 );
			fm.inv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_v_amt){ 	//규정대여료 부가세
			obj.value = parseDecimal(obj.value);
			fm.inv_amt.value		= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.inv_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.inv_amt){ 		//규정대여료 합계
			obj.value = parseDecimal(obj.value);
			fm.inv_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.inv_amt.value))));
			fm.inv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_amt.value)) - toInt(parseDigit(fm.inv_s_amt.value)));			
			dc_fee_amt();
			setTinv_amt();

			//운전자 추가요금(2018.03.30)-------------------------------------------------------------------	
		}else if(obj==fm.driver_add_amt){	//운전자추가요금 공급가
			obj.value = parseDecimal(obj.value);
			fm.driver_add_v_amt.value 		= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) * 0.1 );
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_v_amt){ 	//운전자추가요금 부가세
			obj.value = parseDecimal(obj.value);
			fm.driver_add_total_amt.value	= parseDecimal(toInt(parseDigit(fm.driver_add_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}else if(obj==fm.driver_add_total_amt){ //운전자추가요금 합계			
			obj.value = parseDecimal(obj.value);
			fm.driver_add_amt.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.driver_add_total_amt.value))));
			fm.driver_add_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.driver_add_total_amt.value)) - toInt(parseDigit(fm.driver_add_amt.value)));			
			dc_fee_amt();
			setTinv_amt();
		}				
	}	
	
	//정상요금합계 구하기
	function setTinv_amt(){
		fm.tinv_s_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_s_amt.value)) + toInt(parseDigit(fm.ins_s_amt.value)) + toInt(parseDigit(fm.driver_add_amt.value)));
		fm.tinv_v_amt.value = parseDecimal(toInt(parseDigit(fm.inv_v_amt.value)) + toInt(parseDigit(fm.ins_v_amt.value)) + toInt(parseDigit(fm.driver_add_v_amt.value)));
		fm.tinv_amt.value	= parseDecimal(toInt(parseDigit(fm.inv_amt.value)) + toInt(parseDigit(fm.ins_amt.value)) + toInt(parseDigit(fm.driver_add_total_amt.value)));
	}
	
	//매입옵션유무
	function opt_display(st, rent_dt){
		var fm = document.form1;	
		
		if(rent_dt == '') rent_dt = <%=base.getRent_dt()%>;
		
		if(st == ''){
			if(fm.opt_chk[0].checked == true)		st = '0';
			else if(fm.opt_chk[1].checked == true)		st = '1';
		}
		
		if(st == '0'){
			fm.app_ja.value		= fm.max_ja.value;
			fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
			fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
			fm.ja_r_amt.value 	= fm.ja_amt.value;
			fm.opt_s_amt.value = 0;
			fm.opt_v_amt.value = 0;
			fm.opt_amt.value = 0;
			fm.opt_per.value = 0;
		}else if(st == '1'){
			if(toFloat(parseDigit(fm.opt_per.value)) > toFloat(parseDigit(fm.max_ja.value))){	
				fm.app_ja.value		= fm.max_ja.value;
				fm.ja_r_s_amt.value 	= fm.ja_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.ja_v_amt.value;
				fm.ja_r_amt.value 	= fm.ja_amt.value;		
			}else{		
				fm.app_ja.value		= fm.opt_per.value;
				fm.ja_r_s_amt.value 	= fm.opt_s_amt.value;
				fm.ja_r_v_amt.value 	= fm.opt_v_amt.value;
				fm.ja_r_amt.value 	= fm.opt_amt.value;		
			}
		}		
	}
	
	//차량가격 가져가기
	function setCarPrice(st){
		var fm = document.form1;
		var car_price = 0;
		if(st == 'car_c_price')		car_price = toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value));
		if(st == 'car_price2')		car_price	= toInt(parseDigit(fm.car_c_amt.value)) + toInt(parseDigit(fm.opt_c_amt.value)) + toInt(parseDigit(fm.col_c_amt.value)) + toInt(parseDigit(fm.add_opt_amt.value));
		if(st == 'car_f_price')		car_price = toInt(parseDigit(fm.car_f_amt.value)) - toInt(parseDigit(fm.dc_c_amt.value));
		//수입차DC는 제외
		if(st == 'car_f_price' && <%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
			car_price 	= toInt(parseDigit(fm.car_f_amt.value));
		}
		return car_price;
	}
	//DC금액 가져가기
	function setDcAmt(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//일반 과세차 렌트견적시 매출D/C금액 특소세율반영---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//메출D/C 면세분 반영 = 매출D/C*(1+특소세율);
				s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
			}
		}
		//수입차
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}	
	//DC금액 가져가기
	function setDcAmt2(car_price){
		var fm = document.form1;		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		//수입차
		if('<%=ej_bean.getJg_w()%>'=='1'){ s_dc_amt = 0; }
		return s_dc_amt;
	}		
	
	//선수금 합계
	function sum_pp_amt(){
		var fm = document.form1;
		
		fm.tot_pp_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.grt_s_amt.value)) + toInt(parseDigit(fm.pp_s_amt.value)) + toInt(parseDigit(fm.ifee_s_amt.value)));
		fm.tot_pp_v_amt.value 	= parseDecimal(toInt(parseDigit(fm.pp_v_amt.value)) + toInt(parseDigit(fm.ifee_v_amt.value)) );
		fm.tot_pp_amt.value 	= parseDecimal(toInt(parseDigit(fm.tot_pp_s_amt.value)) + toInt(parseDigit(fm.tot_pp_v_amt.value)) );		

		var car_price = setCarPrice('car_price2');
		var s_dc_amt 	= setDcAmt2(car_price);	
    	car_price = car_price - s_dc_amt - toInt(parseDigit(fm.tax_dc_amt.value));    	
				
		var pp_price 	= toInt(parseDigit(fm.tot_pp_amt.value)) + toInt(parseDigit(fm.gi_amt.value));
		if(pp_price>0 && car_price>0){
			fm.credit_r_per.value = replaceFloatRound(pp_price / car_price );
			fm.credit_r_amt.value = parseDecimal(pp_price);
		}
	}

		
	//대여료 DC율 계산
	function dc_fee_amt(){
		var fm = document.form1;
		
		var pp_s_amt		= toInt(parseDigit(fm.pp_s_amt.value));		//선납금
		var fee_s_amt		= toInt(parseDigit(fm.fee_s_amt.value));	//월대여료(적용)
		var inv_s_amt		= toInt(parseDigit(fm.inv_s_amt.value));	//정상대여료(견적)
		var con_mon		= toInt(parseDigit(fm.con_mon.value));		//대여기간 
		var dc_ra;
		
		//정상요금에서 계산함.
		if(<%=base.getRent_dt()%> < 20150512){			
			if(fee_s_amt > 0 && inv_s_amt > 0){
				dc_ra = (1 - (pp_s_amt+fee_s_amt*con_mon)/(pp_s_amt+inv_s_amt*con_mon))*100;
				fm.dc_ra.value = parseFloatCipher3(dc_ra,1);
			}
		}
	}				
	
	//규정대여료 계산 (견적)
	function estimate(rent_st, rent_dt, rent_start_dt, st){
		var fm = document.form1;
		
		set_fee_amt(fm.opt_amt, rent_dt);
	
		if(fm.con_mon.value == '')			{ alert('이용기간을 입력하십시오.');		return;}
		if(fm.driving_age.value == '')			{ alert('운전자연령을 선택하십시오.');		return;}
		if(fm.gcp_kd.value == '')			{ alert('대물배상을 선택하십시오.');		return;}		
		if(fm.dec_gr.value == '')			{ alert('신용등급을 선택하십시오.');		return;}	
		
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.car_gu.value == '1' && fm.dir_pur_yn[0].checked == false && fm.dir_pur_yn[1].checked == false){	alert('특판출고여부를 선택하여 주십시오.'); fm.dir_pur_yn[0].focus(); return; }
		
		// 테슬라 차량 대여기간 제한 없음. 20210225
		<%-- if ('<%=cm_bean.getCar_comp_id()%>' == '0056') {
			if(fm.con_mon.value > 48) {
				alert('테슬라차량의 경우 48개월 이상 견적이 불가 합니다.');
				fm.con_mon.focus();
				return;
			}
		} --%>
		
		var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
		fm.fee_rent_st.value = rent_st;
		fm.fee_rent_dt.value = rent_dt;
				
		var car_price 	= setCarPrice('car_price2');
		
		var s_dc_amt = toInt(parseDigit(fm.s_dc1_amt.value))+toInt(parseDigit(fm.s_dc2_amt.value))+toInt(parseDigit(fm.s_dc3_amt.value));
		if(fm.s_dc1_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc1_amt.value));
		if(fm.s_dc2_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc2_amt.value));
		if(fm.s_dc3_re.value == '포인트DC')	s_dc_amt = s_dc_amt - toInt(parseDigit(fm.s_dc3_amt.value));
		
		//일반 과세차 렌트견적시 매출D/C금액 특소세율반영---------------
		var purc_gu 	= fm.purc_gu.value;
		var s_st 			= fm.s_st.value;
		if(purc_gu == ''){	alert("과세구분을 선택하십시오."); return; }
		if(purc_gu == '1'){//과세1
		}else{//과세2(면세)
			if('<%=cm_bean.getJg_code()%>' == '2361' || '<%=cm_bean.getJg_code()%>' == '2362' || '<%=cm_bean.getJg_code()%>'=='2031111' || '<%=cm_bean.getJg_code()%>'=='2031112' || '<%=cm_bean.getJg_code()%>'=='5033111' || '<%=cm_bean.getDuty_free_opt()%>' == '1' || (<%=base.getRent_dt()%> < 20190419 && ('<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1012' || '<%=cm_bean.getS_st()%><%=cm_bean.getDiesel_yn()%>' == '1022' || s_st == '301' || s_st =='302' || s_st == '300'))){
			}else{
				setVar_o_123(car_price);
				//매출D/C 면세분 반영 = 매출D/C*(1+특소세율);	수입차DC는 제외				
				if(<%=base.getRent_dt()%> >= 20130501 && '<%=ej_bean.getJg_w()%>'=='1'){
				}else{
					s_dc_amt = Math.round(s_dc_amt*(1+toFloat(fm.v_o_2.value)));
				}
			}
		}		
		
		car_price = car_price - toInt(parseDigit(fm.tax_dc_amt.value));
		
		fm.o_1.value 		= car_price - s_dc_amt;
		fm.t_dc_amt.value 	= s_dc_amt;
		fm.esti_stat.value 	= st;
		
		//특판출고
		if('<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dir_pur_yn[0].checked == true){
			fm.o_1.value 		= car_price;
			fm.t_dc_amt.value 	= 0;
			
			if(<%=base.getRent_dt()%> >= 20130501){
				s_dc_amt = <%=cd_bean.getCar_d_p()%>;
				var s_dc_per = <%=cd_bean.getCar_d_per()%>;
				if(s_dc_per > 0){
					s_dc_amt = (car_price*s_dc_per/100)+s_dc_amt;					
				}
				fm.o_1.value 		= car_price - s_dc_amt;
				fm.t_dc_amt.value 	= s_dc_amt;
			}
		}		
		
		
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';			
		}
		
		if(fm.car_cng_yn.value == 'Y'){
			if('<%=base.getDlv_dt()%>' != ''){
				fm.fee_rent_dt.value = '<%=base.getDlv_dt()%>';
			}else{
				if('<%=pur.getDlv_est_dt()%>' != ''){
					fm.fee_rent_dt.value = '<%=AddUtil.replace(pur.getDlv_est_dt(),"-","")%>';
				}
			}								
		}
		
		//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
		if('<%=base.getCar_st()%><%=max_fee.getRent_way()%>' == '33'){
			if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
				alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
				return;					
			}
		}else{
			if(fm.insurant.value == '2'){
				alert('보험계약자 고객은 리스기본식만 가능합니다.');
				return;
			}			
		}			
				
		<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차 일반견적서  %>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('전기차 인수/반납 유형을 선택하십시오.'); return; }
				//일반식은 인수/반납 선택형을 할수 없다.
				if(fm.rent_way.value == '1' && fm.return_select.value == '0'){
					alert('일반식은 전기차 인수/반납 선택형을 선택할 수 없습니다. ');
					return;
				}
				//인수/반납 선택형 - 매입옵션있음
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//반납형 - 매입옵션없음	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');
			}
		<%}%>
		
		fm.ro_13.value 		= fm.opt_per.value;
		fm.o_13_amt.value 	= fm.opt_amt.value;
		fm.o_13.value 		= 0;					
		fm.action='get_fee_estimate_20090901.jsp';
				
		<%	if(cm_bean.getJg_code().equals("")){%>
		alert("차종잔가코드가 없습니다. 차종관리에서 입력하십시오.");
		return;
		<%	}%>
		
		if(confirm('영업수당 계약조건 '+fm.comm_r_rt.value+'%로 견적됩니다. 계속하시겠습니까?')){		
			fm.submit();
		}
		
		dc_fee_amt();
		
	}
	
	//출고지연대차 디스플레이
	function display_tae(){
		var fm = document.form1;
		if(fm.prv_dlv_yn[0].checked == true){					//없다
			tr_tae2.style.display		= 'none';
		}else{									//있다
			tr_tae2.style.display		= '';
		}		
	}

	//출고지연차 조회
	function car_search(st)	{		var fm = document.form1;		window.open("search_res_car.jsp?taecha=Y&client_id=<%=base.getClient_id()%>", "EXT_CAR", "left=100, top=100, width=800, height=600, status=yes");	}	
	
	
	
	//영업소담당자 조회
	function search_emp(st){		
		var fm = document.form1;		
		var one_self = "N";		
		var pur_bus_st = "4";
		if(fm.one_self[0].checked == true) one_self = "Y";		
		window.open("search_emp.jsp?rent_mng_id="+fm.rent_mng_id.value+"&rent_l_cd="+fm.rent_l_cd.value+"&gubun="+st+"&one_self="+one_self+"&pur_bus_st="+pur_bus_st+"&car_comp_id=<%=cm_bean.getCar_comp_id()%>", "OFF_EMP", "left=100, top=100, height=600, width=800, scrollbars=yes, status=yes");	
	}
	//영업소담당자 입력취소
	function cancel_emp(st){
		var fm = document.form1;
		if(st == 'BUS'){
			fm.emp_nm[0].value = '';
			fm.emp_id[0].value = '';
			fm.car_off_nm[0].value = '';
			fm.car_off_id[0].value = '';
			fm.car_off_st[0].value = '';
			fm.cust_st.value = '';
			fm.comm_rt.value = '';
			fm.comm_r_rt.value = '';
			fm.ch_remark.value = '';
			fm.ch_sac_id.value = '';
			fm.emp_bank.value = '';
			fm.emp_bank_cd.value = '';
			fm.emp_acc_no.value = '';
			fm.emp_acc_nm.value = '';			
		}else{
			fm.emp_nm[1].value = '';
			fm.emp_id[1].value = '';
			fm.car_off_nm[1].value = '';
			fm.car_off_st[1].value = '';
			fm.car_off_id[1].value = '';
		}		
	}
	//출고 영업소담당자를 영업 영업소담당자 상동처리
	function set_emp_sam(){
		var fm = document.form1;
		if(fm.emp_chk.checked == true){			
			fm.emp_nm[1].value = fm.emp_nm[0].value;
			fm.emp_id[1].value = fm.emp_id[0].value;
			fm.car_off_nm[1].value = fm.car_off_nm[0].value;
			fm.car_off_st[1].value = fm.car_off_st[0].value;		
		}else{
			cancel_emp('DLV');
		}			
	}
	
	//영업수당계산
	function setCommi(){
		var fm = document.form1;
		
		var car_price 	= toInt(parseDigit(fm.commi_car_amt.value));
		var comm_r_rt 	= toFloat(fm.comm_r_rt.value);
				
		fm.commi.value = parseDecimal(th_round(car_price*comm_r_rt/100));
				
	}
	
	//차종수정
	function reset_car(){
		var fm = document.form1;
		window.open('reset_car.jsp<%=valus%>', "reset_car", "left=100, top=100, width=800, height=600, scrollbars=yes"); 
	}
	
	//수정
	function update(idx){
		var fm = document.form1;
		
	
		if(idx == 0 || idx == 99){

	
			if(fm.rent_st.value == '')			{ alert('계약구분을 확인하십시오.'); 		return;}			
			if(fm.rent_way.value == '')			{ alert('관리구분을 확인하십시오.'); 		return;}
			if(fm.bus_agnt_id.value.substring(0,1) == '1')	{ alert('영업대리인이 부서로 선택되었습니다. 확인해주세요.'); return; }

			
			
			if(fm.car_st.value != '<%=base.getCar_st()%>'){
				alert('용도구분을 변경하는 경우에 대여요금 및 영업수당 등을 확인하고 수정하셔야 합니다.');
			}
			
			if(fm.rent_way.value != '<%=max_fee.getRent_way()%>'){
				alert('관리구분을 변경하는 경우에 대여요금 등을 확인하고 수정하셔야 합니다.');
			}
			
		}else if(idx == 1 || idx == 99){
		
			if(fm.client_id.value == '')	{ alert('고객을 선택하십시오.'); 		return;}
			if(fm.t_addr[0].value == '')	{ alert('우편물주소를 확인하십시오.'); 		return;}
			
			<%for(int i = 0 ; i <= mgr_size ; i++){%>
			fm.mgr_email[<%=i%>].value = fm.email_1[<%=i%>].value+'@'+fm.email_2[<%=i%>].value;
			<%}%>
			
			//개인,개인사업자는 운전면허번호 필수
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
			}else if(fm.client_st.value == '1'||fm.client_st.value == '6'){	//법인
				if(fm.ssn.value==""){
					if(fm.lic_no.value == '' || fm.lic_no.value.length < 12){
						alert('법인번호가 없는 법인형태인 경우에는 운전면허번호를 입력하십시오.');
						return;
					}
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
		
		}else if(idx == 2 || idx == 99){
		
			// 개인, 개인사업자도 대표 공동임차 사용 20210308
			<%-- if('<%=client.getClient_st()%>' == '1' && fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){ --%>		
			if(fm.client_share_st[0].checked == false && fm.client_share_st[1].checked == false){		
				alert('대표이사 공동임차인여부를 선택하십시오.'); return;			
			}
			if('<%=client.getClient_st()%>' != '1'){		
				fm.client_share_st[1].checked = true;		
			}
		
			if('<%=client.getClient_st()%>' !='2' && fm.client_guar_st[1].checked == true){		
				if(fm.guar_con.options[fm.guar_con.selectedIndex].value == '')		{ alert('대표이사보증 면제조건을 선택하십시오.'); 	return;}			
				if(fm.guar_sac_id.value == '')						{ alert('대표이사보증 면제 결재자를 선택하십시오.'); 	return;}						
			}
			
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('연대보증인 성명을 입력하십시오.'); 			return;}
				if(fm.gur_ssn[0].value == '')	{ alert('연대보증인 생년월일을 입력하십시오.'); 		return;}
				if(fm.t_addr[2].value == '')	{ alert('연대보증인 주소를 입력하십시오.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('연대보증인 연락처를 입력하십시오.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('연대보증인 관계를 입력하십시오.'); 			return;}												
			}
		
		}else if(idx == 3 || idx == 99){
				
			if(fm.client_st.value == '1'){
				var open_year = '<%=AddUtil.replace(client.getOpen_year(),"-","")%>';
				var now = new Date();
				var base_dt = now.getYear()+'0101';
				if(open_year != '' && toInt(open_year) < toInt(base_dt)){
					if(fm.c_ba_year_s.value == '' || fm.c_ba_year.value == '')		{ alert('당기 기준일자를 입력하십시오.'); 		return;}
				}
			}
				
		}else if(idx == 4 || idx == 99){
		
		}else if(idx == 5 || idx == 99){
		
		}else if(idx == 7 || idx == 99){
		
			if(fm.dec_gr.value == '')				{ alert('적용신용등급을 선택하십시오.'); 						return;}
		
		}else if(idx == '8_1' || idx == 99){
			
			if(fm.color.value == '')				{ alert('대여차량-색상을 입력하십시오.'); 			fm.color.focus(); 		return; }
			if(<%=base.getRent_dt()%> > 20161231 && fm.car_gu.value == '1'){//신차
				if(fm.in_col.value == ''){ alert('대여차량-내장색상을 입력하십시오.');fm.in_col.focus();return; }	
			}
			
			if(fm.car_ext.value == '')				{ alert('대여차량-등록지역을 입력하십시오.'); 			fm.car_ext.focus(); 		return; }
			
			<%if(base.getCar_mng_id().equals("") || AddUtil.parseInt(base.getRent_dt()) > 20180208){%>
			
			<%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
			if (fm.ecar_loc_st.value == '') {	
				alert("전기차 고객주소지를 선택하십시오.");
				return;
			} 
//				else {
				//1.서울, 2.파주, 3.부산, 4.김해, 5.대전, 6.포천, 7.인천, 8.제주, 9.광주, 10.대구
				
				//서울 -> 서울 등록
				/* if(fm.ecar_loc_st.value == '0'){
					fm.car_ext.value = '1';
				}
				//인천,경기 -> 서울 등록
				if(fm.ecar_loc_st.value == '1'){
					fm.car_ext.value = '1';
				}
				//강원 -> 서울 등록
				if(fm.ecar_loc_st.value == '2'){
					fm.car_ext.value = '1';
				}
				//대전 -> 서울 등록
				if(fm.ecar_loc_st.value == '3'){
					fm.car_ext.value = '1';
				}
				//광주 -> 광주 등록
				if(fm.ecar_loc_st.value == '4'){
					fm.car_ext.value = '9';
				}
				//대구 -> 대구 등록
				if(fm.ecar_loc_st.value == '5'){
					fm.car_ext.value = '10';
				}
				//부산 -> 서울 등록
				if(fm.ecar_loc_st.value == '6'){
					fm.car_ext.value = '1';
				}
				//세종,충남,충북(대전제외) -> 서울 등록
				if(fm.ecar_loc_st.value == '7'){
					fm.car_ext.value = '1';
				}
				//경북(대구제외) -> 서울 등록
				if(fm.ecar_loc_st.value == '8'){
					fm.car_ext.value = '1';
				}
				//울산,경남 -> 서울 등록
				if(fm.ecar_loc_st.value == '9'){
					fm.car_ext.value = '1';
				}
				//전남,전북(광주제외) -> 서울 등록
				if(fm.ecar_loc_st.value == '10'){
					fm.car_ext.value = '1';
				} */
				
				// 기존 전기화물차(등록지: 서울) 외 모든 전기차 고객 주소지와 관련 없이 인천으로 등록. 2021.02.18.
				// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주서지는 인천 등록. 20210224
				// 전기화물차 외 전기차 고객주소지 따라 실등록지역 등록. 서울/인천/대전/광주/대구/부산 외 나머지 고객주소지는 부산 등록. 20210520
<%-- 						<%if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435")  || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {%> --%>
//						fm.car_ext.value = '1';
<%-- 						<%} else {%> --%>
//						if(fm.ecar_loc_st.value == '0'){
//							fm.car_ext.value = '1';
//						} else if(fm.ecar_loc_st.value == '1'){
//							fm.car_ext.value = '7';
//						} else if(fm.ecar_loc_st.value == '3'){
//							fm.car_ext.value = '5';
//						} else if(fm.ecar_loc_st.value == '4'){
//							fm.car_ext.value = '9';
//						} else if(fm.ecar_loc_st.value == '5'){
//							fm.car_ext.value = '10';
//						} else if(fm.ecar_loc_st.value == '6'){
//							fm.car_ext.value = '3';
//						} else{
//							//fm.car_ext.value = '7';
//							fm.car_ext.value = '3';		// 나머지 지역 부산으로 등록 처리.
//						}
<%-- 						<%}%> --%>
				
				<%-- <%if (cm_bean.getJg_code().equals("3871") || cm_bean.getJg_code().equals("3313111") || cm_bean.getJg_code().equals("3313112") || cm_bean.getJg_code().equals("3313113") || cm_bean.getJg_code().equals("3313114")) {//20191016 모델3는 서울로등록%>
					// fm.car_ext.value = '1';
					fm.car_ext.value = '7'; // 20210216 테슬라 모델3 실등록지역 인천으로 변경.
				<%} else if (cm_bean.getJg_code().equals("9133") || cm_bean.getJg_code().equals("9237") || cm_bean.getJg_code().equals("9015435") || cm_bean.getJg_code().equals("9025435")  || cm_bean.getJg_code().equals("9015436") || cm_bean.getJg_code().equals("9015437") || cm_bean.getJg_code().equals("9025439") || cm_bean.getJg_code().equals("9025440")) {//20200313 포터일렉트릭, 봉고EV는 대구등록%>
					//fm.car_ext.value = '7';
					fm.car_ext.value = '1';
				<%}%> --%>
//				}
			<%}%>
			
			<%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
				if(fm.hcar_loc_st.value == ''){
					alert("수소차 고객주소지를 선택하십시오.");
					return;			
				}
//				else{
//					fm.car_ext.value = '1';
//				}
			//인천 -> 인천 등록
//				if(fm.hcar_loc_st.value == '1'){	
//					fm.car_ext.value = '7';
//				}
			//대전 리스 -> 리스는 대전 등록
<%-- 					if(fm.hcar_loc_st.value == '3' && '<%=base.getCar_st()%>' == '3'){	 --%>
//					fm.car_ext.value = '5';
//				}
			//광주/전남/전북 -> 광주 등록
//				if(fm.hcar_loc_st.value == '4'){	
//					fm.car_ext.value = '9';
//				}
			//부산/울산/경남 -> 부산 등록
//				if(fm.hcar_loc_st.value == '6'){	
//					fm.car_ext.value = '3';
//				}
			//20190701 수소차는 모두 인천
			//fm.car_ext.value = '7';
//				fm.car_ext.value = '7'; //20191206 수소차는 모두 인천
			//fm.car_ext.value = '1'; //20200324 수소차는 모두 인천 -> 서울로 등록
			<%}%>

			<%-- <%if(ej_bean.getJg_b().equals("3")||ej_bean.getJg_b().equals("4")||ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//연료종류-친환경차%>
			if(fm.eco_e_tag.value == ''){	
				alert("맑은서울스티커 발급(남산터널 이용 전자태그)을 선택하십시오.");
				return;
			}		
			/* if(fm.eco_e_tag.value == '1'){
				fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
			} */
			
				<%if(ej_bean.getJg_b().equals("5")||ej_bean.getJg_b().equals("6") ){//친환경차:연료종류%>
				if(fm.eco_e_tag.value == '1'){
					alert("전기차/수소차는 현재 맑은서울스티커 발급(남산터널 이용 전자태그)이 불가합니다.");
					return;
				}
				<%}else{%>
				if(fm.eco_e_tag.value == '1'){
					fm.car_ext.value = '1'; //맑은서울스티커 발급시 서울등록
				}
				<%}%>
			
			<%}%> --%>			
		<%}%>	
		
		}else if(idx == 8 || idx == 99){
		
			// 고급썬팅 추가 2017.12.26
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('전면썬팅(기본형), 전면썬팅 미시공 할인, 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('전면썬팅(기본형)과 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_s_yn.checked == true && fm.tint_sn_yn.checked == true){
				alert('전면썬팅(기본형)과 전면썬팅 미시공 할인 중 하나만 체크하세요.'); fm.tint_s_yn.focus(); return;
			}
			if(fm.tint_sn_yn.checked == true && fm.tint_ps_yn.checked == true){
				alert('전면썬팅 미시공 할인과 고급썬팅(전면포함) 중 하나만 체크하세요.'); fm.tint_ps_yn.focus(); return;
			}
			if(fm.tint_ps_yn.checked == true && fm.tint_ps_amt.value < 1){
				alert('고급썬팅 금액을 입력하세요.'); fm.tint_ps_amt.focus(); return;
			}
					
			if(fm.tint_s_yn.checked == true && toInt(fm.tint_s_per.value) < 50 && '<%=ej_bean.getJg_w()%>' != '1'){
				//alert('대여차량-용품-전면썬팅은 국산차는 투과율이 50% 이상만 가능합니다.'); 				fm.tint_s_per.focus(); 		return;
			}
			
			if(fm.tint_bn_yn.checked == true && fm.tint_bn_nm.value == ''){
				alert('블랙박스 미제공 할인 사유을 선택하십시오.'); fm.tint_bn_nm.focus(); return;
			}
			
			var prev_new_license_plate = '<%=car.getNew_license_plate()%>';
			if(prev_new_license_plate == '1' || prev_new_license_plate == '2'){
				prev_new_license_plate = '1';
			} else {
				prev_new_license_plate = '0';
			}
			fm.prev_new_license_plate.value = prev_new_license_plate;
					
		}else if(idx == 9 || idx == 99){

			var car_c_amt = toInt(parseDigit(fm.car_c_amt.value));
			var car_f_amt = toInt(parseDigit(fm.car_f_amt.value));
			if(fm.purc_gu.value == '')		{ alert('차량가격-과세구분을 입력하십시오.'); 			fm.purc_gu.focus(); 		return; }
			if(car_c_amt == 0)				{ alert('차량가격-소비자가 기본가격을 입력하십시오.'); 	fm.car_c_amt.focus(); 		return; }
			if(car_f_amt == 0)				{ alert('차량가격-구입가 차량가격을 입력하십시오.'); 		fm.car_f_amt.focus(); 		return; }
			
			var chk_car_amt1 = Math.abs(toInt(parseDigit(fm.o_car_c_amt.value))-toInt(parseDigit(fm.car_c_amt.value)));
			if(chk_car_amt1 > 50000){
				alert('차량가격 소비자가 기본가격 수정 변동값이 ±50,000원이 넘습니다. 확인하십시오.');
				return;
			}
			var chk_car_amt2 = Math.abs(toInt(parseDigit(fm.o_car_f_amt.value))-toInt(parseDigit(fm.car_f_amt.value)));
			if(toInt(parseDigit(fm.car_f_amt.value)) > 0 && chk_car_amt2 > 50000){
				alert('차량가격 구입가격 수정 변동값이 ±50,000원이 넘습니다. 확인하십시오.');
				return;
			}	
			
			//계약서상 제조사 할인후 차량가격 표기여부, 신차만. (20190911)
			<%if(base.getCar_gu().equals("1") && fee_size<=1){%>
				if(fm.dc_view_yn.checked==true){
					if(fm.view_car_dc.value==""||fm.view_car_dc.value==0){
						alert("전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부 체크!\n\n-> [제조사 할인 후 차량가격] 을 입력해주세요.");	fm.view_car_dc.focus();	return;
					}
				}else{
					fm.view_car_dc.value="";
				}
			<%}%>

		}else if(idx == 10 || idx == 99){  
		
			if(fm.insur_per.value == '')				{ alert('보험사항-피보험자를 입력하십시오.'); 		fm.insur_per.focus(); 		return; }
			if(fm.driving_age.value == '')				{ alert('보험사항-운전자연령을 입력하십시오.'); 		fm.driving_age.focus(); 	return; }			
			<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600  && AddUtil.parseInt(a_e) != 409){%>	
				if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');	fm.com_emp_yn.focus(); 		return; }
				if(fm.com_emp_yn.value == 'N' && fm.others.value == ''){	alert('* 법인고객의 임직원운전한정특약 미가입 사유를 보험관리-비고에 입력하십시오.');	return; }
			<%}else if(AddUtil.parseInt(client.getClient_st()) >2 && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>
				//개인사업자 업무전용차량 제한없음
				if(fm.com_emp_yn.value == '')			{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');	fm.com_emp_yn.focus(); 		return; }
			<%}else{%>
				if(fm.com_emp_yn.value == 'Y')			{ alert('보험사항-임직원운전한정특약 가입대상이 아닌데 가입으로 되어 있습니다. 확인하십시오.');	fm.com_emp_yn.focus(); 	return; }
			<%}%>
			if(fm.gcp_kd.value == '')				{ alert('보험사항-대물배상 가입금액을 입력하십시오.'); 		fm.gcp_kd.focus(); 		return; }
			if(fm.bacdt_kd.value == '')				{ alert('보험사항-자기신체사고 가입금액을 입력하십시오.'); 	fm.bacdt_kd.focus(); 		return; }
			if(fm.canoisr_yn.value == '')				{ alert('보험사항-무보험차상해 가입여부를 입력하십시오.'); 	fm.canoisr_yn.focus(); 		return; }
			if(fm.cacdt_yn.value == '')				{ alert('보험사항-자기차량손해 가입여부를 입력하십시오.'); 	fm.cacdt_yn.focus(); 		return; }
			if(fm.eme_yn.value == '')				{ alert('보험사항-긴급출동 가입여부를 입력하십시오.'); 		fm.eme_yn.focus(); 		return; }
				
			//20150626 리스기본식만 보험계약자 고객 선택가능, 보험계약자가 고객이면 피보험자도 고객이여야 한다.			
			if('<%=base.getCar_st()%><%=max_fee.getRent_way()%>' == '33'){
				if(fm.insurant.value == '2' && fm.insur_per.value != '2'){
					alert('보험계약자 고객이면 피보험자도 고객이여야 합니다.');
					return;					
				}
			}else{
				if(fm.insurant.value == '2'){
					alert('보험계약자 고객은 리스기본식만 가능합니다.');
					return;
				}			
			}	
			
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'연령 ';		}												
			
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}				
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'대물보상 ';		}				
			
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk3.value =	'자기신체사고 ';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');	fm.ins_chk3.value =	'자기신체사고 ';	}
			
			if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1'){		alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk4.value =	'피보험자 ';		}
			if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2'){		alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk4.value =	'피보험자 ';		}
			<%}%>		
						
			var car_ja 	= toInt(parseDigit(fm.car_ja.value));
			if(car_ja == 0)						{ alert('보험사항-자차면책금을 입력하십시오.'); 		fm.car_ja.focus(); 		return; }
  			<%if(ej_bean.getJg_w().equals("1")){//수입차%>
			if(fm.car_ja.value != fm.imm_amt.value){
				if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 	fm.rea_appr_id.focus(); 	return; }
			}
			<%}else{%>
			if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
				if(fm.ja_reason.value == '')			{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')			{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); 	fm.rea_appr_id.focus(); 	return; }
			}			
			<%}%>			
			if(fm.insur_per.value == '2'){
				if(fm.ip_insur.value == '')			{ alert('보험사항-입보회사 보험사명을 입력하십시오.'); 		fm.ip_insur.focus(); 		return; }
				if(fm.ip_acar.value == '')			{ alert('보험사항-입보회사 대리점명을 입력하십시오.'); 		fm.ip_acar.focus(); 		return; }
				if(fm.ip_dam.value == '')			{ alert('보험사항-입보회사 담당자명을 입력하십시오.'); 		fm.ip_dam.focus(); 		return; }
				if(fm.ip_tel.value == '')			{ alert('보험사항-입보회사 연락처를 입력하십시오.'); 		fm.ip_tel.focus(); 		return; }
			}
			
		
		}else if(idx == 11 || idx == 99){
		
			if(fm.gi_st[0].checked == true){//가입
				var gi_amt 	= toInt(parseDigit(fm.gi_amt.value));
				//var gi_fee 	= toInt(parseDigit(fm.gi_fee.value));
				if(gi_amt == 0)						{ alert('보증보험-가입금액을 입력하십시오.'); 				fm.gi_amt.focus(); 			return; }
				//if(gi_fee == 0)						{ alert('보증보험-보증보험료를 입력하십시오.'); 			fm.gi_fee.focus(); 			return; }
			}else if(fm.gi_st[1].checked == true){//면제
				fm.gi_amt.value 	= 0;
				fm.gi_fee.value 	= 0;				
			}
		


		}else if(idx == 12 || idx == 99){
		
			
			if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 			fm.con_mon.focus(); 		return; }
				
				
			if(toInt(parseDigit(fm.ja_amt.value)) == 0 && toInt(parseDigit(fm.ja_r_amt.value)) > 0){
				fm.ja_s_amt.value 	= fm.ja_r_s_amt.value;
				fm.ja_v_amt.value 	= fm.ja_r_v_amt.value;
				fm.ja_amt.value 	= fm.ja_r_amt.value;
				fm.max_ja.value 	= fm.app_ja.value;								
			}				
				
			if(fm.max_ja.value == '')				{ alert('대여요금-최대잔가율을 입력하십시오.'); 		fm.max_ja.focus(); 		return; }
			var ja_amt = toInt(parseDigit(fm.ja_amt.value));
			if(toInt(fm.cls_r_per.value) < 1)			{ alert('대여요금-중도해지위약율를 확인하십시오.'); 		fm.cls_r_per.focus(); 		return;	}
			var fee_amt = toInt(parseDigit(fm.fee_amt.value));
			var inv_amt = toInt(parseDigit(fm.inv_amt.value));							
				
			var agree_dist 		= toInt(parseDigit(fm.agree_dist.value));
			var over_run_amt 	= toInt(parseDigit(fm.over_run_amt.value));
			var rtn_run_amt 	= toInt(parseDigit(fm.rtn_run_amt.value));
			
			
			if(fm.car_gu.value == '1' && fm.agree_dist.value !='미적용'){//신차
			<%if(AddUtil.parseInt(base.getRent_dt()) > 20130604){%>				
				if(agree_dist == 0)				{ alert('대여요금-약정운행거리를 입력하십시오.'); 			fm.agree_dist.focus(); 		return; }
				if(over_run_amt == 0)			{ alert('대여요금-초과운행부담금을 입력하십시오.'); 			fm.over_run_amt.focus(); 	return; }
				<%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
					if(fm.rtn_run_amt_yn.value == '')								{ alert('대여요금-환급대여료적용여부를 입력하십시오.'); 	fm.rtn_run_amt_yn.focus(); 	return; }
					if(rtn_run_amt == 0 && fm.rtn_run_amt_yn.value == '0')			{ alert('대여요금-환급대여료를 입력하십시오.'); 			fm.rtn_run_amt.focus(); 	return; }
					if(rtn_run_amt > 0 && fm.rtn_run_amt_yn.value == '1')			{ alert('대여요금-환급대여료미적용이므로 환급대여료 0원 처리합니다.'); fm.rtn_run_amt.value = 0; }
				<%}%>
			<%}%>
			}
				
				
			if(fm.fee_pay_tm.value == '')				{ alert('대여요금-납입횟수를 입력하십시오.'); 			fm.fee_pay_tm.focus(); 		return; }
			if(fm.fee_sh.value == '')				{ alert('대여요금-수금구분를 입력하십시오.'); 			fm.fee_sh.focus(); 		return; }
			if(fm.fee_pay_st.value == '')				{ alert('대여요금-납부방법을 입력하십시오.'); 			fm.fee_pay_st.focus(); 		return; }
			if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('납부방법이 자동이체가 아닌 경우 CMS미실행사유를 입력하십시오.'); fm.cms_not_cau.focus(); 	return; }
			if(fm.def_st.value == '')				{ alert('대여요금-거치여부를 입력하십시오.'); 			fm.def_st.focus(); 		return; }
			if(fm.def_st.value == 'Y'){
				if(fm.def_remark.value == '')				{ alert('대여요금-거치사유를 입력하십시오.');			fm.def_remark.focus();		return; }
				if(fm.def_sac_id.value == '')				{ alert('대여요금-거치 결재자를 입력하십시오.');		fm.def_sac_id.focus();		return; }
			}
			
			//특판출고(실적이관가능)이면 영업수당은 없다.
			if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.pur_bus_st[0].checked == false && fm.dir_pur_commi_yn.value == 'Y'){
				alert('현대차이면서 법인고객이고 출고보전수당이 있는 특판출고는 영업수당이 없습니다.'); return;
			}
				
			//대차인 경우
			if('<%=base.getRent_st()%>' == '3'){	
				if(fm.grt_suc_l_cd.value == '')	{ alert('대차의 원계약을 입력하십시오.'); 	return;}
			}					
			
			<%if(base.getCar_gu().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차 제외%>
			if(<%=base.getRent_dt()%> >= 20190215 && <%=base.getRent_dt()%> < 20191217){
				if(fm.return_select.value == ''){ alert('전기차 인수/반납 유형을 선택하십시오.'); return; }
				//일반식은 인수/반납 선택형을 할수 없다.
				if(fm.rent_way.value == '1' && fm.return_select.value == '0'){
					alert('일반식은 전기차 인수/반납 선택형을 선택할 수 없습니다. ');
					return;
				}
				//인수/반납 선택형 - 매입옵션있음
				if(fm.return_select.value == '0'){
					fm.opt_chk[1].checked = true;	
				//반납형 - 매입옵션없음	
				}else if(fm.return_select.value == '1'){
					fm.opt_chk[0].checked = true;	
					fm.opt_s_amt.value = 0;
					fm.opt_v_amt.value = 0;
					fm.opt_amt.value = 0;
					fm.opt_per.value = 0;
				}
				opt_display('', '');
			}	
			<%}%>
			
			if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false)				{ alert('대여요금-매입옵션 여부를 입력하십시오.'); 			fm.opt_chk.focus(); 		return; }
			if(fm.opt_chk[1].checked == true){
				if(fm.opt_per.value == '')			{ alert('대여요금-매입옵션율를 입력하십시오.'); 			fm.opt_per.focus(); 		return; }
				var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
				if(opt_amt == 0)					{ alert('대여요금-매입옵션금액을 입력하십시오.'); 			fm.opt_amt.focus(); 		return; }
			}
			if(fm.opt_chk[0].checked == true){
				var opt_amt = toInt(parseDigit(fm.opt_amt.value));				
				if(opt_amt > 0)						{ alert('대여요금-매입옵션없음으로 되어 있으나 매입옵션금액이 있습니다. 확인하십시오.');	fm.opt_amt.focus(); 		return; }
				//fm.opt_s_amt.value = 0;
				//fm.opt_v_amt.value = 0;
				//fm.opt_amt.value = 0;
				//fm.opt_per.value = 0;
			}
			
			var checkSymbol = false;
			var symbol = "<>\"'\\";		// 입력 제한 대상인 특수 문자(<, >, ', ")
			var con_etc = fm.con_etc.value;
			for(var i=0; i<con_etc.length; i++){
				if(symbol.indexOf(con_etc.charAt(i)) != -1) 	checkSymbol = true;
			}
			if(checkSymbol){		// 특약사항 기재란 일부 특수 문자 입력 제한 처리 수정 2020.01.03.
				alert('대여요금-특약사항 기재 내용에는 특수 문자 중 <, >, \', "\를 사용할 수 없습니다.'); return;
			}
			if (con_etc.indexOf("*,***") != -1) {
				alert('대여요금-특약사항 기재 내용 중 월대여료 인상금액 입력을 확인하세요.'); return;
			}
		
		}else if(idx == 13 || idx == 99){
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ 
				alert('지점등록이 안되어 있습니다. 먼저 지점을 등록하십시오.');
				fm.tax_type[0].checked = true; 
			}
			
			if(fm.rec_st.value == '')			{ alert('세금계산서-청구서수령방법을 입력하십시오.');			fm.rec_st.focus(); 	return; }
			if(fm.rec_st.value == '1'){
				if(fm.ele_tax_st.value == '')		{ alert('세금계산서-전자세금계산서 시스템을 입력하십시오.'); 		fm.ele_tax_st.focus();	return; }
				if(fm.ele_tax_st.value == '2'){
					if(fm.tax_extra.value == '')	{ alert('세금계산서-전자세금계산서 별도시스템 이름을 입력하십시오.'); 	fm.tax_extra.focus(); 	return; }
				}
			}
		
		}else if(idx == 14 || idx == 99){
		
			
			if(fm.prv_dlv_yn[1].checked == true){
				if(fm.tae_car_no.value == '')		{ alert('출고전대차-자동차를 선택하십시오.'); 			fm.tae_car_no.focus(); 		return; }					
				if(fm.tae_car_rent_st.value == '')	{ alert('출고전대차-대여개시일을 입력하십시오.'); 		fm.tae_car_rent_st.focus(); 	return; }
				if(fm.tae_req_st.value == '')		{ alert('출고전대차-청구여부를 선택하십시오.'); 		fm.tae_req_st.focus(); 		return; }
				if(fm.tae_req_st.value == '1'){
					if(toInt(parseDigit(fm.tae_rent_fee.value)) == 0)	{ alert('출고전대차-월대여료를 입력하십시오.'); 			fm.tae_rent_fee.focus(); 	return; }
					if(toInt(parseDigit(fm.tae_rent_inv.value)) == 0)	{ alert('출고전대차-정상요금을 입력하십시오.'); 			fm.tae_rent_inv.focus(); 	return; }
					if(fm.tae_est_id.value == '')	{ alert('출고전대차-정상요금 계산하기를 하십시오.'); 			fm.tae_rent_inv.focus(); 	return; }
					<%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		<%}else{%>
					if(fm.tae_rent_fee_st[0].checked == false && fm.tae_rent_fee_st[1].checked == false){
						alert('출고전대차 견적서 <출고전 신차 대여 계약 해지시 요금정산> 항목에 월렌트 정상요금이 표기되어 있는 경우에 월렌트 정상요금을 입력하고, 월렌트 정상요금이 표기되어 있지 않은 경우에는 ㅇ견적서에 표기되어 있지 않음에 체크해주세요.'); return;
					}else{
						if(fm.tae_rent_fee_st[0].checked == true){
							if(toInt(parseDigit(fm.tae_rent_fee_cls.value)) == 0){ alert('신차 해지시 요금정산(월렌트정상요금)을 입력하십시오.'); return;									}
							if(toInt(parseDigit(fm.tae_rent_fee.value)) >= toInt(parseDigit(fm.tae_rent_fee_cls.value)))	{ alert('신차 해지시 요금정산(월렌트정상요금)값이 출고지연대차 월대여료보다 크지 않습니다. 확인하십시오.'); 			fm.tae_rent_fee_cls.focus(); 	return; }
						}else{
							fm.tae_rent_fee_cls.value = 0;
						}								
					}
					<%}%>
					if(fm.tae_tae_st.value == '')	{ alert('출고전대차-계산서발행여부를 선택하십시오.'); 		fm.tae_tae_st.focus(); 		return; }						
				}					
				if(toInt(parseDigit(fm.tae_rent_fee.value))>0){
					fm.tae_rent_fee_s.value 	= parseDecimal(sup_amt(toInt(parseDigit(fm.tae_rent_fee.value))));
					fm.tae_rent_fee_v.value 	= parseDecimal(toInt(parseDigit(fm.tae_rent_fee.value)) - toInt(parseDigit(fm.tae_rent_fee_s.value)));						
				}
				if(fm.tae_sac_id.value == '')		{ alert('출고전대차-결재자를 선택하십시오.'); 			fm.tae_sac_id.focus(); 		return; }
			}
			
		
		}else if(idx == 15 || idx == 99){
		
			if(fm.emp_id[0].value != ''){
				if(fm.comm_rt.value == '' || fm.comm_rt.value == '0')	{ 
					fm.comm_rt.value = 3.0;
				}
				if(toFloat(fm.comm_rt.value) < toFloat(fm.comm_r_rt.value)){ //최대수수료율보다 적용수수료율이 더 클수는 없다.
					alert('영업담당영업사원-영업수당 최대수수료율보다 적용수수료율이 더 클수 는 없습니다. 확인하십시오.'); 		fm.comm_rt.focus(); 		return;
				}		
				//특판출고(실적이관가능)이면 영업수당은 없다.
				if(<%=base.getRent_dt()%> >= 20190610 && toFloat(parseDigit(fm.v_comm_r_rt.value))>0 && '<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true && fm.dir_pur_yn[0].checked == true && fm.dir_pur_commi_yn.value == 'Y'){
					alert('현대차이면서 법인고객이고 출고보전수당이 있는 특판출고는 영업수당이 없습니다.'); return;
				}else{
					if(fm.v_comm_r_rt.value == '')		{ alert('영업담당영업사원-영업수당 적용수수료율를 입력하십시오.'); 		fm.v_comm_r_rt.focus(); 		return; }				
				}				
				
			}
			
			
			
			//기타(자체)
			if(fm.dir_pur_yn[0].checked == false){
				var con_amt 		= toInt(parseDigit(fm.con_amt.value));
				//if(con_amt > 0){
				//	if(fm.con_bank.value == '' || fm.con_acc_no.value == '' || fm.con_acc_nm.value == ''){
				//		alert('출고영업소에 차량대금(계약금)를 지급할 계좌를 입력하십시오.'); return;
				//	}
				//}	
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value == '법인판매팀장'){
					alert('현대 법인판매팀장인데 특판이 아닙니다. 출고영업소를 확인하십시오.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == 'Y'){
					alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
				if(fm.dir_pur_commi_yn.value == 'N'){
					alert('출고보전수당이 있고 특판출고(실적이관가능)인데 특판이 아닙니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
			//특판출고	
			}else{
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value == ''){
					alert('출고영업소를 입력하십시오.'); return;										
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_id[1].value != '030849'){
						alert('특판출고 선택되었으나 출고영업소가 법인판매팀이 아닙니다. 확인하십시오.'); return;
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0003' && fm.emp_id[1].value != '038036'){
						alert('특판출고 선택되었으나 출고영업소가 법인판매팀이 아닙니다. 확인하십시오.'); return;
				}
				if('<%=cm_bean.getCar_comp_id()%>' == '0001' && fm.emp_nm[1].value != '법인판매팀장'){
					alert('현대 특판인데 법인판매팀장 아닙니다. 출고영업소를 확인하십시오.'); return;											
				}
				if(fm.dir_pur_commi_yn.value == '2'){
					alert('출고보전수당이 있고 자체출고대리점출고인데 특판입니다. 특판출고여부 혹은 출고보전수당 출고구분을 확인하십시오.'); return;
				}
			}
			
			if(fm.emp_id[1].value != ''){
				if(fm.con_amt.value == '' || fm.con_amt.value == '0')	{
					
				}else{	
					if(fm.trf_st0.value == '')			{ alert('출고영업소-선수금 지급수단을 선택하십시오.'); 	fm.trf_st0.focus(); 		return; }
					if(fm.trf_st0.value == '1'){
						if(fm.con_bank.value == '') 	{ alert('출고영업소-선수금 지급금융사를 입력하십시오.'); 	fm.con_bank.focus(); 		return; }
						if(fm.con_acc_no.value == '') 	{ alert('출고영업소-선수금 계좌번호를 입력하십시오.'); 	fm.con_acc_no.focus(); 		return; }
						if(fm.con_acc_nm.value == '') 	{ alert('출고영업소-선수금 계좌예금주를 입력하십시오.'); 	fm.con_acc_nm.focus(); 		return; }
						if(fm.con_est_dt.value == '') 	{ alert('출고영업소-선수금 지급예정일을 입력하십시오.'); 	fm.con_est_dt.focus(); 		return; }
					}	
				}			
				if(fm.trf_amt5.value == '' || fm.trf_amt5.value == '0')	{
					
				}else{	
					if(fm.trf_st5.value == '')			{ alert('임시운행보험료 지급수단을 선택하십시오.'); 	fm.trf_st5.focus(); 		return; }
					if(fm.trf_st5.value == '1'){
						if(fm.card_kind5.value == '') 	{ alert('임시운행보험료 지급금융사를 입력하십시오.'); 	fm.card_kind5.focus(); 		return; }
						if(fm.cardno5.value == '') 		{ alert('임시운행보험료 계좌번호를 입력하십시오.'); 		fm.cardno5.focus(); 	return; }
						if(fm.trf_cont5.value == '') 	{ alert('임시운행보험료 계좌예금주를 입력하십시오.'); 	fm.trf_cont5.focus(); 		return; }
						if(fm.trf_est_dt5.value == '') 	{ alert('임시운행보험료 지급예정일을 입력하십시오.'); 	fm.trf_est_dt5.focus(); 	return; }
					}	
				}	
			}
					
					
		}
	
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_u_a.jsp';		
			fm.target='d_content';
			fm.submit();
		}							
	}
		
	function change_eval_input(){
		var fm = document.form1;
		
		var eval_select = fm.eval_select;
		var eval_select_length = eval_select.length;
		
		for(var i=0; i<eval_select_length; i++){
			if(eval_select[i].selectedIndex == 1){
				eval_select[i].nextElementSibling.style.display = 'none';
				eval_select[i].nextElementSibling.value = '';
			} else {
				eval_select[i].nextElementSibling.style.display = 'inline';
			}
		}
	}

	//결재요청하기
	function sanction_req(){
		var fm = document.form1;
		if(toInt(fm.chk_cnt.value) > 0){
			alert('입력값 체크 결과 확인이 필요한 항목이 '+toInt(fm.chk_cnt.value)+'건 발생했습니다.');
			return;
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
		
	//임직원운전한정특약 미가입 승인 처리
	function Com_emp_sac(){
		var fm = document.form1;
		var ment = '';
		if(fm.com_emp_yn.value=='Y'){
			ment = '가입';
		}else if(fm.com_emp_yn.value=='N'){
			ment = '미가입';
		}else{
			alert('임직원운전한정특약 가입여부를 입력하십시오.'); return;
		}
		fm.idx.value = 'com_emp_sac';
		<%if(client.getClient_st().equals("1")){ %>
		if(ment=='미가입'){
    		if(fm.others.value == ''){ alert('* 고객의 임직원운전한정특약 미가입 사유를 보험관리-비고에 입력하십시오.'); return; }
			if(confirm('법인 고객의 임직원운전한정특약 미가입 사유를 보험관리-비고에 입력하십시오. \n\n 임직원운전한정특약 미가입 승인 처리하시겠습니까?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}
		}else{
			alert('가입승인이 필요없습니다.');
		}	
		<%}else{%>
		if(ment=='가입'){
			if(fm.others.value == ''){ alert('* 고객의 임직원운전한정특약 가입 사유를 보험관리-비고에 입력하십시오.'); return; }
			if(confirm('개인사업자 고객의 임직원운전한정특약 가입 사유를 보험관리-비고에 입력하십시오. \n\n 성실신고대상자로 임직원운전한정특약 가입 승인처리하시겠습니까?')){	
				fm.action='lc_b_u_a.jsp';		
				fm.target='i_no';
				fm.submit();
			}	
		}else{
			alert('미가입승인이 필요없습니다.');	
		}			
		<%}%>
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
		if(cnt == 0){
		 	alert("일괄 등록할 스캔항목을 선택하세요.");
			return;
		}		
		window.open('about:blank', "SCAN_ALL", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "SCAN_ALL";
		fm.action = "reg_scan_all.jsp";
		fm.submit();
	}
	//스캔복사-일괄
	function scan_all_copy(){
		var fm = document.form1;			
		window.open('about:blank', "SCAN_ALL_COPY", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "SCAN_ALL_COPY";
		fm.action = "reg_scan_all_copy.jsp";
		fm.submit();
	}
		
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	
	//출고전대차 규정대여료 계산 (견적)
	function estimate_taecha(st){
		var fm = document.form1;
		
		if(fm.tae_car_mng_id.value == '' && '<%=base.getRent_st()%>' == '3' && fm.tae_car_no.value == '<%=cr_bean.getCar_no()%>'){
			fm.tae_car_mng_id.value 	= '<%=cr_bean.getCar_mng_id()%>';
			fm.tae_car_id.value 		= '<%=cm_bean.getCar_id()%>';
			fm.tae_car_seq.value 		= '<%=cm_bean.getCar_seq()%>';
			fm.tae_car_nm.value 		= '<%=cr_bean.getCar_nm()%>';
			fm.tae_init_reg_dt.value 	= '<%=cr_bean.getInit_reg_dt()%>';						
		}
		
		if(fm.tae_car_mng_id.value == '')	{ alert('출고전대차 차량을 선택하십시오.');	return;}		
		if(fm.tae_car_id.value == '')		{ alert('출고전대차 차량을 다시 선택하십시오.');	return;}		
						
		fm.esti_stat.value 	= st;
				
		if(st == 'view'){
			fm.target = '_blank';
		}else{
			fm.target = 'i_no';
		}		

		fm.action='get_fee_estimate_taecha.jsp';			
							
		fm.submit();
	}		
	
	//견적서인쇄
	function TaechaEstiPrint(est_id){ 
		var fm = document.form1;  
		var SUBWIN="/acar/secondhand_hp/estimate.jsp?from_page=<%=from_page%>&est_id="+est_id;  	
		window.open(SUBWIN, "SubList", "left=10, top=10, width=700, height=800, scrollbars=yes, status=yes, resizable=yes"); 		
	}	
	
	//물적사고할증기준 선택에 따라 자기부담금 셋팅
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.cacdt_memin_amt.value = toInt(fm.cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.cacdt_mebase_amt.value) >0){
			fm.cacdt_me_amt.value = 50;
		}
	}	
	
	function search_cms(idx){		var fm = document.form1;		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}			window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");			}
	//만나이계산하기
	function age_search()
	{
		var fm = document.form1;
		window.open("about:blank",'age_search','scrollbars=yes,status=no,resizable=yes,width=360,height=250,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_age.jsp?mode=EM";
		fm.target = "age_search";
		fm.submit();		
	}	
	//변경이력관리항목 수정
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}
	}	
	
	//직원조회
	function User_search(nm, idx)
	{
		var fm = document.form1;
		var t_wd = '';
		if(idx == '')	t_wd = fm.user_nm.value;
		else  		t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=600,left=370,top=200');		
		fm.action = "/agent/lc_rent/search_user.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&mode=EMP&nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	
	//에이전트직원조회
	function Agent_User_search(nm)
	{
		var fm = document.form1;
		if(fm.bus_st.value != '7')	{ alert('영업구분이 에이전트일 때만 필요합니다.'); 		return;}
		if(fm.bus_id.value == '')		{ alert('최초영업자를 선택하십시오.'); 		return;}
		var t_wd = fm.agent_emp_nm.value;
		window.open("about:blank",'Agent_User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=370,top=200');
		fm.action = "/fms2/lc_rent/search_agent_user.jsp?mode=EMP_Y&nm="+nm+"&t_wd="+t_wd+"&agent_user_id="+fm.bus_id.value;
		fm.target = "Agent_User_search";
		fm.submit();
	}
	
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
	
	//계약승계내용보기
	function update_suc_commi(){
		window.open("/fms2/lc_rent/lc_b_u_suc_commi.jsp<%=valus%>", "UPDATE_SUC_COMMI", "left=0, top=0, width=1280, height=520, scrollbars=yes, status=yes, resizable=yes");
	}
	
	//출고보전수당
	function cng_input3(){
		var fm = document.form1;
		if(<%=base.getRent_dt()%> >= 20190610){
			if('<%=client.getClient_st()%>'=='1' && '<%=cm_bean.getCar_comp_id()%>'=='0001' && fm.dlv_con_commi_yn[1].checked == true){ 
				if(fm.dir_pur_commi_yn.value == ''){
					if('<%=ej_bean.getJg_g_7()%>' == '3' || '<%=ej_bean.getJg_g_7()%>' == '4'){
						fm.dir_pur_commi_yn.value = 'N';
					}else{
						fm.dir_pur_commi_yn.value = 'Y';
					}					
					//기타(자체)
					if(fm.dir_pur_yn[0].checked == false){
						fm.dir_pur_commi_yn.value = '2';
					}
				}
			}else{														
				fm.dir_pur_commi_yn.value = '';
			}
		}			
	}
	
	//제조사 할인 후 차량가격표기 폼
	function span_dc_view(){
		var fm = document.form1;
		if(fm.dc_view_yn.checked==true){	$("#span_dc_view").css("display","");				}
		else{												$("#span_dc_view").css("display","none");		}
	}
	 	
	
	//전자문서 전송하기2 액타소프트
	function go_edoc2(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;
		fm.link_im_seq.value 	= link_im_seq;
		window.open('about:blank', "EDOC_LINK2", "left=0, top=0, width=900, height=800, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK2";
		fm.action = "/fms2/lc_rent/reg_edoc_link2.jsp";
		fm.submit();
	}	
	
	//출고전대차 검색
	function EstiTaeSearch(){
		var fm = document.form1;
		window.open("about:blank", "ESTI_HISTORY", "left=100, top=10, width=1100, height=800, resizable=yes, scrollbars=yes, status=yes");
		fm.target = 'ESTI_HISTORY';
		fm.action = '/acar/rent_mng/tae_esti_history_cont.jsp';
		fm.submit();		
	}	
	
	//수정
	function update_item(st, rent_st){
		var cmd = "입금선수금 수정";
		if(st == 'grt_amt' || st == 'pp_amt' || st == 'ifee_amt'){
			if(st == 'pp_amt'){
				<%if(max_fee.getPp_chk().equals("0")){%>cmd = "매월균등발행 입금선수금 수정"<%}%>		
			}
			window.open("/agent/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st+"&cmd="+cmd, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650");
		}
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
<form action='/acar/secondhand/getSecondhandBaseSet.jsp' name="sh_form" method='post'>
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="car_mng_id"		value="<%=base.getCar_mng_id()%>">  
  <input type='hidden' name="mode"			value="lc_rent">    
  <input type='hidden' name="rent_dt"			value="">    
  <input type='hidden' name="rent_st"			value="">      
  <input type='hidden' name="a_b"			value="">     
  <input type='hidden' name="fee_opt_amt"		value="">
  <input type='hidden' name="cust_sh_car_amt"		value="">   
  <input type='hidden' name="sh_amt"			value="">     
  <input type='hidden' name="cls_n_mon"			value="">     
  <input type='hidden' name="today_dist"		value="">         
</form>
<form action='lc_b_u_a.jsp' name="form1" method='post'>
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
  <input type='hidden' name='from_page'	 		value='<%=from_page%>'>   
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
  <input type='hidden' name="est_from"			value="lc_b_u">
  <input type='hidden' name="fee_opt_amt"		value="">  
  <input type='hidden' name="rent_mng_id2"		value="">    
  <input type='hidden' name="rent_l_cd2"		value="">      
  <input type='hidden' name="fee_rent_st"		value="<%=rent_st%>">        
  <input type='hidden' name="fee_rent_dt"		value="">          
  <input type='hidden' name="ins_chk1"			value="">        
  <input type='hidden' name="ins_chk2"			value="">          
  <input type='hidden' name="ins_chk3"			value="">            
  <input type='hidden' name="ins_chk4"			value="">            
  <input type='hidden' name="now_stat"			value="<%=now_stat%>">            
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value="">  
  <input type='hidden' name="link_im_seq"		value="">  
  <input type='hidden' name="msg_st"		value="">
  <input type='hidden' name='from_page2'	 	value='/agent/lc_rent/lc_b_u.jsp'>
  <input type='hidden' name="prev_new_license_plate"		value="">
  
  <input type="hidden" name="lkas_yn_org" id="lkas_yn_org" value="<%=cont_etc.getLkas_yn()%>"><!-- 차선이탈 제어형 기존 설정 값 -->
  <input type="hidden" name="ldws_yn_org" id="ldws_yn_org" value="<%=cont_etc.getLdws_yn()%>"><!-- 차선이탈 경고형 기존 설정 값 -->
  <input type="hidden" name="aeb_yn_org" id="aeb_yn_org" value="<%=cont_etc.getAeb_yn()%>"><!-- 긴급제동 제어형 기존 설정 값 -->
  <input type="hidden" name="fcw_yn_org" id="fcw_yn_org" value="<%=cont_etc.getFcw_yn()%>"><!-- 긴급제동 경고형 기존 설정 값 -->
  <input type="hidden" name="hook_yn_org" id="hook_yn_org" value="<%=cont_etc.getHook_yn()%>"><!-- 견인고리 기존 설정 값 -->
  <input type="hidden" name="legal_yn_org" id="legal_yn_org" value="<%=cont_etc.getLegal_yn()%>"><!-- 법률비용지원금(고급형) 기존 설정 값 -->  
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 계약관리 > <span class=style5>미결계약</span></span></td>
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
                    <td width=20%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=10%>영업지점</td>
                    <td width=20%>&nbsp;<%=c_db.getNameById(base.getBrch_id(),"BRCH")%></td>
                    <td class=title width=10%>관리지점</td>
                    <td>&nbsp;<%=c_db.getNameById(cont_etc.getMng_br_id(),"BRCH")%></td>
                </tr>
                <tr>
                    <td class=title>계약일자</td>
                    <td>&nbsp;					 
					  <%if(base.getCar_mng_id().equals("") && user_id.equals(base.getBus_id())){%>
        			  	  <input type="text" name="rent_dt" value="<%=AddUtil.ChangeDate2(base.getRent_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(base.getRent_dt())%>
					  <input type='hidden' name='rent_dt' 	value='<%=base.getRent_dt()%>'>				
					  <%}%>
		    </td>
                    <td class=title>계약구분</td>
                    <td>&nbsp;
                      <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
        			  	<select name="rent_st">
                      		<option value=''>선택</option>
                      		<option value='1' <%if(base.getRent_st().equals("1")){%>selected<%}%>>신규</option>
                      		<option value='3' <%if(base.getRent_st().equals("3")){%>selected<%}%>>대차</option>
                      		<option value='4' <%if(base.getRent_st().equals("4")){%>selected<%}%>>증차</option>
                      	</select>
                      <%}else{ %>
                      	<%if(base.getRent_st().equals("1")){%>신규<%}%>
                      	<%if(base.getRent_st().equals("3")){%>대차<%}%>
                      	<%if(base.getRent_st().equals("4")){%>증차<%}%>                      
                      	<input type='hidden' name='rent_st' 	value='<%=base.getRent_st()%>'>
                      <%} %>
                    </td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;
					  에이젼트
					  <input type='hidden' name='bus_st' 	value='<%=base.getBus_st()%>'>				
                    </td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;<%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("2")){%>예비<%}%>
                    <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;
                      <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>
        			  	<select name="rent_way">
                        	<option value=''>선택</option>
                        	<option value='1' <%if(max_fee.getRent_way().equals("1")){%>selected<%}%>>일반식</option>                        	
                        	<option value='3' <%if(max_fee.getRent_way().equals("3")){%>selected<%}%>>기본식</option>
                      	</select>
                      <%}else{ %>
                      	<%if(max_fee.getRent_way().equals("1")){%>일반식<%}%>                      	
                      	<%if(max_fee.getRent_way().equals("3")){%>기본식<%}%>                      
                      	<input type='hidden' name='rent_way' 	value='<%=max_fee.getRent_way()%>'>
                      <%} %>
                      </td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;
                        <%=c_db.getNameById(base.getBus_id(),"USER")%>
			<input type='hidden' name='bus_id' 		value='<%=base.getBus_id()%>'>
                    </td>
                    <td class=title>영업대리인</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="bus_agnt_id" value="<%=cont_etc.getBus_agnt_id()%>">
			<a href="javascript:User_search('bus_agnt_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
		    </td>
                    <td class=title>차량이용지역</td>
                    <td>&nbsp;
                    	<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
                        <input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
			<%if(base.getUse_yn().equals("")){%>
			<a href="javascript:item_cng_update('est_area')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			<%}%>
					</td>
                </tr>
                <tr>
				<td class=title>계약진행담당자</td>
                    <td colspan='5'>&nbsp;
                        <input name="agent_emp_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(base.getAgent_emp_id(), "CAR_OFF_EMP")%>" size="12"> 
			<input type="hidden" name="agent_emp_id" value="<%=base.getAgent_emp_id()%>">
			<a href="javascript:Agent_User_search('agent_emp_id');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>						
                    </td>                	

                </tr>					                
            </table>
	    </td>
    </tr>
  	<%if(!san_st.equals("요청")){%>
	<tr>
	    <td align="right"><a href="javascript:update('0')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<%}%>
	<tr>
	    <td class=h></td>
	</tr>					

    <!--계약승계-->
    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>    
    <tr>
      <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약승계</span>
        &nbsp;<%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update_suc_commi()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%>
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
	
	<tr>
	    <td class=h></td>
	</tr>
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
                      <input type='text' name="firm_nm" value='<%=client.getFirm_nm()%>' size='50' class='text' readonly>                      
                      <%if(client.getClient_id().equals("000228")){%>
        	        <span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>        	      
        	      <%}%>
        	      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					  
        	    </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
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
                    <td height="26" class='left'>&nbsp; 
        			  <input type='text' name="site_nm" value='<%=site.getR_site()%>' size='50' class='text' readonly>
        			  <input type='hidden' name='site_id' value='<%=base.getR_site()%>'>
        			  <span class="b"><a href='javascript:search_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href='javascript:view_site()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>
        			</td>
                    <td width='10%' class='title'>개업년월일</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="open_year" value='<%=client.getOpen_year()%>' size='22' class='whitetext' readonly></td>					
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class='title'>우편물주소</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="65" value="<%=base.getP_addr()%>">
                    </td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
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
                <%	CarMgrBean mgr1 = new CarMgrBean();
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
                <%//if(!client.getClient_st().equals("1")){ %> 
                <tr>
                    <td class='title'>계약자 운전면허번호</td>
		            <td colspan='3'>&nbsp;<input type='text' name='lic_no' value='<%=base.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'>
						<input type="hidden" name="ssn" value="<%=client.getSsn1()%><%=client.getSsn2()%>">
					</td>
		            <td>&nbsp;(개인,개인사업자)&nbsp;※ 계약자(<%=client.getClient_nm()%>)의 운전면허번호를 기재</td>
                </tr>
                <tr>
                    <td class='title' width='13%'>차량이용자 운전면허번호</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no' value='<%=base.getMgr_lic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;이름 : <input type='text' name='mgr_lic_emp' value='<%=base.getMgr_lic_emp()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='mgr_lic_rel' value='<%=base.getMgr_lic_rel()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;(개인,개인사업자)<%if(client.getClient_st().equals("3")||client.getClient_st().equals("4")||client.getClient_st().equals("5")){%>&nbsp;※ 계약자가 운전면허가 없는 경우 차량이용자의 운전면허를 입력<%}%></td>
                </tr>  
	            <%//} %>  
	                
                <tr>
                    <td class='title' width='13%'>추가운전자 운전면허번호</td>
		            <td width='15%'>&nbsp;<input type='text' name='mgr_lic_no5' value='<%=mgr5.getLic_no()%>'  size='20' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='20%'>&nbsp;이름 : <input type='text' name='mgr_lic_emp5' value='<%=mgr5.getMgr_nm()%>'  size='10' class='text'></td>
		            <td width='13%'>&nbsp;관계 : <input type='text' name='mgr_lic_rel5' value='<%=mgr5.getEtc()%>'  size='10' class='text' onBlur='javascript:CheckLen(this.value,20)'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='mgr_lic_result5'>
        		          		<option value='' <%if(mgr5.getLic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(mgr5.getLic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select>&nbsp;※ 계약서의 "운전자범위" 외의 운전자를 추가운전자로 허용하는 경우에는 추가운전자 운전가격을 검증</td>
                </tr>                
    	                 
            
                <!-- 운전자격검증결과 -->
                   
                <tr>
                    <td class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp' value='<%=base.getTest_lic_emp()%>'  size='8' class='text'></td>
		            <td>&nbsp;관계 : <input type='text' name='test_lic_rel' value='<%=base.getTest_lic_rel()%>'  size='10' class='text'></td>
		            <td>&nbsp;검증결과 : <select name='test_lic_result'>
        		          		<option value='' <%if(base.getTest_lic_result().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
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
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='<%=mgr.getCom_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='<%=mgr.getMgr_dept()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='<%=mgr.getMgr_title()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
				<%	String email_1 = "";
					String email_2 = "";
					if(!mgr.getMgr_email().equals("")){
						int mail_len = mgr.getMgr_email().indexOf("@");
						if(mail_len > 0){
							email_1 = mgr.getMgr_email().substring(0,mail_len);
							email_2 = mgr.getMgr_email().substring(mail_len+1);
						}
					}
				%>
                    <td align='center'>
					<input type='text' size='10' name='email_1' value='<%=email_1%>' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' value='<%=email_2%>' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=i%>].value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="daum.net">daum.net</option>
                        <option value="empal.com">empal.com</option>
						<option value="">직접 입력</option>
						</select>
					<input type='hidden' name="mgr_email" value="<%=mgr.getMgr_email()%>">					
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_com'   size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_dept'  size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_nm'    size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_title' size='10' value='' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_tel'   size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'>
					<input type='text' size='10' name='email_1' maxlength='100' class='text' style='IME-MODE: inactive'>@<input type='text' size='10' name='email_2' maxlength='100' class='text' style='IME-MODE: inactive'>
					  <select id="email_domain" onChange="javascript:document.form1.email_2[<%=mgr_size%>].value=this.value;" align="absmiddle">
						<option value="" selected>선택하세요</option>
						<option value="hanmail.net">hanmail.net</option>
						<option value="naver.com">naver.com</option>
						<option value="nate.com">nate.com</option>
						<option value="bill36524.com">bill36524.com</option>
						<option value="gmail.com">gmail.com</option>
						<option value="daum.net">daum.net</option>
						<option value="">직접 입력</option>
						</select>
					<input type='hidden' name="mgr_email" value="">
					</td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>	
				<script>
					function openDaumPostcode1() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip1').value = data.zonecode;
								document.getElementById('t_addr1').value = data.roadAddress;
								
							}
						}).open();
					}
				</script>				
                <tr> 
                    <td colspan="2" class=title>차량이용자 실거주지 주소</td>
                    <td colspan="8">&nbsp;
					<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
					<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr1" size="61" value="<%=mgr_addr%>">
                </tr>
            </table>
        </td>
    </tr>	
    <%if(!san_st.equals("요청")){%>
    <tr>
	    <td align="right"><a href="javascript:update('1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
    <tr>
    <%}%>
<%--     <%if(client.getClient_st().equals("1")){%>	      --%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 공동임차</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
<%--     <%}%>     --%>
    <%-- <tr id=tr_client_share_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">  --%>
    <tr id='tr_client_share_st'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>공동임차여부</td> 
                    <td colspan="4" align='left'>&nbsp;
                      <input type='radio' name="client_share_st" value='1' <%if(cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				있다
        	      <input type='radio' name="client_share_st" value='2' <%if(!cont_etc.getClient_share_st().equals("1"))%>checked<%%> onClick="javascript:cng_input4()">
        				없다</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr id=tr_client_share_st_test style="display:<%if(client.getClient_st().equals("2") && cont_etc.getClient_share_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                
                <!-- 운전자격검증결과 -->
                <tr>
                    <td width='13%' class='title' rowspan='2'>운전자의 운전자격검증</td>
		            <td width='15%'>&nbsp;<input type="button" class="button" value="운전면허정보검증 조회" onclick="javascript:search_test_lic();"></td>
		            <td width='20%'>&nbsp;검증대상자(이름) : <input type='text' name='test_lic_emp2' value='<%=base.getTest_lic_emp2()%>'  size='8' class='text'></td>
		            <td width='12%'>&nbsp;관계 : <input type='text' name='test_lic_rel2' value='<%=base.getTest_lic_rel2()%>'  size='10' class='text'></td>
		            <td width='40%'>&nbsp;검증결과 : <select name='test_lic_result2'>
        		          		<option value='' <%if(base.getTest_lic_result2().equals("")) out.println("selected");%>>선택</option>
        		          		<%for(int i = 0 ; i < code50_size ; i++){
                            		CodeBean code = code50[i];%>
                        		<option value='<%= code.getNm_cd()%>' <%if(base.getTest_lic_result2().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        		<%}%> 
        		            </select></td>
                </tr>  
                <tr>
		            <td colspan='4'>&nbsp;(개인)&nbsp;※ 개인고객의 공동임차인이 있는 경우 운전자격을 검증</td>
                </tr>  
            </table>  
        </td>
    </tr>            
    <%if(client.getClient_st().equals("1")){%>	 
       
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <%}%>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				입보
        			  <input type='radio' name="client_guar_st" value='2' onClick="javascript:cng_input2()" <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				면제</td>
                </tr>
                <tr id=tr_client_guar style="display:<%if(cont_etc.getClient_guar_st().equals("2")){%>''<%}else{%>none<%}%>">
                    <td class='title'>면제조건</td>
                    <td width="50%" height="26" class='left'>&nbsp;
                        <select name='guar_con'>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getGuar_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="guar_sac_id" value="<%=cont_etc.getGuar_sac_id()%>">			
			<a href="javascript:User_search('guar_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
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
                      <input type='radio' name="guar_st" value='1' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("1")){%>checked<%}%>>
        				입보
        			  <input type='radio' name="guar_st" value='2' onClick="javascript:guar_display()" <%if(cont_etc.getGuar_st().equals("2")){%>checked<%}%>>
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
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value='<%=gur.get("GUR_SSN")%>'></td>
                                <td align="center"><input type="text" name="t_zip"  size="7"   class='text' value='<%=gur.get("GUR_ZIP")%>'>&nbsp;<input type='text' name="t_addr" size='25' class='text' value='<%=gur.get("GUR_ADDR")%>'></td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                      <%for(int i=gur_size; i<3; i++){%>
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
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
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	
	<%}%>
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
                    <td width=20%>&nbsp;<input type='text' size='30' name='job' value='<%=client.getJob()%>' maxlength='20' class='text'></td>
                    <td class=title width=10%>소득구분</td>
                    <td colspan="3">&nbsp;
        			  <select name='c_pay_st'>
        		          		<option value='0' <%if(client.getPay_st().equals("")) out.println("selected");%>>선택</option>
        		            	<option value='1' <%if(client.getPay_st().equals("1")) out.println("selected");%>>급여소득</option>
        		                <option value='2' <%if(client.getPay_st().equals("2")) out.println("selected");%>>사업소득</option>
        		                <option value='3' <%if(client.getPay_st().equals("3")) out.println("selected");%>>기타사업소득</option>
        		            </select>
        			</td>
                </tr>
    		    <tr>
        		    <td class='title'>직장명</td>
        		    <td>&nbsp;<input type='text' size='30' name='com_nm' value='<%=client.getCom_nm()%>' maxlength='15' class='text'></td>
                    <td class=title width=10%>근속연수</td>
                    <td width=20%>&nbsp;<input type='text' size='2' name='wk_year' value='<%=client.getWk_year()%>' maxlength='2' class='text'>년</td>
                    <td class=title width=10%>연소득</td>
                    <td>&nbsp;<input type='text' size='7'  name='pay_type' maxlength='9' class='text' value='<%=client.getPay_type()%>'>&nbsp;만원
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
		                <input type='text' name='c_kisu' size='10' value='<%=c_fin.getC_kisu()%>' maxlength='20' class='text' >
		            기)</td>
		            <td width="43%" class=title>전기(
		                <input type='text' name='f_kisu' size='10' value='<%=c_fin.getF_kisu()%>' maxlength='20' class='text' >
		            기)</td>
		        </tr>
		        <tr>
		            <td class=title>&nbsp;&nbsp;
					(
		            	<input type='text' name='c_ba_year_s' size='11' class='text' maxlength='11' value='<%=c_fin.getC_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='c_ba_year' size='10' class='text' maxlength='10' value='<%=c_fin.getC_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		     
		            <td class='title'>&nbsp;&nbsp;
					(
		            	<input type='text' name='f_ba_year_s' size='11' class='text' maxlength='11' value='<%=c_fin.getF_ba_year_s()%>' onBlur='javascript:this.value=ChangeDate(this.value)' >~<input type='text' name='f_ba_year' size='10' class='text' maxlength='10' value='<%=c_fin.getF_ba_year()%>' onBlur='javascript:this.value=ChangeDate(this.value)' > )</td>
		              
		        </tr>
		        <tr>
		            <td colspan="2" class=title>자산총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_asset_tot())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td width="3%" rowspan="2" class=title>자<br>
		            본</td>
		            <td width="9%" class=title>자본금</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td class=title>자본총계</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_cap_tot())%>'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원</td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>매출</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_sale())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		        <tr>
		            <td colspan="2" class=title>당기순이익</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getC_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='num' value='<%=AddUtil.parseDecimal(c_fin.getF_profit())%>' onBlur='javascript:this.value=parseDecimal(this.value);' >
		            백만원 </td>
		        </tr>
		    </table>	     
        </td>
    </tr>
	<%}%>    
	<%if(!san_st.equals("요청")){%>
	<tr>
	    <td align="right"><a href="javascript:update('3')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>		
	<%}%>	
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
        		  	if(client.getClient_st().equals("2")){
        		  		eval3 = a_db.getContEval(rent_mng_id, rent_l_cd, "3", "");
        				if(eval3.getEval_nm().equals("")) eval3.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='3'><input type='hidden' name='e_seq' value='<%=eval3.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval3.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval3.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval3.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval3.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval3.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval3.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval3.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval3.getEval_off().equals("2")||eval3.getEval_off().equals("")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval3.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval3.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%
        		  	
        		  		eval5 = a_db.getContEval(rent_mng_id, rent_l_cd, "5", "");
        				if(eval5.getEval_nm().equals("")) eval5.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr>
                    <td class=title>계약자<input type='hidden' name='eval_gu' value='5'><input type='hidden' name='e_seq' value='<%=eval5.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval5.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center" >
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval5.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval5.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval5.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval5.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval5.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval5.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval5.getEval_off().equals("2")||eval5.getEval_off().equals("")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("3")){
        				  	for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval5.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval5.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval5.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%}else{
        		  		eval1 = a_db.getContEval(rent_mng_id, rent_l_cd, "1", "");
        				if(eval1.getEval_nm().equals("")) eval1.setEval_nm(client.getFirm_nm());
        				eval_cnt++;%>
                <tr id=tr_eval_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인<input type='hidden' name='eval_gu' value='1'><input type='hidden' name='e_seq' value='<%=eval1.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval1.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval1.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval1.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval1.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center"><input type='hidden' name='eval_score' value=''></td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval1.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval1.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval1.getEval_off().equals("2")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("3")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval1.getEval_off().equals("1")||eval1.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd3.length; i++){
        						CodeBean cd = gr_cd3[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
                    <td align="center"><input type='text' name='eval_b_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_b_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>					
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval1.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){
        		  			eval2 = a_db.getContEval(rent_mng_id, rent_l_cd, "2", "");
        					if(eval2.getEval_nm().equals("")) eval2.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='2'><input type='hidden' name='e_seq' value='<%=eval2.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval2.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval2.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval2.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval2.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval2.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval2.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval2.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval2.getEval_off().equals("2")||eval2.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("3")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval2.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval2.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			eval6 = a_db.getContEval(rent_mng_id, rent_l_cd, "6", "");
        					if(eval6.getEval_nm().equals("")) eval6.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%><input type='hidden' name='eval_gu' value='6'><input type='hidden' name='e_seq' value='<%=eval6.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval6.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval6.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval6.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval6.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval6.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval6.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval6.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval6.getEval_off().equals("2")||eval6.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("3")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval6.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval6.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval6.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>                
        		  <%	}%>

        		  <%	
        		  	if(cont_etc.getClient_share_st().equals("1")){
        		  			eval7 = a_db.getContEval(rent_mng_id, rent_l_cd, "7", "");
        					if(eval7.getEval_nm().equals("")) eval7.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='7'><input type='hidden' name='e_seq' value='<%=eval7.getE_seq()%>'>
                    </td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval7.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval7.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval7.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval7.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval7.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval7.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval7.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval7.getEval_off().equals("2")||eval7.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("3")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval7.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval7.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	
        		  			eval8 = a_db.getContEval(rent_mng_id, rent_l_cd, "8", "");
        					if(eval8.getEval_nm().equals("")) eval8.setEval_nm(client.getClient_nm());
        					eval_cnt++;%>
                <tr>
                    <td class=title>공동임차인<input type='hidden' name='eval_gu' value='8'><input type='hidden' name='e_seq' value='<%=eval8.getE_seq()%>'></td>
                    <td align="center"><input type='text' name='eval_nm' size='20' class='whitetext' value='<%=eval8.getEval_nm()%>' onBlur='javascript:CheckLen(this.value,30)' style='IME-MODE: active'></td>
                    <td align="center">
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval8.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval8.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval8.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval8.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval8.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval8.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval8.getEval_off().equals("2")||eval8.getEval_off().equals("")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("3")){
        				    for(int i =0; i<gr_cd1.length; i++){
        						CodeBean cd = gr_cd1[i];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval8.getEval_off().equals("1")){
        				    for(int i =0; i<gr_cd2.length; i++){
        						CodeBean cd = gr_cd2[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval8.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>				  
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval8.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
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
                      <select name='eval_off' onChange="javascript:SetEval_gr(<%=eval_cnt%>)">
                          <option value="">선택</option>
                          <option value="1" <%if(eval4.getEval_off().equals("1")) out.println("selected");%>>크레탑</option>
                          <option value="2" <%if(eval4.getEval_off().equals("2")) out.println("selected");%>>NICE</option>
                          <option value="3" <%if(eval4.getEval_off().equals("3")) out.println("selected");%>>KCB</option>
                      </select>
                    </td>
                    <td align="center">
                    	<select name="eval_select" onchange="javascript:change_eval_input()">
                    		<option value="">입력</option>
                    		<option value="">생략</option>
                    	</select>
                    	<input type='text' name='eval_score' class="text" size="12" value='<%=eval4.getEval_score()%>'>
                    </td>
                    <td align="center">
                      <select name='eval_gr' style="width: 118px;">
                          <option value="">선택</option>
                          <option value="없음" <%if(eval4.getEval_gr().equals("없음")) out.println("selected");%>>없음</option>
                          <option value="생략" <%if(eval4.getEval_gr().equals("생략")) out.println("selected");%>>생략</option>
        				  <%if(eval4.getEval_off().equals("2")||eval4.getEval_off().equals("")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("3")){
        				    for(int j =0; j<gr_cd1.length; j++){
        						CodeBean cd = gr_cd1[j];
        						String scope = "";
                				switch(cd.getNm_cd()){
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
        					<option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%><%=scope%></option>
        				  <%}}%>
        				  <%if(eval4.getEval_off().equals("1")){
        				    for(int j =0; j<gr_cd2.length; j++){
        						CodeBean cd = gr_cd2[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getEval_gr().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}}%>
                      </select>			
        			</td>
					<td align="center">&nbsp;<input type='hidden' name='eval_b_dt' value=''></td>
                    <td align="center"><input type='text' name='eval_s_dt' size='11' class='text' value='<%=AddUtil.ChangeDate2(eval4.getEval_s_dt())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                </tr>
        		  <%	}
        		  	}%>
            </table>
        </td>
    </tr>
	  <input type='hidden' name="eval_cnt"			value="<%=eval_cnt%>">              
	<%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('4')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>			
	<%}%>	
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
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode2() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip2').value = data.zonecode;
									document.getElementById('t_addr2').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>			
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=eval3.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=eval3.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval3.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode3() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip3').value = data.zonecode;
									document.getElementById('t_addr3').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="<%=eval3.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="<%=eval3.getAss2_addr()%>">
					</td>
                </tr> 
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
                  <% }else{%>
                <tr id=tr_dec_firm style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>">
                    <td class=title>법인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=eval1.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr4" size="25" value="<%=eval1.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval1.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode5() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip5').value = data.zonecode;
									document.getElementById('t_addr5').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip5" size="7" maxlength='7' value="<%=eval1.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode5()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr5" size="25" value="<%=eval1.getAss2_addr()%>">
					</td>
                </tr>
        		  <%	if(!cont_etc.getClient_guar_st().equals("2")){%>
                <tr>
                    <td class=title><%if(client.getClient_st().equals("1")){%>대표이사<%}else{%>사장<%}%></td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode6() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip6').value = data.zonecode;
									document.getElementById('t_addr6').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip6" size="7" maxlength='7' value="<%=eval2.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode6()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr6" size="25" value="<%=eval2.getAss1_addr()%>">
					</td>
                    
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval2.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
                    <script>
						function openDaumPostcode7() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip7').value = data.zonecode;
									document.getElementById('t_addr7').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip7" size="7" maxlength='7' value="<%=eval2.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode7()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr7" size="25" value="<%=eval2.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
        		  <% 	} %>
        		  
        		  
        		  <%	if(cont_etc.getClient_share_st().equals("1")){%>
                <tr>
                    <td class=title>공동임차인</td>
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode8() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip8').value = data.zonecode;
									document.getElementById('t_addr8').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip8" size="7" maxlength='7' value="<%=eval7.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode8()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr8" size="25" value="<%=eval7.getAss1_addr()%>">
					</td>
                    
        			<% zip_cnt++;%>
                    <td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int i =0; i<ass_cd.length; i++){
        						CodeBean cd = ass_cd[i];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval7.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
                    <script>
						function openDaumPostcode9() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip9').value = data.zonecode;
									document.getElementById('t_addr9').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip9" size="7" maxlength='7' value="<%=eval7.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode9()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr9" size="25" value="<%=eval7.getAss2_addr()%>">
					</td>
                </tr>
                <input type='hidden' name="ass1_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                <input type='hidden' name="ass2_type"			value="">  
                <input type='hidden' name="t_zip"			value="">  
                <input type='hidden' name="t_addr"			value="">  
                
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
                      <select name='ass1_type'>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss1_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>						
        			</td>
					<script>
						function openDaumPostcode10() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip10').value = data.zonecode;
									document.getElementById('t_addr10').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip10" size="7" maxlength='7' value="<%=eval4.getAss1_zip()%>">
					<input type="button" onclick="openDaumPostcode10()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr10" size="25" value="<%=eval4.getAss1_addr()%>">
					</td>
        			<% zip_cnt++;%>
        			<td align="center">
                      <select name='ass2_type'>
                          <option value="">선택</option>
        				  <%for(int j =0; j<ass_cd.length; j++){
        						CodeBean cd = ass_cd[j];%>
                          <option value="<%=cd.getNm_cd()%>" <%if(eval4.getAss2_type().equals(cd.getNm_cd())) out.println("selected");%>><%=cd.getNm()%></option>
        				  <%}%>
                      </select>			
        			</td>
					<script>
						function openDaumPostcode11() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip11').value = data.zonecode;
									document.getElementById('t_addr11').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
                    <td align="center">
					<input type="text" name="t_zip"  id="t_zip11" size="7" maxlength='7' value="<%=eval4.getAss2_zip()%>">
					<input type="button" onclick="openDaumPostcode11()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr11" size="25" value="<%=eval4.getAss2_addr()%>">
					</td>
					<% zip_cnt++;%>
                </tr>
        		  <%	}
        		  	}%>		
            </table>
        </td>
    </tr>
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('5')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
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
                    <td>&nbsp;<textarea name='dec_etc' rows='5' cols='100' maxlenght='500'><%=cont_etc.getDec_etc()%></textarea></td>
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
        	        <%if(cont_etc.getDec_gr().equals("")) cont_etc.setDec_gr(base.getSpr_kd());%>
                            <select name='dec_gr'>  
                                <!-- 
                                <option value=''>선택</option>
                                <option value='3' <%if(cont_etc.getDec_gr().equals("3")){%>selected<%}%>>신설법인</option>
                                <option value='0' <%if(cont_etc.getDec_gr().equals("0")){%>selected<%}%>>일반고객</option>
                                 -->
                                <option value='1' <%if(cont_etc.getDec_gr().equals("1")){%>selected<%}%>>우량기업</option>
                                <option value='2' <%if(cont_etc.getDec_gr().equals("2")){%>selected<%}%>>초우량기업</option> 
                            </select>        	        
                    </td>                       
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_f_id(), "USER")%>
			<input type="hidden" name="dec_f_id" value="<%=cont_etc.getDec_f_id()%>">						
                    </td>
                    <td align="center"><input type='text' name='dec_f_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.ChangeDate2(cont_etc.getDec_f_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td align="center">
                        <%=c_db.getNameById(cont_etc.getDec_l_id(), "USER")%>
			<input type="hidden" name="dec_l_id" value="<%=cont_etc.getDec_l_id()%>">			
               	    </td>
                    <td align="center"><input type='text' name='dec_l_dt' size='11' maxlength='20' class='whitetext' value='<%=AddUtil.ChangeDate2(cont_etc.getDec_l_dt())%>' ></td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('7')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
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
        		    <td width="20%">&nbsp;<%=cr_bean.getCar_no()%></td>
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
                    <td>&nbsp;<%=cm_bean.getDpm()%>cc</td>
                </tr>
                <tr>
                    <td class='title'>GPS위치추적정치</td>
                    <td colspan="5">&nbsp;
        			  <%if(cr_bean.getGps().equals("Y")){%>장착<%}else{%>미장착<%}%>
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
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !san_st.equals("요청")){%>    
	<tr>
	    <td align="right"><a href="javascript:reset_car()"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr></tr><tr></tr>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td class='title'>색상</td>
                    <td colspan="5">&nbsp;                        
        			  <input type='text' name='color' size='45' maxlength='100' class='text' value='<%=car.getColo()%>'>
					  &nbsp;&nbsp;&nbsp;
					  (내장색상(시트): <input type='text' name="in_col" size='20' class='text' value='<%=car.getIn_col()%>'> )  
					  &nbsp;&nbsp;&nbsp;
					  (가니쉬: <input type='text' name="garnish_col" size='20' class='text' value='<%=car.getGarnish_col()%>'> )  
        			  </td>
                </tr>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
                <tr>
                    <td class='title'>전기차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="ecar_loc_st">
                    	  <option value=""  <%if(pur.getEcar_loc_st().equals(""))%>selected<%%>>선택</option>
                    	  <%for(int i = 0 ; i < code34_size ; i++){
                            CodeBean code = code34[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getEcar_loc_st().equals(code.getNm_cd())){%>selected<%}%> <%if(Integer.parseInt(cm_bean.getJg_code()) > 8000000 && (code.getNm_cd().equals("12") || code.getNm_cd().equals("13"))){ %>style='display: none;'<%} %>><%= code.getNm()%></option>
                        <%}%>        
                      </select>                    	     			  
        			  </td>
                </tr>		
                <%}%>	  
                <%if(ej_bean.getJg_g_7().equals("4")){//수소차%>
                <tr>
                    <td class='title'>수소차 고객주소지</td>
                    <td colspan="5">&nbsp;
                        <select name="hcar_loc_st">
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
                    <%-- <td class='title'>맑은서울스티커 발급<br>(남산터널 이용 전자태그)</td>
                    <td colspan="5">&nbsp;
                        <select name="eco_e_tag" id="eco_e_tag">
                    	  <option value=""  <%if(car.getEco_e_tag().equals(""))%>selected<%%>>선택</option>
                        <option value="0" <%if(car.getEco_e_tag().equals("0"))%>selected<%%>>미발급</option>
                        <option value="1" <%if(car.getEco_e_tag().equals("1"))%>selected<%%>>발급</option>
                      </select>
                      &nbsp;※ 친환경차 고객 중 남산터널 실이용자만 발급 선택, 하이브리드/플러그인 하이브리드 차량의 경우 서울등록으로 대여료가 소폭 상승됨.
        			      </td> --%>
	                <input type="hidden" name="eco_e_tag" id="eco_e_tag" value="<%=car.getEco_e_tag()%>">	                     
                </tr>		
                <%}%> 
                <tr>
                    <td class='title'>차량인수지</td>
                    <td colspan="5">&nbsp;
                        <select name="udt_st">
                        <option value=''>선택</option>
                        <%for(int i = 0 ; i < code35_size ; i++){
                            CodeBean code = code35[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(pur.getUdt_st().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
        			  &nbsp; 인수시 탁송료 :
        			  <input type='text' name='cons_amt1' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(pur.getCons_amt1())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원 (고객인수일 때는 직접 입력하세요.)
        			  </td>
                </tr>			  
                <tr>
                    <td width='13%' class='title'>등록지역</td>
                    <td colspan="5">&nbsp;
                      <select name="car_ext" id="car_ext">
                      	<option value=''>선택</option>
                		<%for(int i = 0 ; i < code32_size ; i++){
                            CodeBean code = code32[i];%>
                        <option value='<%= code.getNm_cd()%>' <%if(car.getCar_ext().equals(code.getNm_cd())){%>selected<%}%>><%= code.getNm()%></option>
                        <%}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('8_1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>
    <tr> 
        <td class='line'> 			
            <table border="0" cellspacing="1" cellpadding="0" width=100%>	
                <tr>
                    <td width='13%' class='title'>썬팅</td>
                    <td <% if (base.getCar_gu().equals("1") && cm_bean.getCar_comp_id().equals("0001")) { %> width='10%' <% } else { %> colspan="3" <% } %>>&nbsp;
                      <input type='text' name="sun_per" value='<%=car.getSun_per()%>' size="4" maxlength="4" class='text'> %
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
	                        <select name="bluelink_yn">
	                            <option value='' <%if(car.getBluelink_yn().equals(""))%>selected<%%>>선택</option>
	                            <option value='Y' <%if(car.getBluelink_yn().equals("Y"))%>selected<%%>>있음</option>
	                            <option value='N' <%if(car.getBluelink_yn().equals("N"))%>selected<%%>>없음</option>
	                        </select>
	                        <span style="font-size : 8pt; letter-spacing: -0.6px;">&nbsp;※ 있음선택시 블루링크 가입 안내문 알림톡발송(스케줄생성시)</span>
	                    </td>
                    <% } %>
                </tr>
                <tr>
                    <td class='title'><span class="title1">출고후추가장착</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='add_opt' size='45' class="text" value='<%=car.getAdd_opt()%>'>
        				&nbsp;<input type='text' name='add_opt_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getAdd_opt_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        					  원&nbsp;<span style="font-size : 8pt;"><font color="#666666">(부가세포함금액,견적반영분,LPG키트제외,네비게이션등)</font></span>
                    </td>
                </tr>

                <tr>
                    <td class='title'><span class="title1">견적반영용품</span></td>
                    <td colspan="5">&nbsp;
                      <input type="checkbox" name="tint_b_yn" value="Y" <%if(car.getTint_b_yn().equals("Y")){%>checked<%}%>> 2채널 블랙박스
                      &nbsp;
                      <input type="checkbox" name="tint_s_yn" value="Y" <%if(car.getTint_s_yn().equals("Y")){%>checked<%}%>> 전면 썬팅(기본형),
                      &nbsp;
                      가시광선투과율 :
                      <input type='text' name="tint_s_per" value='<%=car.getTint_s_per()%>' size="4" maxlength="4" class='text'>
        	      % 
      		      &nbsp;
      		      	<input type="checkbox" name="tint_ps_yn" value="Y" <%if(car.getTint_ps_yn().equals("Y")){%>checked<%}%>> 고급썬팅(전면포함)
      		      	&nbsp; 내용 <input type="text" name="tint_ps_nm" value="<%=car.getTint_ps_nm()%>" size='10' style="text-align:right;">
					&nbsp; 용품점 지급금액 <input type="text" name="tint_ps_amt" value="<%=AddUtil.parseDecimal(car.getTint_ps_amt())%>" size='10' style="text-align:right;"> 원 (부가세별도)
      		      <br>
      		      &nbsp;
                  <input type="checkbox" name="tint_sn_yn" value="Y" <%if(car.getTint_sn_yn().equals("Y")){%>checked<%}%>> 전면썬팅 미시공 할인
      		      &nbsp;
                  <input type="checkbox" name="tint_bn_yn" value="Y" <%if(car.getTint_bn_yn().equals("Y")){%>checked<%}%>> 블랙박스 미제공 할인 
                  &nbsp; 할인사유 : 
                  <select name="tint_bn_nm">
                  		<option value=""  <%if (car.getTint_bn_nm().equals("")){%>selected<%}%>>선택</option>
                  		<option value="2" <%if (car.getTint_bn_nm().equals("2")){%>selected<%}%>>고객장착</option>
                   		<option value="1" <%if (car.getTint_bn_nm().equals("1")){%>selected<%}%>>빌트인캠</option>                   		
                   	</select>
				  &nbsp;
				  <input type="checkbox" name="tint_cons_yn" value="Y" <%if(car.getTint_cons_yn().equals("Y")){%>checked<%}%>> 추가탁송료등
					&nbsp; 금액 <input type="text" name="tint_cons_amt" value="<%=AddUtil.parseDecimal(car.getTint_cons_amt())%>" size='10'> 원
      		      <%if(car.getTint_n_yn().equals("Y")){%>
      		      &nbsp;
                      <input type="checkbox" name="tint_n_yn" value="Y" <%if(car.getTint_n_yn().equals("Y")){%>checked<%}%>> 거치형 내비게이션
      		      <%}%>
                      <%if(ej_bean.getJg_g_7().equals("3")){//전기차%>
      		      &nbsp;
                      <input type="checkbox" name="tint_eb_yn" value="Y" <%if(car.getTint_eb_yn().equals("Y")){%>checked<%}%>> 이동형 충전기(전기차)
                      <%}%>
                  &nbsp;
                  <%if( !( (Integer.parseInt(ej_bean.getSh_code()) > 9018110 && Integer.parseInt(ej_bean.getSh_code()) < 9018999) || ej_bean.getJg_b().equals("5") || ej_bean.getJg_b().equals("6")
                		  || cm_bean.getCar_comp_id().equals("0044") || cm_bean.getCar_comp_id().equals("0007") || cm_bean.getCar_comp_id().equals("0025") || cm_bean.getCar_comp_id().equals("0033") || cm_bean.getCar_comp_id().equals("0048")) ){ %>
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
                   	<%} %>
                    </td>
                </tr>                

                <tr>
                    <td class='title'><span class="title1">서비스품목</span></td>
                    <td colspan="5">&nbsp;
                        <input type='text' name='extra_set' size='45' class="text" value='<%=car.getExtra_set()%>'>
        				&nbsp;<input type='text' name='extra_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(car.getExtra_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                        <textarea rows='5' cols='90' name='remark'><%=car.getRemark()%></textarea></td>
                </tr>
            </table>
        </td>
    </tr>
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('8')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_car1 style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class='title'>과세구분</td>
                    <td colspan="3">&nbsp;
                      <select name="purc_gu">
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
        			<select name="car_origin">
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
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_c_amt()" onMouseOver="window.status=''; return true" title="소비자가 합계 계산하기">합계</a></span></td>
                    <td width="13%" class='title'>공급가</td>
                    <td width="12%" class='title'>부가세</td>
                    <td width="13%" class='title'><span class="b"><a href="javascript:sum_car_f_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">합계</a></span>&nbsp;<span class="b"><a href="javascript:sum_car_f_amt2()" onMouseOver="window.status=''; return true" title="구입가 계산하기">계산</a></span></td>
                </tr>
                <tr>
                    <td class='title'> 기본가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>차량가격</td>
                    <td>&nbsp;
                      <input type='text' name='car_fs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_fv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='car_f_amt' size='10' value='<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>' maxlength='13' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <input type="hidden" name="o_car_c_amt" value="<%=AddUtil.parseDecimal(car.getCar_cs_amt()+car.getCar_cv_amt())%>">
                <input type="hidden" name="o_car_f_amt" value="<%=AddUtil.parseDecimal(car.getCar_fs_amt()+car.getCar_fv_amt())%>">
                <tr>
                    <td height="12" class='title'>옵션</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cv_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='opt_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getOpt_cs_amt()+car.getOpt_cv_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title>탁송료</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td height="12">&nbsp;
                      <input type='text' name='sd_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getSd_cs_amt()+car.getSd_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                </tr>
                <tr>
                    <td height="26" class='title'> 색상</td>
                    <td>&nbsp;
                      <input type='text' name='col_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cv_amt())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td>&nbsp;
                      <input type='text' name='col_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getClr_cs_amt()+car.getClr_cv_amt())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
             			원</td>
                    <td class=title><span class="b"><a href="javascript:search_dc()" onMouseOver="window.status=''; return true" title="클릭하세요">매출D/C</a></span></td>
                    <td>&nbsp;
                      <input type='text' name='dc_cs_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_cv_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cv_amt())%>' readonly maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                    <td>&nbsp;
                      <input type='text' name='dc_c_amt' size='10' value='<%=AddUtil.parseDecimal(car.getDc_cs_amt()+car.getDc_cv_amt())%>' readonly maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
        				원</td>
                </tr>
              <tr id=tr_ecar_dc <%if(base.getDlv_dt().equals("") || car.getTax_dc_s_amt()>0 || car.getTax_dc_s_amt()<0 || ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4") ){//친환경차%>style="display:''"<%}else{%>style="display:none"<%}%>>
                <td height="26" class='title'> 개소세 감면액</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_s_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_v_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_v_amt())%>' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td>&nbsp;
                  -<input type='text' name='tax_dc_amt' size='9' value='<%=AddUtil.parseDecimal(car.getTax_dc_s_amt()+car.getTax_dc_v_amt())%>' maxlength='10' class='num'  onBlur='javascript:this.value=parseDecimal(this.value); set_car_amt(this);' onKeyDown='javascript:enter_car(this)'>
         			원</td>
                <td class=title>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
                <td>&nbsp;</td>
              </tr>                       <tr>
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
                      <select name='pay_st'>
                        <option value="">선택</option>
                        <option value="1" <%if(car.getPay_st().equals("1")){%> selected <%}%>>과세</option>
                        <option value="2" <%if(car.getPay_st().equals("2")){%> selected <%}%>>면세</option>
                      </select>
                    </td>
                    <td class='title'><a href="javascript:sum_tax_amt()" onMouseOver="window.status=''; return true" title="구입가 합계 계산하기">특소세</a></td>
                    <td >&nbsp;
                      <input type='text' name='spe_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>교육세</td>
                    <td >&nbsp;
                      <input type='text' name='edu_tax' size='10' value='<%=AddUtil.parseDecimal(car.getEdu_tax())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tax_amt(this);'>
        				원</td>
                    <td class='title'>합계</td>
                    <td >&nbsp;
                      <input type='text' name='tot_tax' size='10' value='<%=AddUtil.parseDecimal(car.getSpe_tax()+car.getEdu_tax())%>' maxlength='7' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);'>
        				원</td>
                </tr>
            </table>		
	    </td>
    </tr>
    <!-- 제조사 할인 후 차량가격 표시(20190911)- 신차이고 신규/증차/대차계약인 경우만 -->
    <%if(base.getCar_gu().equals("1") && fee_size<=1){ %>
    <tr>
  		<td>
  			<font color="#666666">* 전자 계약서상 제조사 할인 후 차량가격 병행 표기 여부</font>
  			<input type="checkbox" name="dc_view_yn" id="dc_view_yn" <%if(cont_etc.getView_car_dc()!=0){%>checked<%}%> onclick="javascript:span_dc_view();">&nbsp;&nbsp;&nbsp;
  			<span id="span_dc_view" style="display:<%if(cont_etc.getView_car_dc()==0){%> none<%}else{%><%}%>;">
  				<font color="#666666">제조사 할인 후 차량가격 
  					<input type="text" size="10" name="view_car_dc" value="<%=cont_etc.getView_car_dc()%>" onBlur='javascript:this.value=parseDecimal(this.value);' onKeyDown='javascript:enter_car(this)'>원
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
                    <td width="27%">&nbsp;
                        <input type='text' name='import_card_amt' value='<%= AddUtil.parseDecimal(car.getImport_card_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>Cash Back금액</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_cash_back' value='<%= AddUtil.parseDecimal(car.getImport_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='import_bank_amt' value='<%= AddUtil.parseDecimal(car.getImport_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
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
        		<input type='text' name='r_import_cash_back' value='<%= AddUtil.parseDecimal(car.getR_import_cash_back())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
        	    </td>	
        	    <td width="10%" class='title'>탁송썬팅비용등</td>
                    <td width="20%">&nbsp;
        		<input type='text' name='r_import_bank_amt' value='<%= AddUtil.parseDecimal(car.getR_import_bank_amt())%>' size='10' class='defaultnum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
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
                        <input type='text' name='ecar_pur_sub_amt' value='<%= AddUtil.parseDecimal(car.getEcar_pur_sub_amt())%>' size='10' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원
                    </td>
                    <td width="10%" class='title'>보조금수령방식</td>
                    <td>&nbsp;
        		            <select name='ecar_pur_sub_st' disabled>
        		            	<option value="">선택</option>
                          <option value="1" <%if(car.getEcar_pur_sub_st().equals("1")){%> selected <%}%>>제조사 차량대금 공제</option>
                          <option value="2" <%if(car.getEcar_pur_sub_st().equals("2")){%> selected <%}%>>아마존카 직접 수령</option>
                        </select>
                        <input type='hidden' name="h_ecar_pur_sub_amt"	value="<%=car.getEcar_pur_sub_amt()%>">
                        <input type='hidden' name="h_ecar_pur_sub_st"		value="<%=car.getEcar_pur_sub_st()%>">
        	          </td>	                    
                </tr>
            </table>
	    </td>
    </tr>   
    <%}%>              
  <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계") && !san_st.equals("요청")){%>		  
	<tr>
	    <td align="right"><a href="javascript:update('9')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
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
                            <option value='1' <%if(ins.getAge_scp().equals("1")){%>selected<%}%>>만21세이상 
                            </option>
                            <option value='4' <%if(ins.getAge_scp().equals("4")){%>selected<%}%>>만24세이상 
                            </option>
                            <option value='2' <%if(ins.getAge_scp().equals("2")){%>selected<%}%>>만26세이상 
                            </option>
                            <option value='3' <%if(ins.getAge_scp().equals("3")){%>selected<%}%>>전연령 
                            </option>
							<option value=''>=피보험자고객=</option>				
                        <option value='5' <%if(ins.getAge_scp().equals("5")){%>selected<%}%>>만30세이상</option>				
                        <option value='6' <%if(ins.getAge_scp().equals("6")){%>selected<%}%>>만35세이상</option>				
                        <option value='7' <%if(ins.getAge_scp().equals("7")){%>selected<%}%>>만43세이상</option>						
						<option value='8' <%if(ins.getAge_scp().equals("8")){%>selected<%}%>>만48세이상</option>
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>만22세이상</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>만28세이상</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>만35세이상~만49세이상</option>
                          </select></td>
                    <td width="10%" class=title >대물배상</td>
                    <td width="20%">&nbsp;
                    <select name='vins_gcp_kd' disabled>
                            <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
							<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                            <option value='3' <%if(ins.getVins_gcp_kd().equals("3")){%>selected<%}%>>1억원</option>							
                            <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원&nbsp;&nbsp;&nbsp;</option>
                            <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                            <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                            <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                          </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td >&nbsp;
                    <select name='vins_bacdt_kd' disabled>
                            <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>							
                            <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                            <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                            <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                            <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                            <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
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
                        <select name='insurant'>
                          <option value="1" <%if(cont_etc.getInsurant().equals("1")||cont_etc.getInsurant().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsurant().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsurant().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select></td>
                    <td width="10%"  class=title>피보험자</td>
                    <td colspan='3'>&nbsp;<%if(cont_etc.getInsur_per().equals("")) cont_etc.setInsur_per("1");%>
                        <select name='insur_per' onChange='javascript:display_ip()'>
                          <option value="">선택</option>
                          <option value="1" <%if(cont_etc.getInsur_per().equals("1")||cont_etc.getInsur_per().equals("")){%> selected <%}%>>아마존카</option>
                          <%if(cont_etc.getInsur_per().equals("2")){%>
                          <option value="2" <%if(cont_etc.getInsur_per().equals("2")){%> selected <%}%>>고객</option>
                          <%}%>
                      </select></td>
                </tr>
                <tr> 
                    <td width="13%" class=title>운전자범위</td>
                    <td width="20%" class=''>&nbsp;
        			<select name='driving_ext'>
                          <option value="">선택</option>
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>모든사람</option>
                          <option value="2" <%if(base.getDriving_ext().equals("2")){%> selected <%}%>>가족한정</option>
                          <option value="3" <%if(base.getDriving_ext().equals("3")){%> selected <%}%>>기타</option>
                      </select>
        			</td>
                    <td width="10%" class=title >운전자연령</td>
                    <td>&nbsp;
                        <select name='driving_age'>
                          <option value="">선택</option>
                          <option value="0" <%if(base.getDriving_age().equals("0")){%> selected <%}%>>만26세이상</option>
                          <option value="3" <%if(base.getDriving_age().equals("3")){%> selected <%}%>>만24세이상</option>
                          <option value="1" <%if(base.getDriving_age().equals("1")){%> selected <%}%>>만21세이상</option>
                          <option value="2" <%if(base.getDriving_age().equals("2")){%> selected <%}%>>모든운전자</option>
					  <option value=''>=피보험자고객=</option>				
                      <option value='5' <%if(base.getDriving_age().equals("5")){%>selected<%}%>>만30세이상</option>				
                      <option value='6' <%if(base.getDriving_age().equals("6")){%>selected<%}%>>만35세이상</option>				
                      <option value='7' <%if(base.getDriving_age().equals("7")){%>selected<%}%>>만43세이상</option>						
					  <option value='8' <%if(base.getDriving_age().equals("8")){%>selected<%}%>>만48세이상</option>					  						  
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>만22세이상</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>만28세이상</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>만35세이상~만49세이하</option>					  						  
                      </select>&nbsp;<a href="javascript:age_search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a></td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
                  <select name='com_emp_yn'>
                    <option value="">선택</option>
                    <option value="Y" <%if(cont_etc.getCom_emp_yn().equals("Y")){%> selected <%}%>>가입</option>
                    <option value="N" <%if(cont_etc.getCom_emp_yn().equals("N")){%> selected <%}%>>미가입</option>
                  </select>
                  <%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
                      <%if(cont_etc.getCom_emp_sac_id().equals("")){%>
                      <a href="javascript:Com_emp_sac();"><img src=/acar/images/center/button_in_si.gif border=0 align=absmiddle></a>
                      <%}else{%>
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
                        <select name='gcp_kd'>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getGcp_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                      </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">선택</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>무보험차상해</td>
                    <td>&nbsp;
                      <select name='canoisr_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCanoisr_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCanoisr_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>            </td>
                    <td class=title>자기차량손해</td>
                    <td class=''>&nbsp;
                      <select name='cacdt_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getCacdt_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getCacdt_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>              </td>
                    <td class=title >긴급출동</td>
                    <td class=''>&nbsp;
                      <select name='eme_yn'>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEme_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getEme_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select></td>
                </tr>
                <tr>
                    <td  class=title>자차면책금</td>
                    <td>&nbsp;
        			<input type='text' size='12' maxlength='10' name='car_ja' class='num' value='<%=AddUtil.parseDecimal(base.getCar_ja())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			원</td>
                    <td class=title>변경사유</td>
                    <td class=''>&nbsp;
                      <input type='text' size='18' name='ja_reason' class='text' value='<%=cont_etc.getJa_reason()%>'></td>
                    <td class=title >결재자</td>
                    <td class=''>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(cont_etc.getRea_appr_id(), "USER")%>" size="12"> 
			<input type="hidden" name="rea_appr_id" value="<%=cont_etc.getRea_appr_id()%>">			
			<a href="javascript:User_search('rea_appr_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                        (기본 <input type='text' size='6' maxlength='10' name='imm_amt' class='whitenum' value='<%if(car.getCar_origin().equals("2")){%>500,000<%}else{%>300,000<%}%>' readonly>원) </td>
                </tr>
                <tr>
                    <td  class=title>자동차</td>
                    <td colspan="5">&nbsp;
                      <select name="air_ds_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAir_ds_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAir_ds_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>
        				운전석에어백
        			  <select name="air_as_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAir_as_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAir_as_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				조수석에어백
        				 <select name="blackbox_yn">
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getBlackbox_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getBlackbox_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        				블랙박스
        				<br/>
        				&nbsp; 	
                      <select name="lkas_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLkas_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLkas_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
       				차선(제어)	
        			&nbsp; 			
                      <select name="ldws_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLdws_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getLdws_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			차선(경고)	
        			&nbsp; 			
                      <select name="aeb_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getAeb_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getAeb_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			긴급(제어)	
        			&nbsp; 			
                      <select name="fcw_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getFcw_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getFcw_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			긴급(경고)	
        			&nbsp; 			
                      <select name="ev_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getEv_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getEv_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			전기자동차	
        			 &nbsp; 	
					 <select name="hook_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getHook_yn().equals("Y")){%> selected <%}%>>유</option>
                        <option value="N" <%if(cont_etc.getHook_yn().equals("N")){%> selected <%}%>>무</option>
                      </select>	
        			견인고리(트레일러용)	
      				&nbsp; 	
        			<select name="legal_yn" style="background-color:#CCCCCC;" disabled>
                        <option value="">선택</option>
                        <option value="Y" <%if(cont_etc.getLegal_yn().equals("Y")){%> selected <%}%>>가입</option>
                        <option value="N" <%if(cont_etc.getLegal_yn().equals("N")){%> selected <%}%>>미가입</option>
                      </select>	
       				법률비용지원금(고급형)
        			 &nbsp;
        				<br/>
        				&nbsp;  
        				기타장치 : 
                      <input type="text" class="text" name="others_device" value="<%=cont_etc.getOthers_device()%>" size="50"> <!-- (견인고리 등 기타장치) -->        				
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
                                    <input type='text' name='ip_insur' value='<%=cont_etc.getIp_insur()%>' size='12' class='text'>
                      				&nbsp;대리점 : 
                      				<input type='text' name='ip_agent' value='<%=cont_etc.getIp_agent()%>' size='15' class='text'>
                      				&nbsp;담당자 :
                      				<input type='text' name='ip_dam' value='<%=cont_etc.getIp_dam()%>' size='10' class='text'>
                					&nbsp;연락처 :
                					<input type='text' name='ip_tel' value='<%=cont_etc.getIp_tel()%>' size='13' class='text'>
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
					  <select name='cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(cont_etc.getCacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(cont_etc.getCacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(cont_etc.getCacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(cont_etc.getCacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(cont_etc.getCacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  / (최대)자기부담금 
                      <input type='text' size='6' name='cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(cont_etc.getCacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  / (최소)자기부담금  
                      <select name='cacdt_memin_amt'>
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
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('10')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보증보험</span></td>
    </tr>
    <tr>
	    <td class=line2></td>
	</tr>
	<tr id=tr_gi style="display:<%if(!base.getCar_st().equals("2")){%>''<%}else{%>none<%}%>">
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>

	<%	
		for(int f=1; f<=gin_size ; f++){
			ContGiInsBean ext_gin = a_db.getContGiInsNew(rent_mng_id, rent_l_cd, Integer.toString(f));			
			
			if(f<gin_size ){%>  
                <tr>
                    <td class=title width="13%">가입여부</td>
                    <td colspan="5">&nbsp;
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		가입
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		면제 </td>
                </tr>			        
                <tr id=tr_gi<%=f+1%> style='display:<%if(ext_gin.getGi_st().equals("1")){%>""<%}else{%>none<%}%>'>
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='ext_gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='ext_gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='ext_gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='ext_gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
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
                        <input type='radio' name="gi_st" value='1' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("1")){%> checked <%}%>>
                  		가입
                  		<input type='radio' name="gi_st" value='0' onClick="javascript:display_gi()" <%if(ext_gin.getGi_st().equals("0")){%> checked <%}%>>
                  		면제 </td>
                </tr>			   	               
                <tr id=tr_gi<%=f+1%> style='display:<%if(ext_gin.getGi_st().equals("1")){%>""<%}else{%>none<%}%>'>
                    <td class=title>발행지점</td>
                    <td width="20%">&nbsp;<input type='hidden' name='gi_no' value='<%=ext_gin.getGi_no()%>'>
                    <input type='hidden' name='gi_rent_st' value='<%=ext_gin.getRent_st()%>'>
        			   <input type='text' name='gi_jijum' value='<%=ext_gin.getGi_jijum()%>' size='12' class='text'>
                    </td>
                    <td width="10%" class='title'>가입금액</td>
                    <td width="20%" >&nbsp;
                        <input type='text' name='gi_amt' size='10' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(ext_gin.getGi_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value); set_gi_amt();'>
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
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('11')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
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
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		
                <tr>
                    <td width="13%" align="center" class=title>계약일자</td>
                    <td width="20%">&nbsp;<%if(f >1){%><%=AddUtil.ChangeDate2(fees.getRent_dt())%><%}else{%><%=AddUtil.ChangeDate2(base.getRent_dt())%><%}%></td>
                    <td width="10%" align="center" class=title>계약담당자</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fees.getExt_agnt(),"USER")%><%}else{%><%=c_db.getNameById(base.getBus_id(),"USER")%><%}%></td>
                    <td width="10%" align="center" class=title>영업대리인</td>
                    <td >&nbsp;<%if(f >1){%><%=c_db.getNameById(fee_etcs.getBus_agnt_id(),"USER")%><%}else{%><%=c_db.getNameById(cont_etc.getBus_agnt_id(),"USER")%><%}%></td>
                </tr>		
                <tr>
                    <td width="13%" align="center" class=title>이용기간</td>
                    <td width="20%">&nbsp;
                        <input type='text' name="ext_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)' readonly>
            			 개월</td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="ext_rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date(this);' readonly></td>
                    <td width="10%" align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                      <input type="text" name="ext_rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value);' readonly></td>
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
                    <td align='center'><input type='text' size='10' maxlength='10' name='ext_grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
                    <td align='center'>
					<%if(base.getRent_st().equals("3")){%>
					  대차 보증금 승계여부 :
					  <select name='ext_grt_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0"))%>selected<%%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1"))%>selected<%%>>별도</option>
                            </select>	
					<%}else{%>					
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ext_grt_suc_yn' value='<%= fees.getGrt_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ext_grt_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getGrt_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getGrt_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
					<%}%>
        				<input type='hidden' name='ext_gur_per' value=''>
        				<input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_pp_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_pp_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_pere_r_per' class='whitenum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % </td>
                    <td align='center'><input type='hidden' name='ext_pere_per' value=''>
           선납금 계산서발행구분 :
					<select name='ext_pp_chk' disabled>
                              <option value="">선택</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>납부일시발행</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>매월균등발행</option>
                            </select>
                    </td>
                </tr>                
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
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
        			    <%if(fees.getRent_st().equals("1")){ %>
        				<input type='hidden' name='ext_ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ext_ifee_suc_yn' disabled>
                              <option value="">선택</option>
                              <option value="0" <%if(fees.getIfee_suc_yn().equals("0")){%>selected<%}%>>승계</option>
                              <option value="1" <%if(fees.getIfee_suc_yn().equals("1")){%>selected<%}%>>별도</option>
                            </select>			  
        				<%}%>
        			    <input type='hidden' name='ext_pere_mth' value=''></td>
                </tr>
                <tr>
                    <td class='title' colspan="2">합계</td>
                    <td align="center"><input type='text' size='10' name='ext_tot_pp_s_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_tot_pp_v_amt' maxlength='10' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_tot_pp_amt' maxlength='11' class='whitenum' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">입금예정일 :
                          <input type='text' size='11' name='ext_pp_est_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                        결재자 : <input name="ext_user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_credit_sac_id" value="<%=fee_etc.getCredit_sac_id()%>">
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			결재일자 : <input type='text' size='11' name='ext_credit_sac_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>							
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='ext_credit_r_per' class='whitenum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='ext_credit_r_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='ext_credit_per' class='whitenum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='ext_credit_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>              
              <!--20130605 약정운행주행거리 운영-->    
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='ext_agree_dist' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km이하/1년,
                  <br>&nbsp;
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='ext_rtn_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%//	if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='ext_rtn_run_amt_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getRtn_run_amt_yn().equals(""))%>selected<%%>>선택</option>                      
                    <option value="0" <%if(fee_etcs.getRtn_run_amt_yn().equals("0"))%>selected<%%>>환급대여료적용</option>
                    <option value="1" <%if(fee_etcs.getRtn_run_amt_yn().equals("1"))%>selected<%%>>환급대여료미적용</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <input type="hidden" name="ext_rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%//	} %>
                  <%}else{ %>
                  <input type="hidden" name="ext_rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">
                  <input type="hidden" name="ext_rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%} %>    
                  <br>&nbsp;              
                  (약정초과운행시) 초과운행대여료 <input type='text' name='ext_over_run_amt' size='2' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <input type="hidden" name="ext_agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!-- 
                  <select name='ext_agree_dist_yn' disabled>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>선택</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>전액면제(기본식)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%만 납부(일반식)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>매입옵션 없음(기본식,일반식)</option>
                  </select>
                   -->	
                   <!-- 
                  <br>&nbsp;
                  ※ 약정운행거리 미적용시 약정운행거리에 <input type='text' name='ext_ex_agree_dist' size='5' class='whitenum' value='미적용' >과 같이 입력하면 됩니다.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        ※ 예상 운행거리 <input type='text' name='ext_cust_est_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
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
                    <input type='text' name='ext_e_rtn_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                    <input type="hidden" name="ext_e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                    <%} %>
                    <input type='text' name='ext_e_over_run_amt' size='2' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,<br>&nbsp;
                    <input type='text' name='ext_e_agree_dist_yn' size='15' class='whitetext' value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">보유차주행거리</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='ext_over_bas_km' size='6' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
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
        			  <input type='text' size='4' name='ext_b_max_ja' maxlength='10' class='whitenum' value='<%=fees.getB_max_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='ext_e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1년</td>
                </tr>                             
                <tr>
                    <td class='title' colspan="2">조정 최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_s_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_v_amt' readonly maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='ext_max_ja' maxlength='10' readonly class='whitenum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='ext_r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1년
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_opt_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_opt_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_opt_per' class='whitenum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % </td>
                    <td align='center'>
        			  <input type='radio' name="ext_opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      없음
                      <input type='radio' name="ext_opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
        	 		  있음
                    </td>
                </tr>
                <%if(fee_etcs.getReturn_select().equals("1") && (ej_bean.getJg_g_7().equals("3"))){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차 제외 %>
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
                    <td class='title' colspan="2">적용잔가</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_s_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ext_ja_r_v_amt' readonly maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ext_ja_r_amt' readonly maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='ext_app_ja' maxlength='10' readonly class="whitenum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10'  name='ext_fee_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='ext_fee_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					월대여료납입방식 :
					  <select name='ext_fee_chk' disabled>
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
	                <td align="center" ><input type='text' size='11' name='ext_inv_s_amt' maxlength='10' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center" ><input type='text' size='11' name='ext_inv_v_amt' maxlength='9' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='ext_inv_amt' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center">-</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;</td>
               </tr>
               <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='11' name='ext_ins_s_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='ext_ins_v_amt' maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ext_ins_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ext_ins_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
	                <td class='title'>운전자추가요금</td>
	                <td align="center" >
	                	<input type='text' size='11' name='ext_driver_add_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='ext_driver_add_v_amt'  maxlength='9' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='ext_driver_add_total_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align="center" >
                    	<input type='text' size='11' name='ext_tinv_s_amt' maxlength='11' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='ext_tinv_v_amt'  maxlength='9' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='ext_tinv_amt' class='whitenum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
               </tr>
               
        	<tr>
                <td class='title' colspan="2">대여료DC</td>
                <td colspan='3'>&nbsp;
                    결재자 : 
                        <input name="ext_user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_dc_ra_sac_id" value="<%=fee_etcs.getDc_ra_sac_id()%>">
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    결재일자 : 	
		    <input type='text' size='11' name='ext_bas_dt' maxlength='11' class="whitetext" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                
                </td>                    
                <td align='center'>-</td>            
                <td align="center">
                    적용근거 : <select name='ext_dc_ra_st' disabled>
                        <option value=''>선택</option>
                        <option value='1' <%if(fee_etcs.getDc_ra_st().equals("1")){%>selected<%}%>>정상DC조건</option>
                        <option value='2' <%if(fee_etcs.getDc_ra_st().equals("2")){%>selected<%}%>>특별DC</option>
                    </select>
                    &nbsp;
		    기타 : 
		    <input type='text' size='18' name='ext_dc_ra_etc' class="whitetext" value='<%=fee_etcs.getDc_ra_etc()%>'>
                </td>
                <td align='center'>
                    DC율 <input type='text' size='4' name='ext_dc_ra' maxlength='10' class="whitenum" value='<%=fees.getDc_ra()%>'>%
                    DC금액 <input type='text' size='6' name='ext_dc_ra_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
        				  원
                </td>
              </tr>                       
		<%	int fee_etc_rowspan = 2;
		    	if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")) fee_etc_rowspan = fee_etc_rowspan+2;//대차계약일때 원계약정보
		%>
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>기<br>
                      타</td>
                  <td class='title' colspan="2" style="font-size : 8pt;">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='ext_cls_r_per' maxlength='10'  class='whitenum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='ext_cls_per' maxlength='10' class='whitenum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='ext_cls_n_per' maxlength='10' class='whitenum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>
                <tr>
                    <td class='title'  colspan="2">영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준:
        			  <select name='ext_commi_car_st' disabled>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>차량가격</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='ext_commi_car_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="ext_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='whitenum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="ext_comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='whitenum' <%if(!base.getUse_yn().equals("")){%>readonly<%}%>>
        			  %</td>
                </tr>					    
				        <%if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")){
										//대차원계약정보
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>                                  
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
					  <b>[원계약정보]</b>
					  &nbsp;계약번호 : <input type='text' name='ext_grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='ext_grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
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
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701 수소차제외%>
                <tr>
                    <td colspan="3" class='title'>전기차 인수/반납 유형</td>
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
                    <td colspan="3" class='title'>계약서 특약사항 기재 내용</td>
                    <td colspan="6">
                    	<div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                      		<textarea rows='5' cols='90' name='ext_con_etc' OnBlur='checkSpecial();'><%=fee_etcs.getCon_etc()%></textarea>
                      		</div>
                   		</div>
                   		<div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
					  		<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					|| cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					|| cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                	<input type="button" onclick="setMentConEtc('5')" value="개별소비세율 환원시 안내문구">
							<%}%> --%>
								<script>
								function setMentConEtc(idx) {
									if (idx == "5") {
										document.form1.con_etc.value = "※ 2022년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다.";
									} 
								}
							  	</script>
					  		</div>
					  	</div>
                    </td>
                </tr>			                
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='ext_cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
                </tr>			
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
                      <input type='text' name='ext_fee_pay_start_dt' maxlength='11' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='ext_fee_pay_end_dt' maxlength='11' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
                </tr>		
            </table>				  				
	    </td>
    </tr>			
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
            				    <td align="center"><input type='text' size='12' name='ext_bc_b_e1' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e1()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				    <td align="center">E-2</td>
            				    <td align="center">bc_b_e2</td>				  
            				    <td>&nbsp;경매장예상낙찰가격</td>
            				    <td align="center"><input type='text' size='12' name='ext_bc_b_e2' maxlength='10' class=whitenum value='<%=fee_etcs.getBc_b_e2()%>'>&nbsp;</td>
            				</tr>									
            		        <tr>
            				  <td align="center">U</td>
            				  <td align="center">bc_b_u</td>				  
            				  <td>&nbsp;기타비용</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_u' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_u()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='ext_bc_b_u_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_u_cont()%>'>
            				  </td>
            				</tr>							
            		        <tr>
            				  <td align="center">G</td>
            				  <td align="center">bc_b_g</td>				  
            				  <td>&nbsp;기타수익</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_g' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_g()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='ext_bc_b_g_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_g_cont()%>'>
            				  </td>
            				</tr>
            		        <tr>
            				  <td align="center">AC</td>
            				  <td align="center">bc_b_ac</td>				  
            				  <td>&nbsp;기타 영업효율반영값</td>
            				  <td align="center"><input type='text' size='12' name='ext_bc_b_ac' maxlength='10' class='whitenum' value='<%=fee_etcs.getBc_b_ac()%>' onBlur='javascript:this.value=parseDecimal(this.value);'>&nbsp;내용: <input type='text' size='30' name='ext_bc_b_ac_cont' maxlength='150' class=whitetext value='<%=fee_etcs.getBc_b_ac_cont()%>'></td>
            				</tr>
            		        <tr>
            				  <td align="center">-</td>
            				  <td align="center">bc_etc</td>				  
            				  <td>&nbsp;정산유의사항</td>
            				  <td align="center"><textarea rows='5' cols='70' name='ext_bc_etc'><%=fee_etcs.getBc_etc()%></textarea></td>
            				</tr>
        		        </table>		
    			    </td>						
		        </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td class=h></td>
	</tr>    
	<%		}else{//마지막회차 %>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
              <tr>
                <td width="13%" align="center" class=title>계약일자</td>
                <td width="20%">&nbsp;
					  <%if(user_id.equals(base.getBus_id())){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='11' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>계약담당자</td>
                <td >&nbsp;    
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fees.getExt_agnt(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_agnt" value="<%=fees.getExt_agnt()%>">						
			<% user_idx++;%>
                </td>
                <td width="10%" align="center" class=title>영업대리인</td>
                <td >&nbsp;                  
                        <input name="user_nm" type="text" class="whitetext"  readonly value="<%=c_db.getNameById(fee_etcs.getBus_agnt_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ext_bus_agnt_id" value="<%=fee_etcs.getBus_agnt_id()%>">						
			<% user_idx++;%>               
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)' readonly>
        			 개월</td>
                <td width="10%" align="center" class=title>대여개시일</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);' readonly></td>
                <td width="10%" align="center" class=title>대여만료일</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);' readonly></td>
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
                <% String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0"); %>
                <tr>
                    <td width="3%" rowspan="5" class='title'>선<br>
                      수</td>
                    <td width="10%" class='title' colspan="2">보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='grt_s_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'  <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum'  readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='gur_p_per' class='fixnum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % 
        				  <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 보증금은 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('grt_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        			</td>
                    <td align='center'>
					<%if(base.getRent_st().equals("3")){%>
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
        				<input type='hidden' name='gur_per' value=''>
        				<input type='hidden' name='grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'></td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "1"); %>
                <tr>
                    <td class='title' colspan="2">선납금</td>
                    <td align="center"><input type='text' size='10' name='pp_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='pp_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='pp_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getPp_s_amt()+fees.getPp_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='pere_r_per' class='fixnum' value='<%=fees.getPere_r_per()%>' readonly>
        				  % 
        				  <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 선납금은 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('pp_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %>
        				  </td>
                    <td align='center'><input type='hidden' name='pere_per' value=''>
           선납금 계산서발행구분 :
					<select name='pp_chk'>
                              <option value="">선택</option>
                              <option value="1" <%if(fees.getPp_chk().equals("1")){%>selected<%}%>>납부일시발행</option>
                              <option value="0" <%if(fees.getPp_chk().equals("0")){%>selected<%}%>>매월균등발행</option>
                            </select>
                    </td>
                </tr>
                <%  pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "2"); %>
                <tr>
                    <td class='title' colspan="2">개시대여료</td>
                    <td align="center"><input type='text' size='10' name='ifee_s_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ifee_v_amt' maxlength='10' value='<%=AddUtil.parseDecimal(fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ifee_amt' maxlength='11' value='<%=AddUtil.parseDecimal(fees.getIfee_s_amt()+fees.getIfee_v_amt())%>' <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>class='defaultnum' readonly<%}else{%>class='num' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'<%} %>>
        				  원</td>
                    <td align='center'><%=pp_pay_st%></td>
                    <td align="center">마지막
                        <input type='text' size='2' name='pere_r_mth' class='fixnum' value='<%=fees.getPere_r_mth()%>' readonly>
        				  개월치 대여료
        				  <%if(pp_pay_st.equals("입금") || pp_pay_st.equals("잔액")){%>
    				            <br><font color=red>※ 입금된 개시대여료는 별도 변경만 가능합니다.</font>
    				            <a href="javascript:update_item('ifee_amt', '<%=fees.getRent_st()%>')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
    				            <%} %> 
        			</td>
                    <td align='center'>
        			    <%if(fees.getRent_st().equals("1")){%>
        				<input type='hidden' name='ifee_suc_yn' value='<%= fees.getIfee_suc_yn() %>'>-
        				<%}else{%>
        			    <select name='ifee_suc_yn'>
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
                          <input type='text' size='11' name='pp_est_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getPp_est_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                        결재자 : <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etcs.getCredit_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="credit_sac_id" value="<%=fee_etcs.getCredit_sac_id()%>">
			<a href="javascript:User_search('credit_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
			&nbsp;&nbsp;&nbsp;&nbsp;
			결재일자 : <input type='text' size='11' name='credit_sac_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fee_etcs.getCredit_sac_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>							
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='4' name='credit_r_per' class='fixnum' value='<%=fees.getCredit_r_per()%>' readonly>%
        			<input type='text' size='10' name='credit_r_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원(보증보험포함)</td>
                    <td align='center'><input type='text' size='4' name='credit_per' class='fixnum' value='<%=fees.getCredit_per()%>' readonly>%
        			<input type='text' size='10' name='credit_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getCredit_r_amt())%>' readonly>원</td>
                </tr>
                <tr>
                    <td rowspan="2" class='title'>운행<br>
                      거리</td>              
              <!--20130605 약정운행주행거리 운영-->    
                <td class='title' colspan="2"><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;
		  <input type='text' name='agree_dist' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >
                  km이하/1년,
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;
                  (약정이하운행시) 환급대여료  <input type='text' name='rtn_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getRtn_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)
                  <%//	if ((nm_db.getWorkAuthUser("전산팀", user_id) || nm_db.getWorkAuthUser("본사영업부팀장", user_id) || nm_db.getWorkAuthUser("영업팀내근직", user_id) || user_id.equals("000057"))) {%>
                  <!--
                  <select name='rtn_run_amt_yn'>        
                    <option value="">선택</option>                      
                    <option value="0" <%if(fee_etcs.getRtn_run_amt_yn().equals("0")||fee_etcs.getRtn_run_amt_yn().equals(""))%>selected<%%>>환급대여료적용</option>
                    <option value="1" <%if(fee_etcs.getRtn_run_amt_yn().equals("1"))%>selected<%%>>환급대여료미적용</option>                    
                  </select>
                  -->
                  <%//	}else{ %>
                  <%if(fee_etcs.getRtn_run_amt_yn().equals("0")){%>※환급대여료적용<%}else if(fee_etcs.getRtn_run_amt_yn().equals("1")){%>※환급대여료미적용<%} %>
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%//	} %>
                  <%}else{ %>
                  <input type="hidden" name="rtn_run_amt" value="<%=fee_etcs.getRtn_run_amt()%>">
                  <input type="hidden" name="rtn_run_amt_yn" value="<%=fee_etcs.getRtn_run_amt_yn()%>">
                  <%} %>                  
                  <br>&nbsp;                  
                  (약정초과운행시) 초과운행대여료 <input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원/1km (부가세별도)                  	
                  <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>
                  <br>&nbsp;                  
                  매입옵션 행사시 환급대여료 : 기본식은 미지급, 일반식은 40%만 지급
                  <%} %>
                  <br>&nbsp;                  
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 <%if(AddUtil.parseInt(base.getRent_dt()) > 20220414){%>40%<%}else{%>50%<%}%>만 납부
                  <!-- 
                  초과 1km당 (<input type='text' name='over_run_amt' size='2' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 초과운행부담금이 부과됨 (대여종료시)	
                  <br>&nbsp;
                  매입옵션 행사시 초과운행대여료 : 기본식은 전액면제, 일반식은 50%만 납부
                   -->
                  <input type="hidden" name="agree_dist_yn" value="<%=fee_etcs.getAgree_dist_yn()%>">
                  <!-- 
                  <select name='agree_dist_yn'>        
                    <option value=""  <%if(fee_etcs.getAgree_dist_yn().equals(""))%>selected<%%>>선택</option>                      
                    <option value="1" <%if(fee_etcs.getAgree_dist_yn().equals("1"))%>selected<%%>>전액면제(기본식)</option>
                    <option value="2" <%if(fee_etcs.getAgree_dist_yn().equals("2"))%>selected<%%>>50%만 납부(일반식)</option>
                    <option value="3" <%if(fee_etcs.getAgree_dist_yn().equals("3"))%>selected<%%>>매입옵션 없음(기본식,일반식)</option>
                  </select>	
                  -->
                  <br>&nbsp;
                  ※ 약정운행거리 미적용시 약정운행거리에 <input type='text' name='ex_agree_dist' size='5' class='defaultnum' value='미적용' >과 같이 입력하면 됩니다.
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        ※ 예상 운행거리 <input type='text' name='cust_est_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getCust_est_km())%>' >
                        km/1년
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
                    <input type='text' name='e_rtn_run_amt' size='2' class='whitenum' readonly value='<%=AddUtil.parseDecimal(e_bean.getRtn_run_amt())%>' >/1km,<br>&nbsp;
                    <%}else{ %>
                  	<input type="hidden" name="e_rtn_run_amt" value="<%=e_bean.getRtn_run_amt()%>">
                  	<%} %>                       
                    <input type='text' name='e_over_run_amt' size='2' class='whitenum' readonly value='<%=AddUtil.parseDecimal(e_bean.getOver_run_amt())%>' >/1km,    <br>&nbsp;                
                    <input type='text' name='e_agree_dist_yn' size='15' class='whitetext' readonly value='<%=e_agree_dist_yn%>' >
                  <%}%>
                </td>
              </tr>   
                <tr>
                    <td class='title' style="font-size : 8pt;" colspan="2">보유차주행거리</td>
                    <td colspan="6">&nbsp;
                        <input type='text' name='over_bas_km' size='6' maxlength='20' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_bas_km())%>' >
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
                    <td align='center'><input type='text' name='e_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(e_bean.getB_agree_dist())%>' >km/1년</td>
                </tr>                             
                <tr>
                    <td class='title' colspan="2">조정 최대잔가</td>
                    <td align="center"><input type='text' size='10' name='ja_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_s_amt()+fees.getJa_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='max_ja' maxlength='10' readonly class='fixnum' value='<%=fees.getMax_ja()%>'>
        			  % </td>
                    <td align='center'><input type='text' name='r_agree_dist' size='6' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>' >km/1년
        			</td>
                </tr>
                <tr>
                    <td class='title' colspan="2">매입옵션</td>
                    <td align="center"><input type='text' size='10' name='opt_s_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='opt_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='opt_amt' maxlength='11' class='num' value='<%=AddUtil.parseDecimal(fees.getOpt_s_amt()+fees.getOpt_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
                        <input type='text' size='4' name='opt_per' class='defaultnum' value='<%=fees.getOpt_per()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  % </td>
                    <td align='center'>
        			  <input type='radio' name="opt_chk" value='0' <%if(fees.getOpt_chk().equals("0")){%> checked <%}%> onClick="javascript:opt_display('0', <%=fees.getRent_dt()%>)">
                      없음
                      <input type='radio' name="opt_chk" value='1' <%if(fees.getOpt_chk().equals("1")){%> checked <%}%> onclick="javascript:opt_display('1', <%=fees.getRent_dt()%>)">
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
                    <td align="center"><input type='text' size='10' name='ja_r_s_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center"><input type='text' size='10' name='ja_r_v_amt' readonly maxlength='10' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><input type='text' size='10' name='ja_r_amt' readonly maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(fees.getJa_r_s_amt()+fees.getJa_r_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">차가의
        			  <input type='text' size='4' name='app_ja' maxlength='10' readonly class="defaultnum" value='<%=fees.getApp_ja()%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        			  % </td>
                    <td align='center'>-</td>
                </tr>
                <%}%>
                <tr>
                    <td rowspan="6" class='title'>대<br>여<br>료</td>
                    <td class='title' colspan="2">계약요금</td>
                    <td align="center" ><input type='text' size='10'  name='fee_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align="center" ><input type='text' size='10'  name='fee_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center' ><input type='text' size='10'  name='fee_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">-</td>
                    <td align='center'>
					월대여료납입방식 :
					  <select name='fee_chk'>
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
	                <td align="center" ><input type='text' size='11' name='inv_s_amt' maxlength='10' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center" ><input type='text' size='11' name='inv_v_amt' maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align='center' ><input type='text' size='11' maxlength='10' name='inv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
	    				  원</td>
	                <td align="center">-</td>
	                <td align="center">-</td>
	                <td align='center'>&nbsp;
	    			  <span class="b"><a href="javascript:estimate('<%=fees.getRent_st()%>', '<%=fees.getRent_dt()%>', '<%=fees.getRent_start_dt()%>', 'account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
	                </td>
               </tr>
               <tr>
                    <td class='title'>월보험료(고객피보험)</td>
                    <td align="center" ><input type='text' size='11' name='ins_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align="center" ><input type='text' size='11' name='ins_v_amt' maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center' ><input type='text' size='11' maxlength='10'  name='ins_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_s_amt()+fees.getIns_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">&nbsp;월보험료(공급가) = 년간보험료
                    	<input type='text' size='10' maxlength='10' name='ins_total_amt' class='num' value='<%=AddUtil.parseDecimal(fees.getIns_total_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>    
					 원/12</td>
                    <td align='center'>-</td>
                </tr>
                <tr>
	                <td class='title'>운전자추가요금</td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원 
	                </td>
	                <td align="center" >
	                	<input type='text' size='11' name='driver_add_v_amt'  maxlength='9' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center' >
	                	<input type='text' size='11' maxlength='10'  name='driver_add_total_amt' class='num' value='<%=AddUtil.parseDecimal(fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
	                </td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	                <td align='center'>-</td>
	            </tr>
                <tr>
                    <td class='title'>정상요금 합계</td>
                    <td align="center" >
                    	<input type='text' size='11' name='tinv_s_amt' maxlength='11' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getIns_s_amt() + fee_etcs.getDriver_add_amt())%>'> 원 
                    </td>
                    <td align="center" >
                       	<input type='text' size='11' name='tinv_v_amt'  maxlength='9' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_v_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center' >
                    	<input type='text' size='11' maxlength='10'  name='tinv_amt' class='defaultnum' readonly value='<%=AddUtil.parseDecimal(fees.getInv_s_amt() + fees.getInv_v_amt() + fees.getIns_s_amt() + fees.getIns_v_amt() + fee_etcs.getDriver_add_amt() + fee_etcs.getDriver_add_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'> 원
                    </td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
               </tr>
               
        	<tr>
                <td class='title' colspan="2">대여료DC</td>
                <td colspan='3'>&nbsp;
                    결재자 : 
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee_etcs.getDc_ra_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="dc_ra_sac_id" value="<%=fee_etcs.getDc_ra_sac_id()%>">
			<a href="javascript:User_search('dc_ra_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>		        
			<% user_idx++;%>
		    &nbsp;&nbsp;&nbsp;&nbsp;
		    결재일자 : 	
		    <input type='text' size='11' name='bas_dt' maxlength='10' class="text" value='<%=AddUtil.ChangeDate2(fees.getBas_dt())%>' onBlur='javscript:this.value = ChangeDate(this.value);'>                    
                
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
		    <input type='text' size='18' name='dc_ra_etc' class="text" value='<%=fee_etcs.getDc_ra_etc()%>'>
                </td>
                <td align='center'>
                    DC율 <input type='text' size='4' name='dc_ra' maxlength='10' class="fixnum" value='<%=fees.getDc_ra()%>'>%
                    DC금액 <input type='text' size='6' name='dc_ra_amt' maxlength='10' class='fixnum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt()-fees.getFee_s_amt()-fees.getFee_v_amt())%>'>
        				  원
                </td>
              </tr>                       
		<%	int fee_etc_rowspan = 2;
		    	if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")) fee_etc_rowspan = fee_etc_rowspan+2;//대차계약일때 원계약정보
		%>
                <tr>
                    <td rowspan="<%=fee_etc_rowspan%>" class='title'>기<br>
                      타</td>
                  <td class='title' colspan="2" style="font-size : 8pt;">중도해지위약율</td>
                    <td colspan="2" align="center">-</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align="center">잔여기간 대여료의
                        <input type='text' size='3' name='cls_r_per' maxlength='10'  class='defaultnum' value='<%=fees.getCls_r_per()%>'>
        				  %</td>
                    <td align='center'><font color="#FF0000">
        				<input type='text' size='3' name='cls_per' maxlength='10' class='fixnum' value='<%=fees.getCls_per()%>'>%
						,필요위약금율[<input type='text' size='3' name='cls_n_per' maxlength='10' class='fixnum' value='<%=fees.getCls_n_per()%>'>%]
						</font></span></td>
                </tr>
                <tr>
                    <td class='title'  colspan="2">영업수당</td>
                    <td colspan="2" align="center">
        			  산출기준:
        			  <select name='commi_car_st'>
                        <option value='1' <%if(emp1.getCommi_car_st().equals("") || emp1.getCommi_car_st().equals("1")){%>selected<%}%>>차량가격</option>
                      </select>
        			</td>
                    <td align='center'><input type='text' size='10' name='commi_car_amt' maxlength='11' class='defaultnum' value='<%=AddUtil.parseDecimal(emp1.getCommi_car_amt())%>' onBlur="javascript:setCommi()">
        				  원</td>
                    <td align='center'>-</td>
                    <td align="center">
                        <input type='text' name="comm_r_rt" value='<%=emp1.getComm_r_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='defaultnum' onBlur='javascript:setCommi()'>
        		      %</td>
                    <td align='center'>
        				        <input type='text' name="comm_rt" value='<%=emp1.getComm_rt()%>' <%if(AddUtil.parseInt(base.getRent_dt())>=20170801){%>size="3" maxlength='3'<%}else{%>size="4"<%}%> class='fixnum' <%if(!base.getUse_yn().equals("")){%>readonly<%}%>>
        			  %</td>
                </tr>					    
				        <%if(fees.getRent_st().equals("1") && base.getRent_st().equals("3")){
										//대차원계약정보
										Hashtable suc_cont = new Hashtable();
										if(!cont_etc.getGrt_suc_l_cd().equals("")){
											suc_cont = a_db.getSucContInfo(cont_etc.getGrt_suc_m_id(), cont_etc.getGrt_suc_l_cd());
										}  
								%>
                <tr>
                    <td class='title' colspan="2" style="font-size : 8pt;">대차원계약</td>
                    <td colspan="6">&nbsp;
					  <b>[원계약정보]</b>
					  <span class="b"><a href="javascript:search_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
					  &nbsp;계약번호 : <input type='text' name='grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='grt_suc_c_no' size='12' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <span class="b"><a href="javascript:cancel_grt_suc()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum'  readonly>원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum'  onBlur="javascript:document.form1.grt_suc_cha_amt.value=parseDecimal(toInt(parseDigit(document.form1.grt_suc_o_amt.value))-toInt(parseDigit(document.form1.grt_suc_r_amt.value)));">원
					  <input type='hidden' name='grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  <font color=red>(약정보증금 차액 <input type='text' name='grt_suc_cha_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt()-cont_etc.getGrt_suc_r_amt())%>' class='whitenum'>)</font>
					  <%}else{ %>
					  <input type='hidden' name='grt_suc_cha_amt' 	value=''>
					  <%} %>					  	
        			</td>
                </tr>						
                <%}%>
                <%if(ej_bean.getJg_g_7().equals("3")){//전기차,수소차 20190701  || ej_bean.getJg_g_7().equals("4") 수소차 제외 %>
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
                      <div style="float: left; margin-left: 10px; height: 100%; display: table;">
                    		<div style="display: table-cell; vertical-align: middle;">
                      		<textarea rows='5' cols='90' name='con_etc' ><%=fee_etcs.getCon_etc()%></textarea>
                      		</div>
                   		</div>
                      <div style="float: left; margin-left: 10px; height: 100%; display: table;">
					  		<div style="display: table-cell; vertical-align: middle;">
					  		<%-- <%if( ej_bean.getJg_3() > 0 && (
					  					cm_bean.getJg_code().equals("4022311") || cm_bean.getJg_code().equals("4022312") || cm_bean.getJg_code().equals("4022313") || cm_bean.getJg_code().equals("4022314")
					  					 || cm_bean.getJg_code().equals("5014123") || cm_bean.getJg_code().equals("5018411") || cm_bean.getJg_code().equals("5018412") || cm_bean.getJg_code().equals("5018413")
					  					 || cm_bean.getJg_code().equals("6022410") || cm_bean.getJg_code().equals("6022415") || cm_bean.getJg_code().equals("6022418") || cm_bean.getJg_code().equals("4217013") || cm_bean.getJg_code().equals("3516312")
					  					 || cm_bean.getJg_code().equals("4519221") || cm_bean.getJg_code().equals("4519222") || cm_bean.getJg_code().equals("4519223") || cm_bean.getJg_code().equals("5514112")
					  					 || cm_bean.getJg_code().equals("6516213") || cm_bean.getJg_code().equals("6516214") || cm_bean.getJg_code().equals("6516215") || cm_bean.getJg_code().equals("6519213") || cm_bean.getJg_code().equals("6519214")
					  					 || cm_bean.getJg_code().equals("5028511") || cm_bean.getJg_code().equals("5028512")
					  					|| cm_bean.getJg_code().equals("4016314") || cm_bean.getJg_code().equals("6012423") || cm_bean.getJg_code().equals("6012424") || cm_bean.getJg_code().equals("6012428") || cm_bean.getJg_code().equals("6012429")
				                		 || cm_bean.getJg_code().equals("6022421") || cm_bean.getJg_code().equals("6022422") || cm_bean.getJg_code().equals("6022423") || cm_bean.getJg_code().equals("6022424") || cm_bean.getJg_code().equals("6022426") || cm_bean.getJg_code().equals("6022427")
				                		 || cm_bean.getJg_code().equals("6024411") || cm_bean.getJg_code().equals("6024412") || cm_bean.getJg_code().equals("6024413") || cm_bean.getJg_code().equals("6024414") || cm_bean.getJg_code().equals("6024415")
				                		 || cm_bean.getJg_code().equals("5028513") || cm_bean.getJg_code().equals("5018414") || cm_bean.getJg_code().equals("5018415") || cm_bean.getJg_code().equals("5018416")
					  				) ){ %>
			                	<input type="button" onclick="setMentConEtc1('5')" value="개별소비세율 환원시 안내문구">
							<%}%> --%>
								<script>
								function setMentConEtc1(idx) {
									if (idx == "5") {
										document.form1.con_etc.value = "※ 2022년 1월 1일 이후 신차가 출고되어 한시적으로 인하된 자동차 개별소비세율이 환원(3.5% → 5%)될 경우 월대여료가 *,***원(공급가) 인상됩니다.";
									} 
								}
							  	</script>
					  		</div>
					  	</div>
                     </td>
                </tr>			                
                <tr>
                    <td colspan="3" class='title'>비고<br>(일반적인 내용 및 영업사원수당 지급 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
                </tr>			
                <tr>
                    <td colspan="3" class='title'>비고<br>(해지 관련)</td>
                    <td colspan="6">&nbsp;
                      <textarea rows='5' cols='90' name='cls_etc'><%=cont_etc.getCls_etc()%></textarea></td>
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
            </table>
	    </td>
    </tr>			
    <input type='hidden' name='bc_b_e1' value='<%=fee_etcs.getBc_b_e1()%>'>
    <input type='hidden' name='bc_b_e2' value='<%=fee_etcs.getBc_b_e2()%>'>
    <input type='hidden' name='bc_b_u' value='<%=fee_etcs.getBc_b_u()%>'>
    <input type='hidden' name='bc_b_u_cont' value='<%=fee_etcs.getBc_b_u_cont()%>'>
    <input type='hidden' name='bc_b_g' value='<%=fee_etcs.getBc_b_g()%>'>
    <input type='hidden' name='bc_b_g_cont' value='<%=fee_etcs.getBc_b_g_cont()%>'>
    <input type='hidden' name='bc_b_ac' value='<%=fee_etcs.getBc_b_ac()%>'>
    <input type='hidden' name='bc_b_ac_cont' value='<%=fee_etcs.getBc_b_ac_cont()%>'>
    <input type='hidden' name='bc_etc' value='<%=fee_etcs.getBc_etc()%>'>
   <%}%> 
<%}%>
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	    
	<%}%>	
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
                      </select></td>
        			  <td class='title'>CMS미실행</td>
        			  <td>&nbsp;
        			    사유 : <input type='text' name='cms_not_cau' size='25' value='<%=fee_etc.getCms_not_cau()%>' class='text'>
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
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(fee.getDef_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="def_sac_id" value="<%=fee.getDef_sac_id()%>">			
			<a href="javascript:User_search('def_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
                      </td>
                </tr>
                  <tr>
                    <td class='title'>자동이체
                        <br><span class="b"><a href="javascript:search_cms('<%=zip_cnt%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                    </td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						  계좌번호 : 
        			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
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
                        <%			}else{
                        %>
                        <option value='<%= bank.getCode()%>' <%if(cms.getCms_bank().equals(bank.getNm())||cms.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%			}%>
                        <%		}
        					}%>
                      </select>
        
        			       ) </td>
        			    </tr>
        			  <tr>
        			    <td>&nbsp;
						  예 금 주 :&nbsp;
        			      <input type='text' name='cms_dep_nm' value='<%=cms.getCms_dep_nm()%>' size='20' class='text'>
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
        			    <td>&nbsp;
					  예금주 생년월일/사업자번호 :
    			      <input type='text' name='cms_dep_ssn' size='15' class='text' value="<%=AddUtil.ChangeSsn(cms.getCms_dep_ssn())%>">
					  <script>
						function openDaumPostcode12() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip12').value = data.zonecode;
									document.getElementById('t_addr12').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
    				  &nbsp;&nbsp;예금주 주소 : 
					  <input type="text" name="t_zip"  id="t_zip12" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
					<input type="button" onclick="openDaumPostcode12()" value="우편번호 찾기">&nbsp;<input type="text" name="t_addr" id="t_addr12" size="50" value="<%=cms.getCms_dep_addr()%>">
        				  </td>
        			    </tr>			
        			  <tr>
        			    <td>&nbsp;
					  연락전화 :
    			      <input type='text' name='cms_tel' size='15' class='text' value="<%=cms.getCms_tel()%>">

    			      &nbsp;&nbsp;휴대폰 :
    			      <input type='text' name='cms_m_tel' size='15' class='text' value="<%=cms.getCms_m_tel()%>">
    					  
    			      &nbsp;&nbsp;이메일 :
    			      <input type='text' name='cms_email' size='40' class='text' style='IME-MODE: inactive' value="<%=cms.getCms_email()%>">	

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
        						}%>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>			
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('12_2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
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
			  <!--부가세환급차량이 추가 되었을 경우에 부가세환급차량 계산서 별도 발금에 대해 묻는다.-->
			  <%	Hashtable tax_print_car = al_db.getTaxPrintCarStChk(base.getClient_id());
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && !client.getPrint_car_st().equals("1") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){
					   %>
			  <tr>
                <td width="13%" class='title'>계산서별도발행구분</td>			  
			    <td colspan='5'>&nbsp;
				  <select name='print_car_st'>
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
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('13')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고전대차</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_tae1 style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class=title>출고전대차여부</td>
                    <td width="20%">&nbsp; &nbsp;<%if(fee.getPrv_dlv_yn().equals("")) fee.setPrv_dlv_yn("N"); %>
                      <input type='radio' name="prv_dlv_yn" value='N' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("N")){%> checked <%}%>>
                      없다
                      <input type='radio' name="prv_dlv_yn" value='Y' onClick="javascript:display_tae()" <%if(fee.getPrv_dlv_yn().equals("Y")){%> checked <%}%>>
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
    <tr id=tr_tae2 style='display:<%if(fee.getPrv_dlv_yn().equals("Y")){%>""<%}else{%>none<%}%>'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
                <tr>
                    <td width="13%" class=title>차량번호</td>
                    <td width="20%">&nbsp;
                      <input type='text' name='tae_car_no' size='12' class='text' <%if(!base.getRent_st().equals("3"))%>readonly<%%> value='<%=taecha.getCar_no()%>'>
                      &nbsp;<span class="b"><a href="javascript:car_search('taecha')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span> 
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
                      <input type='text' name='tae_car_rent_st' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_st())%>' onBlur='javascript:this.value=ChangeDate(this.value)'></td>
                    <td class='title'>대여만료일</td>
                    <td>&nbsp;
                      <input type='text' name='tae_car_rent_et' class='text' size='11' maxlength='10' value='<%=AddUtil.ChangeDate2(taecha.getCar_rent_et())%>' onBlur='javascript:this.value=ChangeDate(this.value)'>
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
                      <input type='text' name='tae_rent_fee' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
        			  <input type='hidden' name='tae_rent_fee_s'	 value=''>
        			  <input type='hidden' name='tae_rent_fee_v'	 value=''>
        			  <%if(!base.getCar_mng_id().equals("") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){ %>
              		  <%}else{%>	
        			  <a href="javascript:EstiTaeSearch();"><img src=/acar/images/center/button_in_search.gif align="absmiddle" border="0" alt="출고전대차견적조회"></a>
        			  <%}%>								  					  
        			</td>
                    <td class=title>정상요금</td>
                    <td>&nbsp;					  
                      <input type='text' name='tae_rent_inv' class='whitenum' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_inv())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함) 
					  <span class="b"><a href="javascript:estimate_taecha('account')" onMouseOver="window.status=''; return true" title="견적하기"><img src=/acar/images/center/button_in_cal.gif align=absmiddle border=0></a></span>
					  <%	if(!taecha.getRent_inv().equals("0")){
					  		ContCarBean t_fee_add = a_db.getContFeeEtcAdd(rent_mng_id, rent_l_cd, "t");
					  		if(!t_fee_add.getBc_est_id().equals("")){%>
					  <a href="javascript:TaechaEstiPrint('<%=t_fee_add.getBc_est_id()%>');"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a>
					  <%		}
					  	}%>					  
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
                      <input type='text' name='tae_rent_fee_cls' class='num' size='10' maxlength='10' value='<%=AddUtil.parseDecimal(taecha.getRent_fee_cls())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원(vat포함)                 
                      <input type='radio' name="tae_rent_fee_st" value='0' <%if(taecha.getRent_fee_st().equals("0")){%> checked <%}%>  >
    	 		          견적서에 표기되어 있지 않음                      				  					 
        			</td>               
              </tr>		
              <%} %>	  
              <tr>
                <td class=title>청구여부</td>
                <td>&nbsp;
                  <select name='tae_req_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getReq_st().equals("1")) out.print("selected");%>>청구</option>
                    <option value="0" <% if(taecha.getReq_st().equals("0")) out.print("selected");%>>무상대차</option>
                  </select></td>
                <td class='title' style="font-size : 8pt;">계산서발행여부</td>
                <td>&nbsp;
                  <select name='tae_tae_st'>
                    <option value="">선택</option>
                    <option value="1" <% if(taecha.getTae_st().equals("1")) out.print("selected");%>>발행</option>
                    <option value="0" <% if(taecha.getTae_st().equals("0")) out.print("selected");%>>미발행</option>
                  </select></td>
                <td class='title'>결재자</td>
                <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(taecha.getTae_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="tae_sac_id" value="<%=taecha.getTae_sac_id()%>">			
			<a href="javascript:User_search('tae_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
    			</td>
              </tr>
            </table>
        </td>
    </tr>    
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('14')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<%}%>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>영업사원-영업담당</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_bus style="display:''"> 		
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width="3%" rowspan="6" class='title'>영<br>
					업</td>
					<td class='title'>영업구분</td>
					<td colspan='5'>&nbsp;
					<input type='radio' name="pur_bus_st" value='4' checked>
					에이전트
					</td>		
				</tr>
				<tr id="dlv_con_commi_yn_tr">
					<td class='title'>출고보전수당 지급여부</td>
					<td colspan='5'>&nbsp;
						<label><input type='radio' name="dlv_con_commi_yn" value='N' <%if(!cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input3()">
						없음</label>
						<label><input type='radio' name="dlv_con_commi_yn" value='Y' <%if(cont_etc.getDlv_con_commi_yn().equals("Y")){%>checked<%}%> onClick="javascript:cng_input3()">
						있음</label>
						<table>
              		   <tr>              		   
              		       <td>&nbsp;
              		           <select name='dir_pur_commi_yn'>
                          <option  value="">선택</option>
                          <option value="Y" <%if(cont_etc.getDir_pur_commi_yn().equals("Y")){%>selected<%}%>>특판출고(실적이관가능)</option>
                          <option value="N" <%if(cont_etc.getDir_pur_commi_yn().equals("N")){%>selected<%}%>>특판출고(실적이관불가능)</option>
                          <option value="2" <%if(cont_etc.getDir_pur_commi_yn().equals("2")){%>selected<%}%>>자체출고대리점출고</option>
                        </select>                        
              		       </td> 
              		   </tr>
              		</table>
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
					  <input type='hidden' name='car_off_id' value='<%=emp1.getCar_off_id()%>'></td>
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
                      <input type='text' name="v_comm_r_rt" value='<%=emp1.getComm_r_rt()%>' size="4" class='num' onBlur='javascript:setCommi()'>
        		      % 
        			  <input type='text' name="commi" size='10' value='<%=AddUtil.parseDecimal(emp1.getCommi())%>' maxlength='7' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
        			  원			  
        			</td>
                </tr>
                <tr>
                    <td class='title'>변경사유</td>
                    <td colspan="3" >&nbsp;
        		      <input type='text' name="ch_remark" value='<%=emp1.getCh_remark()%>' size="40" class='text'>
                    </td>
                    <td class='title'>결재자</td>
                    <td>&nbsp;
                        <input name="user_nm" type="text" class="text"  readonly value="<%=c_db.getNameById(emp1.getCh_sac_id(), "USER")%>" size="12"> 
			<input type="hidden" name="ch_sac_id" value="<%=emp1.getCh_sac_id()%>">			
			<a href="javascript:User_search('ch_sac_id', '<%=user_idx%>');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
			<% user_idx++;%>
        			</td>
                </tr>
                <tr>
                    <td class='title'>은행명</td>
                    <td >&nbsp;
                    	<input type='hidden' name="emp_bank" value="<%=emp1.getEmp_bank()%>">
        		      <select name='emp_bank_cd'>
                        <option value=''>선택</option>
                        <%	if(bank_size > 0){
        											for(int i = 0 ; i < bank_size ; i++){
        												CodeBean bank = banks[i];
        												//신규인경우 미사용은행 제외
																if(bank.getUse_yn().equals("N"))	 continue;
												%>
                        <option value='<%= bank.getCode()%>' <%if(emp1.getEmp_bank().equals(bank.getNm())||emp1.getBank_cd().equals(bank.getCode())){%> selected <%}%>><%=bank.getNm()%></option>
                        <%		}
        					}%>
                      </select>
        			</td>
                    <td class='title'>계좌번호</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_no" value='<%=emp1.getEmp_acc_no()%>' size="22" class='text'>
        			</td>
                    <td class='title'>예금주명</td>
                    <td>&nbsp;
                      <input type='text' name="emp_acc_nm" value='<%=emp1.getEmp_acc_nm()%>' size="20" class='text'>
        			</td>
                </tr>		  		  
            </table>
        </td>
    </tr>	
	<tr>
	    <td class=h></td>
	</tr>    
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(base.getCar_gu().equals("1")){%>영업사원-출고담당<%if(!cop_bean.getRent_l_cd().equals("")){%>&nbsp;<font color=red>(사전계약 <%=cop_bean.getCom_con_no()%>)</font><%}%><%}else if(base.getCar_gu().equals("2")){%>중고차구입처<%}%></span></td>
	</tr>	
	<tr>
	    <td class=line2></td>
	</tr>
    <tr id=tr_emp_dlv style="display:''"> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>				
              <tr>
                    <td width="3%" rowspan="4" class='title'>출<br>
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
                		  <input type='text' name='pur_req_dt' value='<%=pur.getPur_req_dt()%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
        			  <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>  
                      <span class="b"><a href="javascript:search_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_choice.gif align=absmiddle border=0></a></span>
        			  <span class="b"><a href="javascript:cancel_emp('DLV')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_cancel.gif align=absmiddle border=0></a></span>
        			  <%}%>
                      <input type='checkbox' name="emp_chk" onClick="javascript:set_emp_sam()"><font size='1'>상동</font></td>
                    <td width="10%" class='title'>영업소명</td>
                    <td width="20%">&nbsp;
                      <%=c_db.getNameById(emp2.getCar_comp_id(),"CAR_COM")%>
                      <input type='text' name='car_off_nm' size='15' value='<%=emp2.getCar_off_nm()%>' class='whitetext' readonly>
					  <input type='hidden' name='car_off_id' value='<%=emp2.getCar_off_id()%>'>
        			</td>
        	    <td width="10%" class='title'>연락처</td>
                    <td>&nbsp;
                      <input type='text' name='emp_m_tel' size='15' value='<%=emp2.getEmp_m_tel()%>' class='whitetext' readonly>
                      <input type='hidden' name='car_off_st' value=''>                      
                    </td>		
                </tr>
              <tr>
                <td class='title'>계약금</td>
                <td colspan="5">&nbsp;
                	금액 : 
				     <input type='text' name='con_amt' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getCon_amt())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="3" <%if(pur.getTrf_st0().equals("3")) out.println("selected");%>>카드</option>
        				<option value="1" <%if(pur.getTrf_st0().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='con_bank'>
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
				  	<select name="acc_st0" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st0().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st0().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='con_acc_no' value='<%=pur.getCon_acc_no()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='con_acc_nm' value='<%=pur.getCon_acc_nm()%>' size='20' class='text'>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='con_est_dt' value='<%= AddUtil.ChangeDate2(pur.getCon_est_dt())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
    			</td>															
              </tr>
              <%if(!base.getCar_gu().equals("2")){%>    	
              <tr>				
                <td class='title'>임시운행보험료</td>
                <td colspan='5'>&nbsp;
                  금액 : 
				     <input type='text' name='trf_amt5' maxlength='10' value='<%=AddUtil.parseDecimal(pur.getTrf_amt5())%>' class='num' size='10' onBlur='javascript:this.value=parseDecimal(this.value);'>원	
                     &nbsp;
                     지급수단 :
                     <select name="trf_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="2" <%if(pur.getTrf_st5().equals("2")) out.println("selected");%>>선불카드</option>
        				<option value="3" <%if(pur.getTrf_st5().equals("3")) out.println("selected");%>>후불카드</option>
        				<option value="1" <%if(pur.getTrf_st5().equals("1")) out.println("selected");%>>현금</option>
        			  </select> 
                     &nbsp;
                    금융사 :
					<select name='card_kind5'>
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
				  	<select name="acc_st5" class='default'>
                        <option value="">==선택==</option>
        				<option value="1" <%if(pur.getAcc_st5().equals("1")) out.println("selected");%>>영구계좌</option>
        				<option value="2" <%if(pur.getAcc_st5().equals("2")) out.println("selected");%>>가상계좌</option>
        			  </select>
				  	&nbsp;
					계좌번호 : 
        			<input type='text' name='cardno5' value='<%=pur.getCardno5()%>' size='20' class='text'>
					&nbsp;
					예금주 : 
        			<input type='text' name='trf_cont5' value='<%=pur.getTrf_cont5()%>' size='20' class='text'>
        			&nbsp;
        			지급요청일 :
        			<input type='text' name='trf_est_dt5' value='<%= AddUtil.ChangeDate2(pur.getTrf_est_dt5())%>' class='text' size='11' maxlength='10' onBlur='javscript:this.value = ChangeDate(this.value);'>
				    <!--<input type="button" class="button" id="b_tmp_ins_amt" value='현대해상 보험료 보기' onclick="javascript:OpenImg('/acar/images/center/tmp_ins_amts.jpg');">-->
				    <%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>  
                		<%if(pur.getTrf_amt5() > 0 && !pur.getTrf_amt_pay_req().equals("")){%>
                		&nbsp;송금요청(<%=pur.getTrf_amt_pay_req()%>)
                		<%}%>
                	<%}%>
    			</td>				
              </tr>   
              <%}%>   
              
              
            </table>
        </td>
    </tr>
	<tr>
	    <td>* 출고영업소에 차량대금를 지급할 계좌를 입력하십시오. 개인명의 계좌는 사용할 수 없습니다.(특판제외)</td>
	<tr>		
	<%if(!san_st.equals("요청")){%>	
	<%	if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>  
	<tr>
	    <td align="right"><a href="javascript:update('15')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<%	}else{%>
    <tr>
        <td>&nbsp;</td>
    </tr>		
	<%	}%>
	<%}%>
	<%if(base.getUse_yn().equals("")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>견적사후관리 (계약체결 사유 입력)</span></td>
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
  <%if(!san_st.equals("요청")){%>  
	<tr>
	    <td align="right"><%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%><a href="javascript:update('16')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a><%}%></td>
	<tr>	
	<%}%>	
	<%}%>
			    
	<%	int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;%>
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
			String content_seq  = rent_mng_id+""+rent_l_cd; 
			
			Vector attach_vt = new Vector();
			int attach_vt_size = 0;       
			        		
        	%>
				
		<!--변경후-->	
				
				
		<%	if(ck_acar_id.equals(base.getBus_id())){ %>
        	<%		if(AddUtil.parseInt(base.getRent_dt()) > 20151201){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">자동차대여이용계약서(신규,대차,증차)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_dc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=1&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;<a href='https://fms3.amazoncar.co.kr/data/doc/privacy_agree.pdf' target="_blank"><img src=/acar/images/center/button_in_sj.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getReg_dt()) >= 20200303 && user_id.equals("000284")){%>
                         		<a href="javascript:go_edoc2('lc_rent_link','1','1','');" title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>    
                  </td>		  
                </tr>	        	
        	<%		}%>
        	<%	}%>
        	

        	<%		if(now_stat.equals("계약승계") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) > 20180801 ){ %>
        	<%			scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp;</td>
                  <td align="center">자동차대여이용계약서(계약승계)</td>
                  <td align="center">
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=cont_etc.getSuc_rent_st()%>&paper_size=A4' target="_blank"><img src=/acar/images/center/button_in_a4.gif align="absmiddle" border="0"></a>
		      &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		      <a href='/fms2/lc_rent/newcar_doc_sg.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=cont_etc.getSuc_rent_st()%>&paper_size=A3' target="_blank"><img src=/acar/images/center/button_in_a3.gif align="absmiddle" border="0"></a>
		  </td>
                  <td align="center">웹페이지</td>		  
                  <td align="center">  
                      <%if(now_stat.equals("계약승계") && AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20200303 && user_id.equals("000284")){%>
	                       		<a href="javascript:go_edoc2('lc_rent_link','2','<%=cont_etc.getSuc_rent_st()%>','');" title='전자계약서 전송'><img src=/acar/images/center/button_in_econt.gif align="absmiddle" border="0"></a>
                      <%}%>                                                                               
                  </td>		  
                </tr>	      
                
		<!--대여개시후계약서(앞)-jpg파일-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일 : 계약승계</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(앞)-jpg파일 : 계약승계</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--대여개시후계약서(뒤)-jpg파일-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일 : 계약승계</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">대여개시후계약서(뒤)-jpg파일 : 계약승계</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">  
                
		<!--개인(신용)정보 수집·이용·제공·조회동의서-->				
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
					if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){//법인 대표자연대면제는 제외
					}else{
						scan_cnt++;
						out.println("<font color=red>불충</font>");
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
                	file_rent_st = cont_etc.getSuc_rent_st();
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
						scan_cnt++;
						out.println("<font color=red>불충</font>");
                    %>
                    </td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                           
        <%	}%>                                	
                	
		<!--CMS동의서jpg-->			
                <% 	scan_num++; 
                	file_rent_st = cont_etc.getSuc_rent_st();
                	file_st = "38";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
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
<%				if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(이미지파일이 아니거나 300KB 초과입니다.)</font>"); }
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
					}
				
			%>                      	
                    	</td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                    
                                  	
        	<%		}else{%>        	        	
        	
        					

		<!--최초계약서(pdf)-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "1";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < 1 ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>                
                <tr>
                    <td align="center"><%=scan_num%></td>                    
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">신규 계약서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">신규 계약서</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--대여개시후계약서(앞)-jpg파일-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
                
		<!--대여개시후계약서(뒤)-jpg파일-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>    
                <input type='hidden' name="h_file_st" value="<%=file_st%>">            
                
        	        	
                
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
				//20140801부터 필수
				if(AddUtil.parseInt(base.getRent_dt()) > 20140731 && fee_size == 1){
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
                                	
		<!--개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)-->	
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="'https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">개인(신용)정보 수집·이용·제공·조회동의서(공동임차인)</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
                    <%
				//20210601부터 필수
				if(AddUtil.parseInt(base.getRent_dt()) >= 20210601 && fee_size == 1){
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
				if(AddUtil.parseInt(base.getRent_dt()) > 20170731 && fee_size == 1){
					if(fee.getFee_pay_st().equals("1") && !cms.getCms_acc_no().equals("") && !cms.getCms_bank().equals("") && !cms_scan_yn.equals("Y")){ //자동이체
						scan_cnt++;
						out.println("<font color=red>불충</font>");
						if(!cms_scan_yn.equals("Y")){ out.println("<font color=red>(이미지파일이 아니거나 300KB 초과입니다.)</font>"); }
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//20170801 필수
				if(AddUtil.parseInt(base.getRent_dt()) > 20170731 && fee_size == 1){
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
                <input type='hidden' name="h_file_st" value="<%=file_st%>">         
               
        	<%		}%>                 

		<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409){%>	
		
		<!--임직원운전한정특약가입요청서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "40";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "40", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">   				
			
		<%}%>	
		         
		                                				
				       		
       		<tr>
  		    <td class=line2 colspan="6"></td>
		</tr>
			
				
		<%if(!client.getClient_st().equals("2")){%>		
		<!--사업자등록증jpg-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "2";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "2", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>                       		
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
        	<%}%>
        		
        		
        	<%if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>

		<!--법인등기부등본-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "3";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "3", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>불충</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                      	
                
        	<%}%>
        		
        		
        	<%if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2") && cont_etc.getClient_share_st().equals("2")){%>
        	<%}else{%>
        	<%	if(scan_chk.equals("Y")){%>	
        	
		<!--<%=scan_mm%>신분증jpg-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "4";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "4", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
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
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%// scan_cnt++;%><!--<font color=red>불충</font>--></td>
                    <td align="center"></td>
                </tr>      
                <%	}%> 
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                                              		
                        		
        	<%	}%>
        	<%}%>
        		
        		

                <%//연대보증인 구비서류-----------------------------------
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
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>   
                <input type='hidden' name="h_file_st" value="<%=file_st%>">       
		<!--연대보증인 사업자등록증/신분증-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "11";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "11", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증인 사업자등록증/신분증</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증인 사업자등록증/신분증</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>  
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                         		
		<!--연대보증인 법인등기부등본/주민등록등본-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "12";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "12", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);                                	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증인 법인등기부등본/주민등록등본</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">연대보증인 법인등기부등본/주민등록등본</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>        		
                <input type='hidden' name="h_file_st" value="<%=file_st%>">
		<!--연대보증인 법인인감증명서/인감증명서-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "13";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "13", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">

        	<%}%>	
        	
        	
		<!--통장사본-->				
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "9";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "9", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center">
			<%	//자동이체 & 신규계약 
				if(fee.getFee_pay_st().equals("1") && base.getRent_st().equals("1")){
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
                		file_rent_st = "1";
                		file_st = "44";     
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>                    
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                  
                                
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
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
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
                <% 	file_rent_st = "1";
                	file_st = "10";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "10", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                <% 	file_rent_st = "1";
                	file_st = "15";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileListLcScanEqual(content_code, rent_mng_id, rent_l_cd, "15", 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
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
                <input type='hidden' name="h_file_st" value="">                      	


    
             </table>
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
	
	
    <tr>
	    <td align='center'>	   
		 
	    	<%	String sanction_date = base.getSanction_date();
	  		if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);%>
	  	
		
        	<%	if(AddUtil.parseInt(base.getRent_dt()) > AddUtil.parseInt(sanction_date)){%>
        	<%		if(!san_st.equals("요청")){%>
        	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:sanction_req();" title='계약결제 요청하기'><img src=/acar/images/center/button_gjyc.gif align=absmiddle border=0></a>
	    	<%		}%>
	    	<!--    계약삭제 요청 -->        	
            <br><br>계약삭제요청사유 : <input type='text' name="sanction_req_delete_cont" value='' size="100" class='text'>&nbsp;<a href="javascript:sanction_req_delete();" title='계약삭제 요청하기'>[계약삭제요청 메시지발송]</a><br><br>        
	    	<%	}%>
		

	    	<%	if(base.getBus_id().equals(user_id) || base.getReg_id().equals(user_id)){%>
	    	<%		if(!san_st.equals("요청")){%>
	    	<%			if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>  
	    	&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='전체 수정하기'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
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
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("1")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("1"))){%>	  
	    <a href="lc_reg_step2.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 	    
        <%}%>	
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2"))){%>	  
	    <a href="lc_reg_step3.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_3step.gif align=absmiddle border=0></a>&nbsp;	  
        <%}%>	
	  	<%if((base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && base.getReg_step().equals("2"))){%>	  
	    <a href="lc_reg_step4.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
        <%}%>	
    </tr>			
	    
</table>
  <input type='hidden' name="zip_cnt" 			value="<%=zip_cnt%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
<script language="JavaScript">
<!--	
	//페이지 로드 시 출고보전수당 지급여부 초기화		2017. 12. 06
	document.addEventListener("DOMContentLoaded", function(){
		var dlv_con_commi_yn_val = $("input[name=dlv_con_commi_yn]:checked").val();
		if(dlv_con_commi_yn_val == "Y"){															// 출고보전수당 지급여부 -> 있음 선택
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 -> 자체출고 선택
			$("input[name='one_self']:radio[value='N']").prop("disabled", true);		// 출고구분 -> 영업사원출고 비황성화
		}else if(dlv_con_commi_yn_val == "N"){													// 출고보전수당 지급여부 -> 없음 일 경우
			$("input[name='one_self']:radio[value='N']").prop("disabled", false);	// 출고구분 -> 영업사원출고 활성화
			$("input[name='one_self']:radio[value='N']").prop("checked", true);	// 출고구분 -> 영업사원출고 선택
		}
	});
	
	// 출고보전수당		2017. 12. 06
	var one_self_no = $("input[name='one_self']:radio[value='N']");		// 출고구분 영업사원출고
	$("input[name=dlv_con_commi_yn]").change(function(){
		if($(this).val() == "Y"){																			// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 있음 선택 시
			$("input[name='one_self']:radio[value='Y']").prop("checked", true);		// 출고구분 자체출고 선택
			one_self_no.prop("disabled", true);														// 출고구분 영업사원출고 비활성화
		}else{																										// 영업구분에서 영업사원영업, 에이전트 선택 후 > 출고보전수당 지급여부 없음 선택 시
			one_self_no.prop("disabled", false);														// 출고구분 영업사원출고 활성화
			one_self_no.prop("checked", true);														// 출고구분 영업사원출고 선택
		}
	});
	
	var fm = document.form1;
	
	if(fm.purc_gu.value == '' && fm.car_st.value == '3'){	fm.purc_gu[1].selected = true; 	}	
	if(fm.purc_gu.value == '' && fm.car_st.value == '1'){   fm.purc_gu[2].selected = true; 	}

	sum_car_c_amt();
	sum_car_f_amt();
	sum_pp_amt();	
	
	fm.scan_cnt.value = <%=scan_cnt%>;	
	
	cont_chk();
		
	function cont_chk(){
		var kkk1 = <%=user_id%>;
		if(kkk1 == "139"){
			// del
		}else if(<%=fee_etc.getReg_dt()%> >= 20100501 && toInt(fm.scan_cnt.value) > 0){
		
			fm.chk1.value = '* 미등록 스캔이 <%=scan_cnt%>건 있습니다. --> 결재 조건이 충족되지 않습니다.';
			
			<%	if(client.getFirm_type().equals("7")){%>
			fm.chk1.value = '* 미등록 스캔이 <%=scan_cnt%>건 있습니다. --> 결재 조건이 충족되지 않습니다. -> 지방자체단체일 경우라도 다른 파일을 대체해서 스캔등록하십시오.';
			<%	}%>
			
			tr_chk1.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			
		}
		
		//결재자 입력값 확인
		if(fm.client_st.value != '2' && fm.client_guar_st[1].checked == true &&  fm.guar_sac_id.value != ''){
			fm.sanc1.value = '* 대표이사보증 면제 결재자는 <%=c_db.getNameById(cont_etc.getGuar_sac_id(),"USER")%> 입니다.';
			tr_sanc1.style.display = '';					
		}		
		if(fm.car_ja.value != fm.imm_amt.value &&  fm.rea_appr_id.value != ''){
			fm.sanc2.value = '* 자차면책금 변경 결재자는 <%=c_db.getNameById(cont_etc.getRea_appr_id(),"USER")%> 입니다.';
			tr_sanc2.style.display = '';					
		}
		if(fm.credit_sac_id.value != ''){
			fm.sanc3.value = '* 채권확보 결재자는 <%=c_db.getNameById(fee_etc.getCredit_sac_id(),"USER")%> 입니다.';
			tr_sanc3.style.display = '';					
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
	
		
		//필수이력 체크
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
			<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
			if(toInt(parseDigit(fm.import_cash_back.value))+toInt(parseDigit(fm.dc_c_amt.value)) == 0){
				//fm.chk14.value = '* 수입차인데 매출D/C와 Cash Back금액이 모두 없습니다.';
				//tr_chk14.style.display = '';
				//fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			<%}%>
		<%}else{%>
			if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
				if(fm.car_ja.value != fm.imm_amt.value && (fm.ja_reason.value == '' || fm.rea_appr_id.value == '')){
					fm.chk6.value = '* 자차면책금 변경사유 또는 결재자가 없습니다.';
					tr_chk6.style.display = '';					
					fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				}
			}			
		<%}%>			

		<%if(!ej_bean.getJg_w().equals("1") && !cm_bean.getJg_code().equals("2361") && !cm_bean.getJg_code().equals("2362") && !cm_bean.getJg_code().equals("2031111") && !cm_bean.getJg_code().equals("2031112") && !cm_bean.getJg_code().equals("5033111") && AddUtil.parseInt(cm_bean.getS_st()) < 600){ //!cm_bean.getJg_code().equals("9133") && !cm_bean.getJg_code().equals("9237")%>
		<%	if(ej_bean.getJg_g_7().equals("1")||ej_bean.getJg_g_7().equals("2")||ej_bean.getJg_g_7().equals("3")||ej_bean.getJg_g_7().equals("4")){%>
		if(toInt(parseDigit(fm.tax_dc_amt.value)) == 0){
				fm.chk15.value = '* 친환경인데 개소세감면액 금액이 모두 없습니다.';
				tr_chk15.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}	
		<%	}%>	
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
			
		if(fm.opt_chk[0].checked == false && fm.opt_chk[1].checked == false){
			fm.chk7.value = '* 매입옵션 유무가 없습니다.';
			tr_chk7.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}			
		if(fm.opt_chk[1].checked == true && (fm.opt_per.value == '' || toInt(parseDigit(fm.opt_amt.value))==0)){
			fm.chk7.value = '* 매입옵션율 또는 매입옵션금액이 없습니다.';
			tr_chk7.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}	
		if(toInt(fm.fee_amt.value)=='0' && toInt(fm.tot_pp_amt.value)=='0'){
			fm.chk17.value = '* 선수금과 대여료 계약요금이 없습니다.';
			tr_chk17.style.display = '';					
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
		}		
		if(fm.fee_pay_st.value == '1'){
			if(fm.cms_bank_cd.value == '' || fm.cms_acc_no.value == '' || fm.cms_acc_no.value == '' || fm.cms_dep_nm.value == '' || fm.cms_dep_ssn.value == ''	){
				fm.chk8.value = '* 자동이체인데 은행정보가 없습니다.';				
				tr_chk8.style.display = '';					
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
				if(fm.cms_acc_no.value != '')		{ 
					if ( !checkInputNumber("CMS 계좌번호", fm.cms_acc_no.value) ) {	
						fm.cms_acc_no.focus(); 		return; 
					}
					//휴대폰,연락처 동일여부 확인
					if(replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getM_tel()%>") || replaceString("-","",fm.cms_acc_no.value)==replaceString("-","","<%=client.getO_tel()%>")){
						alert("계좌번호가 휴대폰 혹은 연락처와 같습니다. 평생계좌번호는 자동이체가 안됩니다.");
						fm.cms_acc_no.focus(); 		return; 
					}
				}
			
			}
		}
		
		if(fm.est_area.value == '' || fm.county.value == ''){
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
		
		
		<%if(!String.valueOf(begin.get("CLS_ST")).equals("계약승계")){%>  
			<%if(fee_size ==1 && base.getCar_gu().equals("1")){%>
			//출고담당 출고구분 체크
			if(fm.one_self[0].checked == false && fm.one_self[1].checked == false){
				fm.chk13.value = '* 출고담당 출고구분이 없습니다.';
				tr_chk13.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}
			<%}%>
		<%}%>
			
			if(<%=client_tel_cnt%> < 2 ){
				fm.chk15.value = '* 고객 연락처는 중복되지 않는 번호가 2개 이상이여야 합니다.<%if(client.getClient_st().equals("1")){%>(법인고객:회사전화,대표자휴대폰,차량이용자휴대폰)<%}else if(client.getClient_st().equals("2")){%>(개인고객:고객휴대폰,자택전화,직장전화)<%}else{%>(개인사업자:회사전화,대표자휴대폰,자택전화,차량이용자휴대폰)<%}%>';
				tr_chk15.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
			}			
			
			<%if(client.getClient_st().equals("1") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("N")){%>
      		<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
				fm.chk16.value = '* 고객의 임직원운전한정특약이 미가입입니다. 승인처리하십시오.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    		<%	}else{%>
	    	<%		if(base.getOthers().equals("")){%>	
			fm.chk16.value = '* 고객의 임직원운전한정특약이 미가입입니다. 미가입사유를 보험관리-비고에 입력하십시오.';
			tr_chk16.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  			<%		}%>
      		<%	}%>
      		<%}%>	
      		
      		<%if(!client.getClient_st().equals("1") && !client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("Y")){%>
      		<%	if(cont_etc.getCom_emp_sac_id().equals("")){%>
				fm.chk16.value = '* 고객의 임직원운전한정특약이 가입입니다. 승인처리하십시오.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
    		<%	}else{%>
	    	<%		if(base.getOthers().equals("")){%>	
			fm.chk16.value = '* 고객의 임직원운전한정특약이 가입입니다. 가입사유를 보험관리-비고에 입력하십시오.';
			tr_chk16.style.display = '';
			fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;    	
  			<%		}%>
      		<%	}%>
      		<%}%>	      		

			<%if(!client.getClient_st().equals("2") && AddUtil.parseInt(a_e)>101 && AddUtil.parseInt(a_e) < 600 && AddUtil.parseInt(a_e) != 409 && cont_etc.getCom_emp_yn().equals("")){%>
				fm.chk16.value = '* 고객의 임직원운전한정특약이 가입여부가 없습니다.';
				tr_chk16.style.display = '';
				fm.chk_cnt.value = toInt(fm.chk_cnt.value)+1;
      		<%}%>	
      

			
	}
 
	//전체선택
	function AllSelect(){
		var fm = document.form1;
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
	
	//맑은서울스티커 발급 선택 시 등록지역을 서울로 자동 변경 / 2017. 10. 30
	$("#eco_e_tag").change(function() {
		console.log("cccc");
		if($("#eco_e_tag").val() == "1"){
			if(<%=base.getCar_mng_id().equals("")%>){
				$("#car_ext").val("1").prop("selected", true);	
			}
		}
	});
//-->
</script>
</body>
</html>
