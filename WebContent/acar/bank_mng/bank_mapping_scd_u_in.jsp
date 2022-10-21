<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.cont.*, acar.bank_mng.*, acar.debt.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function in_modify(){
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
		i_fm.action = 'bank_mapping_scd_u_a.jsp';
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
	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
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

	
	Vector debts = abl_db.getDebtScd(car_id);
	int debt_size = debts.size();
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
<input type='hidden' name='t_tot_amt_tm' value='<%=debt_size%>'>
<input type='hidden' name='t_fst_pay_dt' value=''>
<input type='hidden' name='t_fst_pay_amt' value=''>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td class='line'>		 	
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%	if(debt_size > 0){
		for(int i = 0 ; i < debt_size ; i++){
			DebtScdBean a_debt = (DebtScdBean)debts.elementAt(i);
			if(a_debt.getPay_yn().equals("1")){%>
                <tr>
					<td class='is' width='5%'  align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='istext' readonly></td>
					<td class='is' width='12%'  align='center'><input type='text' name='t_est_dt' size='12' value='<%=a_debt.getAlt_est_dt()%>' class='istext' readonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td class='is' width='15%' align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width='15%' align='right'><input type='text' name='t_alt_int' maxlength='10' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='isnumsee' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td class='is' width='15%' align='right'><input type='text' name='t_alt_amt' maxlength='11' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='isnumsee' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					
                    <td class='is' width='15%' align='right'>
                        <input type='text' name='t_rest_amt' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='isnum' readonly>원&nbsp;</td>
		            <td class='is' width='10%'  align='center'><input type='text' name='t_pay_yn' size='2'  value='Y' class='istext' readonly></td>
					
                    <td class='is' align='center'>
                        <input type='text' name='t_pay_dt' size='11' value='<%=a_debt.getPay_dt()%>' class='istext' readonly></td>
				</tr>
<%			}else{%>
				<tr>
					<td width='5%'  align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='white' readonly></td>
					<td width='12%'  align='center'><input type='text' name='t_est_dt' size='12' value='<%=a_debt.getAlt_est_dt()%>' class='white' readonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='15%' align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_int' maxlength='10' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_amt' maxlength='11' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='num' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					
                    <td width='15%' align='right'>
                        <input type='text' name='t_rest_amt' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width='10%'  align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					
                    <td align='center'>
                        <input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>
<%			}
		}
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
<script language='javascript'>
<!--
	parent.cal_total();
-->
</script>
</body>
</html>
