<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.pay_mng.*, acar.user_mng.*, acar.doc_settle.*"%>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String mode 	= request.getParameter("mode")==null?"":request.getParameter("mode");
	
	
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	
	//은행계좌번호
	Vector banks = ps_db.getDepositList();
	int bank_size = banks.size();
	
	String p_pay_dt = "";
	
	
	boolean flag1 = true;
	
	
	long total_amt0	= 0;
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3	= 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	long total_amt15 = 0;
	long total_amt16 = 0;
	
	int s1 = 0;
	int b1 = 0;
	int d1 = 0;
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save()
	{
		var fm = document.form1;
		
		if(fm.pay_dt.value == ''){ alert('지출일자를 확인하십시오.'); return; }				
		
		//자금집금 점검
		if(toInt(parseDigit(fm.t_bc_amt.value)) > 0){ 
			for(var i = 0 ; i < 15 ; i ++){
				if(toInt(parseDigit(fm.bc_amt[i].value)) > 0){
					if(fm.bc_a_deposit_no[i].options[fm.bc_a_deposit_no[i].selectedIndex].value == ''){ 				
						alert('집금 출금 계좌번호를 선택하십시오.'); return;						
					}
					if(fm.bc_b_deposit_no[i].options[fm.bc_b_deposit_no[i].selectedIndex].value == ''){

					}
				}							
			}
		}		
				
		if(confirm('송금하시겠습니까?')){
			
			var link = document.getElementById("submitLink");
			var originFunc = link.getAttribute("href");
			link.setAttribute('href',"javascript:alert('처리 중입니다. 잠시만 기다려주세요');");
			
			fm.action = 'pay_a_cms_bank_req_a.jsp';
			fm.target = 'i_no';
//			fm.target = '_blank';
			fm.submit();	
			
			link.getAttribute('href',originFunc);
				
		}
	}	
	
	function sum_bc_amt(){
		var fm = document.form1;
		var t_bc_amt = 0;
		for(var i = 0 ; i < 15 ; i ++){
			t_bc_amt += toInt(parseDigit(fm.bc_amt[i].value));			
		}
		fm.t_bc_amt.value = parseDecimal(t_bc_amt);
	}
	

//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<form name='form1' method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name='s_kd'  	value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>			
  <input type='hidden' name='andor'	 	value='<%=andor%>'>
  <input type='hidden' name='gubun1' 	value='<%=gubun1%>'>  
  <input type='hidden' name='gubun2' 	value='<%=gubun2%>'>  
  <input type='hidden' name='gubun3' 	value='<%=gubun3%>'>
  <input type='hidden' name='gubun4' 	value='<%=gubun4%>'>  
  <input type='hidden' name='gubun5' 	value='<%=gubun5%>'>      
  <input type='hidden' name='st_dt' 	value='<%=st_dt%>'>  
  <input type='hidden' name='end_dt' 	value='<%=end_dt%>'>        
  <input type='hidden' name="mode" 		value="<%=mode%>">
  <input type='hidden' name="from_page" value="<%=from_page%>">


<table border="0" cellspacing="0" cellpadding="0" width=900>
	<tr>
	  <td><< 자금집금 >></td>
    </tr>
	<tr>
	  <td class=line><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width="90" class=title>지출일자</td>
          <td colspan="4" >&nbsp;<input type='text' size='11' name='pay_dt' maxlength='10' class='default' value='<%=AddUtil.getDate()%>' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
        </tr>
        <tr>
          <td width="90" class=title>연번</td>
          <td class=title width="140" >금액</td>
          <td class=title width="320" >출금계좌</td>
          <td width="30" class=title>&nbsp;</td>
          <td width="320" class=title>입금계좌</td>
        </tr>
        <tr>
          <td class=title>1</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td rowspan="10" align="center" class=is>-&gt;                                                                                                                                            </td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>2</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>3</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>4</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>5</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>6</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>7</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>8</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>9</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>10</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>11</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td rowspan="10" align="center" class=is>-&gt;                                                                                                                                            </td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>12</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>13</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>14</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>
        <tr>
          <td class=title>15</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='bc_amt' maxlength='15' value='' class='num' size='15' onBlur='javascript:this.value=parseDecimal(this.value); sum_bc_amt();'>
      원 </td>
          <td align="center" class=is><select name='bc_a_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
          <td align="center" class=is><select name='bc_b_deposit_no'>
            <option value=''>계좌를 선택하세요</option>
            <%	if(bank_size > 0){
										for(int i = 0 ; i < bank_size ; i++){
											Hashtable bank = (Hashtable)banks.elementAt(i);%>
            <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
            <%		}
									}%>
          </select></td>
        </tr>        
        <tr>
          <td width="90" class=title>합계</td>
          <td align="center" class=is>&nbsp;
              <input type='text' name='t_bc_amt' maxlength='15' value='' class='whitenum' size='15'>
원  </td>
          <td align="center" class=is colspan="3" >-</td>
          </tr>		  
      </table></td>
    </tr>	
	<tr>
		<td>※ 입금계좌없이 출금계좌만 입력되었을 경우 현금출금으로 회계처리시 입금전표로 발행됩니다. &nbsp;</td>	
	</tr>
		
	<%if( auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
    <tr>
	    <td align='center'>
	    <a id="submitLink" href="javascript:save()" onMouseOver="window.status=''; return true" onfocus="this.blur()"><img src=/acar/images/center/button_send_money.gif border=0 align=absmiddle></a>
	    </td>
	</tr>	
	<%}%>			 		
	
</table>
</form>  
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
