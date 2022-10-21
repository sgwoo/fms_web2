<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*,acar.common.*, acar.bank_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?ck_acar_id:request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "15");			
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String bank_id 	= request.getParameter("bank_id")==null?"":request.getParameter("bank_id");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String fund_id 	= request.getParameter("fund_id")==null?"":request.getParameter("fund_id");	
	String seq 	= request.getParameter("seq")==null?"":request.getParameter("seq");
	String cng_item = request.getParameter("cng_item")==null?"":request.getParameter("cng_item");
	String max_int  = request.getParameter("max_int")==null?"":request.getParameter("max_int");
	
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	WorkingFundBean wf = abl_db.getWorkingFundBean(fund_id);
	
	WorkingFundIntBean wf_int = new WorkingFundIntBean();
	
	if(!seq.equals("")){
		wf_int = abl_db.getWorkingFundIntBean(fund_id, Util.parseDigit(seq));
	}
	
	
	
	//코드구분 : 기준금리
	CodeBean[] code23 = c_db.getCodeAll("0023"); 
	int cd23_size = code23.length;

	//로그인 사용자정보
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) user_id = login.getCookieValue(request, "acar_id");
%>

<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//등록
	function save()
	{
		var fm = document.form1;	
		
		<%if(cng_item.equals("wf")){%>	
		
		if(fm.deposit_no_d.value != ''){
			var deposit_no = fm.deposit_no_d.options[fm.deposit_no_d.selectedIndex].value;		
			if(deposit_no.indexOf(":") == -1){
				fm.deposit_no_d.value = deposit_no;
			}else{
				var deposit_split = deposit_no.split(":");
				fm.deposit_no_d.value = deposit_split[0];	
			}
		}
		
		
		if(fm.bn_br.value 	== '')					{ 	alert('금융기관 거래지점을 입력하십시오.'); 		fm.bn_br.focus(); 		return; }
		if(fm.ba_title.value 	== '')					{	alert('담당자 직책을 입력하십시오');			fm.ba_title.focus(); 		return;	}
		if(fm.ba_agnt.value 	== '')					{	alert('담당자 성명을 입력하십시오');			fm.ba_agnt.focus(); 		return;	}
		if(toInt(parseDigit(fm.cont_amt.value)) == 0)			{	alert('대출한도금액을 입력하십시오');			fm.cont_amt.focus(); 		return;	}
		if(fm.cont_dt.value 	== '')					{	alert('최초일자를 입력하십시오');			fm.cont_dt.focus(); 		return;	}
//		if(fm.deposit_no_d.value 	== '')				{	alert('연결계좌 계좌번호를 입력하십시오');		fm.deposit_no_d.focus(); 		return;	}
		if(fm.pay_st.value 	== '')					{	alert('자금인출방식을 입력하십시오');			fm.pay_st.focus(); 		return;	}
		if(fm.security_st1.checked==false && fm.security_st2.checked==false && fm.security_st3.checked==false){
											alert('담보제공을 선택하십시오.');			fm.security_st1.focus(); 	return;
		}
		
		<%}else if(cng_item.equals("renew")){%>
		
		if(fm.renew_dt.value 	== '')					{ 	alert('갱신일자를 입력하십시오.'); 			fm.renew_dt.focus(); 		return; }
		
		if(fm.int_reg_yn.checked == true){
			//if(toInt(fm.fund_int.value) == 0)			{	alert('적용금리를 입력하십시오');			fm.fund_int.focus(); 		return;	}
			//if(fm.validity_s_dt.value 	== '')			{	alert('금리 유효기간을 입력하십시오');			fm.validity_s_dt.focus(); 	return;	}
			//if(fm.validity_e_dt.value 	== '')			{	alert('금리 유효기간을 입력하십시오');			fm.validity_e_dt.focus(); 	return;	}			
			if(fm.int_st.value 		== '')			{	alert('금리 적용구분을 입력하십시오');			fm.int_st.focus(); 		return;	}
			if(fm.int_st.value		== '2'){//변동금리시
				if(fm.spread[0].checked == false && fm.spread[1].checked == false){
												alert('SPREAD 유/무를 선택하십시오.');			fm.spread[0].focus(); 		return;
				}
				if(fm.spread[0].checked == true && toInt(fm.spread_int.value) == 0){
												alert('SPREAD 금리를 입력하십시오.');			fm.spread_int.focus(); 		return;
				}
				if(fm.app_b_st.value 	== '')				{	alert('기준금리를 선택하십시오');			fm.app_b_st.focus(); 		return;	}
				if(fm.app_b_dt.value 	== '')				{	alert('적용기준일자를 입력하십시오');			fm.app_b_dt.focus(); 		return;	}
			}
		}
		
		<%}else if(cng_item.equals("cls")){%>
		
		if(fm.cls_dt.value 	== '')					{ 	alert('해지일자를 입력하십시오.'); 			fm.cls_dt.focus(); 		return; }
		
		<%}else if(cng_item.equals("wf_int") || cng_item.equals("wf_int_add")){%>
		
		if(toInt(fm.fund_int.value) == 0)				{	alert('적용금리를 입력하십시오');			fm.fund_int.focus(); 		return;	}
//		if(fm.validity_s_dt.value 	== '')				{	alert('금리 유효기간을 입력하십시오');			fm.validity_s_dt.focus(); 	return;	}
//		if(fm.validity_e_dt.value 	== '')				{	alert('금리 유효기간을 입력하십시오');			fm.validity_e_dt.focus(); 	return;	}			
		if(fm.int_st.value 		== '')				{	alert('금리 적용구분을 입력하십시오');			fm.int_st.focus(); 		return;	}
		if(fm.int_st.value		== '2'){//변동금리시
			if(fm.spread[0].checked == false && fm.spread[1].checked == false){
												alert('SPREAD 유/무를 선택하십시오.');			fm.spread[0].focus(); 		return;
			}
			if(fm.spread[0].checked == true && toInt(fm.spread_int.value) == 0){
												alert('SPREAD 금리를 입력하십시오.');			fm.spread_int.focus(); 		return;
			}
			if(fm.app_b_st.value 	== '')					{	alert('기준금리를 선택하십시오');			fm.app_b_st.focus(); 		return;	}
			if(fm.app_b_dt.value 	== '')					{	alert('적용기준일자를 입력하십시오');			fm.app_b_dt.focus(); 		return;	}
		}
		
		<%}else if(cng_item.equals("gua")){%>	
		
		if(fm.gua_org.value 	== '')				{ 	alert('보증서발행기관명을 입력하십시오.'); 		fm.gua_org.focus(); 		return; }
		if(fm.gua_s_dt.value 	== '')				{	alert('보증서 유효기간을 입력하십시오');		fm.gua_s_dt.focus(); 		return;	}
		if(fm.gua_e_dt.value 	== '')				{	alert('보증서 유효기간을 입력하십시오');		fm.gua_s_dt.focus(); 		return;	}
		if(toInt(fm.gua_int.value) == 0)			{	alert('보증율을 입력하십시오');				fm.gua_int.focus(); 		return;	}
		if(toInt(parseDigit(fm.gua_amt.value)) == 0)		{	alert('보증금액을 입력하십시오');			fm.gua_amt.focus(); 		return;	}
		if(toInt(parseDigit(fm.gua_fee.value)) == 0)		{	alert('보증보험료를 입력하십시오');			fm.gua_fee.focus(); 		return;	}

		<%}else if(cng_item.equals("realty")){%>		
		
		if(fm.realty_nm.value 	== '')				{ 	alert('담보물부동산명을 입력하십시오.'); 		fm.realty_nm.focus(); 		return; }
		if(fm.t_addr.value 	== '')				{	alert('담보물 주소를 입력하십시오');			fm.t_addr.focus(); 		return;	}
		
		<%}%>
					
		
		if(confirm('수정하시겠습니까?'))
		{	
			fm.action = 'working_fund_u_a.jsp';
			fm.target = 'i_no';
			//fm.target = '_blank';
			fm.submit();
		}
	}
	

	
	//코드관리
	function reg_app_b_st(){
		window.open("/acar/common/code_frame_s.jsp?auth_rw=<%=auth_rw%>&c_st=0023&from_page=/fms2/bank_mng/working_fund_frame.jsp", "CODE", "left=100, top=100, height=400, width=450, resizable=yes, scrollbars=yes, status=yes");
	}	
	
	//디스플레이 타입
	function cng_input(){
		var fm = document.form1;
		
		if(fm.int_reg_yn.checked == true){
			tr_int_1.style.display = "";
			tr_int_2.style.display = "";
		}else{
			tr_int_1.style.display = "none";
			tr_int_2.style.display = "none";
		}
	}	
	//디스플레이 타입
	function cng_input2(){
		var fm = document.form1;
		
		if(fm.amt_reg_yn.checked == true){
			tr_amt_1.style.display = "";
			tr_amt_2.style.display = "";
		}else{
			tr_amt_1.style.display = "none";
			tr_amt_2.style.display = "none";
		}
	}	
	//디스플레이 타입
	function cng_input3(){
		var fm = document.form1;
		
		if(fm.dt_reg_yn.checked == true){
			tr_dt_1.style.display = "";
			tr_dt_2.style.display = "";
		}else{
			tr_dt_1.style.display = "none";
			tr_dt_2.style.display = "none";
		}
	}				
//-->
</script>
</head>
<body leftmargin="15">
<form action="working_fund_u_a.jsp" name="form1" method="POST">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 	value='<%=t_wd%>'>			
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>  
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>
  <input type='hidden' name='bank_id' value='<%=bank_id%>'>
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
  <input type='hidden' name='from_page' value='/fms2/bank_mng/working_fund_c.jsp'>  
  <input type='hidden' name='fund_id' 	value='<%=fund_id%>'>    
  <input type='hidden' name='seq' 	value='<%=seq%>'>    
  <input type='hidden' name='cng_item' 	value='<%=cng_item%>'>    
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr> 
      <td colspan=2>
        <table width=100% border=0 cellpadding=0 cellspacing=0>
          <tr>
            <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
            <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 구매자금관리 > <span class=style1><span class=style5>자금관리</span></span></td>
            <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
          </tr>
        </table>            
      </td>
    </tr>
    <tr> 
      <td class=h></td>
    </tr>
    <%if(cng_item.equals("wf")){%>
    <tr>
      <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
                <tr> 
                    <td width="6%" rowspan="2" class=title>금융기관</td>
                    <td width="7%" class=title>기관명</td>
                    <td width="20%">&nbsp;
                      <select name='cont_bn_st'>
                        <option value="">선택</option>
                        <option value="1" <%if(wf.getCont_bn_st().equals("1")){%>selected<%}%>>제1금융권</option>
                        <option value="2" <%if(wf.getCont_bn_st().equals("2")){%>selected<%}%>>제2금융권</option>
                      </select>
                      &nbsp;
                      <%=c_db.getNameById(wf.getCont_bn(), "BANK")%>
		    </td>
                    <td width="6%" rowspan="2" class=title>담당자</td>
                    <td width="8%" class=title>직책/성명</td>
                    <td width="20%">&nbsp;
                      <input type="text" class="text" name="ba_title" value="<%=wf.getBa_title()%>" size="13" maxlength="20" style="IME-MODE: active">
                      /
                      <input type="text" class="text" name="ba_agnt" value="<%=wf.getBa_agnt()%>" size="12" maxlength="20" style="IME-MODE: active">
		    </td>
                    <td width="13%" class=title>관리번호</td>
                    <td width="20%">&nbsp;
                      <%=wf.getFund_no()%></td>
                </tr>
                <tr>
                  <td class=title>거래지점</td>
                  <td>&nbsp;
                    <input type="text" class="text" name="bn_br" value="<%=wf.getBn_br()%>" size="28" maxlength="20" style="IME-MODE: active">
				  </td>
                  <td class=title>연락처</td>
                  <td>&nbsp;
                    <input type="text" class="text" name="bn_tel" value="<%=wf.getBn_tel()%>" size="13" maxlength="15">
				  </td>
                  <td class=title>최초등록일자</td>
                  <td>&nbsp;
                    <%=AddUtil.ChangeDate2(wf.getReg_dt())%></td>
                </tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td colspan="2" class=title>대출구분</td>
                <td>&nbsp;
                  <input name="fund_type" type="radio" value="1" <%if(wf.getFund_type().equals("1"))%>checked<%%>>
                  운용자금
                  <input type="radio" name="fund_type" value="2" <%if(wf.getFund_type().equals("2"))%>checked<%%>>
                  시설자금
                  <!--
                  <%if(wf.getFund_type().equals("1")){%>운용자금
                  <%}else if(wf.getFund_type().equals("2")){%>시설자금
                  <%}%>
                  -->
		</td>              
              
                <td width="6%" rowspan="4" class=title>약정일자</td>
                <td width="8%" class=title>최초일자</td>
                <td width="10%">&nbsp;
                  <input type="text" class="text" name="cont_dt" id="cont_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getCont_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td width="6%" rowspan="2" class=title>연결계좌</td>
                <td width="7%" class=title>은행명</td>
                <td width="30%">&nbsp;
                  <%=neoe_db.getCodeByNm("bank", wf.getBank_code())%>                  		  
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>대출한도</td>
                <td>&nbsp;
                  <input type="text" class="num" name="cont_amt" id="cont_amt" size="15" maxlength="15" value="<%=AddUtil.parseDecimalLong(wf.getCont_amt())%>" onBlur="javascript:this.value=parseDecimal(this.value)">
                  원				
                </td>              
                <td class=title>갱신일자</td>
                <td>&nbsp;
                  <%if(!wf.getRenew_dt().equals("")){%>
                  <input type="text" class="text" name="renew_dt" id="renew_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getRenew_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  <%}else{%>
                  -
                  <input type='hidden' name='renew_dt' 	value='<%=wf.getRenew_dt()%>'> 
                  <%}%>
		</td>
                <td class=title>계좌번호</td>
                <td>&nbsp;
                  <select name='deposit_no_d'>
                        <option value=''>계좌를 선택하세요</option>
                        <%if(!wf.getBank_code().equals("")){
     					Vector deposits = neoe_db.getDepositList(wf.getBank_code());
        				int deposit_size = deposits.size();
        				for(int i = 0 ; i < deposit_size ; i++){
        					Hashtable deposit = (Hashtable)deposits.elementAt(i);%>
        		<option value='<%=deposit.get("DEPOSIT_NO")%>' <%if(wf.getDeposit_no().equals(String.valueOf(deposit.get("DEPOSIT_NO"))))%>selected<%%>><%= deposit.get("DEPOSIT_NO")%>:<%= deposit.get("DEPOSIT_NAME")%></option>
        		<%		}
        		}%>
                  </select>   
                  <input type='hidden' name='deposit_no2' value=''>               
		</td>
              </tr>
              <tr>
                <td width="6%" rowspan="2" class=title>대출잔액</td>
                <td width="7%" class=title>금액</td>
                <td width="20%">&nbsp;
                  <%if(wf.getFund_type().equals("1")){%>
                    <input type="text" class="num" name="rest_amt" id="rest_amt" size="15" maxlength="15" value="<%=AddUtil.parseDecimalLong(wf.getRest_amt())%>" onBlur="javascript:this.value=parseDecimal(this.value)">원
                  <%}else if(wf.getFund_type().equals("2")){%>
                    -
                    <input type='hidden' name='rest_amt' value='<%=wf.getRest_amt()%>'>
                  <%}%>                   
		</td>
                <td class=title>만기예정일</td>
                <td>&nbsp;
                  <input type="text" class="text" name="cls_est_dt" id="cls_est_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getCls_est_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td colspan="2" class=title>자금인출방식</td>
                <td>&nbsp;
                  <select name="pay_st" id="pay_st">
		    <option value="" >선택</option>
		    <option value="1" <%if(wf.getPay_st().equals("1"))%>selected<%%>>일시출금</option>
		    <option value="2" <%if(wf.getPay_st().equals("2"))%>selected<%%>>수시입출금</option>
                  </select>
		</td>
              </tr>
              <tr>
                <td class=title>기준일자</td>
                <td>&nbsp;
		  <%if(wf.getFund_type().equals("1")){%>
                    <input type="text" class="text" name="rest_b_dt" id="rest_b_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getRest_b_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  <%}else if(wf.getFund_type().equals("2")){%>
                    -
                    <input type='hidden' name='rest_b_dt' value='<%=wf.getRest_b_dt()%>'>
                  <%}%>                                   
		</td>
                <td class=title>해지일자</td>
                <td>&nbsp;
                  <%if(!wf.getCls_dt().equals("")){%>
                  <input type="text" class="text" name="cls_dt" id="cls_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getCls_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  <%}else{%>
                  -
                  <input type='hidden' name='cls_dt' 	value='<%=wf.getCls_dt()%>'> 
                  <%}%>
		</td>
                <td colspan="2" class=title>담보제공</td>
                <td>&nbsp;
                  <input type="checkbox" name="security_st1" id="security_st1" value="Y" <%if(wf.getSecurity_st1().equals("Y"))%>checked<%%>>
                  신용
                  <input type="checkbox" name="security_st2" id="security_st2" value="Y" <%if(wf.getSecurity_st2().equals("Y"))%>checked<%%>>
                  보증서
                  <input type="checkbox" name="security_st3" id="security_st3" value="Y" <%if(wf.getSecurity_st3().equals("Y"))%>checked<%%>>
                  부동산
		</td>
              </tr>	
              <tr>
                <td colspan='2' class=title>회전(리볼빙)여부</td>
                <td colspan='7'>&nbsp;
                  <input type="radio" name="revolving" value="N" <%if(wf.getRevolving().equals("N"))%>checked<%%>>
                  Non
                  <input type="radio" name="revolving" value="Y" <%if(wf.getRevolving().equals("Y"))%>checked<%%>>
                  회전
		</td>
              </tr>		                
              <tr>
                <td colspan="2" class=title>특이사항</td>
                <td colspan="7">&nbsp;
                  <textarea name="note" id="note" cols="90" rows="2"><%=wf.getNote()%></textarea>
		</td>
              </tr>              		  
            </table>
	</td>
    </tr>
    <%}%>	
    <%if(cng_item.equals("renew")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>갱신일자</td>
                <td>&nbsp;
                  <input type="text" class="text" name="renew_dt" id="renew_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getRenew_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>                
              </tr>
              <tr>
                <td width="13%" class=title>대출한도변경</td>
                <td>&nbsp;
                  <input type="checkbox" name="amt_reg_yn" id="amt_reg_yn" value="Y"  onClick="javascript:cng_input2();">
                  갱신시 대출한도 변경 등록
		</td>                
              </tr>
              <tr>
                <td width="13%" class=title>만기예정일변경</td>
                <td>&nbsp;
                  <input type="checkbox" name="dt_reg_yn" id="dt_reg_yn" value="Y"  onClick="javascript:cng_input3();">
                  갱신시 만기예정일 변경 등록
		</td>                
              </tr>
              <tr>
                <td width="13%" class=title>금리변경</td>
                <td>&nbsp;
                  <input type="checkbox" name="int_reg_yn" id="int_reg_yn" value="Y"  onClick="javascript:cng_input();">
                  갱신시 금리 변경 등록
		</td>                
              </tr>              
            </table>
	</td>
    </tr>  
    <tr> 
      <td class=h></td>
    </tr> 
    <tr id=tr_amt_1 style='display:none'>
        <td class=line2></td>
    </tr>
    <tr id=tr_amt_2 style='display:none'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>대출한도</td>                
                <td>&nbsp;
                  [변경전] <%=AddUtil.parseDecimalLong(wf.getCont_amt())%>원
                  ->
                  [변경후]
                  <input type="text" class="num" name="cont_amt" id="cont_amt" size="15" maxlength="15" value="<%=AddUtil.parseDecimalLong(wf.getCont_amt())%>" onBlur="javascript:this.value=parseDecimal(this.value)">
                  원
                  <input type='hidden' name='o_cont_amt' 	value='<%=wf.getCont_amt()%>'>    
		</td>
              </tr>
            </table>
      </td>
    </tr>             
    <tr id=tr_dt_1 style='display:none'>
        <td class=line2></td>
    </tr>
    <tr id=tr_dt_2 style='display:none'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>만기예정일자</td>                
                <td>&nbsp;
                  [변경전] <%=AddUtil.ChangeDate2(wf.getCls_est_dt())%>
                  ->
                  [변경후]
                  <input type="text" class="text" name="cls_est_dt" id="cls_est_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getCls_est_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  <input type='hidden' name='o_cls_est_dt' 	value='<%=wf.getCls_est_dt()%>'>    
		</td>
              </tr>
            </table>
      </td>
    </tr>                 
    <tr id=tr_int_1 style='display:none'>
        <td class=line2></td>
    </tr>
    <tr id=tr_int_2 style='display:none'>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td colspan="2" class=title>변경전</td>
                <td colspan="7">&nbsp;
                  <%=max_int%>%
                  <input type='hidden' name='o_fund_int' 	value='<%=max_int%>'>    
		</td>
              </tr>            
              <tr>
                <td width="6%" rowspan="2" class=title>금리</td>
                <td width="7%" class=title>적용금리</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="fund_int" id="fund_int" size="5" maxlength="5" value="">%
				</td>
                <td width="6%" rowspan="2" class=title>금리구분</td>
                <td width="8%" class=title>적용구분</td>
                <td width="20%">&nbsp;
                  <select name="int_st" id="int_st">
                    <option value="" >선택</option>
                    <option value="1">확정금리</option>
                    <option value="2">변동금리</option>
                  </select>
				</td>
                <td width="6%" rowspan="2" class=title>적용기준</td>
                <td width="7%" class=title>기준금리</td>
                <td width="20%">&nbsp;
                  <select name="app_b_st" id="app_b_st">
                    <option value="" >선택</option>
                    <%	if(cd23_size > 0){
        			for(int i = 0 ; i < cd23_size ; i++){
        				CodeBean code = code23[i];%>
                    <option value="<%= code.getNm_cd()%>"><%= code.getNm()%></option>
                    <%		}
        		}%>
                  </select>
                  &nbsp;<a href="javascript:reg_app_b_st()"><span title="기준금리 등록/수정"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></span></a>
		</td>
              </tr>
              <tr>
                <td class=title>유효기간</td>
                <td>&nbsp;
                  <input type="text" class="text" name="validity_s_dt" id="validity_s_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  ~
                  <input type="text" class="text" name="validity_e_dt" id="validity_e_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td class=title> SPREAD </td>
                <td>&nbsp;
                  <input type="radio" name="spread" value="Y">유(<input type="text" class="text" name="spread_int" id="spread_int" value="" size="5" maxlength="5">%)
                  <input type="radio" name="spread" value="N">무                  
		</td>
                <td class=title>기준일자</td>
                <td>&nbsp;
                  <input type="text" class="text" name="app_b_dt" id="app_b_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>특약사항</td>
                <td colspan="7">&nbsp;
                  <textarea name="note" id="note" cols="90" rows="2"></textarea>
		</td>
              </tr>
            </table>
      </td>
    </tr>      
    <%}%>	
    <%if(cng_item.equals("cls")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>해지일자</td>
                <td>&nbsp;
                  <input type="text" class="text" name="cls_dt" id="cls_dt" size="11" maxlength="10" value="<%=AddUtil.ChangeDate2(wf.getCls_dt())%>" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>                
              </tr>
            </table>
	</td>
    </tr>    
    <%}%>	    
    <%if(cng_item.equals("wf_int") || cng_item.equals("wf_int_add")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="6%" rowspan="2" class=title>금리</td>
                <td width="7%" class=title>적용금리</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="fund_int" id="fund_int" size="5" maxlength="5" value="<%=wf_int.getFund_int()%>">%
		</td>
                <td width="6%" rowspan="2" class=title>금리구분</td>
                <td width="8%" class=title>적용구분</td>
                <td width="20%">&nbsp;
                  <select name="int_st" id="int_st">
                    <option value="" >선택</option>
                    <option value="1" <%if(wf_int.getInt_st().equals("1"))%>selected<%%>>확정금리</option>
                    <option value="2" <%if(wf_int.getInt_st().equals("2"))%>selected<%%>>변동금리</option>
                  </select>
		</td>
                <td width="6%" rowspan="2" class=title>적용기준</td>
                <td width="7%" class=title>기준금리</td>
                <td width="20%">&nbsp;
                  <select name="app_b_st" id="app_b_st">
                    <option value="" >선택</option>
                    <%	if(cd23_size > 0){
        			for(int i = 0 ; i < cd23_size ; i++){
        				CodeBean code = code23[i];%>
                    <option value="<%= code.getNm_cd()%>" <%if(wf_int.getApp_b_st().equals(code.getNm_cd()))%>selected<%%>><%= code.getNm()%></option>
                    <%		}
        		}%>
                  </select>
                  &nbsp;<a href="javascript:reg_app_b_st()"><span title="기준금리 등록/수정"><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></span></a>
		</td>
              </tr>
              <tr>
                <td class=title>유효기간</td>
                <td>&nbsp;
                  <input type="text" class="text" name="validity_s_dt" id="validity_s_dt" value="<%=AddUtil.ChangeDate2(wf_int.getValidity_s_dt())%>" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
                  ~
                  <input type="text" class="text" name="validity_e_dt" id="validity_e_dt" value="<%=AddUtil.ChangeDate2(wf_int.getValidity_s_dt())%>" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td class=title> SPREAD </td>
                <td>&nbsp;
                  <input type="radio" name="spread" value="Y" <%if(wf_int.getSpread().equals("Y"))%>checked<%%>>유(<input type="text" class="text" name="spread_int" id="spread_int" value="<%=wf_int.getSpread_int()%>" size="5" maxlength="5">%)
                  <input type="radio" name="spread" value="N" <%if(wf_int.getSpread().equals("Y"))%>checked<%%>>무                  
		</td>
                <td class=title>기준일자</td>
                <td>&nbsp;
                  <input type="text" class="text" name="app_b_dt" id="app_b_dt" value="<%=AddUtil.ChangeDate2(wf_int.getApp_b_dt())%>" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
              </tr>
              <tr>
                <td colspan="2" class=title>특약사항</td>
                <td colspan="7">&nbsp;
                  <textarea name="note" id="note" cols="90" rows="2"><%= wf_int.getNote()%></textarea>
		</td>
              </tr>
            </table>
      </td>
    </tr>
    <%}%>
    <%if(cng_item.equals("gua")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>보증서발행기관명</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_org" id="gua_org" value="" size="28" maxlength="20" style="IME-MODE: active"></td>
                <td colspan="2" class=title>보증서유효기간</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_s_dt" id="gua_s_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)"> 
                  ~ 
                  <input type="text" class="text" name="gua_e_dt" id="gua_e_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
                <td width="13%" class=title>보증율</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_int" id="gua_int" value="" size="5" maxlength="5">%
		</td>
              </tr>
              <tr>
                <td class=title>보증금액</td>
                <td>&nbsp;
                  <input type="text" class="num" name="gua_amt" id="gua_amt" value="" size="13" maxlength="11" onBlur="javascript:this.value=parseDecimal(this.value)">원
		</td>
                <td width="6%" rowspan="2" class=title>담당자</td>
                <td width="8%" class=title>직책/성명</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="gua_title" value="" size="13" maxlength="20">
                  /
                  <input type="text" class="text" name="gua_agnt" value="" size="12" maxlength="20">
		</td>
                <td class=title>보증서갱신예정일</td>
                <td>&nbsp;
                    <input type="text" class="text" name="gua_est_dt" id="gua_est_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)">
		</td>
              </tr>
              <tr>
                <td class=title>보험료</td>
                <td>&nbsp;
                  <input type="text" class="num" name="gua_fee" id="gua_fee" value="" size="13" maxlength="11" onBlur="javascript:this.value=parseDecimal(this.value)">원
		</td>
                <td class=title>연락처</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_tel" value="" size="13" maxlength="15"></td>
                <td class=title>보증서발행제출서류</td>
                <td>&nbsp;
                  <input type="text" class="text" name="gua_docs" id="gua_docs" value="" size="28" maxlength="50" style="IME-MODE: active">
		</td>
              </tr>
            </table></td>
    </tr>
    <%}%>
    <%if(cng_item.equals("realty")){%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>            
            <table border="0" cellspacing="1" width=100%>
              <tr>
                <td width="13%" class=title>담보물부동산명</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="realty_nm" id="realty_nm" value="" size="28" maxlength="30" style="IME-MODE: active">
				</td>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('t_zip').value = data.zonecode;
								document.getElementById('t_addr').value = data.address;
								
							}
						}).open();
					}
				</script>
                <td width="14%" class=title>담보물주소</td>
                <td colspan="3">&nbsp;
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="우편번호 찾기"><br>
					&nbsp;<input type="text" name="t_addr" id="t_addr" size="50" value="">
				</td>
              </tr>
              <tr>
                <td class=title>근저당설정금액</td>
                <td>&nbsp;
                  <input type="text" class="num" name="cltr_amt" id="cltr_amt" value="" size="13" maxlength="11" onBlur="javascript:this.value=parseDecimal(this.value)">원
		</td>
                <td class=title>설정일자</td>
                <td width="20%">&nbsp;
                  <input type="text" class="text" name="cltr_dt" id="cltr_dt" value="" size="11" maxlength="10" onBlur="javascript:this.value=ChangeDate4(this, this.value)"></td>
                <td width="13%" class=title>지상권설정</td>
                <td width="20%">&nbsp;
                  <input type="radio" name="cltr_st" value="Y">유
                  <input type="radio" name="cltr_st" value="N">무
		</td>
              </tr>
              <tr>
                <td class=title>설정권자</td>
                <td>&nbsp;
                  <input type="text" class="text" name="cltr_user" value="" size="28" maxlength="30" style="IME-MODE: active"></td>
                <td class=title>설정순위</td>
                <td colspan="3">&nbsp;
                  <input type="text" class="text" name="cltr_lank" value="" size="5" maxlength="1" maxlength="15">위</td>
              </tr>
            </table>
	</td>
    </tr>
    <%}%>	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
	    <td align="center">
	     <%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
	    <a href="javascript:save();"><img src="/acar/images/center/button_<%if(cng_item.equals("wf_int_add")){%>reg<%}else{%>modify<%}%>.gif"  border="0" align=absmiddle></a> 
	    <% } %>
	      &nbsp;
	  	<a href='javascript:window.close();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_close.gif" align="absmiddle" border="0"></a> 
	    </td>
	</tr>			
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>