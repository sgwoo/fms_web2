<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//이자,할부금 입력시 할부원금,할부금잔액 셋팅
	function cal_allot(idx, obj){
		var fm = document.form1;
		obj.value = parseDecimal(obj.value);
		fm.alt_prn_amt[idx].value = parseDecimal(toInt(parseDigit(fm.alt_amt[idx].value)) - toInt(parseDigit(fm.alt_int_amt[idx].value)));
		cal_rest();
	}

	//할부금 잔책 셋팅
	function cal_rest(){
		var fm = document.form1;
		var tm = fm.alt_rest.length;
		for(var i = 0 ; i < tm ; i ++){
			if(i == 0)	fm.alt_rest[i].value = parseDecimal(toInt(parseDigit(fm.rtn_cont_amt.value)) - toInt(parseDigit(fm.alt_prn_amt[i].value)));
			else		fm.alt_rest[i].value = parseDecimal(toInt(parseDigit(fm.alt_rest[i-1].value)) - toInt(parseDigit(fm.alt_prn_amt[i].value)));
		}
		cal_total();
	}
	
	//하단의 합계 계산
	function cal_total(){
		var fm = document.form1;
		var tm = fm.alt_prn_amt.length;
		var prn = 0;
		var int = 0;
		var amt = 0;
		for(var i = 0 ; i < tm ; i ++){	
			prn += toInt(parseDigit(fm.alt_prn_amt[i].value));
			int += toInt(parseDigit(fm.alt_int_amt[i].value));
			amt += toInt(parseDigit(fm.alt_amt[i].value));
		}
		parent.form1.tot_alt_prn.value = parseDecimal(prn);
		parent.form1.tot_alt_int.value = parseDecimal(int);
		parent.form1.tot_alt_amt.value = parseDecimal(amt);
	}
	//이자엔터키
	function enter(idx){
		var fm = document.form1;
		var tm = fm.alt_rest.length;
		var keyValue = event.keyCode;
		if (keyValue =='13' && idx+1 != tm){
			fm.alt_int_amt[idx+1].focus();
		}else{
			cal_allot(idx, fm.alt_int_amt[idx])
		}
	}		
	function in_save(){
		var fm = document.form1;
		var idx = fm.alt_int_amt.length;
		
		for(var i = 0 ; i < idx ; i++){
			if((fm.alt_int_amt[i].value == '') || (parseDigit(fm.alt_int_amt[i].value).length > 12) || !isCurrency(fm.alt_int_amt[i].value)){
				alert((i+1)+'회차 이자금액을 확인하십시오');
				return;
			}
			else if((fm.alt_amt[i].value == '') || (parseDigit(fm.alt_amt[i].value).length > 12) || !isCurrency(fm.alt_amt[i].value)){
				alert((i+1)+'회차 할부금액을 확인하십시오');
				return;
			}
		}
		fm.fst_pay_dt.value = parent.form1.fst_pay_dt.value;
		fm.fst_pay_amt.value = parent.form1.fst_pay_amt.value;
		fm.action = 'bank_scd_i_a.jsp';
		fm.target = 'i_in_no';
//		fm.target = '_blank';		
		fm.submit();
	}
	
	//0,1회 약정일 차일수
	function getDefMon(){
		var fm = document.form1;	
		var idx = fm.alt_int_amt.length;		
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;
				
		if(idx > 1 && fm.alt_est_dt[0].value != '' && fm.alt_est_dt[1].value != ''){
			d1 = replaceString('-','',fm.alt_est_dt[0].value)+'00'+ '00';
			d2 = replaceString('-','',fm.alt_est_dt[1].value)+'00'+ '00';		

			t1 = getDateFromString(d1).getTime();
			t2 = getDateFromString(d2).getTime();
			t3 = t2 - t1;

			return parseInt(t3/m);
		}
	}
	function getDateFromString(s){
		return new Date(s.substr(0, 4)-1700, s.substr(4, 2)-1, s.substr(6, 2), s.substr(8, 2), s.substr(10, 2));
	}
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	int cont_term = 0;
	int alt_amt = 0;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	if(!bl.getCont_term().equals("")){
		cont_term = bl.getCont_term().equals("")?0:Integer.parseInt(bl.getCont_term());
	}
	alt_amt = bl.getAlt_amt();
%>
<form name='form1' method='post'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_term' value='<%=cont_term%>'>
<input type='hidden' name='cont_amt' value='<%if(bl.getRtn_cont_amt() != 0){ out.println(Util.parseDecimal(bl.getRtn_cont_amt())); }else{ out.println(AddUtil.parseDecimalLong(bl.getCont_amt()));}%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='fst_pay_amt' value=''>
<input type='hidden' name='fst_pay_dt' value=''>
<input type='hidden' name='rtn_cont_amt' value=''>
<input type='hidden' name='lend_dt' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(cont_term > 0){
		for(int i = 0 ; i < cont_term ; i++){%>
				<tr>
					<td width='6%' align='center'><input type='text' name='alt_tm' value='<%=(i+1)%>' size='2' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='alt_est_dt' size='12' value='<%=c_db.addMonth(bl.getFst_pay_dt(), i)%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='15%' align='right'><input type='text' name='alt_prn_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='alt_int_amt' size='10' value='' maxlength='10' class='num' onBlur='javascript:cal_allot(<%=i%>, this);' onKeyDown='javascript:enter(<%=i%>)'>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='alt_amt' size='10' maxlength='11' value='<%=Util.parseDecimal(alt_amt)%>' class='num' onBlur='javascript:cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td width='17%' align='right'><input type='text' name='alt_rest' size='13' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='8%' align='center'>-</td>
					<td width='12%' align='center'>-</td>
				</tr>
<%		}
	}else{%>
				<tr>
					<td align='center'>은행대출관리 화면에서 할부횟수(상환개월)를 먼저 입력한 후 스케줄을 작성하십시오</td>
				</tr>
<%	}%>
			</table>
		</td>
	</tr>
</table>
</form>
<script language='javascript'>
<!--
cal_total();
-->
</script>
<iframe src="about:blank" name="i_in_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</body>
</html>
