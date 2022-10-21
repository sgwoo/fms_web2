<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.bank_mng.*, acar.common.*, acar.user_mng.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

	function set_est_dt(){
		var fm = document.form1;
		fm.fst_pay_dt.value=ChangeDate(fm.fst_pay_dt.value);
		if((fm.fst_pay_dt.value != '') && isDate(fm.fst_pay_dt.value) &&(fm.cont_term.value != '')){
			fm.action='/acar/bank_mng/est_dt_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}
	
	function cng_est_dt(){
		var fm = document.form1;
		if(fm.cng_tm.value != '' && fm.set_dt.value != '' && fm.cont_term.value != ''){
			fm.action='/acar/bank_mng/est_dt_bank_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}	

	function set_fst_amt(){
		var fm = document.form1;
		var i_fm = i_in.form1;		
		fm.fst_pay_amt.value=parseDecimal(fm.fst_pay_amt.value);
//		if(parseDigit(fm.fst_pay_amt.value).length > 9){ alert('1회차 상환금액을 확인하십시오'); return; }		
		if(i_fm.alt_amt[0] != null){
			i_fm.alt_amt[0].value = fm.fst_pay_amt.value;
			i_in.cal_rest();
		}
	}
	
	function save(){
		var fm = document.form1;
/*		if(!isDate(fm.fst_pay_dt.value)){ alert('회차상환일을 확인하십시오'); return; }
		else if((!isCurrency(fm.fst_pay_amt.value)) || (parseDigit(fm.fst_pay_amt.value).length > 9)){
			alert('1회차 상환금액을 확인하십시오'); return;	
		}
*/		
//		if(i_in.getDefMon() > 1){ alert('0회차 약정일과 1회차 약정일을 확인하십시오.'); return; }		
		if(confirm('수정하시겠습니까?')){
			i_in.in_save();
		}
	}
	
	function go_to_list(){
		location='bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
	}
	
	function bank_print(){
		var fm = document.form1;		
		fm.action='bank_scd_u_print.jsp';
		fm.target='_blank';
		fm.submit();		
	}	
	
	function set_add_tm(){
		var fm = document.form1;

		if( fm.from_tm.value != '' && fm.add_tm.value != '' ){
	
			fm.action='bank_scd_add_a.jsp';
			
			fm.target='i_no';
			fm.submit();
		}else{}
	}				
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //권한
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	//로그인ID&영업소ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "01");
	
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq_r")==null?"1":request.getParameter("rtn_seq_r");
	
	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	int cont_term = bl.getCont_term().equals("")?0:Integer.parseInt(bl.getCont_term());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();
	
	Vector scds = abl_db.getBankScds(lend_id, rtn_seq);
	int scd_size = scds.size();
%>
<body>
<form name='form1' method="POST">
<input type='hidden' name='cont_term' value='<%=cont_term%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='rtn_est_dt' value='<%=bl.getRtn_est_dt()%>'>

<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;재무회계 > 구매자금관리 > 은행대출관리 > <span class=style1><span class=style5>할부금 상환 스케줄</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr> 
        <td class=h></td>
    </tr>
<%	//if(cont_term>=1){%>
	<tr>
		<td align='right'>
			<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			<a href="javascript:bank_print()"><img src=../images/center/button_print.gif align=absmiddle border=0></a>&nbsp;&nbsp;
			<%}%>
			&nbsp;&nbsp;<a href="javascript:go_to_list()"><img src=../images/center/button_list.gif align=absmiddle border=0></a>
			&nbsp;&nbsp;<a href="javascript:history.go(-1);"><img src=../images/center/button_back_p.gif align=absmiddle border=0></a>
		</td>
	</tr>
<%//	}%>
    <tr>
        <td class=line2></td>
    </tr>
	<tr>
	    <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		 	    <tr>
    		 		<td width=8% class='title'>금융사명</td>
    		 		<td width=12%>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
    		 		<td width=8% class='title'><%if(bl.getDeposit_no().equals("")){%>대출번호<%}else{%>계좌번호<%}%></td>
    		 		<td width=12%>&nbsp;<%=bl.getLend_no()%><%=bl.getDeposit_no()%></td>
    		 		<td width=10% class='title'>계약일</td>
    				<td width=12%>&nbsp;<%=bl.getCont_dt()%></td>
    				<td width=8% class='title'>할부횟수</td>
    		 		<td width=11%>&nbsp;<%=bl.getCont_term()%>회 </td>
    		 		<td width=8% class='title'>결재방법</td>
    		 		<td width=11%>&nbsp;<%if(bl.getRtn_way().equals("1")){%>자동이체
    		 			<%}else if(bl.getRtn_way().equals("2")){%>지로
    		 			<%}else if(bl.getRtn_way().equals("3")){%>기타 <%}%></td>
		 	    </tr>
		 	    <tr>
    		 		<td class='title'>대출금액</td>
    		 		<td>&nbsp;<%if(bl.getRtn_cont_amt() != 0){ out.println(Util.parseDecimal(bl.getRtn_cont_amt())); }else{ out.println(AddUtil.parseDecimalLong(bl.getCont_amt()));}%>원</td>
    				<td class='title'>이율</td>
    		 		<td>&nbsp;<%=bl.getLend_int()%>%</td>
    		 		<td class='title'>월상환금액</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getAlt_amt())%>원</td>
    				<td class='title'>할부수수료</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getCharge_amt())%>원</td>
    				<td class='title'>약정일자</title>
    				<td>&nbsp;<%=bl.getRtn_est_dt()%>일</td>	
			    </tr>
			    <tr>
    				<td class='title'>공증료</title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getNtrl_fee())%>원</td>
    				<td class='title'>인지대</title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getStp_fee())%>원</td>
    				<td class='title'>중도해지<br>수수료</td>
    				<td>&nbsp;<%=bl.getCls_rtn_fee_int()%>%</td>
    				<td class='title'>중도해지<br>특이사항</td>
    				<td colspan='3'>&nbsp;<%=bl.getCls_rtn_etc()%></td>
			    </tr>
			    <tr>
    				<%	if(cont_term>=1){%>
    				<td class='title'>1회차결재일</td>
    				<td colspan='3'>&nbsp;<input type='text' size='11' name='fst_pay_dt' value='<%=bl.getFst_pay_dt()%>' class='text' maxlength='10' value='' onBlur='javascript:set_est_dt()'></td>
    				<td class='title'>1회차상환금액</td>
    				<td colspan='5'>&nbsp;<input type='text' name='fst_pay_amt' value='<%=Util.parseDecimal(bl.getFst_pay_amt())%>' size='11' maxlength='11' class='num' onBlur='javascript:set_fst_amt()'>원&nbsp;</td>
    				<%	}else{%>
    				<td class='title'>1회차결재일</td>
    				<td colspan='3'>&nbsp;<input type='text' size='11' name='fst_pay_dt' value='<%=bl.getFst_pay_dt()%>' class='whitenum' maxlength='10' value='' readonly></td>
    				<td class='title'>1회차상환금액</td>
    				<td colspan='5'>&nbsp;<input type='text' name='fst_pay_amt' value='<%=Util.parseDecimal(bl.getFst_pay_amt())%>' size='11' maxlength='11' class='whitenum' readonly>원&nbsp;</td>
    				<%	}%>				
			    </tr>				
		    </table>
	    </td>
	</tr>
    <tr> 
        <td class=h></td>
    </tr>	
	<tr>
		<td align='right'>
			<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			※ 사유 입력하고 스케줄 수정시 관련담당자 메시지 발송 <textarea rows='2' cols='90' name='update_msg'></textarea>
		  &nbsp;&nbsp;<a href="javascript:save()"><img src=../images/center/button_modify.gif align=absmiddle border=0></a>
			<%}%>
		</td>
	</tr>	
</table>
<br>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td></td>
    </tr>
	<tr>
		<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>할부금스케줄</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>	
		<td class='line'>
			<table border='0' cellspacing='1' cellpadding='0' width='100%'>
				<tr>
					<td width=6% class='title'>회차</td>
					<td width=12% class='title'>약정일</td>
					<td width=14% class='title'>할부원금</td>
					<td width=14% class='title'>이자</td>
					<td width=14% class='title'>할부금</td>
					<td width=18% class='title'>할부금잔액</td>
					<td width=10% class='title'>결재여부	</td>
					<td width=12% class='title'>결재일</td>							
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/bank_mng/bank_scd_u_in.jsp?auth_rw=<%=auth_rw%>&lend_id=<%=lend_id%>&rtn_seq=<%=rtn_seq%>&cont_term=<%=cont_term%>" name="i_in" width="100%" height="<%=scd_size*22%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>							
		</td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=6% class='title'>합계 </td>
					<td width=12%>&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_prn' size='12' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_int' size='12' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_amt' size='12' value='' class='whitenum' readonly>원&nbsp;</td>
					<td width=40% colspan='3'></td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<%if(nm_db.getWorkAuthUser("회계업무",ck_acar_id) || nm_db.getWorkAuthUser("계출담당",ck_acar_id)){%>
    <tr> 
      <td colspan="2"><input type='text' name='cng_tm' size='2' value='' class='text' onBlur='javscript:document.form1.set_dt.value = i_in.document.form1.alt_est_dt[this.value].value;'>회 부터 약정일을
	    <input type='text' size='12' name='set_dt' value='' class='text' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
	  부터 <a href="javascript:cng_est_dt()"><img src=../images/center/button_st.gif align=absmiddle border=0></a></td>
    </tr>	
	<%}%>			
	
	<%if(nm_db.getWorkAuthUser("전산팀",ck_acar_id) || nm_db.getWorkAuthUser("할부금스케줄관리",ck_acar_id) ){%>
	 <tr> 
	 <td colspan="2"><input type='text' name='from_tm' size='2'  class='text' >회부터 <input type='text' name='add_tm' size='2'  class='text' >회 추가  
	<a href="javascript:set_add_tm()"><img src=../images/center/button_reg.gif align=absmiddle border=0></a> 	
	 </td>
	 </tr>
	<%}%>		
		
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
