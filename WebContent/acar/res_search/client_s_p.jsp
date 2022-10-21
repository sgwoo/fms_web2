<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.res_search.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cust_st 	= request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	String from_page= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String rent_start_dt= request.getParameter("rent_start_dt")==null?"":request.getParameter("rent_start_dt");
	
	//로그인ID&영업소ID&권한
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals(""))	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals("")) 	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "02", "01", "01");
	
	String h_con 	= request.getParameter("h_con")==null?"1":request.getParameter("h_con");
	String h_wd 	= request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
	
	if(cust_st.equals("4")) h_con = "2";
//	if(rent_st.equals("1") && h_con.equals("")) 			h_con = "2";
//	else if(!rent_st.equals("1") && h_con.equals("")) 		h_con = "1";
%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function select(gubun,rank,cust_st,cust_id,cust_nm,firm_nm,ssn,enp_no,lic_no,lic_st,tel,m_tel,zip,addr,car_no,car_nm,c_id,l_cd,age_scp,site_id,mng_id,mng_nm,ven_code,car_st,rent_way,twomon_yn,rent_start_dt, maint_st_dt, maint_end_dt, car_end_dt, test_st_dt, test_end_dt ){		
		var fm = document.form1;
		var ofm = opener.document.form1;
		if(rank == '불량'){
			alert("선택한 고객은 불량고객입니다.\n확인하십시오.");
			return;
		}
		if(gubun == 'l'){
			ofm.cust_st.value = '1';			
		}else if(gubun == 'u'){
			ofm.cust_st.value = '4';						
		}else if(gubun == 's'){
			ofm.cust_st.value = '1';				
		}
		if(fm.rent_st.value == '2' || fm.rent_st.value == '3'){
			ofm.car_no.value = car_no;		
			ofm.car_nm.value = car_nm;					
			ofm.sub_c_id.value = c_id;
			<%if(from_page.equals("/acar/rent_mng/res_rent_u.jsp")){%>
			<%}else{%>			
			ofm.serv_maint_st_dt.value = maint_st_dt;
			ofm.serv_maint_end_dt.value = maint_end_dt;
			ofm.serv_car_end_dt.value = car_end_dt;
			ofm.serv_test_st_dt.value = test_st_dt;
			ofm.serv_test_end_dt.value = test_end_dt;
			<%}%>
			
		}
		ofm.c_cust_id.value = cust_id;
		//ofm.c_cust_st.value = cust_st;
		ofm.c_cust_nm.value = cust_nm;		
		ofm.c_firm_nm.value = firm_nm;
		ofm.c_ssn.value = ssn;
		if(cust_st !='법인' ) ofm.c_ssn.value = ssn.substring(0,6);
		ofm.c_enp_no.value = enp_no;
		ofm.c_zip.value = zip;
		ofm.c_addr.value = addr;		
		ofm.c_lic_no.value = lic_no;		
		ofm.c_lic_st.value = lic_st;
		ofm.c_tel.value = tel;
		ofm.c_m_tel.value = m_tel;
		ofm.c_car_no.value = car_no;		
		ofm.sub_l_cd.value = l_cd;	
		ofm.site_id.value = site_id;
		
		<%	if(rent_st.equals("2") || rent_st.equals("3") || rent_st.equals("10")){%>
		if(age_scp == '1') ofm.d_car_ins_age.value = '21세이상';
		if(age_scp == '2') ofm.d_car_ins_age.value = '26세이상';
		if(age_scp == '3') ofm.d_car_ins_age.value = '모든운전자';
		if(age_scp == '4') ofm.d_car_ins_age.value = '24세이상';
		if(age_scp == '5') ofm.d_car_ins_age.value = '30세이상';
		if(age_scp == '6') ofm.d_car_ins_age.value = '35세이상';
		if(age_scp == '7') ofm.d_car_ins_age.value = '43세이상';
		if(age_scp == '8') ofm.d_car_ins_age.value = '48세이상';
		if(age_scp == '9') ofm.d_car_ins_age.value = '22세이상';
		if(age_scp == '10') ofm.d_car_ins_age.value = '28세이상';
		if(age_scp == '11') ofm.d_car_ins_age.value = '35세이상~49세이하';
		if(age_scp == '') ofm.d_car_ins_age.value = '';	//	<--추가(2018.01.02) 차량을 바꿔도 보험연령이 공백인 경우 새로 세팅되지않아 상위창에서 confirm 호출됨.
		ofm.d_car_ins_age_cd.value = age_scp;
		<%	}%>
		
		<%if(rent_st.equals("2") && from_page.equals("/acar/res_search/res_rent_i2.jsp")){%>
		ofm.car_st.value = car_st;
		ofm.rent_way.value = rent_way;
		ofm.twomon_yn.value = twomon_yn;
		ofm.sub_rent_start_dt.value = rent_start_dt;
		
		if(rent_way == '1') ofm.rent_way_nm.value = '일반식';
		if(rent_way == '3') ofm.rent_way_nm.value = '기본식';
		
		ofm.rent_way_nm.value = ofm.rent_way_nm.value+" "+rent_start_dt;
		
		if(rent_way == '3' && twomon_yn =='Y'){			
			var con_mon = getRentTimeChk('m', rent_start_dt, '<%=rent_start_dt%>');
			
						
			//정비대차시작일이 대여개시일 2개월이후인지 확인
			if(con_mon >1){
				twomon_yn = 'Y';
			}else{
				twomon_yn = 'N';
			}
		}
			
		if(car_st != '5' && rent_way == '3' && twomon_yn =='Y'){			
			opener.tr_fee0.style.display	= '';	
			opener.tr_fee1.style.display	= '';	
			opener.tr_fee2.style.display	= '';	
			opener.getFee_sam();
		}
		<%}%>
		
		
		<%if(from_page.equals("/acar/rent_mng/res_rent_u.jsp")){%>
		<%}else{%>					
		window.opener.checkClient_st(cust_st);
		<%}%>
		self.close();			
	}
	
	function search(){
		var fm = document.form1;
		fm.h_con.value = fm.s_con.options[fm.s_con.selectedIndex].value;
		fm.h_wd.value =  fm.t_wd.value;
		fm.action='client_s_in.jsp';
		fm.target='inner';
		fm.submit();
	}
	
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
	
	//등록
	function save(){
		var fm = document.form1;
		fm.action='client_i_p.jsp';
		fm.target='CLIENT_SEARCH';
		fm.submit();
	}	
	
	//대여일수 구하기
	function getRentTimeChk(st, dt1, dt2) {
		var fm = document.form1;	
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  		// 1시간
		lm = 60*1000;  	 	 	// 1분
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
//-->
</script>
</head>

<body onLoad="javascript:document.form1.t_wd.focus();">
<center>
<form name='form1' action='' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='cust_st' value='<%=cust_st%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > <span class=style5>고객검색</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td>			
            <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                    <td align='left' width="80%">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gshm.gif align=absmiddle>&nbsp; 
                        <select name='s_con'>
                          <option value='1' <%if(h_con.equals("1")){%> selected <%}%>>상호 
                          </option>
                          <option value='2' <%if(h_con.equals("2")){%> selected <%}%>>성명</option>
                          <option value='3' <%if(h_con.equals("3")){%> selected <%}%>>생년월일/사업자번호</option>
                          <%if(!rent_st.equals("1")){%>
                          <option value='4' <%if(h_con.equals("4")){%> selected <%}%>>차량번호</option>
                          <%}%>
                        </select>
                        <input type='text' name='t_wd' size='15' class='text' value='<%=h_wd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
                        <a href='javascript:search()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_search.gif"  align="absmiddle" border="0"></a> 
                    </td>
                    <td align='right' width="20%">
    			    <%if(rent_st.equals("1") || rent_st.equals("9")){%>
    				  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>			  
    			    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif"  align="absmiddle" border="0"></a>
    				  <%}%>
    			    <%}%>
    			    </td>
                </tr>
            </table>
	    </td>
	</tr>
	<tr>
	    <td>
		    <iframe src="<%if(!h_wd.equals("")){%>client_s_in.jsp?rent_st=<%=rent_st%>&h_con=<%=h_con%>&h_wd=<%=h_wd%>&cust_st=<%=cust_st%>&from_page=<%=from_page%><%}%>" name="inner" width="100%" height="600" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
	    </td>
	</tr>
</table>
</form>
</center>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
