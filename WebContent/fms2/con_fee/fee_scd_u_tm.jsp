<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*,acar.common.*"%>
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
	String fee_tm 	= request.getParameter("fee_tm")==null?"":request.getParameter("fee_tm");
	String tm_st1 	= request.getParameter("tm_st1")==null?"":request.getParameter("tm_st1");
	String tm_st2 	= request.getParameter("tm_st2")==null?"":request.getParameter("tm_st2");
	int idx = request.getParameter("idx")==null?2:AddUtil.parseInt(request.getParameter("idx"));
	String cng_st = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	//cont_view
	Hashtable base = a_db.getContViewCase(m_id, l_cd);
	//자동이체정보
	ContCmsBean cms = a_db.getCmsMng(m_id, l_cd);
	//대여기본정보
	ContFeeBean fee = a_db.getContFeeNew(m_id, l_cd, rent_st);
	
	String taecha_no  	= request.getParameter("taecha_no")==null?"":request.getParameter("taecha_no");
	
	if(taecha_no.equals("")){
		taecha_no = a_db.getMaxTaechaNo(m_id, l_cd)+"";
	}
	
	//출고전대차 조회
	ContTaechaBean taecha = a_db.getContTaechaCase(m_id, l_cd, taecha_no);
	
	//대여료스케줄 한회차 정보
	FeeScdBean fee_scd = af_db.getScdNew(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
	
	Hashtable rtn = af_db.getFeeRtnCase(m_id, l_cd, rent_st, rent_seq);
	
	
	
	//기존대여스케줄 대여횟수 최대값
	int max_fee_tm = a_db.getMax_fee_tm(m_id, l_cd);
	
	int min_fee_tm = af_db.getMin_fee_tm(m_id, l_cd, rent_st, rent_seq);
	
	//대차보증금승계 계약기타정보
	ContEtcBean suc_cont_etc = a_db.getContEtcGrtSuc(m_id, l_cd);
	
	String suc_taecha_no  	= a_db.getMaxTaechaNo(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd())+"";
		
	//출고전대차 조회
	ContTaechaBean suc_taecha = a_db.getTaecha(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd(), suc_taecha_no);
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
		if(fm.req_dt.value == '')
			{	alert('발행일자를 입력하십시오.'); 		fm.req_dt.focus(); 		return; }
		if(fm.tax_out_dt.value == '')
			{	alert('청구일자를 입력하십시오.'); 		fm.tax_out_dt.focus(); 	return; }
		if(fm.fee_est_dt.value == '')
			{	alert('입금예정일를 입력하십시오.'); 	fm.fee_est_dt.focus(); 	return; }
		
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{									
			fm.action = './fee_scd_u_tm_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}		
	
	function cal_sv_amt(obj)
	{
		var fm = document.form1;
		obj.value=parseDecimal(obj.value);

		if(obj == fm.fee_s_amt){ //월대여료 공급가
			if(fm.not_account.checked==false){
				fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) * 0.1) ;
			}
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_v_amt){ //월대여료 부가세		
			if(fm.not_account.checked==false){
				fm.fee_s_amt.value = parseDecimal(toInt(parseDigit(fm.fee_v_amt.value)) / 0.1) ;
			}
			fm.fee_amt.value = parseDecimal(toInt(parseDigit(fm.fee_s_amt.value)) + toInt(parseDigit(fm.fee_v_amt.value))); 				
		}else if(obj == fm.fee_amt){ //월대여료 합계					
			fm.fee_s_amt.value = parseDecimal(sup_amt(toInt(parseDigit(fm.fee_amt.value))));
			fm.fee_v_amt.value = parseDecimal(toInt(parseDigit(fm.fee_amt.value)) - toInt(parseDigit(fm.fee_s_amt.value)));
		}
	}	
	
	//대여스케줄 삭제
	function del_schedule()
	{
		var fm = document.form1;
	
		
		if(confirm('스케줄를 삭제 하시겠습니까?'))
		{									
			if(confirm('스케줄를 정말로 삭제 하시겠습니까?'))
			{									
				if(confirm('스케줄를 완전 삭제됩니다. 정말 삭제 하시겠습니까?'))
				{									
					fm.action = './fee_scd_u_tm_d.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
			}
		}				
	}	
	
	//대여스케줄 삭제
	function del_schedule_all()
	{
		var fm = document.form1;
	
		
		if(confirm('스케줄를 일괄 삭제 하시겠습니까?'))
		{									
			if(confirm('스케줄를 정말로 삭제 하시겠습니까?'))
			{									
				if(confirm('스케줄를 완전 삭제됩니다. 정말 삭제 하시겠습니까?'))
				{									
					fm.action = './fee_scd_u_tm_d_all.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
			}
		}				
	}		
	
	function NoBill_schedule()
	{
		var fm = document.form1;		
				if(confirm('스케줄를 미청구 상태로 처리하시겠습니까?'))
				{									
					fm.action = './fee_scd_u_tm_nobill.jsp';
					fm.target = 'i_no';
					fm.submit();
				}
	}
	
	
	//대여스케줄 이관
	function cng_schedule2()
	{
		var fm = document.form1;
	
		
		if(fm.cng_rent_l_cd.value 		== '')				
			{	alert('변경 rent_l_cd를 입력하십시오.'); 		fm.cng_rent_l_cd.focus(); 	return; }
		if(fm.cng_rent_st.value == '')
			{	alert('변경 rent_st를 입력하십시오.'); 			fm.cng_rent_st.focus(); 	return; }
		if(fm.cng_rent_st.value == '')
			{	alert('변경 tm_st2를 입력하십시오.'); 			fm.cng_tm_st2.focus(); 		return; }

		if(fm.cng_choice1.checked == false && fm.cng_choice2.checked == false <%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%> && fm.cng_choice3.checked == false<%}%>)
		{ alert('이관할 항목을 선택하십시오.'); return;}
			
		if(confirm('스케줄를 이관 하시겠습니까?'))
		{									
			fm.action = './fee_scd_u_tm_cng_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}		
	
	//만기매칭대차 대여스케줄 이관
	function cng_schedule4()
	{
		var fm = document.form1;
	
		
		if(fm.cng_rent_l_cd2.value 		== '')	
			{	alert('변경 rent_l_cd를 입력하십시오.'); 		fm.cng_rent_l_cd2.focus(); 	return; }

		if(fm.cng_choice4.checked == false)
		{ alert('이관할 항목을 선택하십시오.'); return;}
			
		if(confirm('만기매칭대차 스케줄를 이관 하시겠습니까?'))
		{									
			if(confirm('정말로 스케줄를 이관 하시겠습니까?'))
			{							
				fm.action = './fee_scd_u_tm_cng2_a.jsp';
				fm.target = 'i_no';
				fm.submit();
			}
		}
	}				
	
	//회차번호늘리기
	function cng_schedule3()
	{
		var fm = document.form1;
			
		if(confirm('회차번호를 늘리시겠습니까?'))
		{									
			fm.action = './fee_scd_u_tm_add_a.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}				

	
	//청구금액 셋팅
	function set_reqamt(st){
		var fm = document.form1;			
		if(fm.use_s_dt.value == ''){	alert('시작일을 입력하십시오.'); return;}
		if(fm.use_e_dt.value == ''){	alert('시작일을 입력하십시오.'); return;}	
		
		fm.st.value = st;
		fm.action='getUseDayFeeAmt.jsp';		
		if(st == 'view'){
			fm.target='_blank';
		}else{
			fm.target='i_no';
		}				
		fm.submit();
	}
	
	//출고전대차 회차변경
	function cng_schedule_tae()
	{
		var fm = document.form1;
		
		if(fm.tae_tm_cng[0].checked==false && fm.tae_tm_cng[1].checked==false){ alert('지연대차스케줄 회차 변경 방식을 선택하십시오. '); return;}
		
		if(fm.tae_cng_fee_tm.value == ''){ alert('0회차가 아닌 경우 변경회차를 입력하십시오.'); return; }
		
		if(confirm('회차를 변경하시겠습니까?'))
		{									
			fm.action = './fee_scd_u_tm_cng3_a.jsp';
			//fm.target = 'i_no';
			fm.target = '_self';
			fm.submit();
		}		
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
<input type='hidden' name='fee_tm' value='<%=fee_tm%>'>
<input type='hidden' name='tm_st1' value='<%=tm_st1%>'>
<input type='hidden' name='tm_st2' value='<%=tm_st2%>'>
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
<%if(fee_scd.getTm_st2().equals("2")){//출고지연대차스케줄%>
<input type='hidden' name='o_fee_amt' value='<%=taecha.getRent_fee()%>'> 
<input type='hidden' name='o_fee_s_amt' value=''>
<input type='hidden' name='o_fee_v_amt' value=''>
<%}else if(fee_scd.getTm_st2().equals("4")){//선납대여료%>
<input type='hidden' name='o_fee_amt' value=''>
<input type='hidden' name='o_fee_s_amt' value=''>
<input type='hidden' name='o_fee_v_amt' value=''>
<%}else{%>
<input type='hidden' name='o_fee_amt' value='<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>'>
<input type='hidden' name='o_fee_s_amt' value='<%=fee.getFee_s_amt()%>'>
<input type='hidden' name='o_fee_v_amt' value='<%=fee.getFee_v_amt()%>'>
<%}%>
<input type='hidden' name='o_tot_fee_amt' value=''>
<input type='hidden' name='o_tot_mon' value=''>

<input type='hidden' name='st' value=''>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>

<input type='hidden' name='tm_cng_cau' value='<%=fee_scd.getCng_cau()%>'>
<input type='hidden' name='from_page' value='/fms2/con_fee/fee_scd_u_tm.jsp'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>재무회계 > 대여료스케줄관리 > <span class=style5>대여료스케줄 한회차씩 변경</span></span></td>
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
                    <td width='28%'>&nbsp;<%=base.get("RENT_L_CD")%></td>
                    <td width='14%' class='title'>상호</td>
                    <td>&nbsp;<%=base.get("FIRM_NM")%></td>
                </tr>
                <%if(!String.valueOf(base.get("R_SITE")).equals("")){%>
                <tr> 
                    <td class='title'>사용본거지</td>
                    <td colspan="3">&nbsp;<%=base.get("R_SITE")%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr> 
                    <td class='title'><%if(fee_scd.getTm_st2().equals("4")){//선납대여료%>선납대여료<%}else{%>월대여료<%}%></td>
                    <td colspan="3">&nbsp;
					<%if(fee_scd.getTm_st2().equals("2")){//출고지연대차스케줄%>
					<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원
					<%}else if(fee_scd.getTm_st2().equals("4")){//선납대여료%>
					<input type='text' name='p_fee_amt' value='' size='10' class='whitenum'>원
					<%}else{%>
					<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원
					&nbsp;&nbsp;&nbsp;&nbsp;(공급가:<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>, 부가세:<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>)
					<%}%>
					</td>
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
	<input type='hidden' name='rtn_yn' value='Y'>
	<%}else{%>
	<input type='hidden' name='rtn_yn' value='N'>
	<%}%>
	<tr> 
        <td class=h></td>
    </tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>대여료 스케줄 <%=fee_tm%>회차</span></td>	
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='14%' class='title'>월대여료</td>
                    <td>&nbsp;
        		    <input type='text' name='fee_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt()+fee_scd.getFee_v_amt())%>' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    원 (공급가 
                    <input type='text' name='fee_s_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_s_amt())%>' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    원 / 부가세 <input type='text' name='fee_v_amt' value='<%=AddUtil.parseDecimal(fee_scd.getFee_v_amt())%>' size='8' class='num' onBlur='javascript:this.value=parseDecimal(this.value); cal_sv_amt(this);'>
                    원, 
                    &nbsp;
                    <input type="checkbox" name="not_account" value="Y">
                	  금액 자동계산 없음
                	)
                    </td>
                </tr>
                <tr> 
                    <td class='title'>사용기간</td>
                    <td>&nbsp;
        		    <input type='text' name='use_s_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_s_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'>
                    ~ 
                    <input type='text' name='use_e_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getUse_e_dt())%>' size='11' class='text' onBlur="javscript:this.value = ChangeDate4(this, this.value);">
					( <input type='hidden' name='use_days' value=''>
					  <input type="text" name="u_mon" value="" size="5" class=text>개월
  					  <input type="text" name="u_day" value="" size="5" class=text>일 )
					  
					  <span class="b"><a href="javascript:set_reqamt('')" onMouseOver="window.status=''; return true" title="사용일수 및 대여료 일자계산합니다."><img src="/acar/images/center/button_in_cal.gif" align="absmiddle" border="0"></a></span>
        			  <span class="b"><a href="javascript:set_reqamt('view')" onMouseOver="window.status=''; return true" title="월대여료 계산하기"><img src="/acar/images/center/button_in_see.gif" align="absmiddle" border="0"></a></span>					  
					</td>
                </tr>
                <tr> 
                    <td class='title'>발행예정일자</td>
                    <td>&nbsp;
    		        <input type='text' name='req_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getReq_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>청구일자</td>
                    <td>&nbsp;
    		        <input type='text' name='tax_out_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getTax_out_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'></td>
                </tr>
                <tr> 
                    <td class='title'>입금예정일</td>
                    <td>&nbsp;
    		        <input type='text' name='fee_est_dt' value='<%=AddUtil.ChangeDate2(fee_scd.getFee_est_dt())%>' size='11' class='text' onBlur='javscript:this.value = ChangeDate4(this, this.value);'> 
                    </td>
                </tr>
                <tr> 
                    <td class='title'>입금여부</td>
                    <td>&nbsp;
    		        입금일자 : <%=AddUtil.ChangeDate2(fee_scd.getRc_dt())%>,  입금금액 : <%=AddUtil.parseDecimal(fee_scd.getRc_amt())%>
					<%if(fee_scd.getRc_amt()>0){%><font color=red>(대여료를 수정할 경우 잔액이 조정되니 변경후 확인하세요)</font><%}%>
                    </td>
                </tr>
            </table>
	    </td>
    </tr>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="14%" class='title'>변경사유</td>
                    <td>
                        &nbsp;<textarea name="cng_cau" cols="82" rows="3" class=default style='IME-MODE: active'></textarea>
                    </td>
                </tr>
                <tr>
                    <td width="14%" class='title'>일자계산내역</td>
                    <td>
                        &nbsp;<textarea name="etc" cols="82" rows="3" class=default style='IME-MODE: active'><%=fee_scd.getEtc()%></textarea>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<%if(rent_st.equals("1") && idx == 0 && fee_scd.getRc_yn().equals("0")){%>
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr>
                    <td width="14%" class='title'>자동처리</td>
                    <td>
                        <input type="checkbox" name="max_tm_auto" value="Y"><font color='red'>마지막회차 자동으로 맞춤</font>
                    </td>
                </tr>
            </table>
        </td>
    </tr>	
	<%}%>
	<tr>
	    <td><font color=green>* <!--1회차 사용기간에 있는 [계산하기]를 클릭하면 사용기간 및 대여료 일자 계산 합니다.-->1회차만료일 입력시 자동 계산함.</font></td>
    </tr>		
	<tr>
	    <td align="center">     
	    <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        	<a href="javascript:cng_schedule();"><img src=/acar/images/center/button_ch.gif border=0 align=absmiddle></a>
        	&nbsp;&nbsp;
            <%}%>
        	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>			
        </td>
	</tr>
	<tr>
	    <td><hr></td>
	</tr>	
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("연장/승계담당자",user_id) || nm_db.getWorkAuthUser("세금계산서담당자",user_id)){%>
	<!--  입금된건 삭제 불가 - 20210322 -->
	<tr>
	    <td align="right">      
	    <%if(fee_scd.getRc_amt()<1 ){ %>		
        	<a href="javascript:del_schedule();" title='대여료삭제'><img src=/acar/images/center/button_delete.gif border=0 align=absmiddle></a>        
       <% } %>
        </td>
	</tr>
	<%if(nm_db.getWorkAuthUser("전산팀",user_id) && fee_scd.getBill_yn().equals("Y") && fee_scd.getRc_dt().equals("")){ %>
	<!--  입금취소가 아닌 대체처리로 하면 이건은 사용안해도 됨(20190502)-->
	<tr>
	    <td align="right">      		
        <a href="javascript:NoBill_schedule();" title='대여료미청구'>[미청구상태로 변경]</a>
        </td>
	</tr>
	<%}%>		
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>계약승계,차종변경,연장일때 이관</td>	
	</tr>	
	<tr>
        <td class=line2></td>
    </tr>	
	<tr>
	    <td align='right' class="line">
    	    <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='14%' class='title'>구분</td>
                    <td width="6%" class='title'>선택</td>					
                    <td width="40%" class='title'>변경전</td>
                    <td width="40%" class='title'>변경후</td>
                </tr>
                <tr>
                  <td width='14%' class='title'>rent_l_cd</td>
                  <td align="center"><input type="checkbox" name="cng_choice1" value="Y"></td>				  
                  <td>&nbsp;<%=fee_scd.getRent_l_cd()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_l_cd' value='<%=fee_scd.getRent_l_cd()%>' size='20' class='text'></td>
                </tr>
                <tr>
                  <td class='title'>rent_st</td>
                  <td align="center"><input type="checkbox" name="cng_choice2" value="Y"></td>				  				  
                  <td>&nbsp;<%=fee_scd.getRent_st()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_st' value='<%=fee_scd.getRent_st()%>' size='3' class='text'></td>
                </tr>
				<%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%>
                <tr>
                  <td class='title'>tm_st2</td>
                  <td align="center"><input type="checkbox" name="cng_choice3" value="Y"></td>				  				  
                  <td>&nbsp;<%=fee_scd.getTm_st2()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_tm_st2' value='<%=fee_scd.getTm_st2()%>' size='3' class='text'></td>
                </tr>
				<%}%>
            </table>
	    </td>
    </tr>	
	<tr>
	    <td>* rent_l_cd : 계약이관, 차종변경일 경우의 대여료 스케줄 이관입니다.</td>	
	</tr>		
	<tr>
	    <td>* rent_st : 신규,연장스케줄간의 대여료 스케줄 이관입니다. 1은 신규 스케줄이고 그외에는 연장스케줄입니다.</td>	
	</tr>		
	<%if(fee_scd.getTm_st2().equals("2") || fee_scd.getTm_st2().equals("3")){%>
	<tr>
	    <td>* tm_st2 : 회차구분입니다. 0-일반대여료, 2-지연대차대여료, 3-임의연장대여료. tm_st2를 수정할 경우 rent_st도 연장스케줄로 바꿔주십시오.</td>	
	</tr>		
	<%}%>
	<tr>
	    <td align="right">      		
		<a href="javascript:cng_schedule2();" title='대여료이관'><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a>
        </td>
	</tr>
	<tr>
	    <td>fee_tm:<%=fee_tm%>, max_fee_tm:<%=max_fee_tm%>, suc_cont_etc:<%=suc_cont_etc.getRent_l_cd()%>, suc_taecha:<%=suc_taecha.getCar_no()%></td>
	</tr>	
	<%if(fee_tm.equals(String.valueOf(max_fee_tm)) && !suc_cont_etc.getRent_l_cd().equals("") && !suc_taecha.getCar_no().equals("")){//마지막회차
		Hashtable suc_cont_view = a_db.getContViewCase(suc_cont_etc.getRent_mng_id(), suc_cont_etc.getRent_l_cd());
	%>
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>만기매칭대차 이관</td>	
	</tr>	
	<tr>
            <td class=line2></td>
        </tr>	
	<tr>
	    <td align='right' class="line">
    	        <table border="0" cellspacing="1" cellpadding="0" width=100%>
                    <tr> 
                        <td width='14%' class='title'>구분</td>
                        <td width="6%" class='title'>선택</td>					
                        <td width="30%" class='title'>변경전</td>
                        <td width="30%" class='title'>변경후</td>
                        <td width="20%" class='title'>변경회차</td>
                    </tr>
                <tr>
                  <td width='14%' class='title'>rent_l_cd</td>
                  <td align="center"><input type="checkbox" name="cng_choice4" value="Y" checked ></td>				  
                  <td>&nbsp;<%=fee_scd.getRent_l_cd()%></td>
                  <td>&nbsp;
                    <input type='text' name='cng_rent_l_cd2' value='<%=suc_cont_etc.getRent_l_cd()%>' size='20' class='text'>
                    &nbsp;<%=suc_cont_view.get("CAR_NO")%>
                    <input type='hidden' name='cng_rent_mng_id2' value='<%=suc_cont_etc.getRent_mng_id()%>'>
                  </td>
                  <td>&nbsp;
                    <input type='text' name='cng_fee_tm' value='<%=fee_tm%>' size='2' class='text'>회차이후                   
                  </td>
                </tr>            
                </table>
	    </td>
        </tr>	
                <%if(!suc_taecha.getEnd_rent_link_sac_id().equals("")){%>
                <tr>
	    			<td>	        
	        			* 만기매칭대차 원계약과 대여개시일 / 대여만료일 차이가 35일 이상 혹은 신차요금 보다 30% 이상 차이가 발생하였습니다.<br>
	        			<font color=red><b>* 만기매칭대차 스케줄 이관후 출고지연대차에 입력된 "월대여료"를 기준으로 출고지연대차 스케줄을 변경하십시오.</b></font><br> 
	        			* 결재자 : <%=c_db.getNameById(suc_taecha.getEnd_rent_link_sac_id(),"USER")%>	           
	    			</td> 
				<tr>		 
                <%} %> 
	<tr>
	    <td align="right">      		
		<a href="javascript:cng_schedule4();" title='대여료이관'><img src=/acar/images/center/button_sch_ig.gif border=0 align=absmiddle></a>
        </td>
	</tr>	        
        <%}%>					
	<%}%>	
	
	<tr>
	    <td><hr></td>
	</tr>		
	<tr>
	    <td>      		
		<a href="javascript:cng_schedule3();" title='한회차늘리기'>[한회차늘리기]</a>
		&nbsp;&nbsp;<font color=red>(청구서 발행된 것이 없어야 합니다.)</font>
        </td>
	</tr>			
	<%if(AddUtil.parseInt(fee_tm)==min_fee_tm && (nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("연장/승계담당자",user_id))){%>
	<tr>
	    <td><hr></td>
	</tr>		
	<tr>
	    <td>      		
		<a href="javascript:del_schedule_all();" title='스케줄삭제'>[<%if(rent_st.equals("1")){%>신규<%}else{%>연장<%=AddUtil.parseInt(rent_st)-1%>차<%}%> 스케줄 일괄 삭제]</a>
		&nbsp;&nbsp;<font color=red>(청구서 발행된 것이 없어야 합니다.)</font>
        </td>
	</tr>		
	<%}%>	
	
	<%if(fee_scd.getTm_st2().equals("2") && AddUtil.parseInt(fee_scd.getFee_tm()) >= max_fee_tm){%>	
	<%	if(nm_db.getWorkAuthUser("전산팀",user_id) || nm_db.getWorkAuthUser("스케줄생성자",user_id) || nm_db.getWorkAuthUser("연장/승계담당자",user_id)){%>
	<tr>
	    <td><hr></td>
	</tr>	
	<tr>
	    <td>
	    ※ 지연대차스케줄 <a href="javascript:cng_schedule_tae();" title='회차변경'>[회차변경]</a>
	    <br>     
	    <input type="radio" name="tae_tm_cng" value="1" > 0회차로 변경
	    &nbsp;&nbsp;<font color=red>(0회차 변경은 출고전대차스케줄이 하나만 있을 때입니다. )</font><br>
	    <input type="radio" name="tae_tm_cng" value="2" > <input type='text' name='tae_cng_fee_tm' value='1' size='1' class='text'>회차로 변경 
	    &nbsp;&nbsp;<font color=red>(다음스케줄 회차 전체 밀립니다. 계산서 회차변경 가능성 있습니다. )</font><br> 
        </td>
	</tr>
	<%	}%>		
	<%}%>	
	<tr>
	    <td>&nbsp;</td>
	</tr>		
	
		
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.o_tot_fee_amt.value = parseDecimal( <%=fee.getFee_s_amt()+fee.getFee_v_amt()%> * (<%=fee.getCon_mon()%>-<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>));
	fm.o_tot_mon.value 		 = <%=fee.getCon_mon()%>-(<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>);
	
	<%if(fee_scd.getTm_st2().equals("4")){//선납대여료%>
	fm.o_fee_amt.value 		= parseDecimal( <%=fee.getPp_s_amt()+fee.getPp_v_amt()%>/<%=fee.getCon_mon()%>);
	fm.o_fee_s_amt.value 	= sup_amt(toInt(parseDigit(fm.o_fee_amt.value)));
	fm.o_fee_v_amt.value 	= toInt(parseDigit(fm.o_fee_amt.value)) - toInt(fm.o_fee_s_amt.value);
	fm.p_fee_amt.value 		= fm.o_fee_amt.value;	
	<%}%>
	
//-->
</script>
</body>
</html>
