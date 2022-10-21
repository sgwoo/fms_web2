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
//		if(parseDigit(fm.fst_pay_amt.value).length > 9){ alert('1ȸ�� ��ȯ�ݾ��� Ȯ���Ͻʽÿ�'); return; }		
		if(i_fm.alt_amt[0] != null){
			i_fm.alt_amt[0].value = fm.fst_pay_amt.value;
			i_in.cal_rest();
		}
	}
	
	function save(){
		var fm = document.form1;
/*		if(!isDate(fm.fst_pay_dt.value)){ alert('ȸ����ȯ���� Ȯ���Ͻʽÿ�'); return; }
		else if((!isCurrency(fm.fst_pay_amt.value)) || (parseDigit(fm.fst_pay_amt.value).length > 9)){
			alert('1ȸ�� ��ȯ�ݾ��� Ȯ���Ͻʽÿ�'); return;	
		}
*/		
//		if(i_in.getDefMon() > 1){ alert('0ȸ�� �����ϰ� 1ȸ�� �������� Ȯ���Ͻʽÿ�.'); return; }		
		if(confirm('�����Ͻðڽ��ϱ�?')){
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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); //����
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	
	//�α���ID&������ID
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
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;�繫ȸ�� > �����ڱݰ��� > ���������� > <span class=style1><span class=style5>�Һα� ��ȯ ������</span></span></td>
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
    		 		<td width=8% class='title'>�������</td>
    		 		<td width=12%>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
    		 		<td width=8% class='title'><%if(bl.getDeposit_no().equals("")){%>�����ȣ<%}else{%>���¹�ȣ<%}%></td>
    		 		<td width=12%>&nbsp;<%=bl.getLend_no()%><%=bl.getDeposit_no()%></td>
    		 		<td width=10% class='title'>�����</td>
    				<td width=12%>&nbsp;<%=bl.getCont_dt()%></td>
    				<td width=8% class='title'>�Һ�Ƚ��</td>
    		 		<td width=11%>&nbsp;<%=bl.getCont_term()%>ȸ </td>
    		 		<td width=8% class='title'>������</td>
    		 		<td width=11%>&nbsp;<%if(bl.getRtn_way().equals("1")){%>�ڵ���ü
    		 			<%}else if(bl.getRtn_way().equals("2")){%>����
    		 			<%}else if(bl.getRtn_way().equals("3")){%>��Ÿ <%}%></td>
		 	    </tr>
		 	    <tr>
    		 		<td class='title'>����ݾ�</td>
    		 		<td>&nbsp;<%if(bl.getRtn_cont_amt() != 0){ out.println(Util.parseDecimal(bl.getRtn_cont_amt())); }else{ out.println(AddUtil.parseDecimalLong(bl.getCont_amt()));}%>��</td>
    				<td class='title'>����</td>
    		 		<td>&nbsp;<%=bl.getLend_int()%>%</td>
    		 		<td class='title'>����ȯ�ݾ�</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getAlt_amt())%>��</td>
    				<td class='title'>�Һμ�����</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getCharge_amt())%>��</td>
    				<td class='title'>��������</title>
    				<td>&nbsp;<%=bl.getRtn_est_dt()%>��</td>	
			    </tr>
			    <tr>
    				<td class='title'>������</title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getNtrl_fee())%>��</td>
    				<td class='title'>������</title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getStp_fee())%>��</td>
    				<td class='title'>�ߵ�����<br>������</td>
    				<td>&nbsp;<%=bl.getCls_rtn_fee_int()%>%</td>
    				<td class='title'>�ߵ�����<br>Ư�̻���</td>
    				<td colspan='3'>&nbsp;<%=bl.getCls_rtn_etc()%></td>
			    </tr>
			    <tr>
    				<%	if(cont_term>=1){%>
    				<td class='title'>1ȸ��������</td>
    				<td colspan='3'>&nbsp;<input type='text' size='11' name='fst_pay_dt' value='<%=bl.getFst_pay_dt()%>' class='text' maxlength='10' value='' onBlur='javascript:set_est_dt()'></td>
    				<td class='title'>1ȸ����ȯ�ݾ�</td>
    				<td colspan='5'>&nbsp;<input type='text' name='fst_pay_amt' value='<%=Util.parseDecimal(bl.getFst_pay_amt())%>' size='11' maxlength='11' class='num' onBlur='javascript:set_fst_amt()'>��&nbsp;</td>
    				<%	}else{%>
    				<td class='title'>1ȸ��������</td>
    				<td colspan='3'>&nbsp;<input type='text' size='11' name='fst_pay_dt' value='<%=bl.getFst_pay_dt()%>' class='whitenum' maxlength='10' value='' readonly></td>
    				<td class='title'>1ȸ����ȯ�ݾ�</td>
    				<td colspan='5'>&nbsp;<input type='text' name='fst_pay_amt' value='<%=Util.parseDecimal(bl.getFst_pay_amt())%>' size='11' maxlength='11' class='whitenum' readonly>��&nbsp;</td>
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
			�� ���� �Է��ϰ� ������ ������ ���ô���� �޽��� �߼� <textarea rows='2' cols='90' name='update_msg'></textarea>
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
		<td><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һαݽ�����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>	
		<td class='line'>
			<table border='0' cellspacing='1' cellpadding='0' width='100%'>
				<tr>
					<td width=6% class='title'>ȸ��</td>
					<td width=12% class='title'>������</td>
					<td width=14% class='title'>�Һο���</td>
					<td width=14% class='title'>����</td>
					<td width=14% class='title'>�Һα�</td>
					<td width=18% class='title'>�Һα��ܾ�</td>
					<td width=10% class='title'>���翩��	</td>
					<td width=12% class='title'>������</td>							
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
					<td width=6% class='title'>�հ� </td>
					<td width=12%>&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_prn' size='12' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_int' size='12' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=14% align='right'><input type='text' name='tot_alt_amt' size='12' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=40% colspan='3'></td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
	<tr>
	    <td class=h></td>
	</tr>
	<%if(nm_db.getWorkAuthUser("ȸ�����",ck_acar_id) || nm_db.getWorkAuthUser("������",ck_acar_id)){%>
    <tr> 
      <td colspan="2"><input type='text' name='cng_tm' size='2' value='' class='text' onBlur='javscript:document.form1.set_dt.value = i_in.document.form1.alt_est_dt[this.value].value;'>ȸ ���� ��������
	    <input type='text' size='12' name='set_dt' value='' class='text' value='' onBlur='javscript:this.value = ChangeDate(this.value);'>
	  ���� <a href="javascript:cng_est_dt()"><img src=../images/center/button_st.gif align=absmiddle border=0></a></td>
    </tr>	
	<%}%>			
	
	<%if(nm_db.getWorkAuthUser("������",ck_acar_id) || nm_db.getWorkAuthUser("�Һαݽ����ٰ���",ck_acar_id) ){%>
	 <tr> 
	 <td colspan="2"><input type='text' name='from_tm' size='2'  class='text' >ȸ���� <input type='text' name='add_tm' size='2'  class='text' >ȸ �߰�  
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
