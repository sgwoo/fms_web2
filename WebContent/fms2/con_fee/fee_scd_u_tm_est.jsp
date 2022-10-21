<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.fee.*, acar.util.*, tax.*, acar.user_mng.*"%>
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
	
	String doc_no	 	= request.getParameter("doc_no")==null?"":request.getParameter("doc_no");
	String mode   		= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
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
	FeeScdBean fee_scd = af_db.getScdFeeEst(m_id, l_cd, rent_st, rent_seq, fee_tm, tm_st1);
	
	
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
			{	alert('발행일자를 입력하십시오.'); 		fm.req_dt.focus(); 	return; }
		if(fm.tax_out_dt.value == '')
			{	alert('청구일자를 입력하십시오.'); 		fm.tax_out_dt.focus(); 	return; }
		if(fm.fee_est_dt.value == '')
			{	alert('입금예정일를 입력하십시오.'); 		fm.fee_est_dt.focus(); 	return; }
			

		
		if(confirm('스케줄를 변경 하시겠습니까?'))
		{									
			fm.action = './fee_scd_u_tm_est_a.jsp';
			fm.target = 'i_no';
//			fm.target = 'SCDUPD';
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
<input type='hidden' name='o_fee_amt' value='<%=fee.getFee_s_amt()+fee.getFee_v_amt()%>'>
<input type='hidden' name='o_fee_s_amt' value='<%=fee.getFee_s_amt()%>'>
<input type='hidden' name='o_fee_v_amt' value='<%=fee.getFee_v_amt()%>'>
<input type='hidden' name='o_tot_fee_amt' value=''>
<input type='hidden' name='st' value=''>
<input type='hidden' name='firm_nm' value='<%=base.get("FIRM_NM")%>'>
<input type='hidden' name="doc_no" 			value="<%=doc_no%>">
<input type='hidden' name="mode" 			value="<%=mode%>">
<input type='hidden' name='cng_cau' value=''>
<input type='hidden' name='from_page' value='/fms2/con_fee/fee_scd_u_tm_est.jsp'>

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
                    <td colspan="3">&nbsp;<%=base.get("R_SITE_NM")%></td>
                </tr>
                <%}%>
                <tr> 
                    <td class='title'>차량번호</td>
                    <td>&nbsp;<font color="#000099"><b><%=base.get("CAR_NO")%></b></font></td>
                    <td class='title'>차명</td>
                    <td>&nbsp;<span title='<%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%>'><%=base.get("CAR_NM")+" "+base.get("CAR_NAME")%></span> </td>
                </tr>
                <tr> 
                    <td class='title'>월대여료</td>
                    <td colspan="3">&nbsp;
					<%if(fee_scd.getTm_st2().equals("2")){//출고지연대차스케줄%>
					<%=AddUtil.parseDecimal(taecha.getRent_fee())%>원
					<%}else{%>
					<%=AddUtil.parseDecimal(fee.getFee_s_amt()+fee.getFee_v_amt())%>원
					&nbsp;&nbsp;&nbsp;&nbsp;(공급가:<%=AddUtil.parseDecimal(fee.getFee_s_amt())%>, 부가세:<%=AddUtil.parseDecimal(fee.getFee_v_amt())%>)
					<%}%>
					</td>
                </tr>				
            </table>
	    </td>
	</tr>
	<input type='hidden' name='rtn_yn' value='N'>
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
                    원
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
                    <td class='title'>일자계산내역</td>
                    <td>&nbsp;
    		        <input type='text' name='etc' value='<%=fee_scd.getEtc()%>' size='80' class='text'> 
                    </td>
                </tr>
            </table>
	    </td>
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
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language='javascript'>
<!--
	var fm = document.form1;
	fm.o_tot_fee_amt.value = parseDecimal( <%=fee.getFee_s_amt()+fee.getFee_v_amt()%> * (<%=fee.getCon_mon()%>-<%=fee.getIfee_s_amt()%>/<%=fee.getFee_s_amt()%>));		
//-->
</script>
</body>
</html>
