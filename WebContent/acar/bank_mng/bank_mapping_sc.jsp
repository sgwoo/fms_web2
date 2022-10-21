<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	function window_close(){
		var fm = document.form1;
		if(fm.gubun.value == 'reg'){
			parent.close();
			parent.opener.location.reload();
		}else{
			parent.close();
		}		
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
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");
	String rtn_st = request.getParameter("rtn_st")==null?"":request.getParameter("rtn_st");
	String lend_amt_lim = request.getParameter("lend_amt_lim")==null?"":request.getParameter("lend_amt_lim");
	String rtn_size = request.getParameter("rtn_size")==null?"":request.getParameter("rtn_size");
	
	
%>
<form name='form1' action='bank_mapping_sc.jsp' target='i_inner' method="POST">
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
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
      <td> 
        <table border="0" cellspacing="0" cellpadding="0" width=100%>
          <tr> 
            <td> 
              <table border="0" cellspacing="0" cellpadding="0" width=100%>
                <tr> 
                  <td align=right> <iframe src="bank_mapping_sc_in.jsp?auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_rtn=<%=s_rtn%>&gubun=<%=gubun%>&lend_id=<%=lend_id%>&cont_bn=<%=cont_bn%>&lend_int=<%=lend_int%>&max_cltr_rat=<%=max_cltr_rat%>&rtn_st=<%=rtn_st%>&lend_amt_lim=<%=lend_amt_lim%>&rtn_size=<%=rtn_size%>" name="i_inner" width="100%" height=500 cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
                    </iframe></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
    </tr>
<%if(1!=1){
	long loan_sch_amt=0;
	long loan_amt=0;
	long pay_sch_amt=0;
	long pay_amt=0;
	
	Vector car_banks = abl_db.getCarbankList(s_kd, t_wd, s_rtn, gubun, lend_id);
	int car_bank_size = car_banks.size();
    for(int i = 0 ; i < car_bank_size ; i++){
		Hashtable car_bank = (Hashtable)car_banks.elementAt(i);
		if(car_bank.get("LEND_ST").equals("N") && car_bank.get("ALLOT_ST").equals("N")){//대출금제한계산식
	  		String s_loan_sch_amt="0";
	  		if(lend_amt_lim.equals("1")){
				s_loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//만원절삭
			}else if(lend_amt_lim.equals("2")){
				s_loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_AMT_85PER")));//만원절삭
			}else if(lend_amt_lim.equals("3")){
				s_loan_sch_amt = AddUtil.th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//천원절삭
			}else if(lend_amt_lim.equals("4")){
				s_loan_sch_amt = AddUtil.ml_th_rnd(String.valueOf(car_bank.get("SUP_V_AMT")));//백원절삭
			}else if(lend_amt_lim.equals("5")){
				s_loan_sch_amt = AddUtil.ten_th_rnd(String.valueOf(car_bank.get("SUP_AMT_70PER")));//만원절삭
			}else{
				s_loan_sch_amt = String.valueOf(car_bank.get("SUP_AMT"));
			}
			loan_sch_amt	+=Long.parseLong(s_loan_sch_amt);
		}else{
			loan_sch_amt	+=Long.parseLong(String.valueOf(car_bank.get("LOAN_SCH_AMT")));
		}
		loan_amt		+=Long.parseLong(String.valueOf(car_bank.get("LOAN_AMT")));
		pay_sch_amt		+=Long.parseLong(String.valueOf(car_bank.get("PAY_SCH_AMT")));
		pay_amt			+=Long.parseLong(String.valueOf(car_bank.get("PAY_AMT")));
	}
	%>
    <tr> 
      <td colspan="2"></td>
    </tr>
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="0" cellpadding="0" width='800'>
          <tr> 
            <td class='line' width='800'> 
              <table border="0" cellspacing="1" cellpadding="0" width='800'>
                <tr> 
                  <td width='160' class='title'> 구매자금 대출시행금액 누계</td>
                  <td align='right' width='105'><%=Util.parseDecimal(loan_amt)%></td>
                  <td width='160' class='title'> 구매자금 지출시행금액 누계</td>
                  <td align='right' width='105'><%=Util.parseDecimal(pay_amt)%></td>
                  <td width='160' class='title'> 대출-지출금</td>
                  <td align='right'><%=Util.parseDecimal(loan_amt-pay_amt)%></td>
                </tr>
                <tr> 
                  <td class='title' width="160"> 구매자금 대출예정금액 누계</td>
                  <td align='right' width="105"><%=Util.parseDecimal(loan_sch_amt)%></td>
                  <td class='title' width="160"> 구매자금 지출예정금액 누계</td>
                  <td align='right' width="105"><%=Util.parseDecimal(pay_sch_amt)%></td>
                  <td class='title' width="160"> 대출예정 -지출예정</td>
                  <td align='right'><%=Util.parseDecimal(loan_sch_amt-pay_sch_amt)%></td>
                </tr>
                <tr> 
                  <td class='title' width="160"> 합계 </td>
                  <td align='right' width="105"><%=Util.parseDecimal(loan_amt+loan_sch_amt)%></td>
                  <td class='title' width="160"> 합계 </td>
                  <td align='right' width="105"><%=Util.parseDecimal(pay_amt+pay_sch_amt)%></td>
                  <td class='title' width="160"> 대출-지출(합계 )</td>
                  <td align='right'><%=Util.parseDecimal((loan_amt+loan_sch_amt)-(pay_sch_amt+pay_amt))%></td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </td>
      <td width='20'></td>
    </tr>
<%}%>
    <tr> 
      <td colspan="2" align="right"><a href="javascript:window_close();"><img src=../images/center/button_close.gif align=absmiddle border=0></a></td>
    </tr>
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>