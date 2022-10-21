<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.cont.*, acar.bank_mng.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//1회차결제일로 약정일 셋팅
	function set_est_dt(){
		var fm = document.form1;
		fm.t_fst_pay_dt.value=ChangeDate(fm.t_fst_pay_dt.value);
		if((fm.t_fst_pay_dt.value != '') && isDate(fm.t_fst_pay_dt.value) &&(fm.t_tot_amt_tm.value != '')){
			fm.action='est_dt_nodisplay2.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}
	
	//1회차상환금액으로 할부금 셋팅
	function set_fst_amt(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		fm.t_fst_pay_amt.value=parseDecimal(fm.t_fst_pay_amt.value);
		if(parseDigit(fm.t_fst_pay_amt.value).length > 9){ alert('1회차 상환금액을 확인하십시오'); return; }		
		if(i_fm.t_alt_amt[0] != null){
			i_fm.t_alt_amt[0].value = fm.t_fst_pay_amt.value;
			cal_rest();
		}
	}
	//할부금잔액 셋팅
	function cal_rest(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		var tm = i_fm.t_rest_amt.length;
		for(var i = 0 ; i < tm ; i ++){
			if(i == 0)	i_fm.t_rest_amt[i].value = parseDecimal(toInt(parseDigit(fm.t_lend_prn.value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
			else		i_fm.t_rest_amt[i].value = parseDecimal(toInt(parseDigit(i_fm.t_rest_amt[i-1].value)) - toInt(parseDigit(i_fm.t_alt_prn[i].value)));
		}
		cal_total();
	}
	//합계계산
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
	
	function cal_allot(idx, obj){
		var i_fm = i_in.form1;
		obj.value = parseDecimal(obj.value);
		i_fm.t_alt_prn[idx].value = parseDecimal(toInt(parseDigit(i_fm.t_alt_amt[idx].value)) - toInt(parseDigit(i_fm.t_alt_int[idx].value)));
		cal_rest();
	}
	
	function save(){
		var fm = document.form1;
		var i_fm = i_in.form1;
		if(parseDigit(fm.t_fst_pay_amt.value).length > 9){ alert('1회차 상환금액을 확인하십시오'); return; }				
		if(i_in.getDefMon() > 1){ alert('0회차 약정일과 1회차 약정일을 확인하십시오.'); return; }
		if(confirm('등록하시겠습니까?')){					
			i_fm.t_fst_pay_dt.value = fm.t_fst_pay_dt.value;
			i_fm.t_fst_pay_amt.value = fm.t_fst_pay_amt.value;
			i_fm.t_lend_prn.value = fm.t_lend_prn.value;
			i_fm.lend_dt.value = fm.lend_dt.value;
			i_in.in_save();
		}
	}
	
	function go_to_list(){
		var fm = document.form1;
		fm.target='MAPPING';
		fm.action='bank_mapping_frame_s.jsp';
		fm.submit();
	}	
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");

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

	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<form name='form1' action='bank_mapping_scd_i_a.jsp' target='' method="POST">
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
<input type='hidden' name='tot_amt_tm' value='<%=tot_amt_tm%>'>
<input type='hidden' name='rtn_est_dt' value='<%=debt.getRtn_est_dt()%>'>
<input type='hidden' name='lend_dt' value='<%=debt.getLend_dt()%>'>


<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr> 
        <td colspan="2">
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무관리 > 은행대출관리 > <span class=style1><span class=style5>할부금 상환 스케줄 등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr> 
    <tr> 
        <td class=line2 colspan="2"></td>
    </tr>     
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td class='title'>계약번호</td>
                    <td>&nbsp;<%=l_cd%> </td>
                    <td class='title'> 대출금액 </td>
                    <td>&nbsp; 
                      <input type='text' name='t_lend_prn' size='10' value='<%=Util.parseDecimal(debt.getLend_prn())%>' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td class='title'>대출번호</td>
                    <td>&nbsp;<%=debt.getLend_no()%> </td>
                    <td class='title'> 할부금융사 </td>
                    <td colspan='3' align='left'>&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%></td>
                </tr>
                <tr> 
                    <td class='title' width=8%> 할부횟수 </td>
                    <td width=12%>&nbsp; 
                      <input type='text' name='t_tot_amt_tm' size='2' value='<%=debt.getTot_alt_tm()%>' class='white' onBlur='javascript:blur()'>
                      회&nbsp;</td>
                    <td class='title' width=8%> 이율 </td>
                    <td width=12%>&nbsp;<%=debt.getLend_int()%>%&nbsp;</td>
                    <td class='title' width=9%> 할부수수료 </td>
                    <td width=12% align="right">&nbsp;<%=Util.parseDecimal(debt.getAlt_fee())%>원&nbsp;</td>
                    <td class='title' width=11%>공증료 
                    <td width=11% align="right">&nbsp;<%=Util.parseDecimal(debt.getNtrl_fee())%>원&nbsp;</td>
                    <td width=7% class='title'>인지대 
                    <td width=10% align="right">&nbsp;<%=Util.parseDecimal(debt.getStp_fee())%>원&nbsp;</td>
                </tr>
                <tr> 
                    <td class='title'>할부금</td>
                    <td align="right">&nbsp;<%=Util.parseDecimal(debt.getAlt_amt())%>원&nbsp;</td>
                    <td class='title'>약정일자 
                    <td>&nbsp;<%=debt.getRtn_est_dt()%>일</td>
                    <td class='title'>1회차결재일</td>
                    <td>&nbsp; 
                      <input type='text' size='11' name='t_fst_pay_dt' value='<%=debt.getFst_pay_dt()%>' class='text' maxlength='10' onBlur='javascript:set_est_dt()'>
                    </td>
                    <td class='title'>1회차상환금액 </td>
                    <td colspan='3'>&nbsp; 
                      <input type='text' name='t_fst_pay_amt' value='<%=Util.parseDecimal(debt.getFst_pay_amt())%>' size='11' maxlength='11' class='num' onBlur='javascript:set_fst_amt()'>
                      &nbsp;원&nbsp;</td>
                </tr>
            </table>
        </td>
    </tr>
    <%	if(tot_amt_tm>=1){ %>
    <tr> 
        <td><<할부금스케줄>></td>
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	  	<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/images/reg.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
		<%}%>
        <a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
	    </td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>회차</td>
                    <td width='12%' class='title'>약정일</td>
                    <td width='15%' class='title'>할부원금</td>
                    <td width='15%' class='title'>이자</td>
                    <td width='15%' class='title'>할부금</td>
                    <td width='15%' class='title'>할부금잔액</td>
                    <td width='10%' class='title'>결재여부 </td>
                    <td class='title'>결재일</td>
                </tr>
            </table>
        </td>
        <td width='16'>&nbsp;</td>
    </tr>
    <tr> 
        <td colspan='3'> <iframe src="bank_mapping_scd_i_in.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>&car_id=<%=car_id%>&auth_rw=<%=auth_rw%>&s_kd=<%=s_kd%>&t_wd=<%=t_wd%>&s_rtn=<%=s_rtn%>&gubun=<%=gubun%>&lend_id=<%=lend_id%>&cont_bn=<%=cont_bn%>&lend_int=<%=lend_int%>&max_cltr_rat=<%=max_cltr_rat%>&rtn_st=<%=rtn_st%>&lend_amt_lim=<%=lend_amt_lim%>&rtn_size=<%=rtn_size%>" name="i_in" width="800" height="400" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 > 
        </iframe> </td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='5%' class='title'>합계 </td>
                    <td width='12%'>&nbsp;</td>
                    <td width='15%' align='right'>
                      <input type='text' name='t_tot_alt_prn' size='10' value='' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td width='15%' align='right'>
                      <input type='text' name='t_tot_alt_int' size='10' value='' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td width='15%' align='right'>
                      <input type='text' name='t_tot_alt_amt' size='10' value='<%=Util.parseDecimal(alt_amt*tot_amt_tm)%>' class='whitenum' readonly>
                      원&nbsp;</td>
                    <td colspan='3'></td>
                </tr>
            </table>
        </td>
        <td width='16'></td>
    </tr>
    <%	}else{%>
    <tr> </tr>
    <tr> 
        <td colspan="2"><br>
        &nbsp;&nbsp;&nbsp;* 할부횟수가 세팅되지 않았습니다. <br>
        <br>
        &nbsp;&nbsp;&nbsp;* 은행별 대출리스트에서 할부금내역을 입력한 후 스케줄을 작성하십시오</td>
        <td width='20'>&nbsp;</td>
    </tr>
    <%	}%>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
