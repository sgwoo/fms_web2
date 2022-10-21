<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.res_search.*, acar.util.*, acar.user_mng.*, acar.cont.* "%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<jsp:useBean id="a_db"      class="acar.cont.AddContDatabase"          scope="page"/>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<%@ include file="/agent/cookies.jsp" %>

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

	String s_cd = request.getParameter("s_cd")==null?"":request.getParameter("s_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String f_page = request.getParameter("f_page")==null?"":request.getParameter("f_page");
	String end_est_yn 	= request.getParameter("end_est_yn")	==null?"":request.getParameter("end_est_yn");

	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "05", "02");

	CommonDataBase c_db = CommonDataBase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();

	Vector users = c_db.getUserList("", "", "EMP"); //담당자 리스트
	int user_size = users.size();

	//차량정보
	Hashtable reserv = rs_db.getCarInfo(c_id);

	//단기계약정보
	RentContBean rc_bean = rs_db.getRentContCase(s_cd, c_id);
	//고객정보
	RentCustBean rc_bean2 = rs_db.getRentCustCase(rc_bean.getCust_st(), rc_bean.getCust_id());
	String rent_st = rc_bean.getRent_st();

	//단기대여정보
	RentFeeBean rf_bean = rs_db.getRentFeeCase(s_cd);
	
	//원인차량정보
	Hashtable reserv2 = rs_db.getCarInfo(rc_bean.getSub_c_id());

	//주차장 정보
	  CodeBean[] goods = c_db.getCodeAll3("0027");
	  int good_size = goods.length;

	//지연대차이면서 장기계약번호가 없는경우 출고전대차에서 가져와서 처리..
	if(rc_bean.getRent_st().equals("10") && rc_bean.getSub_l_cd().equals("")){
		ContTaechaBean taecha = a_db.getTaechaRes(s_cd, c_id);
		if(!taecha.getRent_l_cd().equals("")){
			rc_bean.setSub_l_cd		(taecha.getRent_l_cd());
			int rs_count = rs_db.updateRentCont(rc_bean);
			System.out.println("##["+rc_bean2.getFirm_nm()+"]지연대차 반차화면 팝업시 계약-출고지연대차 자동 연동!! ");
		}
	}



	String ment = "";
	String gubun = "";

	if(mode.equals("R")){
		if((rc_bean.getRent_st().equals("2") || rc_bean.getRent_st().equals("6")) && rc_bean.getServ_id().equals("")){
			if(rent_st.equals("2") && rf_bean.getRent_tot_amt() > 0){
			}else{
				ment = "정비와 연결되지 않았습니다. 확인하십시오.";
				gubun = "s";
			}
		}else if((rc_bean.getRent_st().equals("3") || rc_bean.getRent_st().equals("8")) && rc_bean.getAccid_id().equals("")){
			ment = "사고와 연결되지 않았습니다. 확인하십시오.";
			gubun = "a";
		}else if(rc_bean.getRent_st().equals("10") && rc_bean.getSub_l_cd().equals("")){
			ment = "계약과 연결되지 않았습니다. 확인하십시오.";
			gubun = "t";
		}
	}

	if(rc_bean.getDeli_mng_id().equals("")){
		//담당자
		user_bean 	= umd.getUsersBean(user_id);
	}else{
		//담당자
		user_bean 	= umd.getUsersBean(rc_bean.getDeli_mng_id());
	}

	String r_park = "";
	//예비차 관리지점으로 차량현위치와 점검할것
	for(int i = 0 ; i < good_size ; i++){
 		CodeBean good = goods[i];
	  if( (String.valueOf(reserv.get("MNG_BR_ID")).equals("S1")|| String.valueOf(reserv.get("MNG_BR_ID")).equals("S2")|| String.valueOf(reserv.get("MNG_BR_ID")).equals("I1")) & good.getNm_cd().equals("1")){ 
	  	r_park = good.getNm_cd();
	  }else if( String.valueOf(reserv.get("MNG_BR_ID")).equals("B1") & good.getNm_cd().equals("8")){
	  	r_park = good.getNm_cd();
	  }else if( String.valueOf(reserv.get("MNG_BR_ID")).equals("D1") & good.getNm_cd().equals("4")){
	  	r_park = good.getNm_cd();
	  }else if( String.valueOf(reserv.get("MNG_BR_ID")).equals("J1") & good.getNm_cd().equals("12")){
	  	r_park = good.getNm_cd();
	  }else if( String.valueOf(reserv.get("MNG_BR_ID")).equals("G1") & good.getNm_cd().equals("13")){
	  	r_park = good.getNm_cd();
	  }
	}
%>

<html>
<head>

<title>예약시스템 <%if(mode.equals("R")){%>반차처리<%}else{%>기간연장<%}%></title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='JavaScript'>
<!--
	//저장하기
	function save(){
		var fm = document.form1;
		if(fm.mode.value == 'R'){
			if((fm.rent_st.value == '10') && fm.sub_l_cd.value == '' && fm.ment.value != ''){ alert('계약과 연결되지 않았습니다. 확인하십시오.'); 	return; }
			if(fm.ret_dt.value == ''){ 		alert('반차일시를 입력하십시오'); 			fm.ret_dt.focus(); 			return; }
			if(fm.ret_loc.value == ''){ 		alert('반차위치를 입력하십시오'); 			fm.ret_loc.focus(); 			return; }
			if(fm.ret_mng_id.value == ''){ 		alert('반차담당자를 선택하십시오'); 			fm.ret_mng_id.focus(); 			return; }
			if(fm.ret_dt.value != '')
				fm.h_ret_dt.value = fm.ret_dt.value+fm.ret_dt_h.value+fm.ret_dt_s.value;

			if(replaceString('-','',fm.h_ret_dt.value) == fm.h_deli_dt.value){ alert('배차일시와 반차일시가 같으면 반차처리되지 않습니다. 취소처리 하세요.'); return; }
			
			if(fm.park.value == '' || (fm.park.value == '6' && fm.park_cont.value == '')){
					alert('차량현위치를 입력하십시오.');
					return;
			}else{
				if('<%=r_park%>'!='' && '<%=r_park%>'!=fm.park.value){
					if(!confirm('보유차 관리지점과 입력한 차량현위치가 다릅니다. 등록하시겠습니까?')){	return;	}
				}
			}

		}else{
			if(fm.add_dt.value == ''){ 		alert('연장일자를 입력하십시오'); 			fm.add_dt.focus(); 			return; }
		}
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.action = 'res_action_a.jsp';
		fm.target = 'i_no';
		fm.submit();
	}

	//대여일수 구하기
	function getRentTime() {
		var fm = document.form1;
		if(fm.rent_st.value == '1') 	return;
		if(fm.ret_dt.value == ''){ alert('반차일자를 입력하십시오'); fm.ret_dt.focus(); return; }
		if(fm.h_rent_end_dt.value == '')	fm.h_rent_end_dt.value = replaceString('-','',fm.ret_dt.value)+fm.ret_dt_h.value+fm.ret_dt_s.value;

		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  		// 1시간
		lm = 60*1000;  	 	 	// 1분
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
		d4 = replaceString('-','',fm.ret_dt.value)+fm.ret_dt_h.value+fm.ret_dt_s.value;

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
			if(fm.rent_months.value == '0' && fm.rent_days.value == '0' && fm.rent_hour.value == '0'){
				fm.rent_months.value = parseInt(t3/m);
				fm.rent_days.value = parseInt((t3%m)/l);
				fm.rent_hour.value = parseInt(((t3%m)%l)/lh);
			}
			fm.tot_months.value = fm.rent_months.value;
			fm.tot_days.value = fm.rent_days.value;
			fm.tot_hour.value = fm.rent_hour.value;

		}else{//초과 or 미만
			if(parseInt(fm.rent_months.value)+parseInt(fm.rent_days.value)+parseInt(fm.rent_hour.value) > 0 ){
				fm.add_months.value 	= parseInt((t6-t3)/m);
				fm.add_days.value 	= parseInt(((t6-t3)%m)/l);
				fm.add_hour.value 	= parseInt((((t6-t3)%m)%l)/lh);
			}
				fm.tot_months.value 	= parseInt(t6/m);
				fm.tot_days.value 	= parseInt((t6%m)/l);
				fm.tot_hour.value 	= parseInt(((t6%m)%l)/lh);

		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}


//-->
</script>
</head>
<body>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<form action="" name="form1" method="post" >
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun1' value='<%=gubun1%>'>
 <input type='hidden' name='gubun2' value='<%=gubun2%>'>
 <input type='hidden' name='brch_id' value='<%=brch_id%>'>
 <input type='hidden' name='start_dt' value='<%=start_dt%>'>
 <input type='hidden' name='end_dt' value='<%=end_dt%>'>
 <input type='hidden' name='car_comp_id' value='<%=car_comp_id%>'>
 <input type='hidden' name='code' value='<%=code%>'>
 <input type='hidden' name='s_kd'  value='<%=s_kd%>'>
 <input type='hidden' name='t_wd' value='<%=t_wd%>'>
 <input type='hidden' name='s_cc' value='<%=s_cc%>'>
 <input type='hidden' name='s_year' value='<%=s_year%>'>
 <input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
 <input type='hidden' name='asc' value='<%=asc%>'>

<input type='hidden' name='s_cd' value='<%=s_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='mode' value='<%=mode%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='f_page' value='<%=f_page%>'>
 <input type='hidden' name='h_rent_start_dt' value='<%=rc_bean.getRent_start_dt()%>'>
 <input type='hidden' name='h_rent_end_dt' value='<%=rc_bean.getRent_end_dt()%>'>
 <input type='hidden' name='h_deli_dt' value='<%=rc_bean.getDeli_dt()%>'>
 <input type='hidden' name='h_ret_dt' value='<%=rc_bean.getRet_dt()%>'>
 <input type='hidden' name='ment' value='<%=ment%>'>
 <input type="hidden" name="serv_id" value="<%=rc_bean.getServ_id()%>">
 <input type="hidden" name="accid_id" value="<%=rc_bean.getAccid_id()%>">
 <input type='hidden' name='sub_c_id' value='<%=rc_bean.getSub_c_id()%>'>
 <input type='hidden' name='sub_l_cd' value='<%=rc_bean.getSub_l_cd()%>'>
 <input type='hidden' name='c_car_no' value='<%=rc_bean2.getCar_no()%>'>
 <input type='hidden' name='serv_dt' value=''>
 <input type='hidden' name='car_nm' value=''>
 <input type='hidden' name='our_num' value=''>
 <input type='hidden' name='ins_nm' value=''>
 <input type='hidden' name='ins_mng_nm' value=''>
 <input type='hidden' name='car_no' value='<%=reserv.get("CAR_NO")%>'>
 <input type='hidden' name='c_firm_nm' value='<%=rc_bean2.getFirm_nm()%>'>
 <input type='hidden' name='c_client_nm' value='<%=rc_bean2.getCust_nm()%>'>
 <input type='hidden' name='from_page' value='/acar/rent_mng/res_action.jsp'>
 <input type='hidden' name='end_est_yn' value='<%=end_est_yn%>'>

<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
    	<td colspan=10>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>차량관리>대차관리 > 반차관리 > <span class=style5><%if(mode.equals("R")){%>반차처리<%}else{%>기간연장<%}%></span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title width=12%>계약구분</td>
                    <td width=15%>&nbsp;
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
                    </td>
                    <td class=title width=10%>차량번호</td>
                    <td width=10%>&nbsp;<%=reserv.get("CAR_NO")%></td>
                    <td class=title width=8%>성명</td>
                    <td width=10%>&nbsp;<%=rc_bean2.getCust_nm()%></td>
                    <td class=title width=8%>상호</td>
                    <td>&nbsp;
                            <%=rc_bean2.getFirm_nm()%>
                    </td>
                </tr>                
                <tr> 
                    <td class=title>차명</td>
                    <td colspan="7">&nbsp;<%=reserv.get("CAR_NM")%>&nbsp;<%=reserv.get("CAR_NAME")%> (<%=reserv.get("SECTION")%>)</td>
                </tr>  
                <tr>
                    <td class=title>대여기간</td>
                    <td colspan="5">&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRent_start_dt())%>
                     ~ <%=AddUtil.ChangeDate3(rc_bean.getRent_end_dt())%></td>
                    <td class=title width=8%>배차일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getDeli_dt())%></td>
                </tr>
                <tr> 
                    <td class=title>보유차관리지점</td>
                    <td colspan="7">&nbsp;<%=c_db.getNameById(String.valueOf(reserv.get("MNG_BR_ID")),"BRCH")%>
                     </td>                    
                </tr>                   
            </table>
        </td>
    </tr>
    <%if(!rc_bean.getSub_c_id().equals("")){     	
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    
                <tr>            
                    <td class=title width=12%>차량번호</td>
                    <td width=15%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %>   
    <%if(rc_bean.getSub_c_id().equals("") && !rc_bean.getSub_l_cd().equals("")){ 
    	//차량정보
    	reserv2 = a_db.getRentBoardSubCase(rc_bean.getSub_l_cd());
    %>     	
    <tr> 
        <td colspan="2"><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>원인차량</span></td>
    </tr>
    <tr><td class=line2></td></tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>    
                <tr>            
                    <td class=title width=12%>차량번호</td>
                    <td width=15%>&nbsp;<%=reserv2.get("CAR_NO")%></td>
                    <td class=title width=10%>차명</td>
                    <td>&nbsp;<%=reserv2.get("CAR_NM")%>&nbsp;<%=reserv2.get("CAR_NAME")%></td>
                </tr>                
            </table>
        </td>
    </tr>    
    <%} %> 
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%if(!ment.equals("")){%>
	<tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
				<%if(rent_st.equals("10") && rc_bean.getSub_l_cd().equals("")){//지연대차 조회%>
                <tr>
                    <td class=title width=23%>장기계약</td>
                    <td>
                      &nbsp;<a href="javascript:cont_select()"><img src=/acar/images/center/button_in_search1.gif align=absmiddle border=0></a>
					  <input type="text" name="rent_l_cd" value="" size="45" class=whitetext>
                    </td>
                </tr>
				<%}%>
            </table>
        </td>
    </tr>
    <tr>
        <td>&nbsp;</td>
    </tr>
	<%}%>
	<%if(mode.equals("R")){%>
	<tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td class=title rowspan="5" width=5%>반<br>차</td>
                    <td class=title width=18%>반차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
                </tr>
                <tr>
                    <td class=title>반차일시</td>
                    <td>
                      &nbsp;<input type="text" name="ret_dt" value="<%=AddUtil.getDate()%>" size="11" <%if(rc_bean.getBus_id().equals(user_id) || rc_bean.getMng_id().equals(user_id) || rc_bean.getReg_id().equals(user_id)){%>class=text<%}else{%>class=whitetext readonly<%}%> onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'><!--onBlur='javscript:this.value = ChangeDate(this.value); getRentTime();'-->
                      <select name="ret_dt_h" onchange="javscript:getRentTime();">
                        <%for(int i=0; i<24; i++){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_h().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>시</option>
                        <%}%>
                      </select>
                      <select name="ret_dt_s" onchange="javscript:getRentTime();">
                        <%for(int i=0; i<59; i+=5){%>
                        <option value="<%=AddUtil.addZero2(i)%>" <%if(rc_bean.getRet_plan_dt_s().equals(AddUtil.addZero2(i))){%>selected<%}%>><%=AddUtil.addZero2(i)%>분</option>
                        <%}%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title>반차위치</td>
                    <td>
                      &nbsp;<input type="text" name="ret_loc" value="<%=rc_bean.getRet_loc()%>" size="50" class=text style='IME-MODE: active'>
                    </td>
                </tr>
                <tr>
                    <td class=title>차량현위치</td>
                    <td>&nbsp;
						<SELECT NAME="park" >
							<option value="">선택</option>
							<%for(int i = 0 ; i < good_size ; i++){
	                  				CodeBean good = goods[i];%>
	                        <option value='<%= good.getNm_cd()%>'><%= good.getNm()%></option>
	                        <%}%>
        		        </SELECT>
						<input type="text" name="park_cont" value="" size="35" class=text style='IME-MODE: active'>
						(기타선택시 내용)
                    </td>
                </tr>
                <tr>
                    <td class=title>반차담당자</td>
                    <td>
                      &nbsp;<select name='ret_mng_id'>
                        <option value="">미지정</option>
                        <%if(user_size > 0){
        					for (int i = 0 ; i < user_size ; i++){
        						Hashtable user = (Hashtable)users.elementAt(i);	%>
                        <option value='<%=user.get("USER_ID")%>' <%if(rc_bean.getDeli_mng_id().equals(String.valueOf(user.get("USER_ID")))){%>selected<%}%>><%=user.get("USER_NM")%></option>
                        <%	}
        				}%>
                      </select>
                    </td>
                </tr>
                <tr>
                    <td class=title rowspan="4">정<br>산</td>
                    <td class=title>당초약정시간</td>
                    <td>
                      &nbsp;<input type="text" name="rent_hour" value="<%=rc_bean.getRent_hour()%>" size="2" class=num>
                      시간
                      <input type="text" name="rent_days" value="<%=rc_bean.getRent_days()%>" size="2" class=num>
                      일
                      <input type="text" name="rent_months" value="<%=rc_bean.getRent_months()%>" size="2" class=num>
                      개월 </td>
                </tr>
                <tr>
                    <td class=title>추가이용시간</td>
                    <td>
                      &nbsp;<input type="text" name="add_hour" value="" size="2" class=num >
                      시간
                      <input type="text" name="add_days" value="" size="2" class=num >
                      일
                      <input type="text" name="add_months" value="" size="2" class=num >
                      개월 </td>
                </tr>
                <tr>
                    <td class=title>총이용시간</td>
                    <td>
                      &nbsp;<input type="text" name="tot_hour" value="" size="2" class=num >
                      시간
                      <input type="text" name="tot_days" value="" size="2" class=num >
                      일
                      <input type="text" name="tot_months" value="" size="2" class=num >
                      개월 </td>
                </tr>
                <tr>
                    <td class=title>비고</td>
                    <td>
                      &nbsp;<input type="text" name="etc" value="" size="50" class=text>
                    </td>
                </tr>
                <tr>
                    <td class=title colspan='2'>누적주행거리</td>
                    <td>
                      &nbsp;<input type="text" name="run_km" value="" size="10" class=text>
                      &nbsp;km </td>
                </tr>
            </table>
        </td>
    </tr>


	<%}else if(mode.equals("A")){%>


	<tr><td class=line2></td></tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" cellpadding="1" width=100%>
                <tr>
                    <td class=title rowspan="2" width=5%>연<br>장</td>
                    <td class=title width=15%>반차예정일시</td>
                    <td>&nbsp;<%=AddUtil.ChangeDate3(rc_bean.getRet_plan_dt())%></td>
                </tr>
                <tr>
                    <td class=title>연장일자</td>
                    <td>
                      &nbsp;<input type="text" name="add_dt" value="" size="11" class=text onBlur='javscript:this.value = ChangeDate(this.value);'>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%}%>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="right">
	  	<%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		 <a href='javascript:save();'><img src="/acar/images/center/button_conf.gif" border="0" align=absmiddle></a>
	  	<%}%>
		&nbsp;<a href="javascript:window.close()"><img src="/acar/images/center/button_close.gif"  border="0" align=absmiddle></a>
	    </td>
	</tr>
    <tr>
        <td class=h></td>
    </tr>    
    <tr> 
        <td>&nbsp;</td>
    </tr> 
    <tr>
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>주차장 입출고현황</span> (10일전~당일)</td>
    <tr>	    
    <tr><td class=line2></td></tr>
    <%
    	Vector p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv.get("CAR_NO")), rs_db.addDay(AddUtil.getDate(4), -10), AddUtil.getDate(4));
    %>  
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>  
                <tr>               
                    <td class=title width=10%>구분</td>
                    <td class=title width=10%>담당자</td>
                    <td class=title width=15%>차량운전자</td>
                    <td class=title width=20%>주차장</td>
                    <td class=title width=10%>구분</td>
                    <td class=title width=20%>입/출고 일시</td>
                    <td class=title width=15%>등록자</td>
                </tr>     
                <%
                	if(p_vt.size() > 0 ){
            			for(int i=0; i < p_vt.size(); i++){            			
            				Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">대차차량</td>
                    <td align="center">&nbsp;<%=p_ht.get("USERS_COMP")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center">&nbsp;<%if(p_ht.get("IO_GUBUN").equals("1")){%>입고<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>출고<%}%></td>
                    <td align="center">&nbsp;<%=p_ht.get("REG_DT")%></td>
                    <td align="center">&nbsp;<%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%		}
            		}%>
            	<%	if(!String.valueOf(reserv2.get("CAR_NO")).equals("")){
            			p_vt = pk_db.getPark_IO_list("", "1", "4", "", String.valueOf(reserv2.get("CAR_NO")), rs_db.addDay(AddUtil.getDate(4), -10), AddUtil.getDate(4)); %>
            	<%
                		if(p_vt.size() > 0 ){%>
                <tr>
                    <td class=h colspan='7'></td>
                </tr>	
            	<%			for(int i=0; i < p_vt.size(); i++){            			
            					Hashtable p_ht = (Hashtable)p_vt.elementAt(i);
                %>           
                <tr>               
                    <td align="center">원인차량</td>
                    <td align="center"><%=p_ht.get("USERS_COMP")%></td>
                    <td align="center"><%=p_ht.get("DRIVER_NM")%></td>
                    <td align="center"><%=p_ht.get("PARK_PLACE")%></td>
                    <td align="center"><%if(p_ht.get("IO_GUBUN").equals("1")){%>입고<%}else if(p_ht.get("IO_GUBUN").equals("2")){%>출고<%}%></td>
                    <td align="center"><%=p_ht.get("REG_DT")%></td>
                    <td align="center"><%=p_ht.get("PARK_MNG")%></td>
                </tr>                
                <%			}
                		}
            		}%>	
            </table>
        </td>
    </tr>  	
</table>
</form>
<script language="JavaScript">
<!--

<%if(mode.equals("R")){%>
	getRentTime();
<%}%>

//-->
</script>
</body>
</html>
