<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.bank_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function in_save(){
		var i_fm = document.form1;
		var idx = i_fm.t_alt_int.length;
		for(var i = 0 ; i < idx ; i++){
			if((i_fm.t_alt_int[i].value == '') || (parseDigit(i_fm.t_alt_int[i].value).length > 8) || !isCurrency(i_fm.t_alt_int[i].value)){
				alert((i+1)+'회차 이자금액을 확인하십시오');
				return;
			}
			else if((i_fm.t_alt_amt[i].value == '') || (parseDigit(i_fm.t_alt_amt[i].value).length > 9) || !isCurrency(i_fm.t_alt_amt[i].value)){
				alert((i+1)+'회차 할부금액을 확인하십시오');
				return;
			}
		}		
		i_fm.action = 'bank_mapping_scd_i_a.jsp';
		i_fm.target = 'i_no';
		i_fm.submit();
	}
	
	function cal_allot(idx, obj){
		var i_fm = i_in.form1;
		obj.value = parseDecimal(obj.value);
		i_fm.alt_prn_amt[idx].value = parseDecimal(toInt(parseDigit(i_fm.alt_amt[idx].value)) - toInt(parseDigit(i_fm.alt_int_amt[idx].value)));
		cal_rest();
	}
	
	function cal_rest(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.alt_rest_amt.length;
		for(var i = 0 ; i < tm ; i ++){
			if(i == 0)	i_fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.lend_prn.value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
			else		i_fm.rest_amt[i].value = parseDecimal(toInt(parseDigit(i_fm.rest_amt[i-1].value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
		}
		cal_total();
	}
	
	function cal_total(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.t_alt_prn.length;
		var prn = 0;
		var int = 0;
		var amt = 0;
		for(var i = 0 ; i < tm ; i ++){	
			prn += toInt(parseDigit(i_fm.t_alt_prn[i].value));
			int += toInt(parseDigit(i_fm.t_alt_int[i].value));
			amt += toInt(parseDigit(i_fm.t_alt_amt[i].value));
		}
		fm.t_tot_alt_prn.value = parseDecimal(prn);
		fm.t_tot_alt_int.value = parseDecimal(int);
		fm.t_tot_alt_amt.value = parseDecimal(amt);
	}	
	
	//0,1회 약정일 차일수
	function getDefMon(){
		var fm = document.form1;	
		var idx = fm.t_alt_int.length;		
		m  = 30*24*60*60*1000;		//달
		l  = 24*60*60*1000;  		// 1일
		lh = 60*60*1000;  			// 1시간
		lm = 60*1000;  	 	 		// 1분
		var d1;
		var d2;
		var t1;
		var t2;
		var t3;
				
		if(idx > 1 && fm.t_est_dt[0].value != '' && fm.t_est_dt[1].value != ''){
			d1 = replaceString('-','',fm.t_est_dt[0].value)+'00'+ '00';
			d2 = replaceString('-','',fm.t_est_dt[1].value)+'00'+ '00';		

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
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_rtn 	= request.getParameter("s_rtn")==null?"":request.getParameter("s_rtn");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	int max_cltr_rat = request.getParameter("max_cltr_rat")==null?0:Util.parseInt(request.getParameter("max_cltr_rat"));
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	int rtn_size = request.getParameter("rtn_size")==null?0:Util.parseInt(request.getParameter("rtn_size"));
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");

	//할부정보
	ContDebtBean debt = abl_db.getBankLend_mapping_allot(m_id, l_cd);
	int tot_amt_tm = debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
	int alt_amt = debt.getAlt_amt();

	
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
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
<input type='hidden' name='t_tot_amt_tm' value='<%=tot_amt_tm%>'>
<input type='hidden' name='t_fst_pay_dt' value=''>
<input type='hidden' name='t_fst_pay_amt' value=''>
<input type='hidden' name='t_lend_prn' value=''>
<input type='hidden' name='lend_dt' value=''>

  <table border="0" cellspacing="0" cellpadding="0" width=780>
    <tr>
		<td class='line'>
		 	
        <table border="0" cellspacing="1" cellpadding="0" width=780>
          <%	if(tot_amt_tm > 0){
		for(int i = 0 ; i < tot_amt_tm ; i++){%>
          <tr>
					<td width='40' align='center'><input type='text' name='t_alt_tm' value='<%=(i+1)%>' size='2' class='white' readonly></td>
					<td width='90' align='center'><input type='text' name='t_est_dt' size='12' value='' class='white' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='120' align='right'><input type='text' name='t_alt_prn' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='120' align='right'><input type='text' name='t_alt_int' size='10' value='' maxlength='10' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td width='120' align='right'><input type='text' name='t_alt_amt' size='10' maxlength='11' value='<%=Util.parseDecimal(alt_amt)%>' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					
            <td width='120' align='right'>
<input type='text' name='t_rest_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='60' align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					
            <td align='center'>
<input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>
<%		}
	}else{%>
				<tr>
					<td colspan='8' align='center'>할부금스케줄이 없습니다</td>
				</tr>
<%	}%>
			</table>
		</td>
	</tr>
</table>
</form>
</body>
</html>
