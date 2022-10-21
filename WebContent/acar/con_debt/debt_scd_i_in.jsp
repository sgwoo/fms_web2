<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.util.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function in_save(){
		var i_fm = document.form1;
		var idx = i_fm.t_alt_int.length;
/*		for(var i = 0 ; i < idx ; i++){
			if((i_fm.t_alt_int[i].value == '') || (parseDigit(i_fm.t_alt_int[i].value).length > 8) || !isCurrency(i_fm.t_alt_int[i].value)){
				alert((i+1)+'회차 이자금액을 확인하십시오');
				return;
			}else if((i_fm.t_alt_amt[i].value == '') || (parseDigit(i_fm.t_alt_amt[i].value).length > 9) || !isCurrency(i_fm.t_alt_amt[i].value)){
				alert((i+1)+'회차 할부금액을 확인하십시오');
				return;
			}
		}		*/
		i_fm.action = '/acar/con_debt/debt_scd_i_a.jsp';
		i_fm.target = 'i_no';
		i_fm.submit();
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
		
	function cal_allot(idx, obj){
		var i_fm = i_in.form1;
		obj.value = parseDecimal(obj.value);
		i_fm.alt_prn_amt[idx].value = parseDecimal(toInt(parseDigit(i_fm.alt_amt[idx].value)) - toInt(parseDigit(i_fm.alt_int_amt[idx].value)));
		cal_rest();
	}
	//이자엔터키
	function enter(idx){
		var fm = document.form1;
		var keyValue = event.keyCode;
		if (keyValue =='13' && idx+1 != fm.t_tot_amt_tm.value){
			fm.t_alt_int[idx+1].focus();
		}else{
			parent.cal_allot(idx, fm.t_alt_int[idx])
		}
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
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
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
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	
	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	int tot_amt_tm = debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
	int alt_amt = debt.getAlt_amt();
%>
<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='t_tot_amt_tm' value='<%=tot_amt_tm%>'>
<input type='hidden' name='t_fst_pay_dt' value=''>
<input type='hidden' name='t_fst_pay_amt' value=''>
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
<input type='hidden' name='t_lend_prn' value=''>
<input type='hidden' name='lend_dt' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
<%	if(tot_amt_tm > 0){
		for(int i = 0 ; i < tot_amt_tm ; i++){%>
				<tr>
					<td width='5%' align='center'><input type='text' name='t_alt_tm' value='<%=(i+1)%>' size='2' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_est_dt' size='12' value='' class='white' readonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='15%' align='right'><input type='text' name='t_alt_prn' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_int' size='10' value='' maxlength='10' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)' onKeyDown='javascript:enter(<%=i%>)'>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_amt' size='10' maxlength='11' value='<%=Util.parseDecimal(alt_amt)%>' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td width='18%' align='right'><input type='text' name='t_rest_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='8%' align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
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
