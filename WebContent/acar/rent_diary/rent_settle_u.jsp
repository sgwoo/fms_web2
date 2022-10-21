<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.car_service.*, acar.serv_off.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="s_bean" class="acar.car_service.ServiceBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="../../include/table.css">
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

		d1 = fm.h_rent_start_dt.value+'00';
		d2 = fm.h_rent_end_dt.value+'00';		
		d3 = fm.h_deli_dt.value+'00';
		d4 = fm.h_ret_dt.value+'00';	
											
		t1 = getDateFromString(d1).getTime();
		t2 = getDateFromString(d2).getTime();
		t3 = t2 - t1;	
		t4 = getDateFromString(d3).getTime();
		t5 = getDateFromString(d4).getTime();
		t6 = t5 - t4;	

		if(t3 == t6){
			fm.add_months.value = 0;
			fm.add_days.value = 0;
			fm.add_hour.value = 0;
			fm.tot_months.value = fm.rent_months.value;
			fm.tot_days.value = fm.rent_days.value;
			fm.tot_hour.value = fm.rent_hour.value;		
		}else{//초과 or 미만
			fm.add_months.value 	= parseInt((t6-t3)/m);
			fm.add_days.value 		= parseInt(((t6-t3)%m)/l);
			fm.add_hour.value 		= parseInt((((t6-t3)%m)%l)/lh);						
			fm.tot_months.value 	= parseInt(t6/m);
			fm.tot_days.value 		= parseInt((t6%m)/l);
			fm.tot_hour.value 		= parseInt(((t6%m)%l)/lh);				
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
		//추가대여료
		if(obj==fm.add_fee_s_amt){
			fm.add_fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) * 0.1) ;
			fm.add_fee_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_v_amt.value)));
			if(fm.ins_yn.value == 'Y' && fm.rent_months.value == '0'){
				fm.add_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) * 0.1) ;	
			}else{
				fm.add_ins_s_amt.value = '0';				
			}
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

		fm.add_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value = parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value = parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));		
		fm.rent_sett_amt.value = parseDecimal(toInt(parseDigit(fm.rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
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
		location = "/acar/rent_end/rent_en_frame_s.jsp?auth_rw="+auth_rw+"&gubun1="+gubun1+"&gubun2="+gubun2+"&brch_id="+brch_id+"&s_kd="+s_kd+"&t_wd="+t_wd+"&s_cc="+s_cc+"&s_year="+s_year+"&sort_gubun="+sort_gubun+"&asc="+asc;
	}	
	
//-->
</script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String gubun1 = request.getParameter("gubun1")==null?"5":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");		
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");	
	String s_cc = request.getParameter("s_cc")==null?"":request.getParameter("s_cc");
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_kd = request.getParameter("s_kd")==null?"2":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"j.sett_dt":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"asc":request.getParameter("asc");
	
	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"c":request.getParameter("mode");
	int pay_tot_amt = 0;
	String disabled = "disabled";
	String white = "white";
	String readonly = "readonly";
	if(mode.equals("u")){
		disabled = "";
		white = "";
		readonly = "";
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();	
	
	//보험사 리스트
	InsComBean ic_r [] = c_db.getInsComAll();
	int ic_size = ic_r.length;	
	
	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);
	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
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
	//단기대여정산정보
	RentSettleBean rs_bean = rs_db.getRentSettleCase(s_cd);
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
 <input type='hidden' name='cust_id' value='<%=rc_bean.getCust_id()%>'>
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'> 
 <input type='hidden' name='section' value='<%=reserv.get("SECTION")%>'> 
 <input type='hidden' name='ins_yn' value='<%=rf_bean.getIns_yn()%>'>   

  <table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr> 
      <td colspan="2"><font color="navy">예약시스템 -> 운행일지</font> -><font color="red"> 
        </font><font color="red">계약내용 ( 
        <%if(rent_st.equals("1")){%>
        단기대여 
        <%}else if(rent_st.equals("2")){%>
        정비대차 
        <%}else if(rent_st.equals("3")){%>
        사고대차 
        <%}else if(rent_st.equals("9")){%>
        보험대차 
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
        기타 
        <%}else if(rent_st.equals("12")){%>
        월렌트
        <%}%>
        )</font></td>
    </tr>
    <tr> 
      <td width="50%">< 차량정보 ></td>
      <td align="right" width="50%"> <a href="javascript:car_reserve();"><%=reserv.get("CAR_NO")%></a> 
        || <a href="javascript:car_reserve2();">동급자동차</a> 대여리스트</td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width=80>차량번호</td>
            <td align="center" width=90><%=reserv.get("CAR_NO")%></td>
            <td class=title width=70>차명</td>
            <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
            <td class=title width=70>차대번호</td>
            <td align="left" colspan="3">&nbsp;<%=reserv.get("CAR_NUM")%></td>
          </tr>
          <tr> 
            <td class=title>최초등록일</td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("INIT_REG_DT")))%></td>
            <td class=title>출고일자</td>
            <td align="center" width=85><%=AddUtil.ChangeDate2(String.valueOf(reserv.get("DLV_DT")))%></td>
            <td class=title width=110>배기량</td>
            <td align="center" width="65"><%=reserv.get("DPM")%>cc</td>
            <td class=title>칼라</td>
            <td align="center" width=60><%=reserv.get("COLO")%></td>
            <td class=title width="50">연료</td>
            <td align="center" width="120"><%=reserv.get("FUEL_KD")%></td>
          </tr>
          <tr> 
            <td class=title>선택사양</td>
            <td colspan="3">&nbsp;<%=reserv.get("OPT")%></td>
            <td class=title>현재예상주행거리</td>
            <td align="center"><%=Util.parseDecimal(String.valueOf(reserv.get("TODAY_DIST")))%>km</td>
            <td class=title>최종점검일</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("SERV_DT")))%></td>
          </tr>
          <tr> 
            <td class=title>최종운행일</td>
            <td colspan="3">&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(reserv.get("MAX_DT")))%></td>
            <td class=title>차량위치</td>
            <td align="center"><a href="javascript:car_map();">위치보기</a></td>
            <td class=title>인도전상태</td>
            <td colspan="3">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <tr id=tr_cust_nm style="display:<%if(rent_st.equals("1")||rent_st.equals("2")||rent_st.equals("3")||rent_st.equals("4")||rent_st.equals("5")||rent_st.equals("9")||rent_st.equals("12")) {%>''<%} else {%>none<%}%>"> 
      <td>< 고객정보 ></td>
      <td align="right"> 
        <!--<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
                <a href='javascript:save();'> <img src="/images/up_info.gif" width="50" height="18" aligh="absmiddle" border="0"> 
        </a>
        <%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a><a href='javascript:save();'> 
        </a> -->
        <a href='javascript:save();'> </a></td>
    </tr>
    <%if(rent_st.equals("1")||rent_st.equals("9")||rent_st.equals("12")){%>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">구분</font></td>
            <!--<a href="javascript:cust_select()"></a>-->
            <td width="130"> 
              <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
              <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
            </td>
            <td class=title width="80">성명</td>
            <td colspan="3"> 
              <input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="45" class=whitetext>
            </td>
            <td class=title width="85">생년월일</td>
            <td> 
              <input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">상호</td>
            <td colspan="5"> 
              <input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
            </td>
            <td class=title width="85">사업자등록번호</td>
            <td> 
              <input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
            </td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('c_zip').value = data.zonecode;
							document.getElementById('c_addr').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td class=title width="80">주소</td>
            <td colspan="7"> 
			<input type="text" name='c_zip' id="c_zip" size="7" value="<%=rc_bean2.getZip()%>" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='c_addr' id="c_addr" value="<%=rc_bean2.getAddr()%>" size="100">

            </td>
          </tr>
          <tr> 
            <td class=title width="80">운전면허번호</td>
            <td> 
              <input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
            <td class=title width="80">면허종류</td>
            <td width="100"> 
              <input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="13" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td class=title width="80">전화번호</td>
            <td width="110"> 
              <input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
            </td>
            <td class=title>휴대폰</td>
            <td> 
              <input type="text" name="c_m_tel" value="<%=rc_bean2.getM_tel()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">비상연락처</td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st2" value="2">
              성명:&nbsp; 
              <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; 연락처:&nbsp; 
              <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
              &nbsp; 관계:&nbsp; 
              <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
            </td>
          </tr>
          <tr> 
            <td class=title rowspan="2"><%if(rent_st.equals("12")){%>추가운전자<%}else{%>실운전자<br>(용역기사 등)<%}%></td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st1" value="1">
              성명:&nbsp; 
              <input type="text" name="mgr_nm1" value="<%=rm_bean1.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; 생년월일:&nbsp; 
              <input type="text" name="m_ssn1" value="<%=rm_bean1.getSsn()%>" size="15" maxlength='8' class=<%=white%>text>
              &nbsp; 운전면허번호:&nbsp; 
              <input type="text" name="m_lic_no1" value="<%=rm_bean1.getLic_no()%>" size="16" class=<%=white%>text>
              전화번호:&nbsp; 
              <input type="text" name="m_tel1" value="<%=rm_bean1.getTel()%>" size="15" class=<%=white%>text>
            </td>
          </tr>
		  <script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('m_zip1').value = data.zonecode;
							document.getElementById('m_addr1').value = data.roadAddress;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td  colspan='7'> 주소:&nbsp; 
			<input type="text" name='m_zip1' id="m_zip1" size="7" value="<%=rm_bean1.getZip()%>" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
			&nbsp;&nbsp;<input type="text" name='m_addr1' id="m_addr1" value="<%=rm_bean1.getAddr()%>" size="95">

            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("2") || rent_st.equals("3")){%>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">구분</font></td>
            <!--<a href="javascript:cust_select()"></a>-->
            <td width="130"> 
              <input type='hidden' name='cust_st' value='<%=rc_bean.getCust_st()%>'>
              <input type="text" name="c_cust_st" value="<%=rc_bean2.getCust_st()%>" size="15" class=whitetext>
            </td>
            <td class=title width="80">성명</td>
            <td width="297"> 
              <input type="text" name="c_cust_nm" value="<%=rc_bean2.getCust_nm()%>" size="45" class=whitetext>
            </td>
            <td class=title width="85">생년월일</td>
            <td> 
              <input type="text" name="c_ssn" value="<%=rc_bean2.getSsn()%>" size="15" maxlength='8' class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">상호</td>
            <td colspan="3"> 
              <input type="text" name="c_firm_nm" value="<%=rc_bean2.getFirm_nm()%>" size="80" class=whitetext>
            </td>
            <td class=title>사업자등록번호</td>
            <td> 
              <input type="text" name="c_enp_no" value="<%=rc_bean2.getEnp_no()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">비상연락처</td>
            <td  colspan='7'> 
              <input type="hidden" name="mgr_st2" value="2">
              성명:&nbsp; 
              <input type="text" name="mgr_nm2" value="<%=rm_bean2.getMgr_nm()%>" class=<%=white%>text size="10">
              &nbsp;&nbsp; 연락처:&nbsp; 
              <input type="text" name="m_tel2" value="<%=rm_bean2.getTel()%>" size="15" class=<%=white%>text>
              &nbsp; 관계:&nbsp; 
              <input type="text" name="m_etc2" value="<%=rm_bean2.getEtc()%>" size="58" class=<%=white%>text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <input type='hidden' name='c_zip' value=''>
    <input type='hidden' name='c_addr' value=''>
    <input type='hidden' name='c_lic_no' value=''>
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_tel' value=''>
    <input type='hidden' name='c_m_tel' value=''>
    <%}else if(rent_st.equals("4") || rent_st.equals("5")){%>
    <input type='hidden' name='c_firm_nm' value='(주)아마존카'>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"><font color="#FFFF00">구분</font></td>
            <td width="125"> 
              <input type='hidden' name='cust_st' value='4'>
              <input type="text" name="c_cust_st" value="직원" size="15" class=whitetext>
            </td>
            <td class=title width="80">성명</td>
            <td width="110"> 
              <select name='c_cust_nm' onChange='javascript:user_select()' <%=disabled%>>
                <option value="">==선택==</option>
                <%	if(user_size > 0){
						for (int i = 0 ; i < user_size ; i++){
							Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>'  <%if(rc_bean2.getCust_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                <%		}
					}		%>
              </select>
            </td>
            <td class=title width="80">영업소명</td>
            <td width="125"> 
              <input type="text" name="c_brch_nm" value="<%=rc_bean2.getBrch_nm()%>" size="15" class=whitetext>
            </td>
            <td class=title width="90">부서명</td>
            <td> 
              <input type="text" name="c_dept_nm" value="<%=rc_bean2.getDept_nm()%>" size="15" class=whitetext>
            </td>
          </tr>
          <tr> 
            <td class=title width="80">운전면허번호</td>
            <td width="125"> 
              <input type="text" name="c_lic_no" value="<%=rc_bean2.getLic_no()%>" size="16" class=whitetext onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
            <td class=title width="80">면허종류</td>
            <td width="110"> 
              <input type="text" name="c_lic_st" value="<%=rc_bean2.getLic_st()%>" size="15" class=whitetext onBlur='javscript:this.value = ChangeDate(this.value);'>
            </td>
            <td class=title width="80">전화번호</td>
            <td width="125"> 
              <input type="text" name="c_tel" value="<%=rc_bean2.getTel()%>" class=whitetext size="15">
            </td>
            <td class=title>휴대폰</td>
            <td> 
              <input type="text" name="c_m_tel" value="<%=rc_bean2.getM_tel()%>" size="15" class=whitetext>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else{%>
    <input type='hidden' name='c_cust_st' value='5'>
    <input type='hidden' name='c_cust_nm' value=''>
    <input type='hidden' name='c_firm_nm' value=''>
    <input type='hidden' name='c_ssn' value=''>
    <input type='hidden' name='c_enp_no' value=''>
    <input type='hidden' name='c_lic_no' value=''>
    <input type='hidden' name='c_lic_st' value=''>
    <input type='hidden' name='c_zip' value=''>
    <input type='hidden' name='c_addr' value=''>
    <%}%>
    <%if(rent_st.equals("2")){
		//정비대차정보
		Hashtable serv = rs_db.getInfoServ(rc_bean.getSub_c_id(), rc_bean.getServ_id());%>
    <tr> 
      <td colspan="2">< 정비대차 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">정비공장명</td>
            <td width="160"><%=serv.get("OFF_NM")%></td>
            <td class=title width="90">정비차량번호</td>
            <td width="110"><%=serv.get("CAR_NO")%></td>
            <td class=title width="80">차종</td>
            <td width="280"><%=serv.get("CAR_NM")%></td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("3")){
		//정비대차정보
		Hashtable accid = rs_db.getInfoAccid(rc_bean.getSub_c_id(), rc_bean.getAccid_id());%>
    <tr> 
      <td colspan="2">< 보험사고대차 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">정비공장명</td>
            <td width="160"><%=accid.get("OFF_NM")%></td>
            <td class=title width="90">피해차량번호</td>
            <td width="110"><%=accid.get("CAR_NO")%></td>
            <td class=title width="80">차종</td>
            <td width="280"><%=accid.get("CAR_NM")%></td>
          </tr>
          <tr> 
            <td class=title> 접수번호</td>
            <td><%=accid.get("P_NUM")%></td>
            <td class=title>가해자보험사</td>
            <td><%=accid.get("G_INS")%></td>
            <td class=title>담당자</td>
            <td><%=accid.get("G_INS_NM")%></td>
          </tr>
        </table>
      </td>
    </tr>
	<%}else if(rent_st.equals("9")){
		//보험대차정보
		RentInsBean ri_bean = rs_db.getRentInsCase(rc_bean.getSub_c_id());%>
    <tr> 
      <td colspan="2">< 보험대차 ></td>
    </tr>	
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80"> 접수번호</td>
            <td width="125"><%=ri_bean.getIns_num()%></td>
            <td class=title width="80">보험사</td>
            <td colspan="5"> 
              <select name='ins_com_id' disabled>
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
            <td class=title width="80"> 담당자</td>
            <td width="125"><%=ri_bean.getIns_nm()%></td>
            <td class=title width="80">연락처Ⅰ</td>
            <td width="110"><%=ri_bean.getIns_tel()%></td>
            <td class=title width="80">연락처Ⅱ</td>
            <td><%=ri_bean.getIns_tel2()%></td>
            <td class=title width="80">팩스</td>
            <td><%=ri_bean.getIns_fax()%></td>
          </tr>
        </table>
      </td>
    </tr>			
    <%}else if(rent_st.equals("6")){%>
    <tr> 
      <td colspan="2">< 차량정비 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">정비공장명</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90"> 정비일자</td>
            <td width="470">&nbsp; </td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("7")){%>
    <tr> 
      <td colspan="2">< 차량정검 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">점검종별</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90"> 점검실시자</td>
            <td width="110">&nbsp;</td>
            <td class=title width="80">점검업체명</td>
            <td width="280">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%}else if(rent_st.equals("8")){%>
    <tr> 
      <td colspan="2">< 사고수리 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">정비공장명</td>
            <td width="160">&nbsp;</td>
            <td class=title width="90">사고일자</td>
            <td width="110">&nbsp;</td>
            <td class=title width="80">담당자</td>
            <td width="280">&nbsp;</td>
          </tr>
          <tr> 
            <td class=title width="80"> 사고내용</td>
            <td colspan="5">&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>
    <%}%>
    <tr> 
      <td colspan="2">< 계약정보 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width='80'>계약번호</td>
            <td width='60'><%=rc_bean.getRent_s_cd()%></td>
            <td class=title width='60'>계약일자</td>
            <td width="80" ><%=AddUtil.ChangeDate2(rc_bean.getRent_dt())%></td>
            <td class=title width='50'>영업소</td>
            <td width="90" ><%=c_db.getNameById(rc_bean.getBrch_id(), "BRCH")%></td>
            <td width="50" class=title>담당자</td>
            <td width="60" ><%=c_db.getNameById(rc_bean.getBus_id(), "USER")%></td>
            <td width="70" class=title>이용기간</td>
            <td width="200" ><%=AddUtil.ChangeDate4(rc_bean.getRent_start_dt())%>~ 
              <%=AddUtil.ChangeDate4(rc_bean.getRent_end_dt())%></td>
          </tr>
          <tr> 
            <td class=title>기타</td>
            <td colspan="9"><%=rc_bean.getEtc()%></td>
          </tr>
        </table>
      </td>
    </tr>
    <tr> 
      <td colspan="2">< 배차/반차 ></td>
    </tr>
    <tr> 
      <td class=line colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="1" width=800>
          <tr> 
            <td class=title width="80">배차예정일시</td>
            <td width="180"><%=AddUtil.ChangeDate4(rc_bean.getDeli_plan_dt())%>시 
            </td>
            <td class=title width="80">반차예정일시</td>
            <td colspan="3"> <%=AddUtil.ChangeDate4(rc_bean.getRet_plan_dt())%>시</td>
          </tr>
          <tr> 
            <td class=title width="80">배차일시</td>
            <td width="180"><%=AddUtil.ChangeDate4(rc_bean.getDeli_dt())%>시 </td>
            <td class=title width="80">반차일시</td>
            <td colspan="3"> <%=AddUtil.ChangeDate4(rc_bean.getRet_dt())%>시</td>
          </tr>
          <tr> 
            <td class=title width="80">배차위치</td>
            <td width="180"><%=rc_bean.getDeli_loc()%></td>
            <td class=title width="80">반차위치</td>
            <td colspan="3"><%=rc_bean.getRet_loc()%></td>
          </tr>
          <tr> 
            <td class=title width="80">배차담당자</td>
            <td width="180"><%=c_db.getNameById(rc_bean.getDeli_mng_id(), "USER")%></td>
            <td class=title width="80">반차담당자</td>
            <td colspan="3"> <%=c_db.getNameById(rc_bean.getRet_mng_id(), "USER")%></td>
          </tr>
          <tr> 
            <td class=title>당초약정시간</td>
            <td> 
              <input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=whitenum readonly>
              시간 
              <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=whitenum readonly>
              일 
              <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=whitenum readonly>
              개월 </td>
            <td class=title>추가이용시간</td>
            <td width="180"> 
              <input type="text" name="add_hour" value="<%=rs_bean.getAdd_hour()%>" size="2" class=<%=white%>num >
              시간 
              <input type="text" name="add_days" value="<%=rs_bean.getAdd_days()%>" size="2" class=<%=white%>num >
              일 
              <input type="text" name="add_months" value="<%=rs_bean.getAdd_months()%>" size="2" class=<%=white%>num >
              개월 </td>
            <td class=title width="80">총이용시간</td>
            <td> 
              <input type="text" name="tot_hour" value="<%=rs_bean.getTot_hour()%>" size="2" class=<%=white%>num >
              시간 
              <input type="text" name="tot_days" value="<%=rs_bean.getTot_days()%>" size="2" class=<%=white%>num >
              일 
              <input type="text" name="tot_months" value="<%=rs_bean.getTot_months()%>" size="2" class=<%=white%>num >
              개월 </td>
          </tr>
          <tr> 
            <td class=title>비고</td>
            <td colspan="5"> 
              <input type="text" name="etc" value="" size="110" class=<%=white%>text>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr align="right"> 
      <td colspan="2"><a href='javascript:self.close();' onMouseOver="window.status=''; return true"><img src="/images/close.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
    </tr>	
  </table>
</form>
<script language='javascript'>
<!--
/*
	getRentTime();

	var fm = document.form1;	
	if(fm.rent_st.value == '1' || fm.rent_st.value == '9'){
		fm.add_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)));
		fm.add_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.add_fee_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)) + toInt(parseDigit(fm.add_etc_amt.value)));
		fm.etc_tot_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ins_m_s_amt.value)) + toInt(parseDigit(fm.ins_h_s_amt.value)) + toInt(parseDigit(fm.oil_s_amt.value)));		
		fm.etc_tot_amt.value 	= parseDecimal(toInt(parseDigit(fm.etc_tot_s_amt.value)) + toInt(parseDigit(fm.ins_m_v_amt.value)) + toInt(parseDigit(fm.ins_h_v_amt.value)) + toInt(parseDigit(fm.oil_v_amt.value)));		
		fm.tot_fee_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_fee_s_amt.value)) + toInt(parseDigit(fm.add_fee_s_amt.value)));
		fm.tot_ins_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_ins_s_amt.value)) + toInt(parseDigit(fm.add_ins_s_amt.value)));
		fm.tot_etc_s_amt.value 	= parseDecimal(toInt(parseDigit(fm.ag_etc_s_amt.value)) + toInt(parseDigit(fm.add_etc_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.rent_tot_s_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_s_amt.value)) + toInt(parseDigit(fm.add_tot_s_amt.value)) + toInt(parseDigit(fm.etc_tot_s_amt.value)));
		fm.s_rent_tot_amt.value = parseDecimal(toInt(parseDigit(fm.ag_tot_amt.value)) + toInt(parseDigit(fm.add_tot_amt.value)) + toInt(parseDigit(fm.etc_tot_amt.value)));
		if(fm.rent_st.value == '1'){
			fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)) + toInt(parseDigit(fm.d_pay_tot_amt.value)));
		}else{
			fm.rent_sett_amt.value 	= parseDecimal(toInt(parseDigit(fm.s_rent_tot_amt.value)) - toInt(parseDigit(fm.pay_tot_amt.value)));		
		}
	}
*/	
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
