<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, acar.common.*, tax.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"2":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"1":request.getParameter("asc");
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String gubun 	= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rent_st 	= request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String rent_seq	= request.getParameter("rent_seq")==null?"1":request.getParameter("rent_seq");
	String cng_st 	= request.getParameter("cng_st")==null?"":request.getParameter("cng_st");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	//대여기본정보
	ContFeeBean f_fee = a_db.getContFeeNew(m_id, l_cd, "1");
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	Vector ht = af_db.getFeeScdCngNew(l_cd, rent_st, rent_seq, "");
	int ht_size = ht.size();
	
	FeeScdBean fee_scd = new FeeScdBean();
	
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

		if(fm.add_tm.value 	== '')					{	alert('연장회차를 입력하십시오'); 				fm.add_tm.focus(); 			return; }
		
		if(fm.rent_start_dt.value 	== '')			{	alert('대여기간을 입력하십시오'); 				fm.rent_start_dt.focus(); 	return; }
		if(fm.rent_end_dt.value 	== '')			{	alert('대여기간을 입력하십시오'); 				fm.rent_end_dt.focus(); 	return; }						
		if(fm.fee_amt.value 		== '0')			{	alert('월대여료 금액을 확인하십시오'); 			fm.fee_amt.focus(); 		return; }
		if(fm.f_use_start_dt.value 	== '')			{	alert('1회차 사용기간을 입력하십시오'); 		fm.f_use_start_dt.focus(); 	return; }
		if(fm.f_use_end_dt.value 	== '')			{	alert('1회차 사용기간을 입력하십시오'); 		fm.f_use_end_dt.focus(); 	return; }		
		if(fm.f_req_dt.value 		== '')			{	alert('1회차 발행예정일을 입력하십시오'); 		fm.f_req_dt.focus(); 		return; }
		if(fm.f_tax_dt.value 		== '')			{	alert('1회차 세금일자를 입력하십시오'); 		fm.f_tax_dt.focus(); 		return; }
		if(fm.f_est_dt.value 		== '')			{	alert('1회차 입금예정일을 입력하십시오'); 		fm.f_est_dt.focus(); 		return; }				
		
		if(fm.cng_cau.value 	== '')				{	alert('연장사유를 입력하십시오'); 				fm.cng_cau.focus(); 		return; }		
		
		//1회차 대여기간 체크
		if(getRentTime('m', fm.f_use_start_dt.value, fm.f_use_end_dt.value) > 1){ 
			if(!confirm('1회차 대여기간이 '+fm.f_use_start_dt.value+'부터 '+fm.f_use_end_dt.value+' 입니다.\n\n입력하신 값이 한달이상 차이납니다.\n\n스케줄을 생성하시겠습니까?'))			
				return;
		}
		
		//1회차 대여기간 체크
		if(getRentTime('d', fm.f_use_start_dt.value, fm.f_use_end_dt.value) < 0){ 
			if(!confirm('1회차 대여기간이 '+fm.f_use_start_dt.value+'부터 '+fm.f_use_end_dt.value+' 입니다.\n\n입력하신 값이 이상합니다.\n\n스케줄을 생성하시겠습니까?'))			
				return;
		}
		
		<%	if(rent_st.equals("") && idx==1 && !f_fee.getRent_start_dt().equals("")){//출고지연대차일때%> 
		if(toInt(replaceString('-','',fm.rent_end_dt.value)) > <%=f_fee.getRent_start_dt()%>){
			alert('신차개시일자보다 출고지연 대차기간이 클수 없습니다.'); return;
		}
		<%	}%>
				
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{		
			fm.fee_s_amt.value = sup_amt(toInt(parseDigit(fm.fee_amt.value)));
			fm.fee_v_amt.value = toInt(parseDigit(fm.fee_amt.value)) - toInt(fm.fee_s_amt.value);
							
			fm.action = './fee_scd_u_addscd_a.jsp';
//			fm.target = 'i_no';
			fm.target = 'ADDSCD';
			fm.submit();
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
	
	//대여기간 셋팅
	function ScdfeeSet()
	{
		var fm = document.form1;
		if(fm.rent_start_dt.value != '' && fm.add_tm.value != ''){
			fm.action = "fee_scd_set_nodisplay.jsp";
			fm.target = "i_no";
			fm.submit();
		}
	}		
	
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.f_use_start_dt.value == ''){	alert('시작일을 입력하십시오.'); return;}
		if(fm.f_use_end_dt.value == ''){	alert('종료일을 입력하십시오.'); return;}				
		fm.st.value = st;
		fm.action='getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
		}				
		fm.submit();
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
<input type='hidden' name='scd_size' value='<%=ht_size%>'>
<input type='hidden' name='from_page' value='/fms2/con_fee/fee_scd_u_addscd.jsp'>
<input type='hidden' name='st' value=''>
<input type='hidden' name='f_fee_amt' value=''>
<input type='hidden' name='f_fee_s_amt' value=''>
<input type='hidden' name='f_fee_v_amt' value=''>
<input type='hidden' name="firm_nm"			value="<%=base.get("FIRM_NM")%>">
<input type='hidden' name='taecha_no' value='<%=taecha_no%>'>      

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>영업지원 > 계출관리 > 대여료스케줄관리 > <span class=style5>회차연장 변경</span></span></td>
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
                     <td width="52%">
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
	<%if(!String.valueOf(rtn.get("FIRM_NM")).equals("") && !String.valueOf(rtn.get("FIRM_NM")).equals("null")){%>
	<tr>
        <td class=h></td>
    </tr>  
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
        <td class=h></td>
    </tr>  	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>출고지연 대차대여</span></td>	
	</tr>	
<%	}%>		
<%	if(idx==2){%>  	
    <tr>
        <td class=h></td>
    </tr> 	
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
		
    			<%		for(int i = 0 ; i < ht_size ; i++){
    						if(i == ht_size-1){
    							fee_scd = (FeeScdBean)ht.elementAt(i);
    						}
    					}%>		  
    					<input type='hidden' name='last_fee_tm' value='<%=fee_scd.getFee_tm()%>'>
    					<input type='hidden' name='tm_st2' value='<%=fee_scd.getTm_st2()%>'>
                <tr>
                    <td width=20% class='title'>연장회차</td>
                    <td>
                      &nbsp;<input type='text' size='3' name='add_tm' value='1' maxlength='2' class='text' onBlur='javscript:ScdfeeSet();'>회</td>
                </tr>
				<!--추가분-->
				<%
					String f_use_s_dt 	=  c_db.addDay  (fee_scd.getUse_e_dt(), 1);
					String f_use_e_dt 	=  c_db.addMonth(fee_scd.getUse_e_dt(), 1);
					String f_fst_dt 	=  c_db.addMonth(fee_scd.getFee_est_dt(), 1);
					String f_req_dt 	=  c_db.addMonth(fee_scd.getReq_dt(), 1);
					String f_tax_dt 	=  c_db.addMonth(fee_scd.getTax_out_dt(), 1);
					String f_rent_end_dt 	=  "";
					
					
					
					int ifee_cnt = 0;
					
					
					//개시대여료 있어서 소진된 경우
					if(rent_st.equals("") && idx==1 && !f_fee.getRent_start_dt().equals("")){//출고지연대차일때
					}else{
						if(fee.getFee_s_amt()>0 && fee.getIfee_s_amt()/fee.getFee_s_amt() >0 && AddUtil.parseInt(fee_scd.getUse_e_dt()) < AddUtil.parseInt(fee.getRent_end_dt()) ){
							ifee_cnt = fee.getIfee_s_amt()/fee.getFee_s_amt();
						
							f_use_s_dt 	=  c_db.addMonth  (f_use_s_dt, ifee_cnt);
							f_use_e_dt 	=  c_db.addMonth  (f_use_e_dt, ifee_cnt);
							f_fst_dt 	=  c_db.addMonth  (f_fst_dt, ifee_cnt);
							f_req_dt 	=  c_db.addMonth  (f_req_dt, ifee_cnt);
							f_tax_dt 	=  c_db.addMonth  (f_tax_dt, ifee_cnt);
							f_rent_end_dt 	=  c_db.addMonth  (fee.getRent_end_dt(), -ifee_cnt); 
						
							
						
							out.println(ifee_cnt+"개월분 개시대여료 있어서 소진된 경우");
						}
					}
					
				%>
                <tr>
                    <td class='title'>연장대여기간</td>
                    <td>&nbsp;<input type='text' name='rent_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        		      ~
        		      <input type='text' name='rent_end_dt' value='<%=AddUtil.ChangeDate2(f_rent_end_dt)%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
        	    </td>
                </tr>			
				<%	if(rent_st.equals("") && idx==1){//출고전대차%> 
                <tr>
                    <td class='title'>월대여료</td>
                    <td>&nbsp;<input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(taecha.getRent_fee())%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>원&nbsp;
        				<input type='hidden' name='fee_s_amt' value=''>
        				<input type='hidden' name='fee_v_amt' value=''>						
        			</td>
                </tr>						 				
				<%	}else{%>
                <tr>
                    <td class='title'>월대여료</td>
                    <td>&nbsp;<input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>원&nbsp;
        				<input type='hidden' name='fee_s_amt' value=''>
        				<input type='hidden' name='fee_v_amt' value=''>						
        			</td>
                </tr>		
				<%}%>		
                <tr>
                    <td class='title'>1회차사용기간</td>
                    <td>
                      &nbsp;<input type='text' name='f_use_start_dt' value='<%=AddUtil.ChangeDate2(f_use_s_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                      	    ~
                      	    <input type='text' name='f_use_end_dt' value='<%=AddUtil.ChangeDate2(f_use_e_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value); '>					  
					  ( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>개월
  					  <input type="text" name="u_day" value="" size="5" class=text>일 )
					  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="사용일수 및 대여료 일자계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
					  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="월대여료 계산하기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>					  
        		    </td>
                </tr>
                <tr>
                    <td class='title'>1회차발행예정일</td>
                    <td>
                        &nbsp;<input type='text' name='f_req_dt' value='<%=AddUtil.ChangeDate2(f_req_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
                <tr>
                    <td class='title'>1회차세금일자</td>
                    <td>
                        &nbsp;<input type='text' name='f_tax_dt' value='<%=AddUtil.ChangeDate2(f_tax_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>						
                <tr>
                    <td class='title'>1회차입금예정일</td>
                    <td>
                        &nbsp;<input type='text' name='f_est_dt' value='<%=AddUtil.ChangeDate2(f_fst_dt)%>' maxlength='10' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
    <tr></tr><tr></tr>		
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width=20% class='title'>연장사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="72" rows="3" class=default></textarea>
                    </td>
                </tr>
                <tr>
                    <td width=20% class='title'>일자계산내역</td>
                    <td>
                        &nbsp;<textarea name="etc" cols="72" rows="2" class=default></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<!--
	<tr>
	    <td>* 회차연장 작업중입니다.  미완성 상태이니 연장등록작업을 유보하시기 바랍니다.</td>
    </tr>	
	-->
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
