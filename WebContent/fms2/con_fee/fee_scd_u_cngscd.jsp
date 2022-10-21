<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth 	= request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 	= request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd 	= request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc 		= request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx 		= request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	Vector ht = af_db.getFeeScdCngNew(l_cd, rent_st, rent_seq, "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
	int tae_sum = af_db.getTaeCnt_lcd(l_cd);
	
	if(rent_st.equals("")){ tae_sum = 0; }
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, rent_st, rent_seq);
	
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//대여스케줄 변경
	function cng_schedule()
	{
		var fm = document.form1;
	
		
		if(fm.fee_tm.value 		== '')				
			{	alert('변경회차를 선택하십시오.'); 		fm.fee_tm.focus(); 	return; }
		if(fm.cng_st.value 		== 'fee_amt'){
			if(fm.fee_s_amt.value == '' || fm.fee_s_amt.value == '0' || fm.fee_v_amt.value == '' || fm.fee_v_amt.value == '0' || fm.fee_amt.value == '' || fm.fee_amt.value == '0')
			{	alert('월대여료를 확인하십시오.'); 		fm.fee_amt.focus(); 	return; }
		}
		if((fm.cng_st.value == 'req_dt' 	|| fm.cng_st.value == 'fee_est_dt') && fm.req_dt.value == '')
			{	alert('발행일자를 입력하십시오.'); 		fm.req_dt.focus(); 		return; }
		if((fm.cng_st.value == 'tax_out_dt' || fm.cng_st.value == 'fee_est_dt') && fm.tax_out_dt.value == '')
			{	alert('세금일자를 입력하십시오.'); 		fm.tax_out_dt.focus(); 	return; }
		if(fm.cng_st.value == 'fee_est_dt' && fm.fee_est_dt.value == '')
			{	alert('입금예정일를 입력하십시오.'); 	fm.fee_est_dt.focus(); 	return; }
		if(fm.cng_cau.value 		== '')				
			{	alert('변경사유를 선택하십시오.'); 		fm.cng_cau.focus(); 	return; }
			
			
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		fm.r_fee_tm.value = value_split[0];
			
		if(fm.c_all[2].checked==true){
			if(fm.s_max_tm.value == ''){ alert('적용종료회차를 선택하여 주십시오.'); fm.s_max_tm.focus(); return;}
			if(toInt(fm.r_fee_tm.value) >= toInt(fm.s_max_tm.value)){ alert('적용시작회차보다 적용종료회차가 작습니다. 확인하십시오.'); fm.s_max_tm.focus(); return; }			
		}else{
			fm.s_max_tm.value = '';
		}

		<%	if(cng_st.equals("fee_amt")){%>		
		if(fm.ins_cng.checked==true){
			if(fm.ins_cng_st[0].checked==false && fm.ins_cng_st[1].checked==false){ alert('대여료변경사유를 선택하십시오. '); return;}	
			if(toInt(parseDigit(fm.ins_cng_amt.value))==0){ alert('변경에 따른 공급가증감액을 입력하십시오.'); fm.ins_cng_amt.focus(); return;}
			if(fm.ins_cng_dt.value == ''){ alert('변경일자를 입력하십시오.'); fm.ins_cng_dt.focus(); return; }
			if(fm.c_all[0].checked == true){ alert('변경으로 변경하는 경우 선택회차 이후의 적용종료회차(마지막OR특정회차)를 선택해야 합니다.'); return; }
		}		
		<%	}%>
			
		var a_dt 	= '';
		var b_dt 	= '';
		var cha_mon = 0;
		var a_dt_nm = '';
		
		if(fm.cng_st.value 			== 'req_dt'){
			a_dt 	= fm.a_req_dt.value;
			b_dt 	= fm.req_dt.value;			
			a_dt_nm = '발행일자가';
		}else if(fm.cng_st.value 	== 'tax_out_dt'){
			a_dt 	= fm.a_tax_out_dt.value;
			b_dt 	= fm.tax_out_dt.value;			
			a_dt_nm = '세금일자가';
		}else if(fm.cng_st.value 	== 'fee_est_dt'){		
			a_dt 	= fm.a_fee_est_dt.value;
			b_dt 	= fm.fee_est_dt.value;					
			a_dt_nm = '입금예정일이';
			
			var est_dt = replaceString('-','',fm.fee_est_dt.value);
			fm.fee_est_y.value = est_dt.substring(0,4);
			fm.fee_est_m.value = est_dt.substring(4,6);
			fm.fee_est_d.value = est_dt.substring(6,8);
			
		}	
					
		if(a_dt != ''){
			cha_mon = getRentTime('m', a_dt, b_dt);
			if(cha_mon > 2){ 
				if(!confirm('입력한 '+a_dt_nm+' 두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
					return;
			}
			if(cha_mon <  -2){ 
				if(!confirm('입력한 '+a_dt_nm+' -두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
					return;
			}
		}
		
		if(fm.cng_st.value 	== 'fee_est_dt'){		
			a_dt 	= fm.a_req_dt.value;
			b_dt 	= fm.req_dt.value;		
			cha_mon = 0;	
			a_dt_nm = '발행일자';
			if(a_dt != ''){
				cha_mon = getRentTime('m', a_dt, b_dt);
				if(cha_mon > 2){ 
					if(!confirm('입력한 '+a_dt_nm+' 두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
						return;
				}
				if(cha_mon <  -2){ 
					if(!confirm('입력한 '+a_dt_nm+' -두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
						return;
				}
			}		
			a_dt 	= fm.a_tax_out_dt.value;
			b_dt 	= fm.tax_out_dt.value;			
			cha_mon = 0;	
			a_dt_nm = '세금일자';
			if(a_dt != ''){
				cha_mon = getRentTime('m', a_dt, b_dt);
				if(cha_mon > 2){ 
					if(!confirm('입력한 '+a_dt_nm+' 두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
						return;
				}
				if(cha_mon <  -2){ 
					if(!confirm('입력한 '+a_dt_nm+' -두달이상 차이납니다.\n\n스케줄을 변경하시겠습니까?'))			
						return;
				}
			}					
		}
		
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{							
			fm.action = './fee_scd_u_cngscd_a.jsp';
			fm.target = '_self';
			fm.submit();
		}
	}		
	
	function set_before(){
		var fm = document.form1;
		var values = fm.fee_tm.options[fm.fee_tm.selectedIndex].value;
		var value_split = values.split(",");
		<%if(cng_st.equals("fee_amt")){%>
		fm.a_fee_s_amt.value 	= parseDecimal(value_split[1]);
		fm.a_fee_v_amt.value 	= parseDecimal(value_split[2]);
		fm.a_fee_amt.value 		= parseDecimal(toInt(parseDigit(fm.a_fee_s_amt.value)) + toInt(parseDigit(fm.a_fee_v_amt.value))); 		
		fm.rc_cont.value		= '[이회차는 '+parseDecimal(value_split[6])+'원이 입금되어 있습니다. 잔액이 조정되니 변경후 확인하세요]';
		<%}%>
		<%if(cng_st.equals("req_dt") || cng_st.equals("fee_est_dt")){%>		
		fm.a_req_dt.value 		= ChangeDate(value_split[3]);
		<%}%>		
		<%if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt")){%>				
		fm.a_tax_out_dt.value 	= ChangeDate(value_split[4]);
		<%}%>		
		<%if(cng_st.equals("fee_est_dt") || cng_st.equals("fee_est_dt")){%>				
		fm.a_fee_est_dt.value 	= ChangeDate(value_split[5]);
		<%}%>		
	}
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //월대여료 공급가
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //월대여료 부가세		
			fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //월대여료 합계		
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}	
	
	//보험변경적용
	function setInsamt(){
		var fm = document.form1;
		if(fm.ins_cng.checked == true){
			if(fm.ins_cng_st[0].checked==false && fm.ins_cng_st[1].checked==false){ fm.ins_cng_st[0].checked=true}	
			if(toInt(parseDigit(fm.ins_cng_amt.value))==0 && toInt(parseDigit(fm.fee_amt.value))>0){
				fm.ins_cng_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.a_fee_amt.value))); 		
			}else if(toInt(parseDigit(fm.ins_cng_amt.value))>0 && toInt(parseDigit(fm.fee_amt.value))==0){
				fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.a_fee_amt.value)) + toInt(parseDigit(fm.ins_cng_amt.value))); 	
				cal_sv_amt(fm.fee_amt);					
			}else if(toInt(parseDigit(fm.ins_cng_amt.value))<0 && toInt(parseDigit(fm.fee_amt.value))==0){
				fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.a_fee_amt.value)) + toInt(parseDigit(fm.ins_cng_amt.value))); 	
				cal_sv_amt(fm.fee_amt);					
			}
			if((fm.cng_cau.value=='' || fm.cng_cau.value=='대여료변경') && fm.ins_cng_st[0].checked == true){
				fm.cng_cau.value = '보험변경';
			}else if((fm.cng_cau.value=='' || fm.cng_cau.value=='보험변경') && fm.ins_cng_st[1].checked == true){
				fm.cng_cau.value = '대여료변경';
			}
			fm.fee_amt_cng.checked = true;
			
			setInscau();
			
		}else{
			fm.ins_cng_amt.value = 0;
			fm.fee_amt_cng.checked = false;
			fm.cng_cau.value = '';
		}
	}
	
	function setInscau(){
		var fm = document.form1;
		if(fm.ins_cng_st[0].checked == true){
			fm.cng_cau.value = '보험변경';
		}else if(fm.ins_cng_st[1].checked == true){
			fm.cng_cau.value = '대여료변경';
		}
		if(fm.ins_cng_sub_st.value != ''){			
			fm.cng_cau.value = fm.cng_cau.value + ' : ' + fm.ins_cng_sub_st.value;
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
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method="post">
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='c_id' value='<%=c_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='rent_seq' value='<%=rent_seq%>'>
<input type='hidden' name='cng_st' value='<%=cng_st%>'>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='auth' value='<%=auth%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='gubun4' value='<%=gubun4%>'>
<input type='hidden' name='st_dt' value='<%=st_dt%>'>
<input type='hidden' name='end_dt' value='<%=end_dt%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='sort_gubun' value='<%=sort_gubun%>'>
<input type='hidden' name='asc' value='<%=asc%>'>
<input type='hidden' name='r_fee_tm' value=''>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name='fee_est_y' value=''>
<input type='hidden' name='fee_est_m' value=''>
<input type='hidden' name='fee_est_d' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>대여료스케줄 변경</span></span></td>
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
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>계약번호</td>
                    <td width='20%'>
    			    &nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='14%' class='title'>상호</td>
                    <td>
    			    &nbsp;<%=base.get("FIRM_NM")%></td>
                </tr>
    		    <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr>
                    <td class='title'>사용본거지</td>
                    <td colspan="3">&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>	
    		    <%}%>	   
                <tr>
                    <td class='title'>차량번호</td>
                    <td>
    			    &nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>
    			    &nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr>
                    <td class='title'> 대여방식 </td>
                    <td>
    			    &nbsp;<%=base.get("RENT_WAY")%></td>
                    <td class='title'>CMS</td>
                    <td>
    				&nbsp;<%if(!cms.getCms_bank().equals("")){%>
					<b>
								<%if(!cms.getCbit().equals("")){%>[<%=cms.getCbit()%>]<%}%>
								</b>
    			 	<%=cms.getCms_bank()%>:<%=AddUtil.ChangeDate2(cms.getCms_start_dt())%>~<%=AddUtil.ChangeDate2(cms.getCms_end_dt())%>(매월<%=cms.getCms_day()%>일)
    			 	<%}else{%>
    			 	-
    			 	<%}%>			 
    			    </td>
                </tr>
                <tr>
                    <td class='title'>영업담당자</td>
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("BUS_ID2")),"USER")%></td>
                    <td class='title'>관리담당자</td>
                    <td>
    			    &nbsp;<%=c_db.getNameById(String.valueOf(base.get("MNG_ID")),"USER")%></td>
                </tr>		   
            </table>
	    </td>
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<%if(!rent_seq.equals("1")){%>
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>분할청구</span></td>	
	</tr>	
	<tr> 
        <td class=line2></td>
    </tr>  			
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width='14%' class='title'>공급받는자</td>
                    <td width="28%">&nbsp;<%=rtn.get("FIRM_NM")%></td>
                    <td width="14%" class='title'>월대여료</td>
                    <td>&nbsp;<%=AddUtil.parseDecimal(String.valueOf(rtn.get("RTN_AMT")))%>원&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>			
	<%}%>
<%	if(rent_st.equals("") && idx==1){%>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고지연 대차대여</span></td>	
	</tr>	
<%	}%>		
<%	if(idx==2){%>  		
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%if(rent_st.equals("1")){%>신차<%}else{%><%=AddUtil.parseInt(rent_st)-1%>차 연장<%}%>대여</span></td>	
	</tr>	  
<%	}%>	
    <tr> 
        <td class=line2></td>
    </tr>			
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td colspan="2" class='title' width=14%>변경회차</td>
                    <td colspan="2">
   					&nbsp;  <%	String max_tm = "";
								if(ht_size > 0){%>
        						<select name='fee_tm' onchange="javascript:set_before()">
        					<%		for(int i = 0 ; i < ht_size ; i++){
        								FeeScdBean bean = (FeeScdBean)ht.elementAt(i);
        								if(i==0){
        									fee_scd = bean;
        								}
										max_tm =bean.getFee_tm(); %>
        							<option value='<%=bean.getFee_tm()%>,<%=bean.getFee_s_amt()%>,<%=bean.getFee_v_amt()%>,<%=bean.getReq_dt()%>,<%=bean.getTax_out_dt()%>,<%=bean.getFee_est_dt()%>,<%=bean.getRc_amt()%>'><%=AddUtil.parseInt(bean.getFee_tm())%></option>
        					<%		}%>
        						</select> 회
								<input type='text' name='rc_cont' value='' size='70' class='whitetext'>
							<br>	
							&nbsp;
        		              <input type="radio" name="c_all" value="O" checked>
                		      <b>한회차</b>만 적용
							<br>	
							&nbsp;
        		              <input type="radio" name="c_all" value="Y">
                		      선택회차부터 <b>모든 회차</b> 적용
							  <br>
							  &nbsp;
							    <input type="radio" name="c_all" value="M">
							  선택회차부터 <b><input type='text' name='s_max_tm' value='' size='2' class='num'>회차까지</b> 적용
        					<%	}else{%>
        						선택가능한 회차가 없습니다.
        					<%	}%>					
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class='title' width=14%>회차간격</td>
                    <td colspan="2">
        					&nbsp;											  
							  <select name='mon_st'>
        							<option value='1'> 1개월</option>
        							<option value='12'>12개월</option>									
        						</select>						
                    </td>
                </tr>				
                <tr>
                    <td colspan="2" class='title'>구분</td>
                    <td width="42%" class='title'>변경전</td>
                    <td class='title'>변경후</td>
                </tr>
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width='5%' rowspan="3" class='title'>월<br>
                    대<br>
                    여<br>료</td>
                    <td width='9%' class='title'>공급가</td>
                    <td align="center">
                      <input type='text' name='a_fee_s_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                    <td align="center">
                    <input type='text' name='fee_s_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원</td>
                </tr>
                <tr>
                    <td class='title'>부가세</td>
                    <td align="center">
                      <input type='text' name='a_fee_v_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_v_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                    <td align="center">
                    <input type='text' name='fee_v_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원</td>
                </tr>
                <tr>
                    <td class='title'>합계</td>
                    <td align="center">
                      <input type='text' name='a_fee_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())%>' size='8' class='whitenum'  onBlur='javascript:this.value=parseDecimal(this.value);'>원</td>
                    <td align="center">
                    <input type='text' name='fee_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>원</td>
                </tr>		
                <tr>
                    <td colspan="2" class='title' width=14%>마지막회차</td>
                    <td colspan="2">
        					&nbsp;
        		              <input type="checkbox" name="max_auto" value="Y">
                		      자동일자계산 (선택회차부터 다수 적용일 경우)	
                    </td>
                </tr>				  
    <%	}%>
    <%	if(cng_st.equals("req_dt") || cng_st.equals("fee_est_dt") ){%>		  		  
                <tr>
                    <td colspan="2" class='title'>발행일자</td>
                    <td align="center">
                    <input type='text' name='a_req_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getReq_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td align="center">
                    <input type='text' name='req_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>
    <%	if(cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt") ){%>		  		  		  
                <tr>
                    <td colspan="2" class='title'>세금일자</td>
                    <td align="center">
                      <input type='text' name='a_tax_out_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getTax_out_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                    <td align="center">
                    <input type='text' name='tax_out_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>
    <%	if(cng_st.equals("fee_est_dt")){%>		  		  		  
                <tr>
                    <td colspan="2" class='title'>입금예정일</td>
                    <td align="center">
        			  <input type='text' name='a_fee_est_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>' size='11' class='whitetext' readonly onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        			</td>
                    <td align="center">
                    <input type='text' name='fee_est_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
    <%	}%>	
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width="14%" class='title'>일자계산 및 회차분할</td>
                    <td>
                        &nbsp;<input type="checkbox" name="ins_cng" value="Y" onclick="javascript:setInsamt();"> 월대여료 일자계산 변경처리 <font color='#999999'>(체크후 증감액 입력시 월대여료 자동계산)</font>
    	 		              <br>
                    	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    	  변경사유 : 
                    	<input type='radio' name="ins_cng_st" value='1' onclick="javascript:setInsamt();">
                        보험변경
                        <input type='radio' name="ins_cng_st" value='2' onclick="javascript:setInsamt();">
    	 		        대여료변경    	 		        
                    	&nbsp;&nbsp;&nbsp;&nbsp;
                    	  (세부사유 : <select name='ins_cng_sub_st'  onchange="javascript:setInscau()">
                    	            <option value=''>선택</option>
        							<option value='21세->26세'>21세->26세</option>
        							<option value='26세->21세'>26세->21세</option>									
        							<option value='추가운전자등록'>추가운전자등록</option>
        							<option value='추가운전자등록취소'>추가운전자등록취소</option>
        							<option value='약정거리변경'>약정거리변경</option>
        							<option value='대물가입금액변경'>대물가입금액변경</option>
        						</select>		
    	 		        )
						<br>	 
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							월대여료증감액 : <input type='text' name='ins_cng_amt' value='' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); setInsamt();'>원 (부가세포함) / 
							변경일자 : <input type='text' name='ins_cng_dt' value='' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>							
                    </td>
                </tr>				
	<%	}%>				
                <tr>
                    <td width="14%" class='title'>동일값적용</td>
                    <td>
                        &nbsp;<input type="checkbox" name="comm_value" value="Y"> 변경 전회차의 적용값을 동일한 값으로 적용 (회차별 변화가 없음)
                    </td>
                </tr>	
                <%if(cng_st.equals("req_dt") || cng_st.equals("tax_out_dt") || cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>변경일자<%if(cng_st.equals("fee_est_dt")){%>1<%}%></td>
                    <td>
                        &nbsp;<input type="checkbox" name="maxday_yn" value="Y"> 말일
                        <font color=red>&nbsp;(<%if(cng_st.equals("fee_est_dt")){%>세금일자-<%}%>변경일자가 말일일때 선택하세요.)</font>
                    </td>
                </tr>	                
                <%}%>
                <%if(cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>변경일자2</td>
                    <td>
                        &nbsp;<input type="checkbox" name="maxday_yn2" value="Y"> 말일
                        <font color=red>&nbsp;(입금예정일-변경일자가 말일일때 선택하세요.)</font>
                    </td>
                </tr>	                                
                <%}%>
				
    <%	if(cng_st.equals("fee_est_dt")){%>		  
                <tr>
                    <td width="14%" class='title'>결제일변경</td>
                    <td>
                        &nbsp;<input type="checkbox" name="fee_est_day_cng" value="Y"> 계약관리-대여정보의 매월결제일자도 수정
                    </td>
                </tr>				
	<%	}else{%>		
	<input type='hidden' name='fee_est_day_cng' value='N'>
	<%	}%>		  		  		  
	
								
    <%	if(cng_st.equals("fee_amt")){%>		  
                <tr>
                    <td width="14%" class='title'>대여요금변경</td>
                    <td>
                        &nbsp;<input type="checkbox" name="fee_amt_cng" value="Y"> 계약관리-대여정보의 대여료 계약요금도 수정
                    </td>
                </tr>				
	<%	}else{%>		
	<input type='hidden' name='fee_amt_cng' value='N'>
	<%	}%>									
	
                <tr>
                    <td width="14%" class='title'>변경사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="5" class=default style='IME-MODE: active'></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
	    <td align='right'>&nbsp;</td>
    </tr>	
	<tr>
	    <td align="center">		
            <a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
      		&nbsp;&nbsp;	
      		<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>		
	    </td>
	</tr>	
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
