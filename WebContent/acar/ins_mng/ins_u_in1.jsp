<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.accid.*, acar.insur.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");//권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//사용자 소속영업소
	
	String gubun0 = request.getParameter("gubun0")==null?"":request.getParameter("gubun0");
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"2":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");	
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");	
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");	
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");	
	String gubun7 = request.getParameter("gubun7")==null?"":request.getParameter("gubun7");	
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"1":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");	
	String s_st = request.getParameter("s_st")==null?"1":request.getParameter("s_st");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");	
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");//계약관리번호
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");//계약번호
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");//자동차관리번호
	String ins_st = request.getParameter("ins_st")==null?"":request.getParameter("ins_st");//보험관리번호
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String update_yn = request.getParameter("update_yn")==null?"":request.getParameter("update_yn");
	
	String mode = "1";
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();	
	EstiDatabase e_db = EstiDatabase.getInstance();

	//계약조회
	Hashtable cont = as_db.getRentCase(m_id, l_cd);
	
	//보험정보
	InsurBean ins = ai_db.getInsCase(c_id, ins_st);
	
	//블랙박스 설치내용
	Hashtable tint_b = ai_db.getCarBlackBox(c_id);
	
	//변수
	String var1 = e_db.getEstiSikVarCase("1", "", "ins_modify_dt");
	String var2 = e_db.getEstiSikVarCase("1", "", "ins_modify_mon");
		
	if(update_yn.equals("")){
			
		String modify_deadline = c_db.addMonth(ins.getIns_exp_dt(), AddUtil.parseInt(var2)).substring(0,8)+""+var1;
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) == 20220325) modify_deadline = "20220425";
		
		if(AddUtil.parseInt(AddUtil.replace(modify_deadline,"-","")) < AddUtil.parseInt(AddUtil.getDate(4))){
			update_yn = "N";
		}
		
	}	
	
	String valus = 	"?auth_rw="+auth_rw+"&user_id="+user_id+"&br_id="+br_id+
					"&s_kd="+s_kd+"&t_wd="+t_wd+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&st_dt="+st_dt+"&end_dt="+end_dt+"&sort="+sort+
					"&rent_mng_id="+m_id+"&rent_l_cd="+l_cd+"&update_yn="+update_yn+
				   	"";
	
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//수정하기
	function save(){	
		var fm = document.form1;	
		if(fm.ins_st.value == ''){ alert("상단을 먼저 등록하십시오."); return; }
		if(!confirm('수정하시겠습니까?')){	return;	}
		fm.target = "i_no";
		fm.submit();
	}
	
	//보험료 합계 셋팅
	function set_tot(){
		var fm = document.form1;
		//책임
		fm.tot_amt1.value = fm.rins_pcp_amt.value;	
		//임의
		fm.tot_amt2.value = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
											toInt(parseDigit(fm.vins_gcp_amt.value))+
											toInt(parseDigit(fm.vins_bacdt_amt.value))+
											toInt(parseDigit(fm.vins_canoisr_amt.value))+
											toInt(parseDigit(fm.vins_share_extra_amt.value))+
											toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
											toInt(parseDigit(fm.vins_spe_amt.value)));
		//계
		fm.tot_amt12.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)));
		//fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt12.value)) - toInt(parseDigit(fm.vins_blackbox_amt.value)));
		//fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt12.value)) );
	}	
	
	//물적사고할증기준 선택에 따라 자기부담금 셋팅
	function setCacdtMeAmt(){
		var fm = document.form1;
		fm.vins_cacdt_memin_amt.value = toInt(fm.vins_cacdt_mebase_amt.value)*0.1;		
		if(toInt(fm.vins_cacdt_mebase_amt.value) >0){
			fm.vins_cacdt_me_amt.value = 50;
		}
	}
	
	//스캔등록
	function scan_file(tint_st, content_code, content_seq){
		window.open("/fms2/car_tint/reg_scan.jsp<%=valus%>&tint_st="+tint_st+"&content_code="+content_code+"&content_seq="+content_seq, "SCAN", "left=300, top=300, width=720, height=300, scrollbars=yes, status=yes, resizable=yes");
	}	
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
  <form action="ins_u_a.jsp" name="form1">
    <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
    <input type='hidden' name='user_id' value='<%=user_id%>'>
    <input type='hidden' name='br_id' value='<%=br_id%>'>
	<input type='hidden' name='gubun0' value='<%=gubun0%>'>
	<input type='hidden' name='gubun1' value='<%=gubun1%>'>
	<input type='hidden' name='gubun2' value='<%=gubun2%>'>
	<input type='hidden' name='gubun3' value='<%=gubun3%>'>
	<input type='hidden' name='gubun4' value='<%=gubun4%>'>
	<input type='hidden' name='gubun5' value='<%=gubun5%>'>
	<input type='hidden' name='gubun6' value='<%=gubun6%>'>
	<input type='hidden' name='gubun7' value='<%=gubun7%>'>
	<input type='hidden' name='brch_id' value='<%=brch_id%>'>
	<input type='hidden' name='st_dt' value='<%=st_dt%>'>
	<input type='hidden' name='end_dt' value='<%=end_dt%>'>
	<input type='hidden' name='s_kd' value='<%=s_kd%>'>
	<input type='hidden' name='t_wd' value='<%=t_wd%>'>
	<input type='hidden' name='sort' value='<%=sort%>'>
	<input type='hidden' name='asc' value='<%=asc%>'>
	<input type="hidden" name="idx" value="<%=idx%>">
	<input type="hidden" name="s_st" value="<%=s_st%>">
	<input type='hidden' name="go_url" value='<%=go_url%>'>
    <input type='hidden' name='m_id' value='<%=m_id%>'>
    <input type='hidden' name='l_cd' value='<%=l_cd%>'>
    <input type='hidden' name='c_id' value='<%=c_id%>'>
    <input type='hidden' name='ins_st' value='<%=ins_st%>'>
    <input type='hidden' name='mode' value='<%=mode%>'>
    <tr> 
        <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험청약사항</span></td>
        <td align="right"> 
	    <%if(!cmd.equals("view")){%>
        <%		if(!update_yn.equals("N") && (auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))){%>
        <a href='javascript:save()'><img src=../images/center/button_modify.gif align=absmiddle border=0></a> 
        <%		}%>
        <%}%>		
        </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title>보험가입일</td>
					<td colspan='3'>&nbsp;<input type="text" name="ins_rent_dt" value="<%=AddUtil.ChangeDate2(ins.getIns_rent_dt())%>" size="11" class="text"  onBlur='javascript:this.value=ChangeDate(this.value);'></td>
                </tr>			
                <tr> 
                    <td class=title colspan="2">담보</td>
                    <td class=title>가입금액</td>
                    <td class=title>보험료</td>
                </tr>
                <tr> 
                    <td class=title width=10%>책임보험</td>
                    <td class=title width=15%>대인배상Ⅰ</td>
                    <td width=60%>&nbsp;자배법 시행령에서 정한 금액</td>
                    <td width=15% align="center"> 
                      <input type='text' size='10' name='rins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getRins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'>
                  원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr1 style='display:<%if(ins.getIns_kd().equals("2")) {%>blank<%} else{%>blank<%}%>'> 
        <td class=line colspan="2"> 
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td class=title rowspan="10" width=10%>임의보험</td>
                    <td class=title colspan="2">대인배상Ⅱ</td>
                    <td width=60%> 
                      &nbsp;
                      <select name='vins_pcp_kd'>
                        <option value='1' <%if(ins.getVins_pcp_kd().equals("1")){%>selected<%}%>>무한</option>
                        <option value='2' <%if(ins.getVins_pcp_kd().equals("2")){%>selected<%}%>>유한</option>
                      </select>
                  </td>
                    <td align="center" width=15%> 
                      <input type='text' size='10' name='vins_pcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_pcp_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">대물배상&nbsp;&nbsp;</td>
                    <td> 
                      &nbsp;<select name='vins_gcp_kd'>
                        <option value='9' <%if(ins.getVins_gcp_kd().equals("9")){%>selected<%}%>>10억원</option>
                        <option value='6' <%if(ins.getVins_gcp_kd().equals("6")){%>selected<%}%>>5억원</option>
			<option value='8' <%if(ins.getVins_gcp_kd().equals("8")){%>selected<%}%>>3억원</option>
			<option value='7' <%if(ins.getVins_gcp_kd().equals("7")){%>selected<%}%>>2억원</option>
                        <option value='3' <%if(ins.getVins_gcp_kd().equals("3")|| ins.getVins_gcp_kd().equals("")){%>selected<%}%>>1억원</option>						
                        <option value='4' <%if(ins.getVins_gcp_kd().equals("4")){%>selected<%}%>>5000만원&nbsp;&nbsp;&nbsp;</option>
                        <option value='1' <%if(ins.getVins_gcp_kd().equals("1")){%>selected<%}%>>3000만원</option>
                        <option value='2' <%if(ins.getVins_gcp_kd().equals("2")){%>selected<%}%>>1500만원</option>
                        <option value='5' <%if(ins.getVins_gcp_kd().equals("5")){%>selected<%}%>>1000만원</option>				
                      </select>
                      (1사고당)</td>
                    <td align="center"> 
                      <input type='text' size='10' class='num' name='vins_gcp_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_gcp_amt()))%>' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
                <tr> 
                    <td class=title rowspan="2" colspan="2">자기신체사고</td>
                    <td> 
                      &nbsp;<select name='vins_bacdt_kd'>
                        <option value=""  <%if(ins.getVins_bacdt_kd().equals("")){%>selected<%}%>>선택</option>
                        <option value="1" <%if(ins.getVins_bacdt_kd().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kd().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kd().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kd().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kd().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kd().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당사망/장해)</td>
                    <td align="center" rowspan="2"> 
                      <input type='text' size='10' name='vins_bacdt_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_bacdt_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
                <tr> 
                    <td> 
                      &nbsp;<select name='vins_bacdt_kc2'>
                        <option value=""  <%if(ins.getVins_bacdt_kc2().equals("")){%>selected<%}%>>선택</option>					  
                        <option value="1" <%if(ins.getVins_bacdt_kc2().equals("1")){%>selected<%}%>>3억원</option>
                        <option value="2" <%if(ins.getVins_bacdt_kc2().equals("2")){%>selected<%}%>>1억5천만원</option>
                        <option value="6" <%if(ins.getVins_bacdt_kc2().equals("6")){%>selected<%}%>>1억원</option>
                        <option value="5" <%if(ins.getVins_bacdt_kc2().equals("5")){%>selected<%}%>>5000만원</option>
                        <option value="3" <%if(ins.getVins_bacdt_kc2().equals("3")){%>selected<%}%>>3000만원</option>
                        <option value="4" <%if(ins.getVins_bacdt_kc2().equals("4")){%>selected<%}%>>1500만원</option>
                      </select>
                      (1인당부상)</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">무보험차상해</td>
                    <td>&nbsp;                      
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_canoisr_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_canoisr_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
                <tr> 
                    <td class=title colspan="2">분담금할증한정</td>
                    <td>&nbsp;                       
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_share_extra_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_share_extra_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>           
               
                
                <tr>
                    <td width="9%" <%if(!ins.getCon_f_nm().equals("아마존카")){%>rowspan="3" <%} %> class=title>자기차량손해</td>
                    <td width="6%" class=title>아마존카</td>
                    <td>&nbsp;<font color="#666666">자차보험료: <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원</font></td>
                    <td align="center" <%if(!ins.getCon_f_nm().equals("아마존카")){%>rowspan="3" <%} %>> 
                      <input type='text' size='10' name='vins_cacdt_cm_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_cm_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
                 <%if(!ins.getCon_f_nm().equals("아마존카")){%>   
                <tr>
                    <td class=title rowspan="2">보험사</td>
                    <td>&nbsp;차&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;량 
                      <input type='text' size='6' name='vins_cacdt_car_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_car_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 만원</td>
                </tr>
                <tr> 
                    <td>&nbsp;물적사고할증기준
					  <select name='vins_cacdt_mebase_amt' onChange="javascript:setCacdtMeAmt();" align="absmiddle">
					    <option value=""    <%if(ins.getVins_cacdt_mebase_amt()==0  ){%>selected<%}%>>선택</option>
					    <option value="50"  <%if(ins.getVins_cacdt_mebase_amt()==50 ){%>selected<%}%>>50만원</option>
					    <option value="100" <%if(ins.getVins_cacdt_mebase_amt()==100){%>selected<%}%>>100만원</option>
					    <option value="150" <%if(ins.getVins_cacdt_mebase_amt()==150){%>selected<%}%>>150만원</option>
					    <option value="200" <%if(ins.getVins_cacdt_mebase_amt()==200){%>selected<%}%>>200만원</option>
					  </select>
					  / (최대)자기부담금 
                      <input type='text' size='6' name='vins_cacdt_me_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_cacdt_me_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value);'> 
                      만원 
					  / (최소)자기부담금  
                      <select name='vins_cacdt_memin_amt'>
                        <option value=""   <%if(ins.getVins_cacdt_memin_amt()==0 ){%>selected<%}%>>선택</option>
                        <option value="5"  <%if(ins.getVins_cacdt_memin_amt()==5 ){%>selected<%}%>>5만원</option>
                        <option value="10" <%if(ins.getVins_cacdt_memin_amt()==10){%>selected<%}%>>10만원</option>
                        <option value="15" <%if(ins.getVins_cacdt_memin_amt()==15){%>selected<%}%>>15만원</option>
                        <option value="20" <%if(ins.getVins_cacdt_memin_amt()==20){%>selected<%}%>>20만원</option>
                      </select>                       
					  </td>
                </tr>
                 <%} %>
                <tr> 
                    <td class=title colspan="2">특약</td>
                    <td> 
                      &nbsp;<input type='text' size='50' name='vins_spe' value='<%=ins.getVins_spe()%>' class='text' style='IME-MODE: active'>
                    </td>
                    <td align="center"> 
                      <input type='text' size='10' name='vins_spe_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_spe_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()'> 원</td>
                </tr>
            </table>
        </td>
    </tr>
    <tr id=tr2 style='display:<%if(ins.getIns_kd().equals("2")) {%>blank<%}else {%>blank<%}%>'> 
        <td colspan="2"> 
            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td></td>
                </tr>
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>보험료</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr>
                              <td rowspan='2' class=title>구분</td>
                              <td colspan="3" class=title>정산보험료</td>
                              <td width="24%" rowspan="2" class=title>납입(분납)구분</td>
                            </tr>
                            <tr>
                              <td width="22%" class=title>책임보험</td>
                              <td width="22%" class=title>임의보험</td>
                              <td width="22%" class=title>소계</td>
                            </tr>						
                            <tr> 
                                <td class=title>원보험료</td>
                                <td width=22% align="center"> 
                                      <input type='text' name='tot_amt1' value='' class='whitenum' size='8' readonly>
                                    원
                                </td>
                                <td width=22% align="center">
                                      <input type='text' name='tot_amt2' value='' class='whitenum' size='8' readonly>
                                    원
                                </td>
                                <td width=22% align="center">
                                      <input type='text' name='tot_amt12' value='' class='whitenum' size='10' readonly>
                                    원
                                </td>
                                <td rowspan="2"> 
                                    &nbsp;<select name='pay_tm'>
                                      <option value="1" <%if(ins.getPay_tm().equals("1")){%>selected<%}%>>1</option>
                                      <option value="2" <%if(ins.getPay_tm().equals("2")){%>selected<%}%>>2</option>
                                      <option value="3" <%if(ins.getPay_tm().equals("3")){%>selected<%}%>>3</option>
                                      <option value="4" <%if(ins.getPay_tm().equals("4")){%>selected<%}%>>4</option>					  
                                      <option value="6" <%if(ins.getPay_tm().equals("6")){%>selected<%}%>>6</option>
                                    </select>
                                회 <%if(ins.getPay_tm().equals("1")){%>완납<%}%></td>
                            </tr>
                            <tr>
                              <td class=title>블랙박스</td>                              
                              <td colspan="2" align="center">할인특약 할인율</td>
                              <td align="center">
                                  <input type='text' size='2' name='vins_blackbox_per' value='<%=ins.getVins_blackbox_per()%>' class='text' style='IME-MODE: active'>%
                              </td>
                            </tr>
                            <!--                       
                            <tr>
                              <td class=title>금액</td>
                              <td align="center" colspan="2"> =(원보험료-<span class="title">분담금할증한정</span>보험료)*할인율</td>
                              <td align="center">
                                  - <input type='text' size='12' name='vins_blackbox_amt' value='<%=Util.parseDecimal(String.valueOf(ins.getVins_blackbox_amt()))%>' class='num' onBlur='javascript:this.value=parseDecimal(this.value); set_tot()' onKeyDown="javasript:enter(1)"> 원
                              </td>
                            </tr>     
                            <tr>
                              <td colspan="2" class=title>최종보험료</td>
                              <td colspan="2">&nbsp;</td>
                              <td align="center">
                                  <input type='text' name='tot_amt' value='' class='whitenum' size='10' readonly>
                                  원
                              </td>
                            </tr>
                            -->
                        </table>
                    </td>
                </tr>
                <%if(!String.valueOf(tint_b.get("SERIAL_NO")).equals("null")){%>
                <tr> 
                    <td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>블랙박스</span></td>
                </tr>
                <tr>
                    <td class=line2></td>
                </tr>
                <tr> 
                    <td class=line> 
                        <table border="0" cellspacing="1" width=100%>
                            <tr>
                              <td width="10%" class=title>블랙박스일련번호</td>
                              <td width="40%" ><%=tint_b.get("SERIAL_NO")%>
                              		(<%if(!String.valueOf(cont.get("OPT")).equals("") && String.valueOf(cont.get("OPT")).contains("빌트인")){%>
                              			내장형 블랙박스
                              		<%}%>)
                              </td>
                              <td width="10%" class=title>첨부파일</td>
                              <td width="40%" >
                    <%		
          		if(!String.valueOf(tint_b.get("TINT_NO")).equals("")){
          		
	                   	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
                   	
				String content_code = "TINT";
				String content_seq  = String.valueOf(tint_b.get("TINT_NO")); 
			
				Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
				int attach_vt_size = attach_vt.size();   
			
				if(attach_vt_size > 0){
					for (int j = 0 ; j < attach_vt_size ; j++){
 						Hashtable ht = (Hashtable)attach_vt.elementAt(j);               
                    %>                
                                        	<a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='보기' ><%=ht.get("FILE_NAME")%></a>
                                        	&nbsp;<a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a>
                                        	<br>
                    <%			}%>
                    <%		}%> 
                    
                    <%		if(attach_vt_size < 2){%> 
                    				<a href="javascript:scan_file('3','<%=content_code%>','<%=content_seq%>')" title='등록하기'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a>
                    <%		}%>                                        		                    
                    
                    		<input type='hidden' name='file_cnt' value='<%=attach_vt_size%>'> 
                    		(앞/실내사진 2장)  	 	
                    <%	}%>                                               
                              
                              </td>
                            </tr>
                            
                        </table>
                    </td>
                </tr>
                
                <%}%>
            </table>
        </td>
    </tr>
	<!--
    <tr> 
      <td colspan="2"><font color="#666666">※ 아마존카 자차보험료: <%=AddUtil.parseDecimal(String.valueOf(cont.get("CAR_JA")))%>원 
        </font></td>
    </tr>-->
  </form>
</table>
<script language='javascript'>
<!--
	var fm = document.form1;
	var ins_kd = <%=ins.getIns_kd()%>;
	//책임
	fm.tot_amt1.value = fm.rins_pcp_amt.value;
	//임의
//	if(ins_kd == '1'){//종합보험
		fm.tot_amt2.value = parseDecimal(toInt(parseDigit(fm.vins_pcp_amt.value))+
										toInt(parseDigit(fm.vins_gcp_amt.value))+
										toInt(parseDigit(fm.vins_bacdt_amt.value))+
										toInt(parseDigit(fm.vins_canoisr_amt.value))+
										toInt(parseDigit(fm.vins_share_extra_amt.value))+
										toInt(parseDigit(fm.vins_cacdt_cm_amt.value))+
										toInt(parseDigit(fm.vins_spe_amt.value)));
//	}
	//계
	fm.tot_amt12.value = parseDecimal(toInt(parseDigit(fm.tot_amt1.value)) + toInt(parseDigit(fm.tot_amt2.value)));
	//fm.tot_amt.value = parseDecimal(toInt(parseDigit(fm.tot_amt12.value)) -  + toInt(parseDigit(fm.vins_blackbox_amt.value)));
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
