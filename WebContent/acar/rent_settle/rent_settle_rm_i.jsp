<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//단기대여---------------------------------------------------------------------------------------------------------
			
	//대여일수 구하기
	function getRentTime() {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var rent_time = "";
		var d1;
		var d2;
		var d3;
		var d4;		
		var t1;
		var t2;
		var t3;
		var t4;
		var t5;
		var t6;

		d1 = fm.h_rent_start_dt.value;
		d2 = fm.h_rent_end_dt.value;		
		d3 = fm.h_deli_dt.value;
		d4 = fm.h_ret_dt.value;	
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

        if (d4 == "") {  //반차가 없을 경우 skip
        
        } else {
          	if(t3 == t6){
				fm.add_months.value 	= 0;
				fm.add_days.value 	= 0;
				fm.add_hour.value 	= 0;
				fm.tot_months.value 	= fm.rent_months.value;
				fm.tot_days.value 	= fm.rent_days.value;
				fm.tot_hour.value 	= fm.rent_hour.value;
		}else{//초과 or 미만
				
				fm.add_months.value 	= parseInt((t6-t3)/m);
				fm.add_days.value 	= parseInt(((t6-t3)%m)/l);
				fm.add_hour.value 	= parseInt((((t6-t3)%m)%l)/lh);						
				fm.tot_months.value 	= parseInt(t6/m);
				fm.tot_days.value 	= parseInt((t6%m)/l);
				fm.tot_hour.value 	= parseInt(((t6%m)%l)/lh);				
		}
        }
        				
					
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
	//정상대여료 자동계산
	function getFee_sam(){
		var fm = document.form1;
		fm.action = '/acar/rent_settle/short_fee_nodisplay.jsp';
		fm.target = 'i_no';
		fm.submit();
	}
	
	//금액 셋팅	
	function set_amt(obj){
		obj.value = parseDecimal(obj.value);
		var fm = document.form1;	
		//대여료
		if(obj==fm.ag_fee_s_amt){
			fm.ag_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) * 0.1) ;
			fm.ag_fee_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_fee_v_amt.value)));
		//추가대여료
		}else if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
			//if(fm.ins_yn.value == 'Y' && fm.rent_months.value == '0'){
			//	fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
			//}else{
			//	fm.add_ins_s_amt.value = '0';				
			//}
		}else if(obj==fm.add_fee_v_amt){
			fm.add_fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_v_amt.value)) / 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
		}else if(obj==fm.add_fee_amt){
			fm.add_fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.add_fee_amt.value))));
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) - toInt(parseDigit(fm.add_fee_s_amt.value)));		
		//추가기타비용
		}else if(obj==fm.add_etc_s_amt){
			fm.add_etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) * 0.1) ;
			fm.add_etc_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_etc_v_amt){
			fm.add_etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_v_amt.value)) / 0.1) ;
			fm.add_etc_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_v_amt.value)));
		}else if(obj==fm.add_etc_amt){
			fm.add_etc_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.add_etc_amt.value))));
			fm.add_etc_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_etc_amt.value)) - toInt(parseDigit(fm.add_etc_s_amt.value)));		
		//면책금
		}else if(obj==fm.ins_m_s_amt){
			fm.ins_m_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) * 0.1) ;
			fm.ins_m_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_m_v_amt){
			fm.ins_m_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_v_amt.value)) / 0.1) ;
			fm.ins_m_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)));
		}else if(obj==fm.ins_m_amt){
			fm.ins_m_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_m_amt.value))));
			fm.ins_m_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_amt.value)) - toInt(parseDigit(fm.ins_m_s_amt.value)));		
		//휴차료
		}else if(obj==fm.ins_h_s_amt){
			fm.ins_h_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) * 0.1) ;
			fm.ins_h_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.ins_h_v_amt){
			fm.ins_h_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_v_amt.value)) / 0.1) ;
			fm.ins_h_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)));
		}else if(obj==fm.ins_h_amt){
			fm.ins_h_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.ins_h_amt.value))));
			fm.ins_h_v_amt.value = parseDecimal(toInt(parseDigit(fm.ins_h_amt.value)) - toInt(parseDigit(fm.ins_h_s_amt.value)));		
		//유류비
		}else if(obj==fm.oil_s_amt){
			fm.oil_v_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) * 0.1) ;
			fm.oil_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.oil_v_amt){
			fm.oil_s_amt.value = parseDecimal(toInt(parseDigit(fm.oil_v_amt.value)) / 0.1) ;
			fm.oil_amt.value = parseDecimal(toInt(parseDigit(fm.oil_s_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));
		}else if(obj==fm.oil_amt){
			fm.oil_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.oil_amt.value))));
			fm.oil_v_amt.value = parseDecimal(toInt(parseDigit(fm.oil_amt.value)) - toInt(parseDigit(fm.oil_s_amt.value)));		
		//용역비용1
		}else if(obj==fm.d_pay_amt1 || obj==fm.d_pay_amt2){
			fm.d_pay_tot_amt.value = parseDecimal(toInt(parseDigit(fm.d_pay_amt1.value)) + toInt(parseDigit(fm.d_pay_amt2.value)));
		}

		fm.ag_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.ag_etc_s_amt.value)));
		fm.ag_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_amt.value)) + toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.ag_etc_amt.value)));
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));		
		fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
	}			

	//용역비용:결재 디스플레이
	function driv_display(){
		var fm = document.form1;
		if(fm.driv_serv_st.options[fm.driv_serv_st.selectedIndex].value == '2'){
			tr_drv2.style.display	= '';						
		}else{
			tr_drv2.style.display	= 'none';
			fm.d_paid_dt1.value = '';
			fm.d_paid_dt2.value = '';
			fm.d_pay_amt1.value = '0';
			fm.d_pay_amt2.value = '0';
			fm.d_pay_tot_amt.value = '0';			
		}	
	}	
	
	//금액 셋팅	
	function pay_set_amt(){
		var fm = document.form1;	
		if(fm.mode.value != 'u') return;		
		fm.rest_amt1.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value))) ;
		fm.rest_amt2.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_amt1.value)) - toInt(parseDigit(fm.pay_amt2.value))) ;
	}			
	


	
	// 기타 ------------------------------------------------------------------------------------------------
	
	//차량위치 조회
	function car_map(){
/*		var fm = document.form1;
		var SUBWIN="car_map.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarMap", "left=50, top=50, width=730, height=530, scrollbars=yes");
*/		
	}

	//차량예약현황 조회
	function car_reserve(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserve", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}

	//동급차량예약현황 조회
	function car_reserve2(){
		var fm = document.form1;
		var SUBWIN="/acar/res_search/car_reserve_dk.jsp?c_id="+fm.c_id.value;	
		window.open(SUBWIN, "CarReserveDK", "left=50, top=50, width=820, height=400, scrollbars=yes");
	}


	//취소하기
	function all_reset(){
		var fm = document.form1;	
		fm.reset();
	}
	
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.sett_dt.value == ''){ alert('정산일자를 확인하십시오'); fm.sett_dt.focus(); return; }
		if(fm.run_km.value == ''){ alert('누적주행거리를 확인하십시오'); fm.run_km.focus(); return; }
		if(fm.rent_st.value == '1' && (fm.add_months.value != '0' || fm.add_days.value != '0' || fm.add_hour.value != '0') && fm.add_fee_s_amt.value == '0'){
//			alert('자동계산을 하십시오'); return;
		}

		if(!confirm('등록하시겠습니까?')){	return;	}
	
		fm.action = 'rent_settle_i_a.jsp';
//		fm.target = 'd_content';
		fm.target='i_no';
		fm.submit();
	}
	
	//리스트 가기
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;						
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;		
		var brch_id = fm.brch_id.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var s_cc 	= fm.s_cc.value;
		var s_year 	= fm.s_year.value;				
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		location = "/acar/rent_settle/rent_se_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
//-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.run_km.focus();">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"a.car_nm":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "02", "01");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"i":request.getParameter("mode");
	String disabled = "";
	String white = "";
	String readonly = "";
	int pay_tot_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	

	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id(), rc_bean.getSite_id());
	//단기관리자-연대보증인
	RentMgrBean rm_bean1 = rs_db.getRentMgrCase(s_cd, "1");
	RentMgrBean rm_bean2 = rs_db.getRentMgrCase(s_cd, "2");
	RentMgrBean rm_bean3 = rs_db.getRentMgrCase(s_cd, "3");
	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	//선수금정보
	ScdRentBean sr_bean1 = rs_db.getScdRentCase(s_cd, "1");
	ScdRentBean sr_bean2 = rs_db.getScdRentCase(s_cd, "2");
	String rent_st = rc_bean.getRent_st();
	String use_st = rc_bean.getUse_st();
	//입금스케줄
	Vector conts = rs_db.getScdRentList(s_cd);
	int cont_size = conts.size();
%>
<form action="rent_settle_i_a.jsp" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>  
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>   
 <input type='hidden' name='brch_id' value='<%=brch_id%>'>
 <input type='hidden' name='start_dt' value='<%=start_dt%>'> 
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>
 <input type='hidden' name='code' value='<%=code%>'>  
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>
 <input type='hidden' name='mode' value='<%=mode%>'> 
 
 <input type='hidden' name='c_id' value='<%=c_id%>'>
 <input type='hidden' name='s_cd' value='<%=s_cd%>'> 
 <input type='hidden' name='rent_st' value='<%=rent_st%>'>
 <input type='hidden' name='use_st' value='<%=use_st%>'>
 <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'> 
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 재무회계 > 정산관리 > <span class=style5>정산등록 
                        ( 
                       <%if(rent_st.equals("1")){%>
                단기대여 
                <%}else if(rent_st.equals("2")){%>
                정비대차 
                <%}else if(rent_st.equals("3")){%>
                사고대차 
                <%}else if(rent_st.equals("9")){%>
                보험대차 
                <%}else if(rent_st.equals("10")){%>
                지연대차 
                <%}else if(rent_st.equals("4")){%>
                업무대여 
                <%}else if(rent_st.equals("5")){%>
                업무지원 
                <%}else if(rent_st.equals("6")){%>
                차량정비 
                <%}else if(rent_st.equals("7")){%>
                차량점검 
                <%}else if(rent_st.equals("8")){%>
                사고수리 
                <%}else if(rent_st.equals("11")){%>
                장기대기
                <%}else if(rent_st.equals("12")){%>
                월렌트
                <%}%>	
                        )</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td width="30%"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정보</span></td>
        <td align="right" width="70%">
	    <img src=/acar/images/center/arrow.gif> <%=reserv.get("CAR_NO")%> 대여리스트 <a href="javascript:car_reserve();"><img src="/acar/images/center/button_see.gif" align="absmiddle" border="0"></a>
		&nbsp;&nbsp;&nbsp;<a href="javascript:car_reserve2();"><img src="/acar/images/center/button_list_dg.gif" align="absmiddle" border="0"></a>&nbsp;
        <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
        <a href='javascript:save();'> <img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;
        <%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a><a href='javascript:save();'></a>		
	    </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                <td class=title>차량번호</td>
                <td>&nbsp;<%=reserv.get("CAR_NO")%></td>
                <td class=title>차명</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                <td class=title>차대번호</td>
                <td colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
              </tr>
              <tr> 
                <td class=title width=10%>최초등록일</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
                <td class=title width=10%>출고일자</td>
                <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
                <td class=title width=11%>배기량</td>
                <td width=10%>&nbsp;<%=reserv.get("DPM")%>cc</td>
                <td class=title width=10%>칼라</td>
                <td width=10%>&nbsp;<%=reserv.get("COLO")%></td>
                <td class=title width=9%>연료</td>
                <td width=10%>&nbsp;<%=reserv.get("FUEL_KD")%></td>
              </tr>
              <tr> 
                <td class=title>선택사양</td>
                <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
                <td class=title>현재예상주행거리</td>
                <td>&nbsp;<%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
                <td class=title>최종점검일</td>
                <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
              </tr>
            </table>
      </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("10")||rent_st.equals("12")){%>''<%}else{%>none<%}%>"> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>고객정보</span></td>
        <td align="right"></td>
    </tr>
    <%if(rent_st.equals("1") || rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("9") || rent_st.equals("10") || rent_st.equals("12")){%>
     <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%><%=rc_bean2.getCust_st()%></td>
                    <td class=title width=10%>성명</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=10%>생년월일</td>
                    <td width=11%>&nbsp;<%=AddUtil.ChangeEnpH(rc_bean2.getSsn())%></td>
                    <td class=title width=10%>상호</td>
                    <td width=18%>&nbsp;<%=rc_bean2.getFirm_nm()%></td>
                    <td class=title width=11%>사업자등록번호</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getEnp_no()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>직원</td>
                    <td class=title width=10%>성명</td>
                    <td width=15%>&nbsp;<%=c_db.getNameById(rc_bean2.getCust_id(),"USER")%></td>
                    <td class=title width=10%>영업소명</td>
                    <td width=15%>&nbsp;<%=rc_bean2.getBrch_nm()%></td>
                    <td class=title width=10%>부서명</td>
                    <td width=30%>&nbsp;<%=rc_bean2.getDept_nm()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}%>
    <%if(rent_st.equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
		
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>정비대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=25%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%>정비차량번호</td>
                    <td width=16%>&nbsp;<%=serv.get("CAR_NO")%></td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>&nbsp;<%=serv.get("CAR_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("3")){
		//사고대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고대차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>피해차량번호</td>
                    <td width=16%>&nbsp;<%=accid.get("CAR_NO")%></td>
                    <td class=title width=10%>차종</td>
                    <td width=29%>&nbsp;<%=accid.get("CAR_NM")%></td>
                </tr>
                <tr> 
                    <td class=title>접수번호</td>
                    <td>&nbsp;<%=accid.get("P_NUM")%></td>
                    <td class=title>가해자보험사</td>
                    <td>&nbsp;<%=accid.get("G_INS")%></td>
                    <td class=title>담당자</td>
                    <td>&nbsp;<%=accid.get("G_INS_NM")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
	<%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getRent_s_cd());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험대차</span></td>
    </tr>	
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title> 접수번호</td>
                    <td>&nbsp;<%=ri_bean.getIns_num()%></td>
                    <td class=title>보험사</td>
                    <td colspan="5"> 
                      &nbsp;<select name='ins_com_id' disabled>
                        <%if(ic_size > 0){
        					for(int i = 0 ; i < ic_size ; i++){
        						InsComBean ic = ic_r[i];%>
                        <option value="<%=ic.getIns_com_id()%>" <%if(ri_bean.getIns_com_id().equals(ic.getIns_com_id()))%>selected<%%>><%=ic.getIns_com_nm()%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr> 
                    <td class=title width=10%>담당자</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_nm()%></td>
                    <td class=title width=10%>연락처Ⅰ</td>
                    <td width=16%>&nbsp;<%=ri_bean.getIns_tel()%></td>
                    <td class=title width=10%>연락처Ⅱ</td>
                    <td width=15%>&nbsp;<%=ri_bean.getIns_tel2()%></td>
                    <td class=title width=10%>팩스</td>
                    <td width=14%>&nbsp;<%=ri_bean.getIns_fax()%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>		
    <%}else if(rent_st.equals("6")){
		//차량정비정보
		Hashtable serv = rs_db.getInfoServ(c_id, rc_bean.getServ_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정비</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=41%>&nbsp;<%=serv.get("OFF_NM")%></td>
                    <td class=title width=10%> 정비일자</td>
                    <td width=39%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(serv.get("SERV_DT")))%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("7")){%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>차량정검</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>검사유효기간</td>
                    <td width=90%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_ST_DT")))%>~<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAINT_END_DT")))%> 
                    </td>
              </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <%}else if(rent_st.equals("8")){
		//사고수리정보
		Hashtable accid = rs_db.getInfoAccid(c_id, rc_bean.getAccid_id());%>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>사고수리</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>	
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>정비공장명</td>
                    <td width=25%>&nbsp;<%=accid.get("OFF_NM")%></td>
                    <td class=title width=10%>사고일자</td>
                    <td width=16%>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(accid.get("ACCID_DT")))%></td>
                    <td class=title width=10%>담당자</td>
                    <td width=29%>&nbsp;<%=c_db.getNameById(String.valueOf(accid.get("REG_ID")), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>사고내용</td>
                    <td colspan="5">&nbsp;<%=accid.get("ACCID_CONT")%>&nbsp;<%=accid.get("ACCID_CONT2")%></td>
                </tr>
            </table>
        </td>
    </tr>
    <%}%>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약정보</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>계약번호</td>
                    <td width=10%>&nbsp;<%=rc_bean.getRent_s_cd()%></td>
                    <td class=title width=10%>계약일자</td>
                    <td width=10%>&nbsp;<%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
                    <td class=title width=11%>영업소</td>
                    <td width=10%>&nbsp;<%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
                    <td width=10% class=title>담당자</td>
                    <td colspan=3>&nbsp;<%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
                </tr>
                <tr> 
                    <td class=title>기타</td>
                    <td colspan="5">&nbsp;<%=rc_bean.getEtc()%></td>
                    <td class=title>약정기간</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>~ 
                      <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_cont style="display:<%if(rent_st.equals("1")){%>''<%}else{%>none<%}%>"> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>운전기사</td>
                    <td width=10%> 
                      <%if(rf_bean.getDriver_yn().equals("Y")){%>
                      &nbsp;포함 
                      <%}else{%>
                      &nbsp;미포함 
                      <%}%>
                    </td>
                    <td class=title width=10%>선택보험</td>
                    <td> 
                      <%if(rf_bean.getIns_yn().equals("Y")){%>
                      &nbsp;가입 
                      <%}else{%>
                      &nbsp;미가입 
                      <%}%>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>배차/반차</span></td>
    </tr>
    <tr>
        <td class=line2 colspan="2"></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                    <td class=title>반차일시</td>
                    <td colspan="3">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_dt())%></td>
                </tr>
                <tr> 
                    <td class=title width=10%>당초약정시간</td>
                    <td width=20%> 
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
                      시간 
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
                      일 
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
                      개월 </td>
                    <td class=title width=10%>추가이용시간</td>
                    <td width=21%> 
                      &nbsp;<input type="text" name="add_hour" value="" size="2" class=num >
                      시간 
                      <input type="text" name="add_days" value="" size="2" class=num >
                      일 
                      <input type="text" name="add_months" value="" size="2" class=num >
                      개월 </td>
                    <td class=title width=10%>총이용시간</td>
                    <td width=29%> 
                      &nbsp;<input type="text" name="tot_hour" value="" size="2" class=num >
                      시간 
                      <input type="text" name="tot_days" value="" size="2" class=num >
                      일 
                      <input type="text" name="tot_months" value="" size="2" class=num >
                      개월 </td>
                </tr>
                <tr> 
                    <td class=title>비고</td>
                    <td colspan="5"> 
                      &nbsp;<input type="text" name="etc" value="" size="130" class=text>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여요금 정산</span></td>
        <td align="right"><a href="javascript:getFee_sam();"><img src=/acar/images/center/button_jdgs.gif align=absmiddle border=0></a></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding=0" width=100%>
            	<tr>
                    <td class=line2 colspan=6 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=10%>정산일자</td>
                    <td width=41%> 
                        &nbsp;<input type="text" name="sett_dt" value="<%=AddUtil.getDate()%>" size="12" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                    <td class=title width=10%>누적주행거리</td>
                    <td width=39%> 
                        &nbsp;<input type="text" name="run_km" value="" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value);'>
                        km </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr></tr><tr></tr>
    <tr id=tr_sett1 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width=10% rowspan="2" class=title>구분</td>
                    <td colspan="3" class=title>대여료</td>
                    <td width=10% rowspan="2" class=title>선택보험료</td>
                    <td width=10% rowspan="2" class=title>배차료</td>
                    <td width=10% rowspan="2" class=title>반차료</td>
                    <td width=10% rowspan="2" class=title>소계(①)<!--(①)--></td>
                    <td rowspan="2" class=title>합계(VAT포함)</td>
                </tr>
                <tr>
                  <td width=10% class=title>차량</td>
                  <td width=10% class=title>내비게이션</td>
                  <td width=10% class=title>기타</td>
                </tr>
                <tr> 
                    <td class=title>정상</td>
                    <td align="center">
                      <input type='hidden' name='ag_fee_amt' value=''>
                      <input type='hidden' name='ag_fee_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getFee_v_amt()-rf_bean.getDc_v_amt())%>'>			 
                      <input type="text" name="ag_fee_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getFee_s_amt()-rf_bean.getDc_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_navi_amt' value=''>
                      <input type='hidden' name='ag_navi_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getNavi_v_amt())%>'>			 
                      <input type="text" name="ag_navi_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getNavi_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_etc_amt' value=''>
                      <input type='hidden' name='ag_etc_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getEtc_v_amt())%>'>			 
                      <input type="text" name="ag_etc_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getEtc_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ag_ins_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getIns_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_cons1_amt' value=''>
                      <input type='hidden' name='ag_cons1_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons1_v_amt())%>'>			 
                      <input type="text" name="ag_cons1_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons1_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type='hidden' name='ag_cons2_amt' value=''>
                      <input type='hidden' name='ag_cons2_v_amt' value='<%=AddUtil.parseDecimal(rf_bean.getCons2_v_amt())%>'>			 
                      <input type="text" name="ag_cons2_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getCons2_s_amt())%>" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                    <td align="center"> 
                      <input type="text" name="ag_tot_s_amt" value="<%=AddUtil.parseDecimal(rf_bean.getTot_s_amt())%>" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="ag_tot_amt" value="<%=AddUtil.parseDecimal(rf_bean.getRent_tot_amt())%>" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
                <tr>
                  <td class=title>추가</td> 
                    <td align="center">
                      <input type='hidden' name='add_fee_amt' value='0'>
                      <input type='hidden' name='add_fee_v_amt' value='0'>
                      <input type="text" name="add_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type='hidden' name='add_navi_amt' value='0'>
                      <input type='hidden' name='add_navi_v_amt' value='0'>
                      <input type="text" name="add_navi_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type='hidden' name='add_etc_amt' value='0'>
                      <input type='hidden' name='add_etc_v_amt' value='0'>
                      <input type="text" name="add_etc_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                    <td align="center"> 
                      <input type="text" name="add_ins_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center">
                      <input type='hidden' name='add_cons1_amt' value='0'>
                      <input type='hidden' name='add_cons1_v_amt' value='0'>
                      <input type="text" name="add_cons1_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                    <td align="center">
                      <input type='hidden' name='add_cons2_amt' value='0'>
                      <input type='hidden' name='add_cons2_v_amt' value='0'>
                      <input type="text" name="add_cons2_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>                      
                    <td align="center"> 
                      <input type="text" name="add_tot_s_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="add_tot_amt" value="0" size="10" class=num readonly onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr></tr><tr></tr>            
    <tr id=tr_sett2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    				
                <tr>
                  <td class=title width=10%>소계</td> 
                    <td align="center" width=10%> 
                      <input type="text" name="tot_fee_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_navi_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_etc_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_ins_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_cons_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="tot_clss_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center" width=10%> 
                      <input type="text" name="rent_tot_s_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"> 
                      <input type="text" name="rent_tot_amt" value="0" size="10" readonly class=<%=white%>num onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                </tr>
            </table>
        </td>
    </tr>    
    <tr></tr><tr></tr>            
    <tr id=tr_sett3 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>                
                <tr> 
                    <td class=title rowspan="7" width=3%>부<br>대<br>비<br>용</td>
                    <td class=title width=7%>구분</td>
                    <td class=title width=10%>공급가</td>
                    <td class=title width=10%>부가세</td>
                    <td class=title width=10%>합계</td>
                    <td class=title width=60%>비고</td>
                </tr>
                <tr>
                  <td class=title>위약금</td> 
                    <td align="center"> 
                      <input type='hidden' name='cls_amt' value='0'>
                      <input type='hidden' name='cls_v_amt' value='0'>
                      <input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원</td>
                    <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원 </td>
                    <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원 </td>
                    <td>잔여기간 대여요금의 10%의 위약금이 부과됩니다.                   </td>
                </tr>
                <tr>
                  <td class=title>면책금</td>
                  <td align="center"><input type='hidden' name='ins_m_amt' value='0'>
                    <input type='hidden' name='ins_m_v_amt' value='0'>
                    <input type="text" name="ins_m_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class=title>휴차료</td>
                  <td align="center"><input type='hidden' name='ins_h_amt' value='0'>
                    <input type='hidden' name='ins_h_v_amt' value='0'>
                    <input type="text" name="ins_h_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td>고객의 귀책사유에 의한 사고발생시 대여차량의 수리기간에 해당하는 대여요금의 50%를 고객이 부담합니다. </td>
                </tr>
                <tr>
                  <td class=title>유류비</td>
                  <td align="center"><input type='hidden' name='oil_amt' value='0'>
                    <input type='hidden' name='oil_v_amt' value='0'>
                    <input type="text" name="oil_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td>&nbsp;</td>
                </tr>
                <tr>
                  <td class=title>KM초과운행</td>
                  <td align="center"><input type='hidden' name='km_amt' value='0'>
                    <input type='hidden' name='km_v_amt' value='0'>
                    <input type="text" name="km_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td> 5,000km/1개월, 초과시 1km당 80원의 추가요금이 부과됩니다. </td>
                </tr>
                <tr>
                  <td class=title>소계</td>
                  <td align="center"><input type="text" name="etc_tot_s_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="cls_s_amt" value="0" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td align="center"><input type="text" name="etc_tot_amt" value="0" size="10" readonly class=num onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
원</td>
                  <td>&nbsp;</td>
                </tr>                
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_pay_nm style='display:<%if(rf_bean.getPaid_way().equals("1")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>입금처리</span></td>
    </tr>
    <tr id=tr_pay1 style='display:<%if(rf_bean.getPaid_way().equals("1")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=5 style='height:1'></td>
                </tr>
                <tr> 
                    <td class=title width=20%>구분</td>
                    <td class=title width=20%> 
                        <p>결제방법</p>
                    </td>
                    <td class=title width=20%>결제일자</td>
                    <td class=title width=20%>금액</td>
                    <td class=title width=20%>비고</td>
                </tr>
    		  <%
    			if(cont_size > 0){
    				for(int i = 0 ; i < cont_size ; i++){
    					Hashtable sr = (Hashtable)conts.elementAt(i);%>		  
                <tr> 
                    <td class=title> 
                      <%if(String.valueOf(sr.get("RENT_ST")).equals("1")){%>
                      예약보증금 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("2")){%>
                      선수대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("3")){%>
                      대여료 
                      <%}else if(String.valueOf(sr.get("RENT_ST")).equals("4")){%>
                      정산금 
                      <%}%>
                    </td>
                    <td align="center">
        			<%if(String.valueOf(sr.get("PAID_ST")).equals("1")){%>
        			현금
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("2")){%>
        			카드
        			<%}else if(String.valueOf(sr.get("PAID_ST")).equals("3")){%>
        			자동이체
        			<%}%>				
        			</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(sr.get("PAY_DT")))%></td>
                    <td align="center"><input type="text" name="pay_amt" value="<%=Util.parseDecimal(String.valueOf(sr.get("PAY_AMT")))%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">-</td>
                </tr>
    		  <%		pay_tot_amt = pay_tot_amt + AddUtil.parseInt(String.valueOf(sr.get("PAY_AMT")));
    		  		}
    		  	}%> 			  
                <tr> 
                    <td class=title>합계</td>
                    <td align="center">&nbsp;</td>
                    <td align="center">&nbsp;</td>
                    <td align="center"><input type="text" name="pay_tot_amt" value="<%=Util.parseDecimal(pay_tot_amt)%>" size="10" readonly class=whitenum onBlur='javascript:this.value=parseDecimal(this.value);'>
                      원</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr><td class=h></td></tr>
    <tr id=tr_drv_nm style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>용역비용(운전기사)</span></td>
    </tr>
    <tr id=tr_drv1 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
            	<tr>
                    <td class=line2 colspan=3 style='height:1'></td>
                </tr>
                <tr> 
                    <td class="title" width=10%>결제방법</td>
                    <td> 
                      <select name="driv_serv_st" onchange="javascript:driv_display();">
                        <option value="">선택</option>
                        <option value="1">소속용역회사와 별도 정산</option>
                        <option value="2">대여료 정산시 합산</option>
                      </select>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv2 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=20%>구분</td>
                    <td class=title width=20%>결제수단</td>
                    <td class=title width=20%>결제일자</td>
                    <td class=title width=20%>금액</td>
                    <td class=title width=20%>비고</td>
                </tr>
                <tr id=tr_scd style='display:block'> 
                    <td align="center">입금 
                        <input type="hidden" name="d_rent_st1" value="1">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st1">
                            <option value="1">카드</option>
                            <option value="2">현금</option>
                            <option value="3">자동이체</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt1" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt1" value=""onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        원</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td align="center">
                        <input type="hidden" name="d_rent_st2" value="2">
                    </td>
                    <td align="center"> 
                        <select name="d_paid_st2">
                            <option value="1">카드</option>
                            <option value="2">현금</option>
                            <option value="3">자동이체</option>
                        </select>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=text name="d_pay_dt2" value=""  onBlur='javscript:this.value=ChangeDate(this.value);'>
                    </td>
                    <td align="center"> 
                        <input type='text' size='12' class=num name="d_pay_amt2" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                        원</td>
                    <td align="center">-</td>
                </tr>
                <tr> 
                    <td class="title"> 합계</td>
                    <td align="center">&nbsp; </td>
                    <td align="center">&nbsp; </td>
                    <td align="center"> 
                        <input type='text' size='12' class=whitenum name="d_pay_tot_amt" value="0" readonly onBlur='javascript:this.value=parseDecimal(this.value);'>
                        원</td>
                    <td align="center">&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr_drv3 style='display:<%if(rent_st.equals("1") && rf_bean.getDriver_yn().equals("Y")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class="title" width=10%>비고</td>
                    <td> 
                      <input type='text' size='90' class=text name="driv_serv_etc" value="" onBlur='javascript:this.value=parseDecimal(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
    <tr><td class=h></td></tr>
    <tr id=tr_sett_nm2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'>	
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>총정산금</span></td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id=tr_sett2 style='display:<%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>block<%}else{%>none<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class=title width=10%>총정산금</td>
                    <td class=title_p style='text-align:left'> 
                      &nbsp;&nbsp;<input type='text' size='12' class=text name="rent_sett_amt" value="" onBlur='javascript:this.value=parseDecimal(this.value); set_amt(this);'>
                      원 (정산대여료 합계 - 입금처리 합계, 기사포함/대여료정산시 합산일 경우 : 용역비용 합계 포함)</td>
                </tr>
            </table>
        </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	//이용기간 셋팅	
	getRentTime();
	
	var fm = document.form1;	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9' || fm.rent_st.value == '12'){

		if(fm.add_hour.value == '0' && fm.add_days.value == '0' && fm.add_months.value == '0'){
			fm.add_fee_s_amt.value = '0';
			fm.add_ins_s_amt.value = '0';
			fm.add_etc_s_amt.value = '0';
			fm.add_tot_s_amt.value = '0';
			fm.add_tot_amt.value = '0';		
		}	
		
		fm.ag_fee_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_fee_v_amt.value)));
		fm.ag_navi_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_v_amt.value)));
		fm.ag_etc_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_v_amt.value)));	
		fm.ag_cons1_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_v_amt.value)));	
		fm.ag_cons2_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_cons2_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_v_amt.value)));	
		fm.ag_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_s_amt.value)));
		fm.ag_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_amt.value)) 		+ toInt(parseDigit(fm.ag_navi_amt.value)) 	+ toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.ag_etc_amt.value)) 	+ toInt(parseDigit(fm.ag_cons1_amt.value)) 	+ toInt(parseDigit(fm.ag_cons2_amt.value)));
		
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) 		+ toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) 		+ toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) 	+ toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) 	+ toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_navi_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_navi_s_amt.value)) 	+ toInt(parseDigit(fm.add_navi_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) 	+ toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_cons_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_cons1_s_amt.value)) 	+ toInt(parseDigit(fm.add_cons1_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) 	+ toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		
		
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) 	+ toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) 		+ toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
		
		if(fm.rent_st.value == '1' || fm.rent_st.value == '12'){
			fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
			fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));
		}
	}
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
