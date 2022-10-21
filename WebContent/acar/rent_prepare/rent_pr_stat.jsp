<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.res_search.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function set_su(){
		var fm = document.form1;	

		//운행차 가로 합계
		for(i=1; i<7 ; i++){
			fm.su1[10].value = toInt(fm.su1[10].value) + toInt(fm.su1[i+3].value);
			fm.su2[10].value = toInt(fm.su2[10].value) + toInt(fm.su2[i+3].value);			
			fm.su3[10].value = toInt(fm.su3[10].value) + toInt(fm.su3[i+3].value);
			fm.su4[10].value = toInt(fm.su4[10].value) + toInt(fm.su4[i+3].value);
			fm.su5[10].value = toInt(fm.su5[10].value) + toInt(fm.su5[i+3].value);
		}	
		fm.su1[0].value = toInt(fm.su1[10].value);
		fm.su2[0].value = toInt(fm.su2[10].value);
		fm.su3[0].value = toInt(fm.su3[10].value);
		fm.su4[0].value = toInt(fm.su4[10].value);
		fm.su5[0].value = toInt(fm.su5[10].value);			

		//운휴차-보유 가로 합계
		for(i=1; i<7 ; i++){
			fm.su1[17].value = toInt(fm.su1[17].value) + toInt(fm.su1[i+10].value);
			fm.su2[17].value = toInt(fm.su2[17].value) + toInt(fm.su2[i+10].value);			
			fm.su3[17].value = toInt(fm.su3[17].value) + toInt(fm.su3[i+10].value);
			fm.su4[17].value = toInt(fm.su4[17].value) + toInt(fm.su4[i+10].value);
			fm.su5[17].value = toInt(fm.su5[17].value) + toInt(fm.su5[i+10].value);					}
		
		fm.su1[1].value = toInt(fm.su1[17].value);
		fm.su2[1].value = toInt(fm.su2[17].value);
		fm.su3[1].value = toInt(fm.su3[17].value);
		fm.su4[1].value = toInt(fm.su4[17].value);
		fm.su5[1].value = toInt(fm.su5[17].value);		
		
		//운휴차-매각진행 가로 합계
		for(i=1; i<4 ; i++){
			fm.su1[21].value = toInt(fm.su1[21].value) + toInt(fm.su1[i+17].value);
			fm.su2[21].value = toInt(fm.su2[21].value) + toInt(fm.su2[i+17].value);			
			fm.su3[21].value = toInt(fm.su3[21].value) + toInt(fm.su3[i+17].value);
			fm.su4[21].value = toInt(fm.su4[21].value) + toInt(fm.su4[i+17].value);
			fm.su5[21].value = toInt(fm.su5[21].value) + toInt(fm.su5[i+17].value);					}
		
		fm.su1[2].value = toInt(fm.su1[21].value);
		fm.su2[2].value = toInt(fm.su2[21].value);
		fm.su3[2].value = toInt(fm.su3[21].value);
		fm.su4[2].value = toInt(fm.su4[21].value);
		fm.su5[2].value = toInt(fm.su5[21].value);		
		
		//총합계			
		fm.su1[3].value = toInt(fm.su1[0].value) + toInt(fm.su1[1].value) + toInt(fm.su1[2].value);
		fm.su2[3].value = toInt(fm.su2[0].value) + toInt(fm.su2[1].value) + toInt(fm.su2[2].value);
		fm.su3[3].value = toInt(fm.su3[0].value) + toInt(fm.su3[1].value) + toInt(fm.su3[2].value);
		fm.su4[3].value = toInt(fm.su4[0].value) + toInt(fm.su4[1].value) + toInt(fm.su4[2].value);
		fm.su5[3].value = toInt(fm.su5[0].value) + toInt(fm.su5[1].value) + toInt(fm.su5[2].value);							
			
		//운행차 세로 합계
		for(i=0; i<22 ; i++){
			fm.su6[i].value = toInt(fm.su1[i].value) + toInt(fm.su2[i].value) + toInt(fm.su3[i].value) + toInt(fm.su4[i].value) + toInt(fm.su5[i].value);		
		}
		
		fm.su7.value = toInt(fm.su6[0].value) + toInt(fm.su6[1].value);
		
		//비율계산
		for(i=0 ; i<22 ; i++){
			fm.per1[i].value = parseFloatCipher3(toInt(fm.su1[i].value) / toInt(fm.su6[3].value)*100, 1);
			fm.per2[i].value = parseFloatCipher3(toInt(fm.su2[i].value) / toInt(fm.su6[3].value)*100, 1);
			fm.per3[i].value = parseFloatCipher3(toInt(fm.su3[i].value) / toInt(fm.su6[3].value)*100, 1);
			fm.per4[i].value = parseFloatCipher3(toInt(fm.su4[i].value) / toInt(fm.su6[3].value)*100, 1);
			fm.per5[i].value = parseFloatCipher3(toInt(fm.su5[i].value) / toInt(fm.su6[3].value)*100, 1);
			fm.per6[i].value = parseFloatCipher3(toInt(fm.su6[i].value) / toInt(fm.su6[3].value)*100, 1);
		}		

	}
	
	function move_page(gubun2){
		var fm = document.form1;
		if(gubun2 == 20){//대기
			fm.gubun2.value = '11';
			fm.action = '/acar/rent_prepare/rent_pr_frame_s.jsp';
		}else if(gubun2 == 21){//예약
			fm.gubun2.value = '12';		
			fm.action = '/acar/rent_prepare/rent_pr_frame_s.jsp';
		}else if(gubun2 == 22){//매각에정
			fm.gubun2.value = '2';		
			fm.action = '/acar/rent_prepare/rent_pr_frame_s.jsp';
		}else if(gubun2 == 23){//해지도난
			fm.gubun2.value = '16';		
			fm.action = '/acar/rent_prepare/rent_pr_frame_s.jsp';
		}else if(gubun2 == 31){//매각결정현황
			fm.action = '/acar/off_ls_pre/off_ls_pre_frame.jsp';
		}else if(gubun2 == 32){//출품현황
			fm.action = '/acar/off_ls_jh/off_ls_jh_frame.jsp';
		}else if(gubun2 == 33){//낙찰현황
			fm.action = '/acar/off_ls_cmplt/off_ls_cmplt_frame.jsp';
		}else{
			fm.gubun2.value = gubun2;		
			fm.action = '/acar/rent_mng/rent_mn_frame_s.jsp';		
		}
		fm.submit();							
	}
//-->
</script>
</head>
<body leftmargin="15">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	Vector cars = rs_db.getStatCar();
	int car_size = cars.size();
	
	int cnt[] = new int[76];
	
	for(int i = 0 ; i < car_size ; i++){
		Hashtable car = (Hashtable)cars.elementAt(i);
		String car_kd 	= String.valueOf(car.get("CAR_KD"));
		String prepare 	= String.valueOf(car.get("PREPARE"));
		String off_ls 	= String.valueOf(car.get("OFF_LS"));
		String rent_st 	= String.valueOf(car.get("RENT_ST"));
		String su 		= String.valueOf(car.get("SU"));
		
		//운행차-단기-일반
		if     ((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("1"))														cnt[1] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("1"))														cnt[2] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("1"))														cnt[3] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("1"))								cnt[4] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("1"))		cnt[5] += AddUtil.parseInt(su);
		//운행차-단기-보험
		else if(car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("9"))														cnt[6] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("9"))														cnt[7] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("9"))														cnt[8] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("9"))								cnt[9] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("9"))		cnt[10] += AddUtil.parseInt(su);
		//운행차-대차-정비
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("2"))														cnt[11] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("2"))														cnt[12] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("2"))														cnt[13] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("2"))								cnt[14] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("2"))		cnt[15] += AddUtil.parseInt(su);
		//운행차-대차-사고
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("3"))														cnt[16] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("3"))														cnt[17] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("3"))														cnt[18] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("3"))								cnt[19] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("3"))		cnt[20] += AddUtil.parseInt(su);
		//운행차-대차-지연
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("10"))													cnt[51] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("10"))													cnt[52] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("10"))													cnt[53] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("10"))							cnt[54] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("10"))		cnt[55] += AddUtil.parseInt(su);
		//운행차-업무
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("4") || rent_st.equals("5")))							cnt[21] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("4") || rent_st.equals("5")))							cnt[22] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("4") || rent_st.equals("5")))							cnt[23] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("4") || rent_st.equals("5")))	cnt[24] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("4") || rent_st.equals("5")))	cnt[25] += AddUtil.parseInt(su);
		//운휴차-정비-사고
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("8"))														cnt[26] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("8"))														cnt[27] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("8"))														cnt[28] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("8"))								cnt[29] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("8"))		cnt[30] += AddUtil.parseInt(su);
		//운휴차-정비-일반
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("6") || rent_st.equals("7")))							cnt[31] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("6") || rent_st.equals("7")))							cnt[32] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("6") || rent_st.equals("7")))							cnt[33] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("6") || rent_st.equals("7")))	cnt[34] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && (rent_st.equals("6") || rent_st.equals("7")))	cnt[35] += AddUtil.parseInt(su);
		//운휴차-대기
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("0"))														cnt[36] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("0"))														cnt[37] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("0"))														cnt[38] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("0"))								cnt[39] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("0"))							cnt[40] += AddUtil.parseInt(su);
		//운휴차-해지/도난/말소/수해/기타
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("1"))																			cnt[56] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("1"))																			cnt[57] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("1"))																			cnt[58] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("1"))													cnt[59] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("1"))							cnt[60] += AddUtil.parseInt(su);
		//운휴차-매각-준비(매각결정)
		else if((car_kd.equals("3") || car_kd.equals("9")) && (off_ls.equals("4")||off_ls.equals("1")) && !rent_st.equals(""))								cnt[41] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && (off_ls.equals("4")||off_ls.equals("1")) && !rent_st.equals(""))								cnt[42] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && (off_ls.equals("4")||off_ls.equals("1")) && !rent_st.equals(""))								cnt[43] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && (off_ls.equals("4")||off_ls.equals("1")) && !rent_st.equals(""))		cnt[44] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && (off_ls.equals("4")||off_ls.equals("1")) && !rent_st.equals(""))	cnt[45] += AddUtil.parseInt(su);
		//운휴차-매각-경매장(출품)
		else if((car_kd.equals("3") || car_kd.equals("9")) && off_ls.equals("3") && !rent_st.equals(""))								cnt[46] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && off_ls.equals("3") && !rent_st.equals(""))								cnt[47] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && off_ls.equals("3") && !rent_st.equals(""))								cnt[48] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && off_ls.equals("3") && !rent_st.equals(""))		cnt[49] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && off_ls.equals("3") && !rent_st.equals(""))	cnt[50] += AddUtil.parseInt(su);
		//운휴차-매각-경매장(명도중)
		else if((car_kd.equals("3") || car_kd.equals("9")) && off_ls.equals("5") && !rent_st.equals(""))								cnt[61] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && off_ls.equals("5") && !rent_st.equals(""))								cnt[62] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && off_ls.equals("5") && !rent_st.equals(""))								cnt[63] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && off_ls.equals("5") && !rent_st.equals(""))		cnt[64] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && off_ls.equals("5") && !rent_st.equals(""))	cnt[65] += AddUtil.parseInt(su);
		//운휴차-예약
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("11"))														cnt[66] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("11"))														cnt[67] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("11"))														cnt[68] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("11"))								cnt[69] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("0") && off_ls.equals("0") && rent_st.equals("11"))		cnt[70] += AddUtil.parseInt(su);
		//운휴차-매각예정
		else if((car_kd.equals("3") || car_kd.equals("9")) && prepare.equals("2") && off_ls.equals("0"))																			cnt[71] += AddUtil.parseInt(su);
		else if(car_kd.equals("2") && prepare.equals("2") && off_ls.equals("0"))																			cnt[72] += AddUtil.parseInt(su);
		else if(car_kd.equals("1") && prepare.equals("2") && off_ls.equals("0"))																			cnt[73] += AddUtil.parseInt(su);
		else if((car_kd.equals("4") || car_kd.equals("5")) && prepare.equals("2") && off_ls.equals("0"))													cnt[74] += AddUtil.parseInt(su);
		else if((car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8")) && prepare.equals("2") && off_ls.equals("0"))							cnt[75] += AddUtil.parseInt(su);
		//나머지-대기
		else{
			if(car_kd.equals("3") || car_kd.equals("9"))								cnt[36] += AddUtil.parseInt(su);
			else if(car_kd.equals("2"))													cnt[37] += AddUtil.parseInt(su);
			else if(car_kd.equals("1"))													cnt[38] += AddUtil.parseInt(su);
			else if(car_kd.equals("4") || car_kd.equals("5"))							cnt[39] += AddUtil.parseInt(su);
			else if(car_kd.equals("6") || car_kd.equals("7") || car_kd.equals("8"))		cnt[40] += AddUtil.parseInt(su);
		}
	}
	

%>	
<form name='form1' method='post' target='d_content'>
 <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
 <input type='hidden' name='user_id' value='<%=user_id%>'>
 <input type='hidden' name='br_id' value='<%=br_id%>'>
 <input type='hidden' name='gubun2' value=''>   
<input type='hidden' name='car_size' value='<%=car_size%>'> 	  	
<table border="0" cellspacing="0" cellpadding="0" width=100%>
  	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>예약시스템 > 자동차관리 > <span class=style5>예비차 보유현황</span></span></td>
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
	    <td  width='100%' class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td colspan="2" rowspan="2" class='title'>구분</td>
                    <td class='title' colspan="2">소형승용</td>
                    <td class='title' colspan="2">중형승용</td>
                    <td class='title' colspan="2">대형승용</td>
                    <td class='title' colspan="2">승합</td>
                    <td class='title' colspan="2">화물</td>
                    <td class='title' colspan="3">합계</td>
                </tr>
                <tr> 
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>비율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>비율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>비율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>비율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>비율</td>
                    <td width='9%' colspan="2" class='title'>대수</td>
                    <td class='title' width='9%'>비율</td>
                </tr>
                <tr> 
                    <td colspan="2" class='title' >운행</td>
                    <td align="center"> 
                      <input type="text" name="su1" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per1" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su2" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per2" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su3" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per3" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su4" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per4" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su5" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per5" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</td>
                    <td rowspan="2" align="center"><input type="text" name="su7" size="3" class=whitenum readonly>
대</td>
                    <td align="center"> 
                      <input type="text" name="per6" size="4" class=whitenum readonly>
                      % </td>
                </tr>
                <tr> 
                    <td width="6%" rowspan="2" class='title' >운휴</td>
                    <td width="6%" class='title' >보유</td>
                    <td align="center"> 
                      <input type="text" name="su1" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per1" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su2" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per2" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su3" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per3" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su4" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per4" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su5" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per5" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per6" size="4" class=whitenum readonly>
                      % </td>
                </tr>
                <tr> 
                    <td class='title' >매각진행</td>
                    <td align="center"> 
                      <input type="text" name="su1" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per1" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su2" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per2" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su3" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per3" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su4" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per4" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su5" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per5" size="4" class=whitenum readonly>
                      % </td>
                    <td colspan="2" align="center"> 
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per6" size="4" class=whitenum readonly>
                      % </td>
                </tr>
                <tr> 
                    <td colspan="2" class='title' >합계</td>
                    <td align="center"> 
                      <input type="text" name="su1" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per1" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su2" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per2" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su3" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per3" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su4" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per4" size="4" class=whitenum readonly>
                      % </td>
                    <td align="center"> 
                      <input type="text" name="su5" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per5" size="4" class=whitenum readonly>
                      % </td>
                    <td colspan="2" align="center"> 
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                      <input type="text" name="per6" size="4" class=whitenum readonly>
                      % </td>
                </tr>
            </table>
	    </td>
	    <td width='17'>&nbsp;</td>
	</tr>  	
  	<tr>
	    <td width='100%'>&nbsp;</td>
	    <td width='17'>&nbsp;</td>	  
	</tr>	
  	<tr>	  
        <td width='100%'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운행차 현황</span></td>
	    <td width='17'>&nbsp;</td>	  
    </tr>	
    <tr>
    	<td class=line2></td>
    </tr>
    <tr>
	    <td width='100%' class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="2" width="12%" colspan="2">구분</td>
                    <td class='title' colspan="2">소형승용</td>
                    <td class='title' colspan="2">중형승용</td>
                    <td class='title' colspan="2">대형승용</td>
                    <td class='title' colspan="2">승합</td>
                    <td class='title' colspan="2">화물</td>
                    <td class='title' colspan="2">합계</td>
                </tr>
                <tr> 
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운행율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운행율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운행율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운행율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운행율</td>
                    <td class='title' width='9%'>대수</td>
                    <td class='title' width='9%'>운행율</td>
                </tr>
                <tr> 
                    <td class='title' rowspan="2" width=5%>단기</td>
                    <td class='title' width=7%>일반</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[1]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[2]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[3]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[4]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[5]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"><a href="javascript:move_page(1)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(1)" readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >보험</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[6]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[7]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[8]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[9]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[10]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(9)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(9)" readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' rowspan="3" >대차</td>
                    <td class='title' >정비</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[11]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[12]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[13]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[14]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[15]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(2)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(2)" readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >사고</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[16]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[17]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[18]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[19]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[20]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(3)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(3)" readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >출고전</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[51]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[52]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[53]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[54]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[55]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"><a href="javascript:move_page(10)"> 
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' colspan="2" >업무</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[21]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[22]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[23]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[24]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[25]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(4)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(4)" readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' colspan="2" >합계</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center">
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
            </table>
        </td>
	    <td width='17'>&nbsp;</td>
	</tr>
	<tr>
		<td></td>
		<td></td>
    </tr>  		
  	<tr>	  
        <td width='100%'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운휴차-보유 현황</span></td>
	    <td width='17'>&nbsp;</td>	  
	</tr>
	<tr>
    	<td class=line2></td>
    </tr>	
    <tr>
	    <td  width='100%' class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="2" width=12% colspan="2">구분</td>
                    <td class='title' colspan="2">소형승용</td>
                    <td class='title' colspan="2">중형승용</td>
                    <td class='title' colspan="2">대형승용</td>
                    <td class='title' colspan="2">승합</td>
                    <td class='title' colspan="2">화물</td>
                    <td class='title' colspan="2">합계</td>
                </tr>
                <tr> 
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='9%'>대수</td>
                    <td class='title' width='9%'>운휴율</td>
                </tr>
                <tr> 
                    <td class='title' rowspan="2" width=5%>정비</td>
                    <td class='title' width=7%>사고</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[26]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[27]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[28]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[29]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[30]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(8)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(8)">
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >일반정비</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[31]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[32]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[33]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[34]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[35]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(6)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(6)">
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' colspan="2" >예약</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[66]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[67]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[68]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[69]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[70]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(21)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(20)">
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>				
                <tr> 
                    <td class='title' colspan="2" >대기</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[36]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[37]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[38]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[39]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[40]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(20)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(20)">
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' colspan="2" >매각예정</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[71]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[72]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[73]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[74]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[75]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(22)">
                      <input type="text" name="su6" size="3" class=whitenum onClick="javascript:move_page(20)">
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>				
                <tr> 
                    <td class='title' colspan="2" >도난/말소/수해/기타</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[56]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[57]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[58]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[59]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[60]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(23)">
                      <input type="text" name="su6" size="3" class=whitenum readonly>
                      대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>				
                <tr> 
                    <td class='title' colspan="2" >합계</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
            </table>
        </td>
	    <td width='17'>&nbsp;</td>
	</tr>  
	<tr>
		<td></td>
		<td></td>
    </tr>  		
  	<tr>	  
        <td width='100%'><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>운휴차-매각진행 현황</span></td>
	    <td width='17'>&nbsp;</td>	  
	</tr>
	<tr>
    	<td class=line2></td>
    </tr>	
    <tr>
	    <td  width='100%' class='line'>
    	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td class='title' rowspan="2" width=12%>구분</td>
                    <td class='title' colspan="2">소형승용</td>
                    <td class='title' colspan="2">중형승용</td>
                    <td class='title' colspan="2">대형승용</td>
                    <td class='title' colspan="2">승합</td>
                    <td class='title' colspan="2">화물</td>
                    <td class='title' colspan="2">합계</td>
                </tr>
                <tr> 
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='7%'>대수</td>
                    <td class='title' width='7%'>운휴율</td>
                    <td class='title' width='9%'>대수</td>
                    <td class='title' width='9%'>운휴율</td>
                </tr>
                <tr> 
                    <td class='title' >준비중</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[41]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[42]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[43]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[44]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[45]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(31)">
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >출품</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[46]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[47]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[48]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[49]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[50]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(32)">
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
                <tr> 
                    <td class='title' >명도중</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum value="<%=cnt[61]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum value="<%=cnt[62]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum value="<%=cnt[63]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum value="<%=cnt[64]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum value="<%=cnt[65]%>" readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> <a href="javascript:move_page(33)">
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</a></td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>			
                <tr> 
                    <td class='title' >합계</td>
                    <td align="center"> 
                    <input type="text" name="su1" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per1" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su2" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per2" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su3" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per3" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su4" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per4" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su5" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per5" size="4" class=whitenum readonly>
                    % </td>
                    <td align="center"> 
                    <input type="text" name="su6" size="3" class=whitenum readonly>
                    대</td>
                    <td align="center"> 
                    <input type="text" name="per6" size="4" class=whitenum readonly>
                    % </td>
                </tr>
            </table>
        </td>
	    <td width='17'>&nbsp;</td>
	</tr> 			
</table>
</form>  
<script language='javascript'>
<!--
	set_su();
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>  
</body>
</html>
