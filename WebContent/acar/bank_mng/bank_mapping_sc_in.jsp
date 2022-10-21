<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.bank_mng.*, acar.common.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language="JavaScript" src='/include/common.js'></script>
<script language='javascript'>
<!--
	/* Title 고정 */
	function setupEvents(){
		window.onscroll = moveTitle ;
		window.onresize = moveTitle ; 
	}
	
	function moveTitle(){
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    	    
	}
	
	function init(){		
		setupEvents();
	}	

	//은행별 대출 등록/수정
	function bank_mapping(m_id, l_cd, car_id, lend_id){
		var fm = document.form1;
		fm.m_id.value		= m_id;
		fm.l_cd.value 		= l_cd;
		fm.car_id.value 	= car_id;
		if(lend_id == ""){	
			fm.action='bank_mapping_i.jsp';		
		}else{
			fm.lend_id.value 	= lend_id;		
			fm.action='bank_mapping_u.jsp';		
		}
		fm.target = 'MAPPING';
		fm.submit();		
	}	
	
	//스케줄
	function bank_mapping_scd(m_id, l_cd, car_id, scd_st){
		var fm = document.form1;
		fm.m_id.value		= m_id;
		fm.l_cd.value 		= l_cd;
		fm.car_id.value 	= car_id;
		if(scd_st == 'N'){	
			fm.action='bank_mapping_scd_i.jsp';		
		}else{
			fm.action='bank_mapping_scd_u.jsp';		
		}
		fm.target = 'MAPPING';
		fm.submit();		
	}
	
	/* 구매자금 대출 수정*/
	function bank_mapping_loan(idx, m_id, l_cd, car_id, lend_id, sup_amt, spe_amt){
		var fm = document.form1;
//		if(fm.s_rtn.value == ''){ alert('상환을 선택하십시오.'); return; }

		if(fm.car_bank_size.value == '1'){
			fm.h_loan_sch_amt.value= fm.loan_sch_amt.value;
			fm.h_loan_dt.value 	= fm.loan_dt.value;
			fm.h_cpt_cd.value 	= fm.cpt_cd.value;
			fm.h_pay_dt.value 	= fm.pay_dt.value;				
		}else{
			fm.h_loan_sch_amt.value= fm.loan_sch_amt[idx].value;
			fm.h_loan_dt.value 	= fm.loan_dt[idx].value;
			fm.h_cpt_cd.value 	= fm.cpt_cd[idx].value;
			fm.h_pay_dt.value 	= fm.pay_dt[idx].value;				
		}
		fm.m_id.value		= m_id;
		fm.l_cd.value 		= l_cd;
		fm.car_id.value 	= car_id;
		if(lend_id != '') fm.lend_id.value 	= lend_id;		
		fm.sup_amt.value 	= sup_amt;
		fm.spe_amt.value 	= spe_amt;	
//		if(GetCookie("s_rtn") != null){ fm.s_rtn.value = GetCookie("s_rtn"); }
		if(fm.h_loan_dt.value == '' && fm.h_pay_dt.value == ''){ alert('구매자금 대출일 또는 지출일을 입력하십시오'); return; }
		fm.dif_amt.value = parseDecimal(toInt(parseDigit(fm.sup_amt.value)) - toInt(parseDigit(fm.h_loan_sch_amt.value)));				
		if(confirm('구매자금을 수정하시겠습니까?')){
			fm.action='bank_mapping_loan_null.jsp';
			fm.target = 'i_no';
//			fm.target = 'MAPPING';
			fm.submit();
		}
	}

	function GetCookie(cName){
		var a = document.cookie.split("; ");
		for(var i=0; i<a.length; i++){
			var aa = a[i].split("=");
			if(cName == aa[0] && aa[1] != null){
				return unescape(aa[1]);
			}
		}
		return null;
	}
	/* 구매자금 지출 수정*/
/*	function bank_mapping_pay(idx, m_id, l_cd, car_id, lend_id){
		var fm = document.form1;
		fm.h_pay_dt.value 	= fm.pay_dt[idx].value;		
		fm.m_id.value		= m_id;
		fm.l_cd.value 		= l_cd;
		fm.car_id.value 	= car_id;
		fm.lend_id.value 	= lend_id;		
		if(confirm('구매자금 지출일을 수정하시겠습니까?')){
			fm.action='bank_mapping_pay_null.jsp';
			fm.target = 'i_no';
			fm.submit();
		}
	}	*/
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:init()">
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
	
	Vector car_banks = abl_db.getCarbankList(s_kd, t_wd, s_rtn, gubun, lend_id);
	int car_bank_size = car_banks.size();
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	CodeBean[] banks = c_db.getCodeAll("0003"); /* 코드 구분:은행명 */	
	int bank_size = banks.length;

	String cpt_nm = c_db.getNameById(cont_bn, "BANK");
%>
<form name='form1' action='bank_mapping_i.jsp' target='MAPPING' method="POST">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='s_rtn' value='<%=s_rtn%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
<input type='hidden' name='rtn_st' value='<%=rtn_st%>'>
<input type='hidden' name='lend_amt_lim' value='<%=lend_amt_lim%>'>
<input type='hidden' name='rtn_size' value='<%=rtn_size%>'>
<input type='hidden' name='h_loan_sch_amt'>
<input type='hidden' name='h_loan_dt'>
<input type='hidden' name='h_cpt_cd'>
<input type='hidden' name='h_pay_dt'>
<input type='hidden' name='sup_amt'>
<input type='hidden' name='spe_amt'>
<input type='hidden' name='dif_amt'>
<input type='hidden' name='m_id'>
<input type='hidden' name='l_cd'>
<input type='hidden' name='car_id'>
<input type='hidden' name='car_bank_size' value='<%=car_bank_size%>'>
<table border="0" cellspacing="0" cellpadding="0" width=1700>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>
		<td class='line' width='27%' id='td_title' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td colspan="5" class='title'>계약 정보</td>
                </tr>
                <tr> 
                    <td width=10% class='title'>연번</td>
                    <td width=25% class='title'>계약번호 </td>
                    <td width=22% class='title'>상호 </td>
                    <td width=20% class='title'>차량번호</td>
                    <td width=23% class='title'>차명</td>			
                </tr>
            </table>
		</td>
		<td class='line' width='73%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr> 
                    <td colspan="4" class='title'>&nbsp;</td>
                    <td colspan="3" class='title'>구매자금대출</td>
                    <td colspan="4" class='title'>구매자금지출</td>
                    <td class='title' rowspan="2" width=5%>근저당<br>설&nbsp;&nbsp;&nbsp;정</td>
                    <td class='title' rowspan="2" width=6%>스케줄<br>등록/수정</td>
                </tr>
                <tr> 		
                    <td width=7% class='title'>소비자가격</td>
                    <td width=7% class='title'>구입가격 </td>			
                    <td width=8% class='title'>출고(예정)일</td>
                    <td width=14% class='title'>대출번호</td>					    
                    <td class='title' width=9%><%if(gubun.equals("reg")){%> 대출예정금액<%}else{%>시행금액<%}%> </td>			
                    <td class='title' width=7%> 대출일자</td>
                    <td class='title' width=7%> 시행처</td>
                    <td width=7% class='title'> 지출예정금액 </td>
                    <td width=7% class='title'> 지출일자</td>
                    <td width=8% class='title'> 지출처</td>
                    <td width=8% class='title'> 지출금액 </td>
                </tr>
            </table>
		</td>
	</tr>
<%	if(car_bank_size > 0){	%>
	<tr>
		<td class='line' width='27%' id='td_con' style='position:relative;'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
            <%for(int i = 0 ; i < car_bank_size ; i++){
				Hashtable car_bank = (Hashtable)car_banks.elementAt(i);
%>
                <tr> 
                    <td width=10% align='center'><%=i+1%></td>
                    <td width=25% align='center'><a href="javascript:bank_mapping('<%=car_bank.get("RENT_MNG_ID")%>','<%=car_bank.get("RENT_L_CD")%>','<%=car_bank.get("CAR_MNG_ID")%>','<%=car_bank.get("LEND_ID")%>');"><%=car_bank.get("RENT_L_CD")%></a>
        		    </td>
                    <td width=22%>&nbsp;<span title='<%=car_bank.get("FIRM_NM")%>'><%=Util.subData(String.valueOf(car_bank.get("FIRM_NM")), 6)%></span></td>
                    <td width=20% align='center'>&nbsp;<%=car_bank.get("CAR_NO")%>&nbsp;</td>			
                    <td width=23%>&nbsp;<span title='<%=car_bank.get("CAR_NM")%> <%=car_bank.get("CAR_NAME")%>'><%=Util.subData(String.valueOf(car_bank.get("CAR_NM"))+" "+String.valueOf(car_bank.get("CAR_NAME")), 5)%></span></td>
                </tr>
                <%}	%>
                <tr> 
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>			
                    <td class=title>&nbsp;</td>
                    <td class=title align="center">합계</td>
                </tr>		  
            </table>
        </td>
        <td class='line' width='73%'>			
            <table border="0" cellspacing="1" cellpadding="0" width='100%' height="100%">
              <%for(int i = 0 ; i < car_bank_size ; i++){
    				Hashtable car_bank = (Hashtable)car_banks.elementAt(i);%>
                <tr> 
                    <td width=7% align='right'><%=Util.parseDecimal(String.valueOf(car_bank.get("SPE_AMT")))%></td>
                    <td width=7% align='right'><%=Util.parseDecimal(String.valueOf(car_bank.get("SUP_AMT")))%></td>
                    <td width=8% align='center'>&nbsp;<%=car_bank.get("DLV_DT")%>&nbsp;</td>
                    <td width=14% align='center'>&nbsp;<%=car_bank.get("LEND_NO")%>&nbsp;</td>					  
                    <td align='right' width=9%> 
        			<%if(gubun.equals("reg")){%> 
                      <%if(car_bank.get("LEND_ST").equals("N") && car_bank.get("ALLOT_ST").equals("N")){//구입공급가 만월절사
        			  		String loan_sch_amt="0";
        					int sch_amt=0;
        			  		if(lend_amt_lim.equals("1")){
        						loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//만원절삭
        					}else if(lend_amt_lim.equals("2")){
        						loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_AMT_85PER")));//만원절삭
        					}else if(lend_amt_lim.equals("3")){
        						loan_sch_amt = AddUtil.th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//천원절삭
        					}else if(lend_amt_lim.equals("4")){
        						loan_sch_amt = AddUtil.ml_th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//백원절삭
        					}else if(lend_amt_lim.equals("5")){
        						loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_AMT_70PER")));//만원절삭
        					}else{
        						loan_sch_amt = String.valueOf(car_bank.get("SUP_AMT"));
        					}
        				%>
                      <input type="text" name="loan_sch_amt" maxlength='10' value="<%=Util.parseDecimal(loan_sch_amt)%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>                      
                      <%}else{%>
                      <%=Util.parseDecimal(String.valueOf(car_bank.get("LOAN_SCH_AMT")))%> 
                      <input type='hidden' name="loan_sch_amt">
                      <%}%>
        			  <%}else{%>
        			  <input type="text" name="loan_sch_amt" maxlength='10' value="<%=Util.parseDecimal(String.valueOf(car_bank.get("LOAN_AMT")))%>" size="9" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>        			  
        			  <%}%>			
                    </td>
                    <td align='center' width=7%> 
                      <%if(car_bank.get("LEND_ST").equals("N") && car_bank.get("ALLOT_ST").equals("N")){%>
                      <input type="text" name="loan_dt" maxlength='11' value="<%=car_bank.get("LOAN_DT")%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      <%}else{%>
                      <%=car_bank.get("LOAN_DT")%> 
                      <input type='hidden' name="loan_dt">
                      <%}%>
                    </td>
                    <td align='center' width=7%> 
                      <%if(car_bank.get("LEND_ST").equals("N") && car_bank.get("ALLOT_ST").equals("N")){%>
        				<%=cpt_nm%>
        				<input type='hidden' name="cpt_cd" value="<%=cont_bn%>">
                      <%}else{%>
                      <%=c_db.getNameById(String.valueOf(car_bank.get("CPT_CD")), "BANK")%><%//=car_bank.get("CPT_NM")%> 
                      <input type='hidden' name="cpt_cd" value="<%=car_bank.get("CPT_CD")%>">
                      <%}%>
                    </td>
                    <td align='right' width=7%><%=Util.parseDecimal(String.valueOf(car_bank.get("PAY_SCH_AMT")))%></td>
                    <td align='center' width=7%> 
                      <%if(car_bank.get("PAY_DT").equals("")){%>
                      <input type="text" name="pay_dt" maxlength='11' value="<%=car_bank.get("PAY_DT")%>" size="11" class=text onBlur='javascript:this.value=ChangeDate(this.value)'>
                      <%}else{%>
                      <%=car_bank.get("PAY_DT")%> 
                      <input type='hidden' name="pay_dt">
                      <%}%>
                    </td>
                    <td align='center' width=8%><span title='<%=car_bank.get("CAR_OFF_NM")%>'><%=Util.subData(String.valueOf(car_bank.get("CAR_OFF_NM")), 6)%></span></td>
                    <td align='right' width=8%><%=Util.parseDecimal(String.valueOf(car_bank.get("PAY_AMT")))%></td>
                    <!--
        			<td align='center' width="40"> 
                      <%if(gubun.equals("reg")){
        				  	if(car_bank.get("LEND_ST").equals("N") && car_bank.get("ALLOT_ST").equals("N")){%>
                      <a href="javascript:bank_mapping_loan('<%=i%>','<%=car_bank.get("RENT_MNG_ID")%>','<%=car_bank.get("RENT_L_CD")%>','<%=car_bank.get("CAR_MNG_ID")%>','<%=car_bank.get("LEND_ID")%>','<%=car_bank.get("SUP_AMT")%>','<%=car_bank.get("SPE_AMT")%>');">수정</a> 
                      <%	}else{%>
                      - 
                      <%	}
        			    }else{//list
        				  	if(car_bank.get("LEND_ST").equals("") || car_bank.get("PAY_DT").equals("")){%>
                      <a href="javascript:bank_mapping_loan('<%=i%>','<%=car_bank.get("RENT_MNG_ID")%>','<%=car_bank.get("RENT_L_CD")%>','<%=car_bank.get("CAR_MNG_ID")%>','<%=car_bank.get("LEND_ID")%>','<%=car_bank.get("SUP_AMT")%>','<%=car_bank.get("SPE_AMT")%>');">수정</a> 
                      <%	}else{%>
                      - 
                      <%	}
        			    }%>
                    </td>-->
                    <td align='center' width=5%><%if(car_bank.get("CLTR_ST").equals("Y")){%>유<%}else{%>무<%}%></td>
                    <td align='center' width=6%> 
                      <%if(rtn_st.equals("0") && gubun.equals("list")){%>
                      <a href="javascript:bank_mapping_scd('<%=car_bank.get("RENT_MNG_ID")%>','<%=car_bank.get("RENT_L_CD")%>','<%=car_bank.get("CAR_MNG_ID")%>','<%=car_bank.get("SCD_ST")%>');"><font color="#009900"><%=car_bank.get("SCD_ST")%></font></a> 
                      <%}else{%>
                      -
                      <%}%>
                    </td>
                </tr>
                <%}	%>
                <tr> 
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title style='text-align:right'><input type="text" name="tot_loan_sch_amt" maxlength='12'  size="11" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
        			</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                    <td class=title>&nbsp;</td>
                </tr>		  		  
            </table>
		</td>
<%	}else{	%>                     
	<tr>
		
        <td class='line' width='27%' id='td_con' style='position:relative;' height="21"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					<td align='center'>등록된 데이타가 없습니다</td>
				</tr>
			</table>
		</td>
		
        <td class='line' width='73%' height="20"> 
            <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
					
                    <td>&nbsp;</td>
				</tr>
			</table>
		</td>
	</tr>
<%	}	%>
</table>
</form>
<script language='javascript'>
<!--
<%	if(car_bank_size > 0){	%>
	
	set_amt();
	
	function set_amt(){
		var fm = document.form1;
		for(i=0; i<<%=car_bank_size%> ; i++){
			fm.tot_loan_sch_amt.value = parseDecimal(toInt(parseDigit(fm.tot_loan_sch_amt.value)) + toInt(parseDigit(fm.loan_sch_amt[i].value)) );
		}
	}
<%	}	%>
//-->
</script>
</body>
</html>