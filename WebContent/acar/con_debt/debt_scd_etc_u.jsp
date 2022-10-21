<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.cont.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.debt.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
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
	String car_id 	= request.getParameter("car_id")==null?"":request.getParameter("car_id");
	
	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	
	Vector debts = d_db.getDebtScdEtc(car_id);
	int debt_size = debts.size();
	
	String ui_st = "i";
	
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
function set_est_dt(){
	var fm = document.form1;
	fm.action='/acar/con_debt/est_dt_nodisplay.jsp';
	fm.target='i_no';
	fm.submit();
}

function set_fst_amt(){
	var fm = document.form1;
	var tm = fm.t_rest_amt.length;	
	for(var i = 1 ; i < tm ; i ++){
		fm.t_alt_prn[i].value = fm.t_fst_pay_amt.value;
		fm.t_alt_int[i].value = 0;
		fm.t_alt_amt[i].value = parseDecimal(toInt(parseDigit(fm.t_alt_prn[i].value)) + toInt(parseDigit(fm.t_alt_int[i].value)));
	}
	cal_rest();
}

function cal_rest(){	
	var fm = document.form1;
	var tm = fm.t_rest_amt.length;		
	for(var i = 1 ; i < tm ; i ++){		
		if((i+1)==tm){
			fm.t_alt_prn[i].value = fm.t_rest_amt[i-1].value;
			fm.t_alt_amt[i].value = fm.t_rest_amt[i-1].value;
		}		
		fm.t_rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.t_rest_amt[i-1].value)) - toInt(parseDigit(fm.t_alt_prn[i].value)));
	}	
	cal_total();
}

function cal_total(){
	var fm = document.form1;
	var tm = fm.t_alt_prn.length;
	var prn = 0;
	var int = 0;
	var amt = 0;
	for(var i = 0 ; i < tm ; i ++){	
		prn += toInt(parseDigit(fm.t_alt_prn[i].value));
		int += toInt(parseDigit(fm.t_alt_int[i].value));
		amt += toInt(parseDigit(fm.t_alt_amt[i].value));
	}
	fm.t_tot_alt_prn.value = parseDecimal(prn);
	fm.t_tot_alt_int.value = parseDecimal(int);
	fm.t_tot_alt_amt.value = parseDecimal(amt);
}	

function cal_allot(idx, obj){
	var fm = document.form1;	
	obj.value = parseDecimal(obj.value);
	fm.t_alt_prn[idx].value = parseDecimal(toInt(parseDigit(fm.t_alt_amt[idx].value)) - toInt(parseDigit(fm.t_alt_int[idx].value)));
	cal_rest();
}


//이자엔터키
function enter(idx){
	var fm = document.form1;
	var keyValue = event.keyCode;
	if (keyValue =='13' && idx+1 != fm.t_tot_amt_tm.value){
		fm.t_alt_int[idx+1].focus();
	}else{
		cal_allot(idx, fm.t_alt_int[idx])
	}
}	

function save(){
	var fm = document.form1;	
	if(confirm('등록하시겠습니까?')){
		fm.action = 'debt_scd_etc_u_a.jsp';
		//fm.target = 'i_no';
		fm.target = '_self';
		fm.submit();
	}
}
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' method='post'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=car_id%>'>
<input type='hidden' name='t_tot_amt_tm' value='<%=debt_size-1%>'>
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
<input type='hidden' name='update_msg' value=''>
<input type='hidden' name='mode' value='etc'>
<input type='hidden' name='rtn_est_dt' value='<%=debt.getRtn_est_dt()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>기타비용</span></td>
	</tr>	
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'  width=10%>기타비용</td>
                    <td>&nbsp;
                      내용 : 
                      <input type="text" name="alt_etc" value='<%=debt.getAlt_etc()%>' maxlength='100' size="40" class=whitetext>&nbsp; 
                      &nbsp; 총금액 :
                      <input type='text' name='alt_etc_amt' value='<%=AddUtil.parseDecimal(debt.getAlt_etc_amt())%>' maxlength='10' size='10' class='whitenum'>
                      원
                      &nbsp; 회차 :
                      <input type='text' name='alt_etc_tm' value='<%=debt.getAlt_etc_tm()%>' size='3' maxlength='2' class='whitenum'>
                      회
                      &nbsp;
                      (대출금에 포함되어 있으나 원금 별도 상환인 경우)
                      </td>                    
                </tr>	
                <%
                	int tot_amt_tm = debt.getAlt_etc_tm().equals("")?0:Integer.parseInt(debt.getAlt_etc_tm());
					int alt_amt = debt.getAlt_etc_amt()/Integer.parseInt(debt.getAlt_etc_tm());
	 			%>
	 			<tr> 
                    <td class='title'  width=10%>스케줄</td>
                    <td>&nbsp;
                      월상환액 : 
                      <input type='text' name='t_fst_pay_amt' value='<%=AddUtil.parseDecimal(alt_amt)%>' maxlength='10' size='10' class='num' onBlur='javascript:set_fst_amt()'>
                      원
                      (=총금액/회차)
                      &nbsp; 
                      1회차결재일 :
                      <input type='text' name='t_fst_pay_dt' value='<%=debt.getFst_pay_dt()%>' size='15' maxlength='15' class='text'  onBlur='javscript:set_est_dt();'>
                    </td>                    
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
					<td width=7% class='title'>회차</td>
					<td width=12% class='title'>약정일</td>
					<td width=15% class='title'>기타비용</td>		
					<td width=15% class='title'>이자</td>
					<td width=15% class='title'>합계</td>								
					<td width=15% class='title'>잔액</td>
					<td width=9% class='title'>결재여부</td>
					<td width=12% class='title'>결재일</td>
				</tr>		 	
<%
	if(debt_size > 0)
	{
		for(int i = 0 ; i < debt_size ; i++)
		{
			DebtScdBean a_debt = (DebtScdBean)debts.elementAt(i);
			if(a_debt.getPay_yn().equals("1"))
			{
				if((i+1) == debt_size){
					ui_st = "u";
				}
%>
				<tr>
					<td class='is' width=7%  align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='istext' readonly></td>
					<td class='is' width=12%  align='center'><input type='text' name='t_est_dt' size='12' value='<%=a_debt.getAlt_est_dt()%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td class='is' width=15% align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=15% align='right'><input type='text' name='t_alt_int' maxlength='10' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='isnumsee' onBlur='javascript:cal_allot(<%=i%>, this)' onKeyDown='javascript:enter(<%=i%>)'>원&nbsp;</td>
					<td class='is' width=15% align='right'><input type='text' name='t_alt_amt' maxlength='11' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='isnumsee' onBlur='javascript:parent.cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td class='is' width=15% align='right'><input type='text' name='t_rest_amt' size='11' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='isnum' readonly>원&nbsp;</td>
					<td class='is' width=9%  align='center'><input type='text' name='t_pay_yn' size='2'  value='Y' class='white' readonly></td>
					<td class='is' width=12% align='center'><input type='text' name='t_pay_dt' size='11' value='<%=a_debt.getPay_dt()%>' class='white' readonly></td>
				</tr>
<%
			}
			else
			{
%>				<tr>
					<td align='center'><input type='text' name='t_alt_tm' value='<%=a_debt.getAlt_tm()%>' size='2' class='white' readonly></td>
					<td align='center'><input type='text' name='t_est_dt' size='12' value='<%=a_debt.getAlt_est_dt()%>' class='text' onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td align='right'><input type='text' name='t_alt_prn' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn())%>' class='whitenum' readonly>원&nbsp;</td>
					<td align='right'><input type='text' name='t_alt_int' maxlength='10' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_int())%>' class='num' onBlur='javascript:cal_allot(<%=i%>, this)' onKeyDown='javascript:enter(<%=i%>)'>원&nbsp;</td>
					<td align='right'><input type='text' name='t_alt_amt' maxlength='11' size='10' value='<%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%>' class='num' onBlur='javascript:cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td align='right'><input type='text' name='t_rest_amt' size='11' value='<%=Util.parseDecimal(a_debt.getAlt_rest())%>' class='whitenum' >원&nbsp;</td>
					<td align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					<td align='center'><input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>
<%			}
		}
	}
	else
	{
%>

<!-- 신규생성 -->

				<tr>
					<td width='5%' align='center'><input type='text' name='t_alt_tm' value='0' size='2' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_est_dt' size='12' value='<%=debt.getLend_dt()%>' class='white' readonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='15%' align='right'><input type='text' name='t_alt_prn' size='10' value='0' class='whitenum' readonly>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_int' size='10' value='0' maxlength='10' class='num' onBlur='javascript:cal_allot(0, this)' onKeyDown='javascript:enter(0)'>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_amt' size='10' maxlength='11' value='0' class='num' onBlur='javascript:cal_allot(0, this)'>원&nbsp;</td>
					<td width='18%' align='right'><input type='text' name='t_rest_amt' size='10' value='<%=Util.parseDecimal(debt.getAlt_etc_amt())%>' class='whitenum' readonly>원&nbsp;</td>
					<td width='8%' align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>

<%	
	

	if(tot_amt_tm > 0){
		for(int i = 1 ; i <= tot_amt_tm ; i++){%>
				<tr>
					<td width='5%' align='center'><input type='text' name='t_alt_tm' value='<%=(i)%>' size='2' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_est_dt' size='12' value='' class='white' readonly onBlur='javscript:this.value = ChangeDate(this.value);'></td>
					<td width='15%' align='right'><input type='text' name='t_alt_prn' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_int' size='10' value='' maxlength='10' class='num' onBlur='javascript:cal_allot(<%=i%>, this)' onKeyDown='javascript:enter(<%=i%>)'>원&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='t_alt_amt' size='10' maxlength='11' value='<%=Util.parseDecimal(alt_amt)%>' class='num' onBlur='javascript:cal_allot(<%=i%>, this)'>원&nbsp;</td>
					<td width='18%' align='right'><input type='text' name='t_rest_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width='8%' align='center'><input type='text' name='t_pay_yn' size='2' value='N' class='white' readonly></td>
					<td width='12%' align='center'><input type='text' name='t_pay_dt' size='11' value='-' class='white' readonly></td>
				</tr>
<%		}
	}%>
				
				
				
				
<%	}
%>

				<tr>
					<td width=7% class='title'>합계 </td>
					<td width=12%>&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_prn' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_int' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=15% align='right'><input type='text' name='t_tot_alt_amt' size='10' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=36% colspan='3'>&nbsp;</td>
				</tr>
	
			</table>
		</td>
	</tr>
	
	<tr>
		<td align='right' colspan=2>
		  <a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>&nbsp;&nbsp;
		</td>	
	</tr>				
	
</table>
<script language='javascript'>
<!--
	var fm = document.form1;
	if((fm.t_tot_amt_tm.value == 0 || fm.t_tot_amt_tm.value < <%=debt.getAlt_etc_tm()%>) && '<%=ui_st%>' == 'i'){
		fm.t_tot_amt_tm.value = <%=tot_amt_tm%>;
	}
	
	cal_total();
-->
</script>
</body>
</form>
<iframe src="about:blank" name="i_no" width="100%" height="100" frameborder="0" noresize></iframe>
</html>
