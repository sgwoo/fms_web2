<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.con_ins.*, acar.ext.*"%>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="al_db"     class="acar.client.AddClientDatabase"      scope="page"/>
<jsp:useBean id="af_db"     class="acar.fee.AddFeeDatabase"	       scope="page"/>
<jsp:useBean id="e_bean"    class="acar.estimate_mng.EstimateBean"     scope="page"/>
<jsp:useBean id="ej_bean"   class="acar.estimate_mng.EstiJgVarBean"    scope="page"/>
<jsp:useBean id="em_bean"   class="acar.estimate_mng.EstiCommVarBean"  scope="page"/>
<jsp:useBean id="cr_bean"   class="acar.car_register.CarRegBean"       scope="page"/>
<jsp:useBean id="shDb"      class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="code_bean" class="acar.common.CodeBean"               scope="page"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="ac_db"     class="acar.cost.CostDatabase"             scope="page"/>
<jsp:useBean id="ae_db"     class="acar.ext.AddExtDatabase"            scope="page"/>
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
	String gubun4 	= request.getParameter("gubun4")==null?	"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?	"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?	"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?	"":request.getParameter("end_dt");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	
	String now_stat	 	= request.getParameter("now_stat")==null?"":request.getParameter("now_stat");
	String san_st	 	= request.getParameter("san_st")==null?"":request.getParameter("san_st");
	
	CommonDataBase c_db 	= CommonDataBase.getInstance();
	AddCarMstDatabase cmb 	= AddCarMstDatabase.getInstance();
	EstiDatabase edb 	= EstiDatabase.getInstance();
	CarRegDatabase crd 	= CarRegDatabase.getInstance();
	MaMenuDatabase nm_db 	= MaMenuDatabase.getInstance();
	EstiDatabase e_db 	= EstiDatabase.getInstance();
	CarOfficeDatabase cod 	= CarOfficeDatabase.getInstance();
	
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
	
	//월렌트정보
	ContFeeRmBean f_fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, "1");
	
	
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
	
	
	
	//계약승계 혹은 차종변경일때 원계약 해지내용
	Hashtable begin = a_db.getContBeginning(rent_mng_id, base.getReg_dt());
	
	//임의연장
	Vector im_vt = af_db.getFeeImList(rent_mng_id, rent_l_cd, "");
	int im_vt_size = im_vt.size();
	
	
	//담당자 리스트
	Vector users = c_db.getUserList("", "", "EMP"); //영업담당자 리스트
	int user_size = users.size();
	
	Vector users2 = c_db.getUserList("9999", "", "", "N"); //퇴사자 리스트
	int user_size2 = users2.size();
	
	
	
	//금융사리스트
	CodeBean[] banks = c_db.getCodeAllCms("0003"); 
	int bank_size = banks.length;
	
	//잔가변수NEW
	ej_bean = edb.getEstiJgVarCase(cm_bean.getJg_code(), "");
	
	String a_a = "2";
	if(base.getCar_st().equals("1")) a_a = "2";
	if(base.getCar_st().equals("3")) a_a = "1";
	
	//공통변수
	em_bean = edb.getEstiCommVarCase(a_a, "");
	
	
	
	
	
	Hashtable carOld 	= c_db.getOld(cr_bean.getInit_reg_dt());//차량등록 경과기간(차령)
	
	
	
	//스캔파일 체크여부
	String scan_chk = "Y";
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st="+rent_st+"&from_page="+from_page;
	
	String valus_t = "?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&rent_st=t&from_page="+from_page;
	
	int fee_opt_amt = 0;
	
	int zip_cnt = 0;
	
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(max_fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(max_fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
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
	

	
	//리스트
	function list(){
		var fm = document.form1;	
		
		if(fm.from_page.value == '')						fm.action = 'lc_rm_frame.jsp';
		else if(fm.from_page.value == '/fms2/lc_rent/lc_bc_frame.jsp')		fm.action = '/fms2/lc_rent/lc_bc_frame.jsp';		
		else if(fm.from_page.value == '/fms2/mis/sale_cost_mng_frame.jsp')	fm.action = '/fms2/mis/sale_cost_mng_frame.jsp';				
		else									fm.action = fm.from_page.value;
		
		fm.target = 'd_content';
		fm.submit();
	}	

	//2단계 -----------------------------------------------------------
	
	//고객 조회
	function search_client()
	{
		window.open("/fms2/client/client_s_frame.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp", "CLIENT", "left=10, top=10, width=1100, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//고객 보기
	function view_client()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("선택된 고객이 없습니다."); return;}	
		window.open("/fms2/client/client_c.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT", "left=10, top=10, width=900, height=600, scrollbars=yes, status=yes, resizable=yes");
	}		
	
	//지점/현장 조회
	function search_site()
	{
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}
		window.open("/fms2/client/client_site_s_p.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=500, scrollbars=yes, status=yes, resizable=yes");
	}			
	//지점/현장 보기
	function view_site()
	{
		var fm = document.form1;
		if(fm.site_id.value == ""){ alert("선택된 지점이 없습니다."); return;}
		window.open("/fms2/client/client_site_i_p.jsp?cmd=view&auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&from_page=/fms2/lc_rent/lc_reg_step2.jsp&client_id="+fm.client_id.value+"&site_id="+fm.site_id.value, "CLIENT_SITE", "left=100, top=100, width=620, height=450");
	}			


	//관계자 조회
	function search_mgr(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_mgr.jsp?car_st=<%=base.getCar_st()%>&idx="+idx+"&client_id="+fm.client_id.value, "MGR", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");
	}
	
	//주소 조회
	function search_post(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_post.jsp?idx="+idx+"&client_id="+fm.client_id.value, "POST", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");	
	}
	
	//연대보증인
	function guar_display(){
		var fm = document.form1;
		var size = toInt(fm.gur_size.value);
		if(fm.guar_st[0].checked == true){ 				//가입
			tr_guar2.style.display	= '';
		}else{								//면제
			tr_guar2.style.display	= 'none';
		}
	}	
	
	//길이 체크
	function CheckLen(f, max_len){
		var len = get_length(f);
		if (len > max_len){
			alert(f+'는 길이'+len+'로 최대길이'+max_len+'를 초과합니다.');
		}
	}
	


	//4단계 -----------------------------------------------------------
		
	//자동차등록정보 보기
	function view_car()
	{
		window.open("/acar/car_register/car_view.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&car_mng_id=<%=base.getCar_mng_id()%>&cmd=ud", "VIEW_CAR", "left=10, top=10, width=850, height=700, scrollbars=yes");
	}		
	//차종내역 보기
	function view_car_nm(car_id, car_seq){
		window.open("/acar/car_mst/car_mst_u.jsp?from_page=lc_rent&car_id="+car_id+"&car_seq="+car_seq, "VIEW_CAR_NM", "left=20, top=20, width=875, height=650, scrollbars=yes");		
	}

	//해당 차량 상위차종 기본사양 보기
	function open_car_b(car_id, car_seq, car_name){
		window.open('view_car_b.jsp?car_id='+car_id+'&car_seq='+car_seq+'&car_name='+car_name, "car_b", "left=100, top=100, width=450, height=600, scrollbars=yes"); 
	}	


	
	
	//대여기간 셋팅
	function set_cont_date(obj){
		var fm = document.form1;
		
		
		if(obj == fm.con_mon || obj == fm.con_day){
		
			fm.rent_start_dt.value = ChangeDate4(fm.rent_start_dt, fm.rent_start_dt.value);
					
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

	
	

	//수정
	function update(idx){
		var fm = document.form1;
		
		if(idx == 0 || idx == 99){

			if(fm.bus_id2.value == '')			{ alert('영업담당자를 확인하십시오.'); 				return;}
			if(fm.bus_id2.value.substring(0,1) == '1')	{ alert('영업담당자가 부서로 선택되었습니다. 확인해주세요.'); 	return;}				
			if(fm.est_area.value == '')			{ alert('차량이용지역을 확인하십시오.'); 			return;}
				
		}else if(idx == 1 || idx == 99){
		
			if(fm.client_id.value == '')	{ alert('고객을 선택하십시오.'); 		return;}
									
			
		}else if(idx == 2 || idx == 99){
					
			if(fm.guar_st[0].checked == true){
				if(fm.gur_nm[0].value == '')	{ alert('연대보증인 성명을 입력하십시오.'); 			return;}
				if(fm.gur_ssn[0].value == '')	{ alert('연대보증인 생년월일을 입력하십시오.'); 		return;}
				if(fm.t_addr[2].value == '')	{ alert('연대보증인 주소를 입력하십시오.'); 			return;}
				if(fm.gur_tel[0].value == '')	{ alert('연대보증인 연락처를 입력하십시오.'); 			return;}
				if(fm.gur_rel[0].value == '')	{ alert('연대보증인 관계를 입력하십시오.'); 			return;}												
			}	
			
		}else if(idx == 10 || idx == 99){
		
			if(fm.driving_age.value == '')				{ alert('보험사항-운전자연령을 입력하십시오.'); 		fm.driving_age.focus(); 	return; }
			//if(fm.com_emp_yn.value == '')				{ alert('보험사항-임직원운전한정특약 가입여부를 입력하십시오.');	fm.com_emp_yn.focus(); 		return; }
			if(fm.gcp_kd.value == '')				{ alert('보험사항-대물배상 가입금액을 입력하십시오.'); 		fm.gcp_kd.focus(); 		return; }
			if(fm.bacdt_kd.value == '')				{ alert('보험사항-자기신체사고 가입금액을 입력하십시오.'); 	fm.bacdt_kd.focus(); 		return; }
			if(fm.canoisr_yn.value == '')				{ alert('보험사항-무보험차상해 가입여부를 입력하십시오.'); 	fm.canoisr_yn.focus(); 		return; }
			if(fm.cacdt_yn.value == '')				{ alert('보험사항-자기차량손해 가입여부를 입력하십시오.'); 	fm.cacdt_yn.focus(); 		return; }
			if(fm.eme_yn.value == '')				{ alert('보험사항-긴급출동 가입여부를 입력하십시오.'); 		fm.eme_yn.focus(); 		return; }
							
			<%if(!base.getCar_mng_id().equals("") && !ins.getCar_mng_id().equals("")){%>
			if(fm.driving_age.value=='1' && fm.age_scp.value!='1'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';}
			if(fm.driving_age.value=='3' && fm.age_scp.value!='4'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
			if(fm.driving_age.value=='0' && fm.age_scp.value!='2'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
			if(fm.driving_age.value=='2' && fm.age_scp.value!='3'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}
			if(fm.driving_age.value=='5' && fm.age_scp.value!='5'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
			if(fm.driving_age.value=='6' && fm.age_scp.value!='6'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
			if(fm.driving_age.value=='7' && fm.age_scp.value!='7'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}			
			if(fm.driving_age.value=='8' && fm.age_scp.value!='8'){		alert('보험 연령범위가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk1.value =	'보험 연령범위가 현재 가입과 약정이 틀립니다.';		}												
				
			if(fm.gcp_kd.value=='3' && fm.vins_gcp_kd.value!='6'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}
			if(fm.gcp_kd.value=='2' && fm.vins_gcp_kd.value!='3'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}				
			if(fm.gcp_kd.value=='1' && fm.vins_gcp_kd.value!='4'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}
			if(fm.gcp_kd.value=='4' && fm.vins_gcp_kd.value!='7'){		alert('보험 대물보상이 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk2.value =	'보험 대물보상이 현재 가입과 약정이 틀립니다.';		}				
				
			if(fm.bacdt_kd.value=='2' && fm.vins_bacdt_kd.value!='6'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
			if(fm.bacdt_kd.value=='1' && fm.vins_bacdt_kd.value!='5'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
			if(fm.bacdt_kd.value=='9' && fm.vins_bacdt_kd.value!='9'){	alert('보험 자기신체사고가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk3.value =	'보험 자기신체사고가 현재 가입과 약정이 틀립니다.';	}
				
			if(fm.con_f_nm.value=='1' && fm.insur_per.value!='1'){		alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk4.value =	'보험 피보험자가 현재 가입과 약정이 틀립니다.';		}
			if(fm.con_f_nm.value=='2' && fm.insur_per.value!='2'){		alert('보험 피보험자가 현재 가입과 약정이 틀립니다.확인하십시오.');		fm.ins_chk4.value =	'보험 피보험자가 현재 가입과 약정이 틀립니다.';		}
			<%}%>		
					
			var car_ja 	= toInt(parseDigit(fm.car_ja.value));
			if(car_ja == 0)							{ alert('보험사항-자차면책금을 입력하십시오.'); 			fm.car_ja.focus(); 			return; }
			<%if(car.getCar_origin().equals("2")){//수입차%>
			if(fm.car_ja.value != fm.imm_amt.value){
				if(fm.ja_reason.value == '')		{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')		{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); fm.rea_appr_id.focus(); 	return; }
			}
			<%}else{%>
			if(fm.car_ja.value != '300,000' && fm.car_ja.value != '200,000'<%if(base.getCar_st().equals("3")){%> && fm.car_ja.value != '100,000'<%}%>){
				if(fm.ja_reason.value == '')		{ alert('보험사항-자차면책금 변경사유를 입력하십시오.'); 	fm.ja_reason.focus(); 		return; }
				if(fm.rea_appr_id.value == '')		{ alert('보험사항-자차면책금 변경 결재자를 입력하십시오.'); fm.rea_appr_id.focus(); 	return; }
			}			
			<%}%>			
		
		}else if(idx == 12 || idx == 99){
		
			if(fm.con_mon.value == '')				{ alert('대여요금-이용기간을 입력하십시오.'); 				fm.con_mon.focus(); 		return; }
											
			<%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계") || String.valueOf(begin.get("CLS_ST")).equals("차종변경")){%>
			<%}else{%>
			
			var fee_amt 	= toInt(parseDigit(fm.fee_amt.value));
			var inv_amt 	= toInt(parseDigit(fm.inv_amt.value));		
			var agree_dist 	= toInt(parseDigit(fm.agree_dist.value));
			var over_run_amt= toInt(parseDigit(fm.over_run_amt.value));		
		
			if(inv_amt == 0)	{ alert('대여요금-정상대여료를 입력하십시오.'); 	fm.inv_amt.focus(); 		return; }
			if(fee_amt == 0)	{ alert('대여요금-월대여료를 확인하십시오.'); 		fm.inv_amt.focus(); 		return; }
			if(agree_dist == 0)	{ alert('대여요금-약정운행거리를 입력하십시오.'); 	fm.agree_dist.focus(); 		return; }
			if(over_run_amt == 0)	{ alert('대여요금-초과운행부담금을 입력하십시오.'); 	fm.over_run_amt.focus(); 	return; }
		
			if(toInt(parseDigit(fm.f_rent_tot_amt.value)) == '0')	{ alert('대여요금-최초결제금액을 입력하십시오.'); 		fm.f_rent_tot_amt.focus(); 	return; }			
		
							
			if(fm.fee_pay_tm.value == '')			{ alert('대여요금-납입횟수를 입력하십시오.'); 				fm.fee_pay_tm.focus(); 		return; }
			if(fm.fee_sh.value == '')			{ alert('대여요금-수금구분를 입력하십시오.'); 				fm.fee_sh.focus(); 			return; }
			if(fm.fee_pay_st.value == '')			{ alert('대여요금-납부방법을 입력하십시오.'); 				fm.fee_pay_st.focus(); 		return; }
			if(fm.fee_pay_st.value != '1' && fm.cms_not_cau.value == ''){ alert('납부방법이 자동이체가 아닌 경우 CMS미실행사유를 입력하십시오.'); fm.cms_not_cau.focus(); return; }
			if(fm.def_st.value == '')			{ alert('대여요금-거치여부를 입력하십시오.'); 				fm.def_st.focus(); 			return; }
			if(fm.def_st.value == 'Y'){
				if(fm.def_remark.value == '')		{ alert('대여요금-거치사유를 입력하십시오.');				fm.def_remark.focus();		return; }
				if(fm.def_sac_id.value == '')		{ alert('대여요금-거치 결재자를 입력하십시오.');			fm.def_sac_id.focus();		return; }
			}

				
			//대차인 경우
			if('<%=fee_size%>' == '1' && '<%=base.getRent_st()%>' == '3'){	
				if(fm.grt_suc_l_cd.value == '')	{ alert('대차의 원계약을 입력하십시오.'); 	return;}
			}		
			<%}%>
			
		}else if(idx == 13 || idx == 99){
		
			if(fm.tax_type[1].checked == true && '<%=site.getEnp_no()%>' == ''){ fm.tax_type[0].checked = true; }
			if(fm.car_st.value != '2'){		
				if(fm.rec_st.value == '')				{ alert('세금계산서-청구서수령방법을 입력하십시오.');		fm.rec_st.focus(); 			return; }
				if(fm.rec_st.value == '1'){
					if(fm.ele_tax_st.value == '')		{alert('세금계산서-전자세금계산서 시스템을 입력하십시오.'); fm.ele_tax_st.focus();		return; }
					if(fm.ele_tax_st.value == '2'){
						if(fm.tax_extra.value == '')	{ alert('세금계산서-전자세금계산서 별도시스템 이름을 입력하십시오.'); fm.tax_extra.focus(); 	return; }
					}
				}
			}			
																
		}
		
		fm.idx.value = idx;
		
		if(confirm('수정하시겠습니까?')){	
			fm.action='lc_b_u_rm_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}							
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
	
	function getSecondhandCarDist(rent_dt, serv_dt, tot_dist){
		var fm = document.form1;
		rent_dt = fm.sh_day_bas_dt.value;
		serv_dt = fm.sh_km_bas_dt.value;
		tot_dist = fm.sh_tot_km.value;
		var height = 300;
		window.open("search_todaydist.jsp?car_mng_id=<%=base.getCar_mng_id()%>&rent_dt="+rent_dt+"&serv_dt="+serv_dt+"&tot_dist="+tot_dist, "VIEW_DIST", "left=0, top=0, width=650, height="+height+", scrollbars=yes");
	}
	

	function search_cms(idx){
		var fm = document.form1;
		if(fm.client_id.value == ""){ alert("고객을 먼저 선택하십시오."); return;}	
		window.open("search_cms.jsp?idx="+idx+"&client_id="+fm.client_id.value, "CMS", "left=100, top=100, height=500, width=800, scrollbars=yes, status=yes");		
	}				
	
	//전산팀 계약삭제하기
	function rent_delete(){
		var fm = document.form1;
		fm.idx.value = 'delete';
		
		if(confirm('삭제하시겠습니까?')){	
		if(confirm('정말 삭제하시겠습니까?')){
		if(confirm('삭제하면 복구할수 없습니다.\n\n정말 진짜로 삭제하시겠습니까?')){		
		if(confirm('계약관련 모든 데이타를 삭제하게 됩니다. \n\n삭제하시겠습니까?')){				
			fm.action='lc_b_u_a.jsp';		
//			fm.target='i_no';
			fm.target='d_content';
			fm.submit();
		}}}}
	}
	
	//변경이력관리항목 수정
	function item_cng_update(st){
		if(st == 'car_st' || st == 'rent_way' || st == 'mng_br_id' || st == 'bus_id2' || st == 'mng_id' || st == 'bus_st' || st == 'est_area'){
			window.open("/fms2/lc_rent/cng_item.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=650, status=yes, scrollbars=yes");
		}else{
			//window.open("/fms2/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st, "CHANGE_ITEM", "left=100, top=100, width=1050, height=500, status=yes, scrollbars=yes");
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
	
	
	//거래치 기존스캔 동기화
	function scan_sys(){
		var fm = document.form1;
		fm.idx.value = 'scan_sys';		
		if(confirm('스캔파일 동기화하시겠습니까?')){	
			fm.action='lc_b_u_rm_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}	
	}									
		
		
	//전자문서 전송하기
	function go_edoc(link_table, link_type, link_rent_st, link_im_seq){
		var fm = document.form1;	
		fm.link_table.value 	= link_table;
		fm.link_type.value 	= link_type;
		fm.link_rent_st.value 	= link_rent_st;	
		fm.link_im_seq.value 	= link_im_seq;			
		window.open('about:blank', "EDOC_LINK", "left=0, top=0, width=900, height=500, scrollbars=yes, status=yes, resizable=yes");				
		fm.target = "EDOC_LINK";
		fm.action = "reg_edoc_link.jsp";
		fm.submit();		
	}			
	
	//마감보기
	function view_sale_cost_lw_add(){
		window.open("/fms2/mis/view_sale_cost_cont_lw_add.jsp?rent_mng_id=<%=base.getRent_mng_id()%>&rent_l_cd=<%=base.getRent_l_cd()%>&add_rent_st=s", "VIEW_SALE_COST_LW_ADD", "left=0, top=0, width=850, height=<%=s_height%>, scrollbars=yes");
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
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>    
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
  <input type='hidden' name='rent_way' 			value='<%=max_fee.getRent_way()%>'>
    
  <input type='hidden' name="fee_size"			value="<%=fee_size%>">    
  <input type='hidden' name="est_from"			value="lc_b_u">
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
  <input type='hidden' name="v_o_1"			value="">
  <input type='hidden' name="v_o_2"			value="">
  <input type='hidden' name="v_o_3"			value="">
  <input type='hidden' name="car_cng_yn"		value="<%=cont_etc.getCar_cng_yn()%>">
  <input type='hidden' name="link_table"		value="">  
  <input type='hidden' name="link_type"			value="">  
  <input type='hidden' name="link_rent_st"		value=""> 
  <input type='hidden' name="link_im_seq"		value="">   
     
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
        <td colspan='2'>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>월렌트 미결계약</span></span></td>
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
                    <td>&nbsp;<%String cont_rent_st = base.getRent_st();%><%if(cont_rent_st.equals("1")){%>신규<%}else if(cont_rent_st.equals("3")){%>대차<%}else if(cont_rent_st.equals("4")){%>증차<%}%></td>
                    <td class=title>영업구분</td>
                    <td>&nbsp;<%String bus_st = base.getBus_st();%><%if(bus_st.equals("1")){%>인터넷<%}else if(bus_st.equals("2")){%>영업사원<%}else if(bus_st.equals("3")){%>업체소개<%}else if(bus_st.equals("4")){%>catalog<%}else if(bus_st.equals("5")){%>전화상담<%}else if(bus_st.equals("6")){%>기존업체<%}else if(bus_st.equals("7")){%>에이젼트<%}else if(bus_st.equals("8")){%>모바일<%}%>
        	    </td>
                </tr>
                <tr> 
                    <td class=title>차량구분</td>
                    <td>&nbsp;<%String car_gu = base.getCar_gu();%><%if(car_gu.equals("0")){%>재리스<%}else if(car_gu.equals("1")){%>신차<%}else if(car_gu.equals("2")){%>중고차<%}else if(car_gu.equals("3")){%>월렌트<%}%></td>
                    <td class=title>용도구분</td>
                    <td>&nbsp;                   
                    <%String car_st = base.getCar_st();%><%if(car_st.equals("1")){%>렌트<%}else if(car_st.equals("3")){%>리스<%}else if(car_st.equals("2")){%>예비<%}else if(car_st.equals("4")){%>월렌트<%}else if(car_st.equals("5")){%>업무대여<%}%>
                    <input type='hidden' name="car_st"		value="<%=base.getCar_st()%>">      
                    </td>
                    <td class=title>관리구분</td>
                    <td>&nbsp;<%String rent_way = max_fee.getRent_way();%><%if(rent_way.equals("1")){%>일반식<%}else if(rent_way.equals("3")){%>기본식<%}else if(rent_way.equals("2")){%>맞춤식<%}%></td>
                </tr>
                <tr> 
                    <td class=title>최초영업자</td>
                    <td>&nbsp;
        			  <select name="bus_id">
        			    <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}%>
        		  		<option value="">=퇴사자=</option>
                 		 <%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        							Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                  		<option value='<%=user2.get("USER_ID")%>' <%if(base.getBus_id().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
                  		<%		}
        					}%>				
                    </select></td>
                    <td class=title>영업담당자</td>
                    <td>&nbsp;
			<%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("본사관리팀장",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			  <select name="bus_id2">
        			    <option value="">선택</option>
                        <%	if(user_size > 0){
        						for(int i = 0 ; i < user_size ; i++){
        							Hashtable user = (Hashtable)users.elementAt(i); %>
                        <option value='<%=user.get("USER_ID")%>' <%if(base.getBus_id2().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%		}
        					}		%>
        		  		<option value="">=퇴사자=</option>
                  		<%	if(user_size2 > 0){
        						for (int i = 0 ; i < user_size2 ; i++){
        						Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                  		<option value='<%=user2.get("USER_ID")%>' <%if(base.getBus_id2().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
                  		<%		}
        					}%>				
                      </select>						
					  <%}else{%>
						<%=c_db.getNameById(base.getBus_id2(),"USER")%>
						<input type='hidden' name='bus_id2' 		value='<%=base.getBus_id2()%>'>
					  <%}%>
					</td>   
                    <td class=title>차량인도일</td>
                    <td>&nbsp;
        			  <input type="text" name="car_deli_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'></td>
					                 					
                </tr>
                <tr>
                    <td class=title>차량이용지역</td>
                    <td colspan='5'>&nbsp;
                    	<%=cont_etc.getEst_area()%>&nbsp;<%=cont_etc.getCounty()%>
                        <input type='hidden' name="est_area" value="<%=cont_etc.getEst_area()%>">
			<input type='hidden' name='county' value='<%=cont_etc.getCounty()%>'>
			<%if(base.getUse_yn().equals("")){%>
			<a href="javascript:item_cng_update('est_area')"><img src=/acar/images/center/button_in_modify.gif align=absmiddle border=0></a>
			<%}%>
					</td>
                </tr>									
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('0')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
	<tr>
	    <td class=h></td>
	</tr>					
    <%if(String.valueOf(begin.get("CLS_ST")).equals("계약승계")){
    		if(cont_etc.getRent_suc_dt().equals("")) cont_etc.setRent_suc_dt(base.getReg_dt());
			ExtScdBean suc2 = ae_db.getAGrtScd(rent_mng_id, rent_l_cd, "1", "5", "1");//기존 등록 여부 조회
			//원게약자 승계수수료 부담
			if(cont_etc.getRent_suc_commi_pay_st().equals("1")){
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
                    <td colspan='3'>&nbsp;
    			    <input type="text" name="rent_suc_dt" value="<%=AddUtil.ChangeDate2(cont_etc.getRent_suc_dt())%>" size="11" maxlength='11' class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
    		</tr>	    
		<tr>			
					</td>	
                    <td class=title width=13%>계약승계수수료</td>
                    <td colspan='3'>&nbsp;
        			  <input type='text' size='11' name='rent_suc_commi' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getRent_suc_commi())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  &nbsp;&nbsp;&nbsp;
					  <% 	if(suc2 == null || suc2.getRent_l_cd().equals("")){%> 
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='0' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;					  
					  <% 		if(AddUtil.parseInt(cont_etc.getRent_suc_dt()) >= 20100520){%> 	
					  <br>&nbsp;
						(스케줄 없음 -> 
					    <input type="checkbox" name="suc_tax_req" value="Y"> 계산서 발행
						입금예정일 : <input type='text' name='suc_commi_est_dt' size='11' class='text' onBlur='javascript: this.value = ChangeDate(this.value);'>
						<a href="javascript:make_suc_schedule();"><img src=/acar/images/center/button_sch_cre.gif  align=absmiddle border="0"></a> )
					  <%		}%>
					  <%	}else{%>
					  공급가 : <input type='text' size='8' name='suc_commi_s_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_s_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원
					  부가세 : <input type='text' size='8' name='suc_commi_v_amt' maxlength='10' class='num' value='<%=AddUtil.parseDecimal(suc2.getExt_v_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원					  
					  &nbsp;&nbsp;&nbsp;
					  <%	}%>				   				   
				   &nbsp;&nbsp;&nbsp;
				   * 정상승계수수료 : <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt())*0.7/100)%>원	  
				   (신차소비자가 <%=AddUtil.parseDecimal((car.getCar_cs_amt()+car.getOpt_cs_amt()+car.getClr_cs_amt()+car.getCar_cv_amt()+car.getOpt_cv_amt()+car.getClr_cv_amt()-car.getTax_dc_s_amt()-car.getTax_dc_v_amt()))%>원의 0.7%)

					  
					  </td>
                    
                </tr>
				<tr>
                    <td class=title width=13%>비용부담자</td>
                    <td colspan='3'>&nbsp;
    			    	<select name='rent_suc_commi_pay_st'>
                           <option value="">선택</option>
                           <option value="1" <%if(cont_etc.getRent_suc_commi_pay_st().equals("1")){%>selected<%}%>>원계약자</option>
                           <option value="2" <%if(cont_etc.getRent_suc_commi_pay_st().equals("2")){%>selected<%}%>>계약승계자</option>
                        </select>
						
					</td>					
				</tr>
				<tr>
                    <td class=title width=13%>보증금</td>
                    <td width=50%>&nbsp;
    			    	원계약보증금
						<input type='text' size='11' name='suc_grt_suc_o_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						, 승계보증금
						<input type='text' size='11' name='suc_grt_suc_r_amt' maxlength='12' class='num' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>원						
						
					</td>					
					<td class=title width=10%>보증금승계여부</td>
					<td>&nbsp;
						<select name='rent_suc_grt_yn'>
                           <option value="">선택</option>
                           <option value="0" <%if(cont_etc.getRent_suc_grt_yn().equals("0")){%>selected<%}%>>승계</option>
                           <option value="1" <%if(cont_etc.getRent_suc_grt_yn().equals("1")){%>selected<%}%>>별도</option>
                        </select>
					</td>					
				</tr>				
            </table>
	    </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('suc_commi')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>
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
                      <%if(client.getClient_id().equals("000228") || nm_db.getWorkAuthUser("전산팀",user_id)){//%>
        		<span class="b"><a href='javascript:search_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
        	      <%}%>
        	      <span class="b"><a href='javascript:view_client()' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_see.gif align=absmiddle border=0></a></span>					  
        	    </td>
                    <td width='10%' class='title'>대표자</td>
                    <td align='left'>&nbsp;
                    <input type='text' name="client_nm" value='<%=client.getClient_nm()%>' size='22' class='whitetext' readonly></td>
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
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <tr>
                    <td class='title'>우편물주소</td>
                    <td align='left'>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=base.getP_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="40" value="<%=base.getP_addr()%>">
                    </td>
                    <td class='title'>우편물수취인</td>
                    <td class='left'>&nbsp;
                    <input type='text' name="tax_agnt" value='<%=base.getTax_agnt()%>' size="22" class='text' onBlur='javascript:CheckLen(this.value,50)'></td>
                </tr>		  
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width="3%" rowspan="<%=mgr_size+2%>" class=title>관<br>계<br>자</td>
                    <td class=title width="10%">구분</td>
                    <td class=title width="10%">성명</td>			
                    <td class=title width="12%">생년월일</td>
                    <td class=title width="15%">주소</td>
                    <td class=title width="10%">전화번호</td>
                    <td class=title width="10%">휴대폰</td>
                    <td width="10%" class=title>운전면허번호</td>
                    <td width="15%" class=title>기타</td>
                    <td width="5%" class=title>조회</td>
                </tr>
    		  <%String mgr_zip = "";
    			String mgr_addr = "";
    		  	for(int i = 0 ; i < mgr_size ; i++){
    				CarMgrBean mgr = (CarMgrBean)car_mgrs.elementAt(i);%>
                <tr>                 <input type='hidden' name='mgr_id' value='<%=mgr.getMgr_id()%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='<%=mgr.getMgr_st()%>' class='white' readonly ></td>
                    
                    <td align='center'><input type='text' name='mgr_nm'   size='13' value='<%=mgr.getMgr_nm()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' maxlength='8' value='<%=mgr.getSsn()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' value='<%=mgr.getMgr_addr()%>' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' value='<%=mgr.getMgr_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' value='<%=mgr.getMgr_m_tel()%>' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' value='<%=mgr.getLic_no()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' value='<%=mgr.getEtc()%>' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>
    		  <%	} %>
                <tr>                 <input type='hidden' name='mgr_id'  value='<%=mgr_size%>'> 
                    <td align='center'><input type='text' name='mgr_st'    size='10' value='' class='text'></td>
                    <td align='center'><input type='text' name='mgr_nm'   size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_ssn'  size='15' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_addr'  size='20' class='text' onBlur='javascript:CheckLen(this.value,15)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_tel'    size='13' class='text' onBlur='javascript:CheckLen(this.value,20)' style='IME-MODE: active'></td>
                    <td align='center'><input type='text' name='mgr_m_tel' size='13' class='text' onBlur='javascript:CheckLen(this.value,10)'></td>
                    <td align='center'><input type='text' name='mgr_lic_no'   size='13' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><input type='text' name='mgr_etc' size='20' class='text' onBlur='javascript:CheckLen(this.value,15)'></td>
                    <td align='center'><span class="b"><a href='javascript:search_mgr(<%=mgr_size%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                </tr>		  		  
                <tr id=tr_mgr_addr style='display:none'> 
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
                    <td colspan="8">&nbsp;<% zip_cnt++;%>
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=mgr_zip%>">
						<input type="button" onclick="openDaumPostcode1()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="60" value="<%=mgr_addr%>">
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr></tr><tr></tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>차량사용용도</td>                    
                    <td>&nbsp;
                      <input type='text' name="rm_car_use" value='<%=f_fee_rm.getCar_use()%>' size='50' class='text'></td>
                </tr>  
            </table>
        </td>
    </tr>        
	<tr>
	    <td align="right"><a href="javascript:update('1')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대표 연대보증</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>
    <tr id=tr_client_guar_st style="display:<%if(client.getClient_st().equals("1")){%>''<%}else{%>none<%}%>"'> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width='13%' class='title'>보증여부</td>
                    <td colspan="3" align='left'>&nbsp;
                      <input type='radio' name="client_guar_st" value='1'  <%if(cont_etc.getClient_guar_st().equals("1"))%>checked<%%>>
        				입보
        			  <input type='radio' name="client_guar_st" value='2'  <%if(cont_etc.getClient_guar_st().equals("2"))%>checked<%%>>
        				면제</td>
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
        					<% zip_cnt++;%>
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=gur.get("GUR_ID")%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value='<%=gur.get("GUR_NM")%>'></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" maxlength='8' class='text' value='<%=gur.get("GUR_SSN")%>'></td>
                                <script>
									function openDaumPostcode2() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip2').value = data.zonecode;
												document.getElementById('t_addr2').value = data.address;
												
											}
										}).open();
									}
								</script>
								<td align="center">
									<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=gur.get("GUR_ZIP")%>">
									<input type="button" onclick="openDaumPostcode2()" value="우편번호 찾기"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr2" size="25" value="<%=gur.get("GUR_ADDR")%>">
									</td>
                                <td align="center"><input type="text" name="gur_tel" size="13" class='text' value='<%=gur.get("GUR_TEL")%>'></td>
                                <td align="center"><input type="text" name="gur_rel" size="18" class='text' value='<%=gur.get("GUR_REL")%>'></td>
                                <td align="center"><span class="b"><a href='javascript:search_gur(<%=i%>)' onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span> </td>
                            </tr>
                      <%}%>
                      <%for(int i=gur_size; i<3; i++){%>
                      <% zip_cnt++;%>
                            <tr>
                                <td class=title>연대보증인<input type='hidden' name='gur_id' value='<%=i+1%>'></td>
                                <td align="center"><input type="text" name="gur_nm" size='10' class='text' value=''></td>
                                <td align="center"><input type="text" name="gur_ssn" size="15" class='text' value=''></td>
								<script>
									function openDaumPostcode3() {
										new daum.Postcode({
											oncomplete: function(data) {
												document.getElementById('t_zip3').value = data.zonecode;
												document.getElementById('t_addr3').value = data.address;
												
											}
										}).open();
									}
								</script>
                                <td align="center">
									<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="">
									<input type="button" onclick="openDaumPostcode3()" value="우편번호 찾기"><br>
									&nbsp;<input type="text" name="t_addr" id="t_addr3" size="25" value="">
								</td>
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
	    <td align="right"><a href="javascript:update('2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	
	<tr>
	    <td class=h></td>
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
                <tr>
                    <td width='13%' class='title'>자동차회사</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id(),"CAR_COM")%></td>
                    <td class='title' width="10%">차명</td>
                    <td width="20%">&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                    <td class='title' width='10%'>차종</td>
                    <td>&nbsp;<a href="javascript:view_car_nm('<%=cm_bean.getCar_id()%>', '<%=cm_bean.getCar_seq()%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><%=cm_bean.getCar_name()%></a></td>
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
        			      <a href="javascript:open_car_b('<%=cm_bean2.getCar_id()%>','<%=cm_bean2.getCar_seq()%>','<%=cm_bean2.getCar_name()%>')" title="<%=cm_bean2.getCar_b()%>"><font color='#999999'><%=cm_bean2.getCar_name()%>외&nbsp;</font></a>
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
                <tr>
                    <td class='title'>색상</td>
                    <td colspan="5">&nbsp;                        
        			  <%=car.getColo()%>
					  &nbsp;&nbsp;&nbsp;
					  (내장색상(시트): <%=car.getIn_col()%> )  
					  &nbsp;&nbsp;&nbsp;
					  (가니쉬: <%=car.getGarnish_col()%> )  
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
	<tr>
	    <td align="right"><a href="javascript:update('8')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량가격</span></td>
	</tr>
	<tr>
	    <td class=line2></td>
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
        				  	<input type='text' name='sh_car_amt' value='<%=AddUtil.parseDecimal(sh_car_amt)%>'size='10' class='defaultnum' readonly >
        				  원 </td>
                    <td class='title' width="10%">잔가율</td>
                    <td width="10%">&nbsp;
                      <input type='text' name='sh_ja' value='<%= AddUtil.parseFloatCipher(sh_ja,2) %>'size='4' class='defaultnum' readonly >
					  %</td>
                    <td class='title' width='10%'>
                      중고차가</td>
                  <td width="37%">&nbsp;
                    <input type='text' name='sh_amt' value='<%= AddUtil.parseDecimal(sh_amt) %>'size='10' class='defaultnum'  readonly>
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
                    <input type='text' name='sh_init_reg_dt' size='11' value='<%=AddUtil.ChangeDate2(sh_init_reg_dt)%>' class='default' onBlur='javascript:this.value=ChangeDate(this.value);'>
                    ~계약일
                    <input type='text' name='sh_day_bas_dt' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' >
				  

                  )				  
				  </td>
                </tr>
                <tr>				  
                  <td class='title'>적용주행거리</td>
                  <td colspan="5">&nbsp;
                    <input type='text' name='sh_km' size='6' value='<%= AddUtil.parseDecimal(sh_km) %>' class='defaultnum' >
					  km ( <%if(fee_size==1){%>계약일 <%}else{%> 대여개시일<%}%>
					  <input type='text' name='sh_day_bas_dt2' value='<%=AddUtil.ChangeDate2(sh_day_bas_dt)%><%//= AddUtil.ChangeDate2(base.getRent_dt()) %>'size='11' class='white' > 
					  ) / 확인주행거리 
					  <input type='text' name='sh_tot_km' size='6' value='<%= AddUtil.parseDecimal(sh_tot_km) %>' class='defaultnum' >
					  km ( 최종확인일
					  <input type='text' name='sh_km_bas_dt' size='11' value='<%= AddUtil.ChangeDate2(sh_km_bas_dt) %>' class='default' >
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
   	<!--
	<tr>
	    <td align="right"><a href="javascript:update('9')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	-->
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
						<option value='9' <%if(ins.getAge_scp().equals("9")){%>selected<%}%>>22세이상</option>
						<option value='10' <%if(ins.getAge_scp().equals("10")){%>selected<%}%>>28세이상</option>
						<option value='11' <%if(ins.getAge_scp().equals("11")){%>selected<%}%>>35세이상~49세이하</option>
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
                          <option value="1" <%if(base.getDriving_ext().equals("1")){%> selected <%}%>>모든사람</option>
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
					  <option value='9' <%if(base.getDriving_age().equals("9")){%>selected<%}%>>22세이상</option>					  						  
					  <option value='10' <%if(base.getDriving_age().equals("10")){%>selected<%}%>>28세이상</option>					  						  
					  <option value='11' <%if(base.getDriving_age().equals("11")){%>selected<%}%>>35세이상~49세이하</option>					  						  
                      </select></td>
                <td class=title >임직원운전한정특약</td>
                <td class=''>&nbsp;
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
                          <option value="2" <% if(base.getGcp_kd().equals("2")) out.print("selected"); %>>1억원</option>
						  <option value="4" <% if(base.getGcp_kd().equals("4")) out.print("selected"); %>>2억원</option>
						  <option value="8" <% if(base.getGcp_kd().equals("8")) out.print("selected"); %>>3억원</option>
                          <option value="3" <% if(base.getGcp_kd().equals("3")) out.print("selected"); %>>5억원</option>						  
                      </select></td>
                    <td width="10%" class=title >자기신체사고</td>
                    <td class=''>&nbsp;
                        <select name='bacdt_kd'>
                          <option value="">선택</option>
                          <option value="1" <% if(base.getBacdt_kd().equals("1")) out.print("selected"); %>>5천만원</option>
                          <option value="2" <% if(base.getBacdt_kd().equals("2")) out.print("selected"); %>>1억원</option>
                          <option value="9" <% if(base.getBacdt_kd().equals("9")) out.print("selected"); %>>미가입</option>
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
                        <option value="Y" <%if(f_fee_rm.getMy_accid_yn().equals("Y"))%>selected<%%>>고객부담</option>
                        <option value="N" <%if(f_fee_rm.getMy_accid_yn().equals("N"))%>selected<%%>>면제</option>
                      </select>
                  </td>
              </tr>                              
            </table>
        </td>
    </tr>
	<tr>
	    <td align="right"><a href="javascript:update('10')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	</tr>	    	
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
                <td width="13%"  class=title>배차시간</td>
    <%
	if(f_fee_rm.getDeli_plan_dt().length() == 12){
		plan_dt = f_fee_rm.getDeli_plan_dt().substring(0,8);
		plan_h 	= f_fee_rm.getDeli_plan_dt().substring(8,10);
		plan_m	= f_fee_rm.getDeli_plan_dt().substring(10,12);
	}
    %>                
                <td width="37%">&nbsp;<input type='text' size='11' name='deli_plan_dt' maxlength='11' class='default' value='<%=AddUtil.ChangeDate2(plan_dt)%>' onBlur='javscript:this.value = ChangeDate(this.value);'>
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
                <td width="37%">&nbsp;<input type='text' size='30' name='deli_loc' class='default' value='<%=f_fee_rm.getDeli_loc()%>'  onBlur="javscript:set_loc(this.value, 'deli');">
                      </td>
                <td width="13%" class=title>반차장소</td>
                <td width="37%">&nbsp;<input type='text' size='30' name='ret_loc' class='default' value='<%=f_fee_rm.getRet_loc()%>'  onBlur="javscript:set_loc(this.value, 'ret');">
                      </td>
              </tr>          
            </table>
        </td>
    </tr>
    <tr>
        <td>* 배/반차 장소 번호 자동입력 : 1 - 영남주차장, 2 - 대전지점 주차장, 3 - 부산지점 주차장, 4 - 광주지점 주차장, 5 - 대구지점 주차장 </td>
    </tr>          	    
	<tr>
	    <td align="right"><a href="javascript:update('16')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금</span></td>
    </tr>
	<%	for(int f=1; f<=fee_size; f++){
			ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));
			
			//월렌트정보
			ContFeeRmBean fee_rm = a_db.getContFeeRm(rent_mng_id, rent_l_cd, Integer.toString(f));
			
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
                        <input type='text' name="ext_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)'>
            			 개월
            		<%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 
            		<input type='text' name="ext_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitetext' onChange='javascript:set_cont_date(this)'>
            			 일
            		<%}else{%>
            		<input type='hidden' name="ext_con_day" value="<%=fee_etcs.getCon_day()%>">      
            		<%}%>
            	    </td>
                    <td width="10%" align="center" class=title>대여개시일</td>
                    <td width="20%">&nbsp;
                      <input type="text" name="ext_rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date(this);'></td>
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
                    <td colspan='2' class='title'>보증금</td>
                    <td align='center'>-</td>
                    <td align='center'>-</td>
                    <td align='center'><input type='text' size='10' maxlength='10' name='ext_grt_s_amt' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>' onBlur="javascript:set_fee_amt(this, <%=fees.getRent_dt()%>)" onKeyDown='javascript:enter_fee(this, <%=fees.getRent_dt()%>)'>
        				  원</td>
                    <td align='center'><%=a_db.getPpPaySt(rent_mng_id, rent_l_cd, fees.getRent_st(), "0")%></td>
                    <td align="center">차가의
                        <input type='text' size='4' name='ext_gur_p_per' class='whitenum' value='<%=fees.getGur_p_per()%>' readonly>
        				  % </td>
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
        			  <input type='hidden' name='ext_grt_amt' value='<%=AddUtil.parseDecimal(fees.getGrt_amt_s())%>'><!--차가 <font color="#FF0000">렌트
        			    <input type='text' size='3' name='gur_per' class='whitenum' value='' readonly>%</font> 이상-->
						</td>
                </tr>    
              <tr>
                <td width="3%" rowspan="5" class='title'>월<br>
                  대<br>여<br>료</td>
                <td width="10%" class='title'>정상대여료</td>
                 <td align="center"><input type='text' size='11' name='ext_inv_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_inv_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_inv_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getInv_s_amt()+fees.getInv_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>

                <td align="center">-</td>
                <td align='center'>-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>D/C</td>
                <td align="center">-<input type='text' size='10' name='ext_dc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center">-<input type='text' size='10' name='ext_dc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-<input type='text' size='10' name='ext_dc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getDc_s_amt()+fee_rm.getDc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
    		<td align='center'>-</td>		  
                <td align="center">DC율:
                  <input type='text' size='4' name='ext_dc_ra' maxlength='10' class="whitenum" value='<%=fee.getDc_ra()%>'>
                </font>%</span></td>
                <td align='center'>-</td>
              </tr>              
              <tr>
                <td class='title'>내비게이션</td>
                <td align="center"><input type='text' size='11' name='ext_navi_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_navi_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_navi_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getNavi_s_amt()+fee_rm.getNavi_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                 
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>기타</td>
                <td align="center"><input type='text' size='11' name='ext_etc_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_etc_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_etc_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getEtc_s_amt()+fee_rm.getEtc_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                    <input type='text' size='40' name='ext_etc_cont' class='text' value='<%=fee_rm.getEtc_cont()%>'>
    				  </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='ext_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fees.getFee_s_amt()+fees.getFee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">-</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>대여료총액</td>
                <td align="center"><input type='text' size='11' name='ext_t_fee_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_t_fee_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_t_fee_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getT_fee_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"><input type='text' name="ext_v_con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 개월
        		<%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 		 
        	    <input type='text' name="ext_v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='whitenum' onChange='javascript:set_cont_date(this)'>
        			 일
        		<%}else{%>	
        		<input type='hidden' name="ext_v_con_day" value="<%=fee_etcs.getCon_day()%>">       
        		<%}%>
        			 </td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>배차료</td>
                <td align="center"><input type='text' size='11' name='ext_cons1_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_cons1_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_cons1_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons1_s_amt()+fee_rm.getCons1_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  
    	 	</td>
                <td align='center'>
    			  
                </td>
              </tr>
              <tr>
                <td colspan="2" class='title'>반차료</td>
                <td align="center"><input type='text' size='11' name='ext_cons2_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_cons2_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_cons2_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getCons2_s_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center">
                  
    	 	</td>
                <td align='center'>-</td>
              </tr>
              <tr>
                <td colspan="2" class='title'>합계</td>
                <td align="center"><input type='text' size='11' name='ext_rent_tot_s_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align="center"><input type='text' size='11' name='ext_rent_tot_v_amt' maxlength='10' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'><input type='text' size='11' name='ext_rent_tot_amt' maxlength='11' class='whitenum' value='<%=AddUtil.parseDecimal(fee_rm.getT_fee_s_amt()+fee_rm.getCons1_s_amt()+fee_rm.getCons2_s_amt()+fee_rm.getT_fee_v_amt()+fee_rm.getCons1_v_amt()+fee_rm.getCons2_v_amt())%>' onBlur="javascript:set_fee_amt(this)" onKeyDown='javascript:enter_fee(this)'>
    				  원</td>
                <td align='center'>-</td>
                <td align="center"> </td>
                <td align='center'>-</td>
              </tr>              
              <tr id=tr_emp_bus style="display:''">
                <td rowspan="<%if(rent_st.equals("3")){%>4<%}else{%>3<%}%>" class='title'>기<br>타</td>                             
                <td class='title'><span class="title1">최초결제금액</span></td>
                <td align='center'><input type="text" name="ext_f_rent_tot_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_rent_tot_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원		  
                </td>                
                <td colspan='4'>&nbsp;&nbsp;&nbsp;
                     * 최초결제방식 : <select name="ext_f_paid_way" onchange="javascript:f_paid_way_display();" disabled>
                        <option value="">==선택==</option>			  
                        <option value="1" <%if(fee_rm.getF_paid_way().equals("1")){%>selected<%}%>>1개월치</option>
                        <option value="2" <%if(fee_rm.getF_paid_way().equals("2")){%>selected<%}%>>총액</option>
                      </select>
                      &nbsp; 반차료
                      <select name="ext_f_paid_way2" onchange="javascript:f_paid_way_display();" disabled>
                        <option value="">==선택==</option>
                        <option value="1" <%if(fee_rm.getF_paid_way2().equals("1")){%>selected<%}%>>포함</option>
                        <option value="2" <%if(fee_rm.getF_paid_way2().equals("3")){%>selected<%}%>>미포함</option>
                      </select>          
                      &nbsp;&nbsp;&nbsp;
                      * 예약금 : <input type="text" name="ext_f_con_amt" value="<%=AddUtil.parseDecimal(fee_rm.getF_con_amt())%>" size="11" class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원	
                  
                </td>                
                <td align='center'>-</td>
              </tr>  
              <tr>
                <td class='title'><span class="title1">약정운행거리</span></td>
                <td colspan="5">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='ext_agree_dist' size='8' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getAgree_dist())%>'>
                  km이하/1개월,
                  초과시 1km당 (<input type='text' name='ext_over_run_amt' size='3' maxlength='20' class='whitenum' value='<%=AddUtil.parseDecimal(fee_etcs.getOver_run_amt())%>' onBlur='javascript:this.value=parseDecimal(this.value);'>
                  원)의 추가요금이 부과됩니다.
                </td>
                <td align='center'>-</td>
              </tr>                                   
              <tr>
                <td class='title'>중도해지위약율</td>
                <td colspan="4" align="center">실이용기간이 1개월 이상일 경우</td>                
                <td align="center">잔여기간 대여료의
                    <input type='text' size='3' name='ext_cls_r_per' maxlength='10'  class='whitenum' value='<%=fee.getCls_r_per()%>'>
    				  %</td>
                <td align='center'><font color="#FF0000">
    				<input type='text' size='3' name='ext_cls_per' maxlength='10' class='whitenum' value='<%=fee.getCls_per()%>'>%					
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
					  &nbsp;계약번호 : <input type='text' name='ext_grt_suc_l_cd' size='15' value='<%=cont_etc.getGrt_suc_l_cd()%>' class='whitetext' >
					  &nbsp;차량번호 : <input type='text' name='ext_grt_suc_c_no' size='15' value='<%=cont_etc.getGrt_suc_c_no()%>' class='whitetext' >
					  &nbsp;차종코드별변수 차명 : <%=suc_cont.get("CARS")==null?"":suc_cont.get("CARS")%>
					  &nbsp;
					  <br>
					  &nbsp;
					  <b>[대차보증금승계]</b>
					  &nbsp;기존보증금 : <input type='text' name='ext_grt_suc_o_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_o_amt())%>' class='whitenum' >원
					  &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					  승계보증금 : <input type='text' name='ext_grt_suc_r_amt' size='10' value='<%=AddUtil.parseDecimal(cont_etc.getGrt_suc_r_amt())%>' class='defaultnum' >원
					  <input type='hidden' name='ext_grt_suc_m_id' value='<%=cont_etc.getGrt_suc_m_id()%>'>
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>		
        			</td>
              </tr>	
              <%}%>
              <tr>
                <td colspan="2" class='title'>비고</td>
                <td colspan="6">&nbsp;
                  <textarea rows='5' cols='90' name='ext_fee_cdt' disabled><%=fees.getFee_cdt()%></textarea></td>
              </tr>			
            </table>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="13%" class='title'>납입횟수</td>
                    <td width="20%">&nbsp;
                      <input type='text' size='3' name='ext_fee_pay_tm' value='<%=fees.getFee_pay_tm()%>' maxlength='2' class='text' >
        				회 </td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="20%">&nbsp;매월
                      <select name='ext_fee_est_day'>
                        <option value="">선택</option>
                        <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                        <option value='<%=i%>' <%if(fees.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                        <% } %>
                        <option value='99' <%if(fees.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
						<option value='98' <%if(fees.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                      </select></td>
                    <td width="10%" class='title'>납입기간</td>
                    <td>&nbsp;
                      <input type='text' name='ext_fee_pay_start_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_start_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'>
        				~
        			  <input type='text' name='ext_fee_pay_end_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fees.getFee_pay_end_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
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
					  <%if(nm_db.getWorkAuthUser("임원",user_id) || nm_db.getWorkAuthUser("전산팀",user_id)){%>
        			  <input type="text" name="ext_rent_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_dt())%>" size="11" maxlength='10' class=text onBlur='javascript:this.value=ChangeDate(this.value);'>
					  <%}else{%>
					  <%=AddUtil.ChangeDate2(fees.getRent_dt())%>
					  <input type='hidden' name='ext_rent_dt' 	value='<%=fees.getRent_dt()%>'>
					  <%}%>				
				  
				</td>
                <td width="10%" align="center" class=title>계약담당자</td>
                <td >&nbsp;                  
                  <select name='ext_agnt'>
                    <option value="">선택</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
    		  <option value="">=퇴사자=</option>
              <%if(user_size2 > 0){
    				for (int i = 0 ; i < user_size2 ; i++){
    					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
              <option value='<%=user2.get("USER_ID")%>' <%if(fees.getExt_agnt().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
              <%	}
    			}%>												
                  </select>                  
                </td>
                <td width="10%" align="center" class=title>영업대리인</td>
                <td >&nbsp;                  
                  <select name='ext_bus_agnt_id'>
                    <option value="">선택</option>
                    <%if(user_size > 0){
    					for(int i = 0 ; i < user_size ; i++){
    						Hashtable user = (Hashtable)users.elementAt(i); %>
                    <option value='<%=user.get("USER_ID")%>' <%if(fee_etc.getBus_agnt_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                    <%	}
    				}		%>
    		  <option value="">=퇴사자=</option>
              <%if(user_size2 > 0){
    				for (int i = 0 ; i < user_size2 ; i++){
    					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
              <option value='<%=user2.get("USER_ID")%>' <%if(fee_etc.getBus_agnt_id().equals(String.valueOf(user2.get("USER_ID")))){%>selected<%}%>><%=user2.get("USER_NM")%></option>
              <%	}
    			}%>																
                  </select>                 
                </td>
              </tr>				
              <tr>
                <td width="13%" align="center" class=title>이용기간</td>
                <td width="20%">&nbsp;
                    <input type='text' name="con_mon" value='<%=fees.getCon_mon()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 개월
        	    <%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>	 		 
        	    <input type='text' name="con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='text' onChange='javascript:set_cont_date(this)'>
        			 일	
        	    <%}else{%>		 	 
        	    <input type='hidden' name="con_day" value="<%=fee_etcs.getCon_day()%>">      
        	    <%}%>
        	</td>
                <td width="10%" align="center" class=title>대여개시일</td>
                <td width="20%">&nbsp;
                  <input type="text" name="rent_start_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_start_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value); set_cont_date(this);'></td>
                <td width="10%" align="center" class=title>대여만료일</td>
                <td>&nbsp;
                  <input type="text" name="rent_end_dt" value="<%=AddUtil.ChangeDate2(fees.getRent_end_dt())%>" size="11" maxlength='10' class=whitetext onBlur='javascript:this.value=ChangeDate(this.value);'></td>
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
                    <td class='title' width='11%'>공급가</td>
                    <td class='title' width='11%'>부가세</td>
                    <td class='title' width='13%'>합계</td>
                    <td class='title' width='4%'>입금</td>
                    <td class='title' width="28%">계약조건</td>
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
                <td align='center'>-
                  
                  &nbsp;<%=fee_rm.getEst_id()%>
                  
                </td>
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
        			 <%if(!fee_etcs.getCon_day().equals("") && !fee_etcs.getCon_day().equals("0")){%>
        	    <input type='text' name="v_con_day" value='<%=fee_etcs.getCon_day()%>' size="4" maxlength="2" class='fixnum' onChange='javascript:set_cont_date(this)'>
        			 일
        			 <%}else{%>
        			 <input type='hidden' name="v_con_day" value="<%=fee_etcs.getCon_day()%>">      
        			 <%}%>
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
					  <%if(cont_etc.getGrt_suc_r_amt()>0 && fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt()>0){ %>
					  				<font color=red>(약정보증금 차액 <%=AddUtil.parseDecimal(fees.getGrt_amt_s()-cont_etc.getGrt_suc_r_amt())%>)</font>
					  			<%} %>		
        			</td>
              </tr>	
              <%}%>
              <tr>
                <td colspan="2" class='title'>비고</td>
                <td colspan="6">&nbsp;
                  <textarea rows='5' cols='90' class=default name='fee_cdt'><%=fees.getFee_cdt()%></textarea></td>
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
	<%		}%>
	<%	}%>
	
		
	
	<tr>
	    <td align="right"><a href="javascript:update('12')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
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
                        <option value='6' <%if(fee.getFee_pay_st().equals("6")){%> selected <%}%>>카드</option>
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
                    <td class='title'>자동이체<% zip_cnt++;%>
                        <br><span class="b"><a href="javascript:search_cms('<%=zip_cnt%>')" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_in_search.gif align=absmiddle border=0></a></span>
                    </td>
                    <td colspan="5"><table width="100%" border="0" cellpadding="0">
        			  <tr>
        			    <td>&nbsp;
						  계좌번호 : 
        			      <input type='text' name='cms_acc_no' value='<%=cms.getCms_acc_no()%>' size='20' class='text'>
        			      (
        			      <input type='hidden' name="cms_bank" value="<%=cms.getCms_bank()%>">
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
						function openDaumPostcode4() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip4').value = data.zonecode;
									document.getElementById('t_addr4').value = data.address;
									
								}
							}).open();
						}
					</script>
    				  &nbsp;&nbsp;예금주 주소 : 
						<input type="text" name="t_zip"  id="t_zip4" size="7" maxlength='7' value="<%=cms.getCms_dep_post()%>">
						<input type="button" onclick="openDaumPostcode4()" value="우편번호 찾기"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr4" size="65" value="<%=cms.getCms_dep_addr()%>">
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
        			     <tr>
        			    <td>&nbsp;
					  최초인출일자 :
    			      <input type='text' name='cms_start_dt' size='11' class='text' value="<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)'>

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
	<tr>
	    <td align="right"><a href="javascript:update('12_2')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
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
			  		if(AddUtil.parseInt(String.valueOf(tax_print_car.get("TOT_CNT")))>1 && client.getPrint_car_st().equals("") && !client.getPrint_st().equals("1") &&
					      ( cm_bean.getS_st().equals("100") || cm_bean.getS_st().equals("101") || cm_bean.getS_st().equals("409") 
						    || cm_bean.getS_st().equals("601") || cm_bean.getS_st().equals("602") 
							|| cm_bean.getS_st().equals("700") || cm_bean.getS_st().equals("701") || cm_bean.getS_st().equals("702") 
							|| cm_bean.getS_st().equals("801") || cm_bean.getS_st().equals("802") 
							|| cm_bean.getS_st().equals("803") || cm_bean.getS_st().equals("811") || cm_bean.getS_st().equals("812") ) 
					   ){//'100','101','601','602','701','702','801','802','803','811','812'
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
	<tr>
	    <td align="right"><a href="javascript:update('13')"><img src=/acar/images/center/button_modify.gif align=absmiddle border=0></a></td>
	<tr>	
	
	<%	int scan_num = 0;
		String scan_mm = "";
		int scan_cnt = 0;%>
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
                  <td width="5%" class=title></td>
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
		<%	for(int f=1; f<=fee_size; f++){
					ContFeeBean fees = a_db.getContFeeNew(rent_mng_id, rent_l_cd, Integer.toString(f));
					ContCarBean fee_etcs = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, Integer.toString(f));%>	


        	<!-- 자동차대여이용계약서 웹페이지 -->
        	
        	
        	<%if(AddUtil.parseInt(fees.getRent_dt()) > 20130701 && f==1 && !base.getReg_step().equals("")){%>
        	<%	scan_num++;%>        	
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp</td>		  
                  <td align="center">자동차대여이용계약서</td>                  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>
                      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                      <%}else{%>
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		      <%}%>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%}%>
        	
        	<%if(AddUtil.parseInt(fees.getRent_dt()) > 20130701 && f>1 && !base.getReg_step().equals("")){%>
        	<%	scan_num++;%>
                <tr>
                  <td align="center"><%=scan_num%></td>
                  <td align="center">&nbsp</td>		  
                  <td align="center">자동차대여이용계약서(연장)</td>                  
                  <td align="center">
                      <%if(AddUtil.parseInt(base.getRent_dt()) > 20140228){%>
                      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
                      <%}else{%>
		      <a href='/fms2/lc_rent/rmcar_doc.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&rent_st=<%=f%>' target="_blank"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a>
		      <%}%>
		  </td>
                  <td align="center"></td>
                  <td align="center"></td>		  
                </tr>	        	
        	<%}%>

        	
		<!--최초계약서(pdf)-->			
                <% 	scan_num++; 
                	file_rent_st = Integer.toString(f);
                	file_st = "1";                
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"><%if(f==1 && AddUtil.parseInt(cont_etc.getRent_suc_dt())==0 ){%><% scan_cnt++;%><font color=red>불충</font><%}%></td>
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
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                	file_rent_st = Integer.toString(f);
                	file_st = "18";                
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
                		
													
		<%			}%>
				
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
			<%	//20140801부터 필수
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
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>      
                <%		}
                	}else{%>                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center"><input type="checkbox" name="ch_l_cd" value="<%=content_seq%>"></td>
                    <td align="center">CMS동의서tif/jpg</td>
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      

                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">          
                
                                       		
                       		
        		<tr>
	    			<td class=line2 colspan="6"></td>
				</tr>
				
		<%	if(!client.getClient_st().equals("2")){%>
		
		<!--사업자등록증jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "2";                
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
                		
       		<%	}%>
        		
       		<%	if(scan_chk.equals("Y") && client.getClient_st().equals("1")){%>
       		
		<!--법인등기부등본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "3";                
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
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">      
                
		<!--법인인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "6";                
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
                    <td align="center"></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">                         		
       		
       		<%	}%>
        		
       		<%	if(client.getClient_st().equals("1") && cont_etc.getClient_guar_st().equals("2")){%>
       		<%	}else{%>
       		<%		if(scan_chk.equals("Y")){%>
       		
		<!--<%=scan_mm%>신분증jpg-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "4";                
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
                    <td align="center"><% scan_cnt++;%><font color=red>불충</font></td>
                    <td align="center"></td>
                </tr>      
                <%	}%>
                <input type='hidden' name="h_file_st" value="<%=file_st%>">     
                
		<!--<%=scan_mm%>인감증명서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "8";                
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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

		<!--사업자등록증/신분증-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "11";                
                	content_seq  = rent_mng_id+""+rent_l_cd+""+file_rent_st+""+file_st;
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
                	attach_vt_size = attach_vt.size();
                	
                	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
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
                    <td align="center"><a href="javascript:scan_reg('<%=file_st%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
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
                
                	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
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
		
		
		<%	}%>	
		

		<!--통장사본-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "9";                
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
                 
		<%if(cont_etc.getInsur_per().equals("2")){%>
		
		<!--보험가입특약서-->			
                <% 	scan_num++; 
                	file_rent_st = "1";
                	file_st = "19";                
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
 					
 					if(file_st.equals("1")||file_st.equals("2")||file_st.equals("3")||file_st.equals("4")||file_st.equals("5")||file_st.equals("6")||file_st.equals("7")||file_st.equals("8")||file_st.equals("9")||file_st.equals("10")||file_st.equals("11")||file_st.equals("12")||file_st.equals("13")||file_st.equals("14")||file_st.equals("15")||file_st.equals("17")||file_st.equals("18")||file_st.equals("19")||file_st.equals("20")||file_st.equals("36")||file_st.equals("37")) continue;
 					
 					scan_num++;                             	
                %>
                
                <tr>
                    <td align="center"><%=scan_num%></td>
                    <td align="center">&nbsp;</td>
                    <td align="center">
                        <%if(file_st.equals("16")){%>과태료첨부서류<%}%>
			<%if(file_st.equals("21")){%>보험계약사항변경요청서<%}%>					
			<%if(file_st.equals("22")){%>대여료계약사항변경요청서<%}%>
			<%if(file_st.equals("23")){%>면세물품반출신고서<%}%>                    
			<%if(file_st.equals("24")){%>수입신고필증<%}%>
			<%if(file_st.equals("31")){%>주운전자운전면허증<%}%>
			<%if(file_st.equals("32")){%>추가운전자운전면허증<%}%>
			<%if(file_st.equals("33")){%>배차차량인도증<%}%>
			<%if(file_st.equals("34")){%>반차차량인수증<%}%>
			<%if(file_st.equals("35")){%>견적서<%}%>
                    </td>
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
                
                	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
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
		  <span class="b"><a href="javascript:scan_sys()" onMouseOver="window.status=''; return true" title="클릭하세요">[동기화]</a> (동일 거래처 타계약 스캔파일과 동기화)</span>		  
	</td>
    </tr>    
	<!--
    <tr> 
      <td colspan="2" align="right"><a href="javascript:scan_reg('')">스캔 추가 등록</a></td>
    </tr>	
	-->
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
    <tr>
	    <td align='center'>	   
		 
	    <%String sanction_date = base.getSanction_date();
	  	if(sanction_date.length() > 0) sanction_date = sanction_date.substring(0,8);%>
		

	    <%if(user_id.equals("000000") || base.getBus_id().equals(user_id) || base.getBus_id2().equals(user_id) || base.getReg_id().equals(user_id) || nm_db.getWorkAuthUser("관리자모드",user_id)){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:update(99);" title='전체 수정하기'><img src=/acar/images/center/button_all_modify.gif align=absmiddle border=0></a>
	    <%}%>
		
	    <%if(nm_db.getWorkAuthUser("계약삭제",user_id)){%>
		<%	if(base.getUse_yn().equals("") || base.getRent_start_dt().equals("")){%>
	    &nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:rent_delete();" title='계약 삭제하기'>
	    <img src=/acar/images/center/button_delete.gif align=absmiddle border=0>
	    </a>
	    <%	}%>
	    <%}%>		
		
		
	    &nbsp;&nbsp;&nbsp;&nbsp;<font color="#999999">( 수정권한 : 결재권한이 있는 사람 OR 최초영업자 OR 등록자 )</font>
	    </td>
	</tr>
	<tr>
	    <td></td>
	</tr>	
	
    <tr>
        <td align='right'>
        
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사월렌트담당",user_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("1"))){ %>	  
	    <a href="lc_reg_step2_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_2step.gif align=absmiddle border=0></a>&nbsp; 	    	    
          <%}%>	
          
	  <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사월렌트담당",user_id) || (base.getBus_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("3")) || (base.getReg_id().equals(user_id) && base.getUse_yn().equals("") && fee_size == 1 && base.getReg_step().equals("2"))){%>	  
            <a href="lc_reg_step4_rm.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_4step.gif align=absmiddle border=0></a>&nbsp; 	 
          <%}%>	
          
          <%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("본사월렌트담당",user_id)){%>            
            <a href="lc_c_frame.jsp<%=valus_t%>" target='d_content'><img src=/acar/images/center/button_gy.gif align=absmiddle border=0></a>	  	   
          <%}%>	
	
	<tr>
	    <td>&nbsp;</td>
    </tr>			
    		
	  
	    </td>
    </tr>
</table>
  <input type='hidden' name="zip_cnt" 			value="<%=zip_cnt%>">
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
 	var fm = document.form1;
	
	
	//바로가기
	var s_fm 	= parent.top_menu.document.form1;
	s_fm.auth_rw.value 	= fm.auth_rw.value;
	s_fm.user_id.value 	= fm.user_id.value;
	s_fm.br_id.value 	= fm.br_id.value;		
	s_fm.m_id.value 	= fm.rent_mng_id.value;
	s_fm.l_cd.value 	= fm.rent_l_cd.value;	
	s_fm.c_id.value 	= fm.car_mng_id.value;
	s_fm.client_id.value 	= fm.client_id.value;
	s_fm.accid_id.value 	= "";
	s_fm.serv_id.value 	= "";
	s_fm.seq_no.value 	= "";
	
	
//-->
</script>
</body>
</html>
