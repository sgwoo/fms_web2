<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.cont.*, acar.util.*, acar.bank_mng.*, acar.car_mst.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
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
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	//계약정보
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	//출고영업소정보
	Hashtable mgrs = a_db.getCommiNInfo(m_id, l_cd);
	Hashtable mgr_dlv = (Hashtable)mgrs.get("DLV");	
	
	String ssn = AddUtil.ChangeEnpH(String.valueOf(cont.get("ENP_NO")));
	
	CodeBean[] banks = c_db.getBankList("1"); /* 코드 구분:제1금융권 */	
	int bank_size = banks.length;
	CodeBean[] banks2 = c_db.getBankList("2"); /* 코드 구분:제2금융권 */
	int bank_size2 = banks2.length;
	
	//자동차회사&차종&자동차명
	AddCarMstDatabase a_cmb = AddCarMstDatabase.getInstance();
	CarMstBean mst = a_cmb.getCarEtcNmCase(m_id, l_cd);
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	int cnt = 7; //현황 출력 영업소 총수
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//현황 라인수만큼 제한 아이프레임 사이즈
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		var fm = document.form1;

		if(fm.allot_st.value == '2'){
			if(fm.cpt_cd.value == '' && fm.cpt_cd2.value == ''){	alert('금융사를 입력하십시오');	fm.lend_dt.focus(); return;	}
			if(fm.lend_dt.value == ''){			alert('대출일자를 입력하십시오');		fm.lend_dt.focus(); 		return;	}
			if(fm.lend_prn.value == ''){		alert('대출원금을 입력하십시오');		fm.lend_prn.focus(); 		return;	}
			if(fm.lend_int.value == ''){		alert('대출이율를 입력하십시오');		fm.lend_int.focus(); 		return;	}
			if(fm.rtn_tot_amt.value == ''){		alert('상환총금액을 입력하십시오');		fm.rtn_tot_amt.focus(); 	return;	}						
			if(fm.tot_alt_tm.value == ''){		alert('할부횟수를 입력하십시오');		fm.tot_alt_tm.focus(); 		return;	}						
			if(fm.alt_amt.value == ''){			alert('월상환료를 입력하십시오');		fm.alt_amt.focus();			return;	}		
		}

		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.pay_sch_amt.value)) - toInt(parseDigit(fm.lend_prn.value)));						

		if(confirm('등록하시겠습니까?')){					
			fm.action='debt_reg_i_a.jsp';		
			fm.target='i_no';
//			fm.target='d_content';
			fm.submit();
		}
	}

	function go_to_list(){
		var fm = document.form1;		
		fm.action='debt_scd_frame_s.jsp';		
		fm.target='d_content';
		fm.submit();	
	}

	//설정비용,말소비용 합계계산
	function set_tot_amt(obj){
		fm = document.form1;
		var fm = document.form1;	
		if(obj == fm.cltr_set_dt){//설정일자 입력
		  fm.cltr_f_amt.value = fm.cltr_amt.value;
			fm.reg_tax.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.002);
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.cltr_f_amt.value)) * 0.004);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.reg_tax){//설정등록세 입력
			fm.set_stp_fee.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) * 2);
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else if(obj == fm.set_stp_fee){//설정인지대 입력
			fm.ext_tot_amt.value = parseDecimal(toInt(parseDigit(fm.reg_tax.value)) + toInt(parseDigit(fm.set_stp_fee.value)));
		}else	if(obj == fm.exp_tax){//말소등록세 입력
//			fm.exp_stp_fee.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) * 2);
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}else if(obj == fm.exp_stp_fee){//말소인지대 입력
			fm.exp_tot_amt.value = parseDecimal(toInt(parseDigit(fm.exp_tax.value)) + toInt(parseDigit(fm.exp_stp_fee.value)));
		}		
	}		
		
	//상환총액,할부기간,월상환료 셋팅
	function set_alt_term(obj){
		var fm = document.form1;	
		if(obj == fm.alt_start_dt){//할부기간 종료일 셋팅
			fm.action='debt_dt_nodisplay.jsp?alt_start_dt='+fm.alt_start_dt.value+'&tot_alt_tm='+fm.tot_alt_tm.value;
			fm.target='i_no';
			fm.submit();		
		}
		else if(obj == fm.lend_int_amt){
			fm.rtn_tot_amt.value = parseDecimal(toInt(parseDigit(fm.lend_prn.value)) + toInt(parseDigit(fm.lend_int_amt.value)));	
		}
		else if(obj == fm.rtn_tot_amt || obj == fm.tot_alt_tm){
			fm.alt_amt.value = parseDecimal(toInt(parseDigit(fm.rtn_tot_amt.value)) / toInt(parseDigit(fm.tot_alt_tm.value)));	
		}
	}		
			
	//디스플레이 타입
	function bond_sub_display(){
		var fm = document.form1;
		if(fm.bond_get_st.options[fm.bond_get_st.selectedIndex].value == '7'){ //채권확보유형 선택시 기타입력 디스플레이
			td_bond_sub.style.display	= '';
		}else{
			td_bond_sub.style.display	= 'none';
		}
	}	

	//디스플레이 타입
	function bn_display(){
		var fm = document.form1;
		if(fm.cpt_cd_st.options[fm.cpt_cd_st.selectedIndex].value == '1'){ //금융사구분 선택시 금융사 디스플레이
			td_bn_1.style.display	= '';
			td_bn_2.style.display	= 'none';
		}else{
			td_bn_1.style.display	= 'none';
			td_bn_2.style.display	= '';
		}
	}	
	

	
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='debt_reg_i_a.jsp' target='' method="post">
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
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='pay_sch_amt' value='<%=cont.get("CAR_F_AMT")%>'>
<input type='hidden' name='dif_amt' value=''>
<input type='hidden' name='rimitter' value=''>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>

  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 구매자금관리 > 할부금관리 > <span class=style1><span class=style5>할부금 등록(건별)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
      <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td align="right" colspan=2>
	    <%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>					  
	    <a href='javascript:save();'><img src=../images/center/button_reg.gif align=absmiddle border=0></a>&nbsp;
	    <%	}%>		  
        <a href='javascript:go_to_list();'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
        </td>
    </tr>
    <tr> 
        <td class=line2 colspan=2></td>
    </tr>  
     
    
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='85' class='title'>계약번호</td>
            <td width='115'>&nbsp;<%=l_cd%> </td>
            <td width='85' class='title'>상호</td>
            <td colspan="3">&nbsp;<%=cont.get("FIRM_NM")%> </td>
            <td width='85' class='title'> 사업자등록번호</td>
            <td align='left'>&nbsp;<%=ssn%></td>
          </tr>
          <tr> 
            <td width='85' class='title'> 차량번호</td>
            <td width='115'>&nbsp;<%=cont.get("CAR_NO")%></td>
            <td width='85' class='title'> 차명</td>
            <td width='115' align='left'>&nbsp;<span title='<%=mst.getCar_nm()+" "+mst.getCar_name()%>'><%=Util.subData(mst.getCar_nm()+" "+mst.getCar_name(), 9)%></span></td>
            <td width='85' class='title'>소비자가격</td>
            <td width='115'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_C_AMT")))%>원&nbsp;</td>
            <td width='85' class='title'>구입가격</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("CAR_F_AMT")))%>원&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'>출고일자</td>
            <td width='115'>&nbsp;<%=cont.get("DLV_DT")%></td>
            <td width='85' class='title'>최초등록일자</td>
            <td width='115'>&nbsp;<%=cont.get("INIT_REG_DT")%></td>
            <td class='title' width="85">계약기간</td>
            <td width='115'>&nbsp;<%=cont.get("CON_MON")%>개월</td>
            <td width='85' class='title'>대여방식</td>
            <td>&nbsp;<%=cont.get("RENT_WAY")%></td>
          </tr>
          <tr> 
            <td class='title' width="85">계약개시일</td>
            <td width="115">&nbsp;<%=cont.get("RENT_START_DT")%></td>
            <td class='title' width="85">계약종료일</td>
            <td width="115">&nbsp;<%=cont.get("RENT_END_DT")%></td>
            <td class='title' width="85">월대여료</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("FEE_AMT")))%>원&nbsp;</td>
            <td class='title' width="85">총대여료</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_FEE_AMT")))%>원&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'> 보증금</td>
            <td width='115' align='left'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("GRT_AMT")))%>원&nbsp;</td>
            <td width='85' class='title'>선납금</td>
            <td width='115'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("PP_AMT")))%>원&nbsp;</td>
            <td width='85' class='title'>개시대여료</td>
            <td width='95'>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("IFEE_AMT")))%>원&nbsp;</td>
            <td class='title' width="85">선수금총액</td>
            <td>&nbsp;<%=Util.parseDecimal(String.valueOf(cont.get("TOT_PRE_AMT")))%>원&nbsp;</td>
          </tr>
          <tr> 
            <td class='title'>자동차회사</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("COM_NM") != null) out.println(mgr_dlv.get("COM_NM"));%></td>
            <td  class='title' width="85">지점/영업소</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%>&nbsp;<%if(mgr_dlv.get("CAR_OFF_ST") != null && !mgr_dlv.get("CAR_OFF_ST").equals("1") && mgr_dlv.get("CAR_OFF_NM") != null) out.println(mgr_dlv.get("CAR_OFF_NM"));%></td>
            <td  class='title'>출고담당자</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("NM") != null) out.println(mgr_dlv.get("NM"));%>&nbsp;<%if(mgr_dlv.get("POS") != null) out.println(mgr_dlv.get("POS"));%></td>
            <td class='title'>전화번호</td>
            <td align='left'>&nbsp;<%if(mgr_dlv.get("O_TEL") != null) out.println(mgr_dlv.get("O_TEL"));%></td>
          </tr>		  
        </table>
      </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    
    <tr> 
      <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부관리</span></td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class=title width="85">할부구분</td>
            <td width="115">&nbsp; 
              <select name='allot_st'>
                <option value="1">현금구매</option>
                <option value="2" selected>할부구매</option>
              </select>
            </td>
            <td class=title width="85">금융사구분</td>
            <td width="115">&nbsp; 
              <select name='cpt_cd_st' onChange='javascript:bn_display()'>
                <option value="">선택</option>
                <option value="1">제1금융권</option>
                <option value="2">제2금융권</option>
              </select>
            </td>
            <td width='85' class='title'>금융사</td>
            <td width='115'>
              <table width="115" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td id="td_bn_1" style="display:''" width="115">&nbsp; 
                    <select name='cpt_cd'>
	                <option value="">선택</option>					
                      <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									CodeBean bank = banks[i];		%>
                      <option value='<%= bank.getCode()%>'><%= bank.getNm()%></option>
                      <%		}
							}		%>
                    </select>
                  </td>
                  <td id="td_bn_2" style='display:none' width="115">&nbsp; 
                    <select name='cpt_cd2'>
	                <option value="" selected>선택</option>										
                      <%	if(bank_size2 > 0){
								for(int i = 0 ; i < bank_size2 ; i++){
									CodeBean bank2 = banks2[i];		%>
                      <option value='<%= bank2.getCode()%>'><%= bank2.getNm()%></option>
                      <%		}
							}		%>
                    </select>
                  </td>
                </tr>
              </table>
            </td>
            <td width='85' class='title'>대출번호 </td>
            <td>&nbsp; 
              <input type='text' name='lend_no' size='20' maxlength='30' class='text'>
            </td>
          </tr>
          <tr> 
            <td width='85' class='title'>대출일자 </td>
            <td width="115">&nbsp; 
              <input type='text' name='lend_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
            <td width='85' class='title'>대출원금 </td>
            <td width='115'>&nbsp; 
              <input type='text' name='lend_prn' size='11' maxlength='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원</td>
            <td width='85' class='title'>대출이자</td>
            <td width='115'>&nbsp; 
              <input type='text' name='lend_int_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              원</td>
            <td width='85' class='title'>대출이율</td>
            <td>&nbsp; 
              <input type='text' name='lend_int' size='6' maxlength='6' class='num'>
              %</td>
          </tr>
          <tr> 
            <td class='title' width="85">상환총금액</td>
            <td width="115">&nbsp; 
              <input type='text' name='rtn_tot_amt' maxlength='11' size='11' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_alt_term(this);'>
              원</td>
            <td class='title' width="85">상환의무자</td>
            <td width="115">&nbsp; 
              <select name='loan_debtor'>
                <option value='1'>고객</option>
                <option value='2' selected>당사</option>
              </select>
            </td>
            <td class='title' width="85">상환조건</td>
            <td width="115">&nbsp; 
              <select name='rtn_cdt'>
                <option value='1'>원리금균등</option>
                <option value='2'>원금균등</option>
              </select>
            </td>
            <td class='title' width="85">상환방법</td>
            <td>&nbsp; 
              <select name='rtn_way'>
                <option value='1'>자동이체</option>
                <option value='2'>지로</option>
                <option value='3'>기타</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">상환약정일 </td>
            <td width="115">&nbsp; 
              <select name='rtn_est_dt'>
                <%	for(int j=1; j<=31 ; j++){ //1~31일 %>
                <option value='<%=j%>'><%=j%>일 </option>
                <% } %>
                <option value='99'> 말일 </option>
              </select>
            </td>
            <td class='title' width="85">할부횟수 </td>
            <td width="115">&nbsp; 
              <input type='text' name='tot_alt_tm' size='3' maxlength='2' class='num' onBlur='javascript:set_alt_term(this);'>
              회</td>
            <td class='title' width="85">할부기간 </td>
            <td colspan="3">&nbsp; 
              <input type='text' name='alt_start_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_alt_term(this);'>
              ~ 
              <input type='text' name='alt_end_dt' size='12' maxlength='10' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">월상환료</td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
            <td class='title' width="85">할부수수료 </td>
            <td width="115">&nbsp; 
              <input type='text' name='alt_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
            <td class='title' width="85">공증료</td>
            <td>&nbsp; 
              <input type='text' name='ntrl_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
            <td class='title' width="85">인지대 </td>
            <td>&nbsp; 
              <input type='text' name='stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
          </tr>
          <tr> 
            <td class='title' width="85">채권확보유형</td>
            <td colspan='7'>
              <table width="580" border="0" cellspacing="0" cellpadding="0">
                <tr> 
                  <td width="320">&nbsp; 
                    <select name='bond_get_st'  onChange='javascript:bond_sub_display()'>
                      <option value="">선택</option>
                      <option value="1">계약서 </option>
                      <option value="2">계약서+인감증명서</option>
                      <option value="3">계약서+인감증명서+공증서</option>
                      <option value="4">계약서+인감증명서+공증서+LOAN 연대보증서계약자</option>
                      <option value="5">계약서+인감증명서+공증서+LOAN 연대보증서보증인</option>
                      <option value="6">계약서+연대보증인</option>
                      <option value="7">기타</option>
                    </select>
                  </td>
                  <td id="td_bond_sub" style='display:none' width="260">&nbsp; 
                    <input type="text" name="bond_get_st_sub" maxlength='40' value="" size="40" class=text>
                  </td>
                </tr>
              </table>
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">기타</td>
            <td colspan='7'>&nbsp; 
              <input type="text" name="note" value="" maxlength='80' size="80" class=text>
            </td>
          </tr>
                <tr> 
                    <td class=title width=10%>중도상환<br>수수료율</td>
                    <td width=15%>&nbsp; 
                      <input type="text" name="cls_rtn_fee_int" maxlength='5' value="" size="5" class=text >
                      %</td>
                    <td class=title wwidth=10%>중도상환<br>특이사항</td>
                    <td colspan='5'>&nbsp; 
                      <textarea name="cls_rtn_etc" cols="90" rows="2"></textarea></td>                    
                </tr>	
		  
        </table>
      </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
      <td colspan="2"><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>근저당설정관리</span>&nbsp;&nbsp;<input type="checkbox" name="cltr_st" value="Y">&nbsp;근저당설정</td>
    </tr>	
    <tr> 
      <td class='line' colspan="2"> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td class=title width="85">설정약정액</td>
            <td width="115">&nbsp; <input type='text' name='cltr_amt' maxlength='10' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원</td>
            <td width='85' class='title'>설정서류<br>
              작성일자</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_docs_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>설정일자</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_set_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value); set_tot_amt(this)'> 
            </td>
            <td width='85' class='title'>설정가액</td>
            <td>&nbsp; <input type='text' name='cltr_f_amt' size='10' maxlength='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'>
              원 </td>
          </tr>
          <tr> 
            <td width='85' class='title'>저당권순위</td>
            <td width='115'>&nbsp; <select name='mort_lank'>
                <option value="1">1</option>
                <option value="2">2</option>
                <option value="3">3</option>
              </select>
              위</td>
            <td class='title' width="85">설정율</td>
            <td width="115">&nbsp; <input type='text' name='cltr_per_loan' maxlength='6' size='6' class='num' onBlur='javascript:set_tot_amt(this)'>
              %</td>
            <td class='title' width="85">근저당권자</td>
            <td>&nbsp; <input type='text' name='cltr_user' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title'>을부번호</td>
            <td>&nbsp; <input name='cltr_num' type='text' class='text' id="cltr_num" size='14' maxlength='20'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">등록관청</td>
            <td width="115">&nbsp; <input type='text' name='cltr_office' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">담당자</td>
            <td width="115">&nbsp; <input type='text' name='cltr_offi_man' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">전화번호</td>
            <td width="115">&nbsp; <input type='text' name='cltr_offi_tel' size='12' maxlength='15' class='text'> 
            </td>
            <td class='title' width="85">팩스번호</td>
            <td>&nbsp; <input type='text' name='cltr_offi_fax' size='12' maxlength='15' class='text'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">설정등록세</td>
            <td width="115">&nbsp; <input type='text' name='reg_tax' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              원&nbsp;</td>
            <td class='title' width="85">설정인지대</td>
            <td width="115">&nbsp; <input type='text' name='set_stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              원&nbsp;</td>
            <td class='title' width="85">설정비용합계</td>
            <td colspan='3'>&nbsp; <input type='text' name='ext_tot_amt' maxlength='9' size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
          </tr>
          <tr> 
            <td width='85' class='title'>말소등록일</td>
            <td width='115'>&nbsp; <input type='text' name='cltr_exp_dt' size='12' maxlength='15' class='text' onBlur='javscript:this.value=ChangeDate(this.value);'> 
            </td>
            <td width='85' class='title'>말소사유</td>
            <td colspan="5">&nbsp; <input type='text' name='cltr_exp_cau' maxlength='100' size='80' class='text'> 
            </td>
          </tr>
          <tr> 
            <td class='title' width="85">말소등록세</td>
            <td width="115">&nbsp; <input type='text' name='exp_tax' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              원&nbsp;</td>
            <td class='title' width="85">말소인지대</td>
            <td width="115">&nbsp; <input type='text' name='exp_stp_fee' maxlength='9' size='10' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot_amt(this);'>
              원&nbsp;</td>
            <td class='title' width="85">말소비용합계</td>
            <td colspan='3'>&nbsp; <input type='text' name='exp_tot_amt' maxlength='9' size='10' class='whitenum' onBlur='javascript:this.value=parseDecimal(this.value)'>
              원&nbsp;</td>
          </tr>
        </table>
      </td>
    </tr>	

  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
