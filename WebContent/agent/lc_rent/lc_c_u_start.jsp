<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*,acar.common.*"%>
<%@ page import="acar.cont.*,acar.client.*, acar.car_mst.*, acar.estimate_mng.*, acar.car_register.*, acar.car_office.*, acar.user_mng.*, acar.doc_settle.*, acar.con_ins.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<jsp:useBean id="cr_bean" class="acar.car_register.CarRegBean" scope="page"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="ai_db"     class="acar.con_ins.AddInsurDatabase"      scope="page"/>
<jsp:useBean id="ins"       class="acar.con_ins.InsurBean"             scope="page"/>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<jsp:useBean id="ScdMngDb" scope="page" class="tax.ScdMngDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>

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
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String rent_st	 	= request.getParameter("rent_st")==null?"1":request.getParameter("rent_st");
	String cng_item  	= request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();
	
	//계약기본정보
	ContBaseBean base = a_db.getCont(rent_mng_id, rent_l_cd);
			
	//계약기타정보
	ContEtcBean cont_etc = a_db.getContEtc(rent_mng_id, rent_l_cd);
	
	//차량기본정보
	ContCarBean car 	= a_db.getContCarNew(rent_mng_id, rent_l_cd);
	
	//출고정보
	ContPurBean pur = a_db.getContPur(rent_mng_id, rent_l_cd);	
	
	//자동차기본정보
	CarMstBean cm_bean = cmb.getCarNmCase(String.valueOf(car.getCar_id()), String.valueOf(car.getCar_seq()));
		
	//차량등록정보
	if(!base.getCar_mng_id().equals("")){
		cr_bean = crd.getCarRegBean(base.getCar_mng_id());
	}
	
	if(!base.getCar_mng_id().equals("")){
		//보험정보
		String ins_st = ai_db.getInsSt(base.getCar_mng_id());
		ins = ai_db.getIns(base.getCar_mng_id(), ins_st);
	}	
	
	//신차대여정보
	ContFeeBean fee = a_db.getContFeeNew(rent_mng_id, rent_l_cd, "1");
	
	if(fee.getPp_s_amt()==0 && !fee.getPp_chk().equals(""))  fee.setPp_chk("");
	
				
	//차량기본정보
	ContCarBean fee_etc = a_db.getContFeeEtc(rent_mng_id, rent_l_cd, "1");
		
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(base.getClient_id());
			
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(rent_mng_id, rent_l_cd)+"";
	}
			
	//출고지연대차
	ContTaechaBean taecha = a_db.getTaecha(rent_mng_id, rent_l_cd, taecha_no);
	
	//출고지연대차 리스트
	Vector ta_vt = a_db.getTaechaList(rent_mng_id, rent_l_cd);
	int ta_vt_size = ta_vt.size();		
	
	//차량인도일 - 탁송 대여차량인도 탁송일자 가져옴.
        if(cont_etc.getCar_deli_dt().equals("")){
        	cont_etc.setCar_deli_dt(cs_db.getContCarDeliDt(rent_mng_id, rent_l_cd));
        }	

	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&andor="+andor+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+
					"&rent_mng_id="+rent_mng_id+"&rent_l_cd="+rent_l_cd+"&from_page="+from_page;
					
	String cyc_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20111130 || AddUtil.parseInt(fee.getRent_dt()) > 20111130){
		cyc_yn_chk = "N";
	}	
	
	String ac_dae_yn_chk = "Y";
	
	if(AddUtil.parseInt(base.getRent_dt()) > 20090531 || AddUtil.parseInt(fee.getRent_dt()) > 20090531){
		ac_dae_yn_chk = "N";
	}			
	
	String car_ins_chk = "N";
	
	if(!ins.getCar_mng_id().equals("")){
		car_ins_chk = "Y";
	}
	
	int car_ret_chk = 0;
			
	//재리스일때 예약시스템 반차종료 확인
	if(base.getCar_gu().equals("0")){
		car_ret_chk = rs_db.getCarRetChk(base.getCar_mng_id());
	}
			
	//예약시스템 지연대차 미반차건 확인 : 계약미연동분
	Vector rs_conts = rs_db.getTarchaNoRegSearchList(base.getClient_id());
	int rs_cont_size = rs_conts.size();
	
	//예약시스템 지연대차 미반차건 확인 : 계약연동분
	Vector rs_conts2 = rs_db.getTarchaNoRetSearchList(base.getRent_l_cd());
	int rs_cont_size2 = rs_conts2.size();
	
	//예약시스템 지연대차 미반차건 확인 : 계약번호연동 출고전대차 미등록분
	Vector rs_conts3 = rs_db.getTarchaNoRegSearchList2(base.getRent_l_cd());
	int rs_cont_size3 = rs_conts3.size();		
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	
	String content_code = "LC_RENT";
	String content_seq  = "";
	String scan17 = "";
	String scan18 = "";


	Vector attach_vt = new Vector();
	int attach_vt_size = 0;	

	Vector attach_vt2 = new Vector();
	int attach_vt_size2 = 0;	
	
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"17";

	attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size = attach_vt.size();	
		
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
    			Hashtable ht = (Hashtable)attach_vt.elementAt(j);   
    			scan17 = String.valueOf(ht.get("FILE_NAME"));
    	}
    }		
	content_code = "LC_SCAN";
	content_seq  = rent_mng_id+""+rent_l_cd+"1"+"18";

	attach_vt2 = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	attach_vt_size2 = attach_vt2.size();	
		
	if(attach_vt_size2 > 0){
		for (int j = 0 ; j < attach_vt_size2 ; j++){
    			Hashtable ht = (Hashtable)attach_vt2.elementAt(j);   
    			scan18 = String.valueOf(ht.get("FILE_NAME"));
    		}
    	}	
    	
    //발행작업스케줄
	Vector fee_scd = ScdMngDb.getFeeScdClient(base.getClient_id());
	int fee_scd_size = fee_scd.size();		
	
	if(fee_scd_size > 10) fee_scd_size = 10;    	
		
	String com_dir_pur_doc_yn = "";
	String com_dir_pur_doc_reg_yn = "";
	String com_dir_pur_doc_no = "";
	if(base.getCar_gu().equals("1") && AddUtil.parseInt(base.getRent_dt()) >= 20190610 && client.getClient_st().equals("1") && cm_bean.getCar_comp_id().equals("0001") && pur.getDir_pur_yn().equals("Y") && !pur.getPur_bus_st().equals("4")){ //법인고객 현대특판출고 에이전트영업 제외
		com_dir_pur_doc_yn = "Y";
		//문서품의
		DocSettleBean doc17 = d_db.getDocSettleCommi("17", rent_l_cd);
		com_dir_pur_doc_no = doc17.getDoc_no();
		if(doc17.getDoc_no().equals("")){
			com_dir_pur_doc_reg_yn = "N";
		}
	}	
	
	//선납금 입금상태
	String pp_pay_st = a_db.getPpPaySt(rent_mng_id, rent_l_cd, "1", "1");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//새로고침
	function reload(){
		var fm = document.form1;			
		fm.action='lc_c_u_start.jsp';
		fm.target='d_content';
		fm.submit();
	}
		
	//대여기간 셋팅
	function set_cont_date(){
		var fm = document.form1;
	
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') return;
			
		fm.action='get_fee_nodisplay.jsp';
		fm.target='i_no';
		fm.submit();
	}
	
	function cng_input(idx){
		var fm = document.form1;		
		if(idx == 1){
			tr_fee_type1.style.display	= '';
			tr_fee_type2.style.display	= 'none';
			tr_fee_type3.style.display	= 'none';
			fm.end_chk.value		= 'N';
		}else if(idx == 2){
			tr_fee_type1.style.display	= 'none';
			tr_fee_type2.style.display	= '';
			tr_fee_type3.style.display	= 'none';
			fm.end_chk.value		= 'N';
		}else if(idx == 3){
			tr_fee_type1.style.display	= 'none';
			tr_fee_type2.style.display	= 'none';
			tr_fee_type3.style.display	= '';
			fm.end_chk.value		= 'Y';
		}
		
		//set_start_date(2);
	}	
		
	//스케줄생성 기간 셋팅
	function set_start_date(idx){
		var fm = document.form1;
	
		if((fm.con_mon.value == '') || (fm.rent_start_dt.value == '') || (fm.rent_end_dt.value == ''))
			return;

		if(ChangeDate4_chk(fm.rent_start_dt, fm.rent_start_dt.value)=='') 	return;
		if(ChangeDate4_chk(fm.rent_end_dt, fm.rent_end_dt.value)=='') 		return;		
		//if(fm.reg_type[1].checked == true && fm.fee_est_day3.value == '')	return;
		
		if(idx == 1)	fm.fee_fst_dt3.value = '';
		
		fm.end_chk.value		= 'N';
								
		fm.action='get_fee_start_nodisplay.jsp';
		fm.target='i_no';
		//fm.target='_blank';
		fm.submit();
	}	
	
	//수정화면
	function update2(st, rent_st){
		var height = 600;
		window.open("/agent/lc_rent/lc_c_u.jsp<%=valus%>&cng_item="+st+"&rent_st="+rent_st, "CHANGE_ITEM2", "left=150, top=150, width=1050, height="+height+", scrollbars=yes");
	}	
	
	//수정
	function update(){
		var fm = document.form1;
		
		var cng_item = fm.cng_item.value;

		<%if(fee.getPp_s_amt() > 0 && fee.getPp_chk().equals("0") && !pp_pay_st.equals("입금")){%>
			alert('선납금균등발행이면 선납금이 완납되어야 합니다.');	return; 
		<%}%>		
		
		<%	if(com_dir_pur_doc_yn.equals("Y") && com_dir_pur_doc_reg_yn.equals("N")){%>
			alert('법인고객 자동차 영업직원 활동 보고서를 먼저 등록하십시오.'); 	return; 
		<%  } %>
		
				
		//jpg 계약서 앞(scan17)/뒤(scan18) 스캐닝 영부 체크 - 미등록시 대여개시못함 - 스캐닝은 차량번호,  대여개시일자 필히 입력하여 스캐닝할 것 
		<% if(scan17.equals("")  || scan18.equals("")  ){ %>
			alert('차량번호와 대여개시일을 추가하여 계약서 앞/뒤를 JPG로 스캔등록 후 대여개시를 처리할 수 있습니다.\n\n확인하십시오.'); 	return; 
		<%} %>
		
		<%if(base.getCar_mng_id().equals("")){%>	
		  	alert('현재 차량이 등록되지 않았습니다. 차량등록 후 개시할 수 있습니다.'); 	
		  	return; 			
		<%}%>
				
		//보험가입등록 체크
		<%if(car_ins_chk.equals("N")){%>
			alert('보험가입등록이 안되어있습니다. 보험담당자에게 확인하십시오.');	return; 
		<%}%>
		
		
		if(toInt(fm.car_ret_chk.value) > 0)		{ alert('예약시스템에 반차 미처리분이 있습니다. 먼저 반차처리후에 대여개시 하십시오.'); return; }
		
		if(<%=rs_cont_size%> > 0){
			if(!confirm('예약시스템-지연대차에 반차 미처리분이 있습니다(장기계약 미연동분). 하단 지연대차 미반차 리스트에서 출고전대차 수정할 수 있습니다. 대여개시 진행하시겠습니까?')){	return;	}
		}		

		if(<%=rs_cont_size2%> > 0){
			alert('예약시스템-지연대차에 반차 미처리분이 있습니다(장기계약 연동분). 먼저 반차처리후에 대여개시 하십시오.'); return;
		}		
		
		if(<%=rs_cont_size3%> > 0){
			alert('예약시스템-지연대차에 계약번호 연동은 되었으나 계약관리-출고지연대차는 미입력되었습니다. 먼저 출고지연대차를 입력하십시오.'); return;
		}	
		
		
		
		if(fm.con_mon.value == '')			{ alert('대여개시-이용기간을 입력하십시오.'); 				fm.con_mon.focus(); 		return; }
		if(fm.rent_start_dt.value == '')		{ alert('대여개시-대여개시일을 입력하십시오.'); 			fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value == '')			{ alert('대여개시-대여만료일을 입력하십시오.'); 			fm.rent_end_dt.focus(); 	return; }				
			
		//여기
		<%if(base.getRent_st().equals("3") && base.getCar_mng_id().equals(taecha.getCar_mng_id())){%>
		//[입력값 체크]1.대여개시일 현재보다 4개월이상 차이가 나면 안된다.---만기매칭대차일때!
		var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
		if( est_day > 5 ||est_day < -5){ 
			alert('입력하신 대여개시일이 현재날짜와 4개월이상 차이납니다.\n\n확인하십시오.'); 				fm.rent_start_dt.focus(); 	return; 
		}
		<%}else{%>			
		//[입력값 체크]1.대여개시일 현재보다 한달이상 차이가 나면 안된다.
		var est_day = getRentTime('m', fm.rent_start_dt.value, '<%=AddUtil.getDate()%>');				
		if( est_day > 1 || est_day < -1){ 
			alert('입력하신 대여개시일이 현재날짜와 한달이상 차이납니다.\n\n확인하십시오.'); 				fm.rent_start_dt.focus(); 	return; 
		}
		<%}%>
								
		<%if(!fee.getFee_chk().equals("1") && !fee.getPp_chk().equals("0") ){%>
		
			if(fm.reg_type[0].checked == false && fm.reg_type[1].checked == false){	alert('대여료스케줄 구분을 선택하십시오.');	return;}
			
			/*
			if(fm.reg_type[0].checked == true){

				if(fm.fee_est_day1.value == '')		{ alert('1대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_pay_start_dt1.value == '')	{ alert('2대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_pay_end_dt1.value == '')	{ alert('3대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_fst_dt1.value == '')		{ alert('4대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_fst_amt1.value == '')		{ alert('5대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_lst_dt1.value == '')		{ alert('6대여료스케줄 구분을 선택하십시오.');		 	return; }
				if(fm.fee_lst_amt1.value == '')		{ alert('7대여료스케줄 구분을 선택하십시오.');		 	return; }
			
				//[입력값 체크]2.첫회차납입일이 대여개시일보다 클수는 없다.
				est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt1.value);
				if( est_day < 0){ 
					alert('입력하신 첫회차납입일이 대여개시일보다 작습니다. \n\n확인하십시오.');			return;
				}									
				
			}else 
			*/
			if(fm.reg_type[0].checked == true){

				ChangeDate4(fm.fee_fst_dt3, fm.fee_fst_dt3.value);
				
				if(fm.fee_est_day2.value == '')		{ alert('1변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_pay_start_dt2.value == '')	{ alert('2변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_pay_end_dt2.value == '')	{ alert('3변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_fst_dt2.value == '')		{ alert('4변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_fst_amt2.value == '')		{ alert('5변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_lst_dt2.value == '')		{ alert('6변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_lst_amt2.value == '')		{ alert('7변경후 월대여료 납입일자를 선택하십시오.'); 			return; }

				if(fm.fee_est_day3.value == '')		{ alert('8변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_pay_start_dt3.value == '')	{ alert('9변경후 월대여료 납입일자를 선택하십시오.'); 			return; }
				if(fm.fee_pay_end_dt3.value == '')	{ alert('10변경후 월대여료 납입일자를 선택하십시오.'); 		return; }
				if(fm.fee_fst_dt3.value == '')		{ alert('11변경후 월대여료 납입일자를 선택하십시오.'); 		return; }
				if(fm.fee_fst_amt3.value == '')		{ alert('12변경후 월대여료 납입일자를 선택하십시오.'); 		return; }
				if(fm.fee_lst_dt3.value == '')		{ alert('13변경후 월대여료 납입일자를 선택하십시오.'); 		return; }
				if(fm.fee_lst_amt3.value == '')		{ alert('14변경후 월대여료 납입일자를 선택하십시오.'); 		return; }
				
				if(toInt(parseDigit(fm.fee_fst_amt3.value)) == 0){ alert('1회차대여료 납입금액을 확인하십시오.'); 		return; }
				
				//[입력값 체크]2.첫회차납입일이 대여개시일보다 클수는 없다.
				est_day = getRentTime('d', fm.rent_start_dt.value, fm.fee_fst_dt3.value);
				if( est_day < 0){ 
					alert('입력하신 첫회차납입일이 대여개시일보다 작습니다. \n\n확인하십시오.');			return;
				}				
				
				//[입력값 체크]3.첫회차납입일이 오늘날짜와 7일이상 차이가 나야 한다.
				est_day = getRentTime('d', '<%=AddUtil.getDate(4)%>', fm.fee_fst_dt3.value);
				
				if( est_day < 7){ 
					alert('입력하신 첫회차납입일이 오늘보다 7일이후여야 합니다. \n\n확인하십시오.');			return;
				}					
			
			}else if(fm.reg_type[1].checked == true){
				if(fm.etc.value == '')			{ alert('업무협조 내용을 입력하십시오.'); 			fm.etc.focus(); 		return; }
			}										
			
			if(fm.end_chk.value == 'N')			{ alert('대여료스케줄 구분 재선택 및 납입일자 재선택이 필요합니다.'); 				return; }
				
		<%}%>
		
			
										
		if(confirm('수정하시겠습니까?')){	
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action='lc_c_u_start_a.jsp';		
			fm.target='i_no';
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
	
	//스캔관리 보기
	function view_scan(){
		window.open("scan_view.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>", "VIEW_SCAN", "left=100, top=10, width=720, height=800, scrollbars=yes");		
	}
	
	//법인고객 자동차 영업직원 활동 보고서 보기
	function reg_doc(doc_no, doc_st){
		window.open("doc_com_dir_pur.jsp?doc_no="+doc_no+"&doc_st="+doc_st+"&rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>", "VIEW_DOC", "left=100, top=0, width=650, height=950, scrollbars=yes");		
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

<form action='lc_c_u_start_a.jsp' name="form1" method='post'>
  <input type='hidden' name="auth_rw" 			value="<%=auth_rw%>">
  <input type='hidden' name="user_id" 			value="<%=user_id%>">
  <input type='hidden' name="br_id"   			value="<%=br_id%>">
  <input type='hidden' name='s_kd'  			value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 			value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name='gubun1' 			value='<%=gubun1%>'>
  <input type='hidden' name='gubun2' 			value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 			value='<%=gubun3%>'>    
  <input type='hidden' name='from_page'	 		value='/agent/lc_rent/lc_c_u_start.jsp'>   
  <input type='hidden' name='cng_item'	 		value='<%=cng_item%>'>     
  <input type='hidden' name="rent_mng_id" 		value="<%=rent_mng_id%>">
  <input type='hidden' name="rent_l_cd" 		value="<%=rent_l_cd%>">
  <input type='hidden' name="rent_way"			value="<%=fee.getRent_way()%>">
  <input type='hidden' name="fee_amt"			value="<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>">
  <input type='hidden' name="fee_s_amt"			value="<%=fee.getFee_s_amt()%>">
  <input type='hidden' name="fee_v_amt"			value="<%=fee.getFee_v_amt()%>">
  <input type='hidden' name="ifee_amt"			value="<%=fee.getIfee_s_amt()+fee.getIfee_v_amt()%>">
  <input type='hidden' name="pere_r_mth"		value="<%=fee.getPere_r_mth()%>">  
  <input type='hidden' name="car_ret_chk"		value="<%=car_ret_chk%>">
  <input type='hidden' name="firm_nm"			value="<%=client.getFirm_nm()%>">
  <input type='hidden' name="end_chk"			value="N">
  
  
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계약관리 > <span class=style5>신차 대여개시 및 스케줄 생성</span></span></td>
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
                    <td class=title width=15%>계약번호</td>
                    <td width=35%>&nbsp;<%=rent_l_cd%></td>
                    <td class=title width=15%>상호</td>
                    <td width=35%>&nbsp;<%=client.getFirm_nm()%></td>
                </tr>
                <tr> 
                    <td class=title>차량번호</td>
                    <td>&nbsp;<%=cr_bean.getCar_no()%></td>
                    <td class=title>차명</td>
                    <td>&nbsp;<%=c_db.getNameById(cm_bean.getCar_comp_id()+cm_bean.getCode(),"CAR_MNG")%></td>
                </tr>
                <tr> 
                    <td class=title>개시대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getIfee_s_amt()+fee.getIfee_v_amt())%>원&nbsp;
                    	<%if(fee.getIfee_s_amt()>0 && fee.getFee_s_amt()>0){%>
                    	(<%=(fee.getIfee_s_amt()+fee.getIfee_v_amt())/(fee.getFee_s_amt()+fee.getFee_v_amt())%>회)
                    	<%}%>
                    </td>
                    <td class=title>선납금</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(fee.getPp_s_amt()+fee.getPp_v_amt())%>원</td>
                </tr>
                <tr> 
                    <td class=title>월대여료납입방식</td>
                    <td>&nbsp;<%if(fee.getFee_chk().equals("0")){%>매월납입<%}else if(fee.getFee_chk().equals("1")){%>일시완납<%}else{%>-<%}%></td>
                    <td class=title>선납금계산서발행구분</td>
                    <td>&nbsp;<%if(fee.getPp_chk().equals("1")){%>납부일시발행<%}else if(fee.getPp_chk().equals("0")){%>매월균등발행<%}else{%>-<%}%></td>
                </tr>
    	    </table>
	</td>
    </tr>  
    <%	if(com_dir_pur_doc_yn.equals("Y")){%>
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>법인고객 자동차 영업직원 활동 보고서</span></td>
	</tr>  	
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>등록여부</td>
                    <td>&nbsp;
	<%		if(com_dir_pur_doc_reg_yn.equals("N")){%>
	        	미등록  &nbsp;<a href ="javascript:reg_doc('','17')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
	<%		}else{ %>	
	                     등록  &nbsp;<a href ="javascript:reg_doc('<%=com_dir_pur_doc_no%>','17')"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>			
	<%		} %>    
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 	        
    <%	}%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>문서스캔</span>
	        &nbsp;<a href ="javascript:view_scan()"><img src=/acar/images/center/button_see_ss.gif align=absmiddle border=0></a>
	    </td>
	</tr>  			
    <tr>
        <td class=line2></td>
    </tr>  
    <tr>
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>		  
                <tr> 
                    <td class=title width=15%>대여개시후계약서(앞)</td>
                    <td width=35%>&nbsp;
                    <%	if(attach_vt_size > 0){
				for (int j = 0 ; j < attach_vt_size ; j++){
 					Hashtable ht = (Hashtable)attach_vt.elementAt(j);     					 					
                    %>                    
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>
        	    </td>
                    <td class=title width=15%>대여개시후계약서(뒤)</td>
                    <td width=35%>&nbsp;
                    <%  if(attach_vt_size2 > 0){
				for (int j = 0 ; j < attach_vt_size2 ; j++){
 					Hashtable ht = (Hashtable)attach_vt2.elementAt(j);     					 					
                    %>
                    <a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                    <%		}%>
        	    <%}%>         
        	    </td>
                </tr>	
    		</table>
	    </td>
	</tr> 	    
<%		if(fee_scd_size>0){%>  
	<tr>
	    <td class=h></td>
	</tr>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=client.getFirm_nm()%> 기존계약 발행예정일 확인</span></td>
	</tr>     
    <tr>
        <td class=line2></td>
    </tR>			
	<tr>
	    <td  class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td class='title'>차량번호</td>
                    <td class='title'>차명</td>					
                    <td class='title'>회차</td>
                    <td colspan="2" class='title'>사용기간</td>
                    <td class='title'>월대여료</td>
                    <td class='title'>발행예정일</td>
                    <td class='title'>세금일자</td>
                    <td class='title'>입금예정일</td>
                </tr>
        <%			for(int j = 0 ; j < fee_scd_size ; j++){
        				Hashtable ht = (Hashtable)fee_scd.elementAt(j);%>
                <tr>
                    <td width="15%" align="center"><%=ht.get("CAR_NO")%></td>
                    <td width="15%" align="center"><%=ht.get("CAR_NM")%></td>					
                    <td width="10%" align="center"><%=ht.get("FEE_TM")%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
                    <td width="10%" align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
                    <td width="10%" align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>원&nbsp;&nbsp;</td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("REQ_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("TAX_OUT_DT")))%></td>
                    <td width="10%" align="center" ><%=AddUtil.ChangeDate2(String.valueOf(ht.get("FEE_EST_DT")))%></td>
                </tr>
<%			}%>
            </table>
	    </td>
    </tr>
<%		}%>     	  
    <tr>
	<td align="right">&nbsp;</td>
    <tr>
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여개시</span></td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <td width="15%" align="center" class=title>대여기간</td>
                    <td width="35%">&nbsp;
                        <input type='text' name="con_mon" value='<%=fee.getCon_mon()%>' size="4" maxlength="2" class='fix' onBlur='javascript:set_cont_date()'>개월
                    </td>
                    <%
                    	
                    %>
                    <td width="15%" class='title'>차량인도일</td>
                    <td width="35%">&nbsp;
                        <input type='text' name='car_deli_dt' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(cont_etc.getCar_deli_dt())%>' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>			
                        &nbsp;(탁송요청일 디폴트)
		    </td>
                </tr>
                <tr>                        
                    <td align="center" class=title>대여개시일</td>
                    <td>&nbsp;
                        <input type="text" name="rent_start_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value); set_cont_date();'>
                    </td>
                    <td align="center" class=title>대여만료일</td>
                    <td>&nbsp;
                        <input type="text" name="rent_end_dt" value="" size="11" maxlength='10' class='text' onBlur='javascript:this.value=ChangeDate4(this, this.value);'>
                    </td>
                </tr>
            </table>
	</td>
    </tr>
 	    	 
    <tr>
	<td>&nbsp;</td>
    </tr>
				  <input type='hidden' name='fee_pay_tm' 		value='<%=fee.getFee_pay_tm()%>'>  
				  <input type='hidden' name='fee_est_day' 		value='<%=fee.getFee_est_day()%>'>  
				  <input type='hidden' name='fee_fst_dt' 		value='<%=fee.getFee_fst_dt()%>'>  
				  <input type='hidden' name='fee_fst_amt' 		value='<%=fee.getFee_fst_amt()%>'>  
				  <input type='hidden' name='fee_pay_start_dt' 		value='<%=fee.getFee_pay_start_dt()%>'>  
				  <input type='hidden' name='fee_pay_end_dt' 		value='<%=fee.getFee_pay_end_dt()%>'>
	<%if(fee.getFee_chk().equals("1") || fee.getPp_chk().equals("0") ){%>
    <tr>
	<td><font color=red>* 월대여료납입방식이 일시완납이거나 선납금 월균등발행건 입니다. 총무팀 스케줄담당자가 별도로 대여료를 생성합니다.</font></td>
    </tr>	    
				  <input type='hidden' name='reg_type' 		value='3'>
    <%}else{%>        
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 스케줄 생성</span></td>
    </tr>    
    <tr>
	<td class=line2></td>
    </tr>
    <tr id=tr_fee style="display:''"> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>
                <tr>
                    <!--<td width="33%" align="center" class=title><input type='radio' name="reg_type" value='1' onClick="javascript:cng_input(1)"> 대여개시일과 납입일자가 정상</td>-->
                    <td width="50%" align="center" class=title><input type='radio' name="reg_type" value='2' onClick="javascript:cng_input(2)"> 납입일자변경(일할계산)</td>
                    <td width="50%" align="center" class=title><input type='radio' name="reg_type" value='3' onClick="javascript:cng_input(3)"> 대여료 선납/분산청구 및 분산납부(다중스케줄)</td>
                </tr>
            </table>
	</td>
    </tr>  
    <tr>
	<td>&nbsp;</td>
    </tr>
    <tr id=tr_fee_type1 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="75%">&nbsp;
                        매월
                        <select name='fee_est_day1'>
                            <option value="">선택</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                        </select>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt1' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt1' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt1' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>                        
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt1' value='' maxlength='10' size='10' class='whitenum'>원
                        <input type='hidden' name='fee_fst_amt1_etc' value=''>   
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt1' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt1' value='' maxlength='10' size='10' class='whitenum'>원
                        <input type='hidden' name='fee_lst_amt1_etc' value=''>   
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>  
    <tr id=tr_fee_type2 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%> 
                <tr>
                    <td colspan='3' class='title'>변경전</td>
                    <td colspan='3' class='title'>변경후</td>
                </tr>                              
                <tr>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="25%">&nbsp;
                        매월
                        <select name='fee_est_day2'>
                            <option value="">선택</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%> selected <%}%>><%=i%>일 </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%> selected <%}%>> 말일 </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%> selected <%}%>> 대여개시일 </option>
                        </select>
                    </td>
                    <td rowspan='2' width="15%" class='title'>월대여료</td>
                    <td width="10%" class='title'>납입일자</td>
                    <td width="25%">&nbsp;
                        매월
                        <select name='fee_est_day3'>
                            <option value="">선택</option>
                            <%	for(int i=1; i<=31 ; i++){ //1~31일 %>
                            <option value='<%=i%>' <%if(fee.getFee_est_day().equals(Integer.toString(i))){%>  <%}%>><%=i%>일 </option>
                            <% } %>
                            <option value='99' <%if(fee.getFee_est_day().equals("99")){%>  <%}%>> 말일 </option>
			    <option value='98' <%if(fee.getFee_est_day().equals("98")){%>  <%}%>> 대여개시일 </option>
                        </select>
                        &nbsp;<a href="javascript:set_start_date('1')" onMouseOver="window.status=''; return true" title="대여료 일자계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt2' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt2' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td class='title'>납입기간</td>
                    <td>&nbsp;
                        <input type='text' name='fee_pay_start_dt3' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_start_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		~
    			<input type='text' name='fee_pay_end_dt3' maxlength='10' size='11' value='<%=AddUtil.ChangeDate2(fee.getFee_pay_end_dt())%>' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt2' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td rowspan='2' class='title'>1회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_dt3' value='' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value); set_start_date(2);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt2' value='' maxlength='10' size='10' class='whitenum'>원
                     </td>
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_fst_amt3' value='' maxlength='10' size='10' class='whitenum'>원
                        <input type='hidden' name='fee_fst_amt3_etc' value=''>  
                     </td>
                </tr>	
                <tr>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt2' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                    <td rowspan='2' class='title'>마지막회차대여료</td>
                    <td class='title'>납입일자</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_dt3' value='' maxlength='10' size='11' class='whitetext' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>		  		  		  		  
                <tr>                
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt2' value='' maxlength='10' size='10' class='whitenum'>원
                    </td>
                    <td class='title'>납입금액</td>
                    <td>&nbsp;
                        <input type='text' name='fee_lst_amt3' value='' maxlength='10' size='10' class='whitenum'>원
                        <input type='hidden' name='fee_lst_amt3_etc' value=''>  
                    </td>
                </tr>	                                	  		  		  		  
            </table>
	</td>
    </tr>            
    <tr id=tr_fee_type3 style='display:none'> 
        <td class='line'> 
            <table border="0" cellspacing="1" cellpadding='0' width=100%>                   
                <tr>
                    <td colspan='2' class='title'>업무협조(총무팀) 메시지 발송</td>                    
                </tr>		  		  		  		                                    	  		  		  		  
                <tr>
                    <td width="15%" class='title'>내용</td>                    
                    <td>&nbsp;
                        <textarea rows='5' cols='90' name='etc'></textarea>                        
                    </td>                    
                </tr>		  		  		  		                                    	  		  		  		  
            </table>
	</td>
    </tr>      
    <%}%>
    
    
    <tr>
	<td>&nbsp;</td>
    </tr>    	
    
    <%		if(com_dir_pur_doc_yn.equals("Y") && com_dir_pur_doc_reg_yn.equals("N")){%>
    <tr>
	<td><font color=red>* 법인고객 자동차 영업직원 활동 보고서를 먼저 등록하십시오.</font></td>
    </tr>	    
    <% 		}%>
    
    <%		if(fee.getPp_s_amt() > 0 && fee.getPp_chk().equals("0") && !pp_pay_st.equals("입금")){%>
    <tr>
	<td><font color=red>* 선납금균등발행이면 선납금이 완납되어야 합니다.</font></td>
    </tr>	        
    <%		}%>    
        
    <% 		if(scan17.equals("")  || scan18.equals("")  ){ %>
    <tr>
	<td><font color=red>* 차량번호와 대여개시일을 추가하여 계약서 앞/뒤를 JPG로 스캔등록 후 대여개시를 처리할 수 있습니다.</font></td>
    </tr>	    
    <% 		}%>
    
    <% 		if(base.getCar_mng_id().equals("")){ %>
    <tr>
	<td><font color=red>* 현재 차량이 등록되지 않았습니다. 차량등록 후 개시할 수 있습니다.</font></td>
    </tr>	    
    <% 		}%>    
        
    <%		if(car_ret_chk>0){%>
    <tr>
	<td><font color=red>* 예약시스템에 [<%=cr_bean.getCar_no()%>]차량 반차 미처리분이 있습니다. 먼저 반차처리후에 대여개시하십시오.</font></td>
    </tr>	
    <%		}%>	
    
    <%		if(rs_cont_size2>0){%>
    <tr>
	<td><font color=red>* 예약시스템에 지연대차 반차 미처리분이 있습니다. 먼저 반차처리후에 대여개시하십시오.</font></td>
    </tr>	
    <%		}%>	    
    
    <%		if(rs_cont_size3>0){%>
    <tr>
	<td><font color=red>* 예약시스템-지연대차에 계약번호 연동은 되었으나 계약관리-출고지연대차는 미입력되었습니다. 먼저 출고지연대차를 입력하십시오.</font></td>
    </tr>	
    <%		}%>	        
    
    <%		if(rs_cont_size>0 && taecha.getRent_s_cd().equals("")){%>
    <tr>
	<td><font color=red>* 예약시스템-지연대차에 반차 미처리분이 있습니다.</font></td>
    </tr>	
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>지연대차 미반차 리스트</span></td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="20%">차량번호</td>			
                    <td class=title width="30%">차명</td>
                    <td class=title width="20%">배차일시</td>
                    <td class=title width="17%">처리</td>
                </tr>
        	<%	for(int i = 0 ; i < rs_cont_size ; i++){
        					Hashtable rs_ht = (Hashtable)rs_conts.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=rs_ht.get("CAR_NO")%></td>
                    <td align='center'><%=rs_ht.get("CAR_NM")%></td>					
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(rs_ht.get("DELI_DT")))%></td>
                    <td align='center'>출고전대차<a href="javascript:update2('taecha','')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td>
                </tr>
        	<%	} %>
            </table>
        </td>
    </tr>			
    <%		}%>
    
    <%		if(rs_cont_size3>0){%>
    <tr>
	<td><font color=red>* 출고지연대차 미등록분이 있습니다.</font></td>
    </tr>	
    <tr>
	<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고지연대차 미등록 리스트</span></td>
    </tr>
    <tr>
	<td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width="13%">연번</td>
                    <td class=title width="20%">차량번호</td>			
                    <td class=title width="30%">차명</td>
                    <td class=title width="20%">배차일시</td>
                    <td class=title width="17%">처리</td>
                </tr>
        	<%	for(int i = 0 ; i < rs_cont_size3 ; i++){
        					Hashtable rs_ht = (Hashtable)rs_conts3.elementAt(i);%>
                <tr> 
                    <td align='center'><%=i+1%></td>
                    <td align='center'><%=rs_ht.get("CAR_NO")%></td>
                    <td align='center'><%=rs_ht.get("CAR_NM")%></td>					
                    <td align='center'><%=AddUtil.ChangeDate3(String.valueOf(rs_ht.get("DELI_DT")))%></td>
                    <td align='center'>출고전대차
                    <%if(ta_vt_size==0){ %>
                    <a href="javascript:update2('taecha_info','')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%}else{ %>
                    <a href="javascript:update2('taecha','0')"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%} %>
                    </td>
                </tr>
        	<%	} %>
            </table>
        </td>
    </tr>			
    <%		}%>

    <tr>
	<td>* 고객 계약담당자에게 영업담당자 배정에 대한 문자를 보냅니다. (00000(차량번호) 차량 담당자는 000, 연락처는 000 입니다. (주)아마존카)</td>
    </tr>	
        
    <%		if(car_ins_chk.equals("N")){%>
    <tr>
	<td><font color=red>* FMS에 보험 등록이 안된 차량이므로 고객에게 보험안내문자를 보낼 수 없습니다. 보험등록 완료후 개시처리하십시오.</font></td>
    </tr>		
    <%		}else{%>
    <tr>
	<td>* 고객 계약담당자에게 보험에 대한 문자를 보냅니다. (보험사는 0000 1588-****, 긴급출동은 마스타자동차 1588-6688 입니다. (주)아마존카)</td>
    </tr>		
    <%		}%>	
    
    <tr>
	<td align='center'>&nbsp;</td>
    </tr>	
    <tr>
	<td align='center'>
	    <a href='javascript:update();' id="submitLink" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_modify.gif" align="absmiddle" border="0"></a> 
	    &nbsp;
	    <a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 		
	    
	    
	    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	    <a href="javascript:reload()" onMouseOver="window.status=''; return true" title="클릭하세요"><img src=/acar/images/center/button_reload.gif align=absmiddle border=0></a> 		
	    
	</td>
    </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
	var fm = document.form1;
	var ifee_tm = toInt(parseDigit(fm.ifee_amt.value)) / toInt(parseDigit(fm.fee_amt.value));
	if(ifee_tm>0){
		fm.pere_r_mth.value = ifee_tm;
	}
//-->
</script>
</body>
</html>
