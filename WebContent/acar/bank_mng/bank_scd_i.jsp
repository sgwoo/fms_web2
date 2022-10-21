<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*, acar.common.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//������ ����
	function set_est_dt(){
		var fm = document.form1;
		fm.fst_pay_dt.value=ChangeDate(fm.fst_pay_dt.value); //��¥��ȯ
		if((fm.fst_pay_dt.value != '') && isDate(fm.fst_pay_dt.value) &&(fm.cont_term.value != '')){
			fm.action='est_dt_nodisplay.jsp';
			fm.target='i_no';
			fm.submit();
		}else{}
	}

	//����,�Һα� ����
	function set_fst_amt(){
		var fm = document.form1;
		var i_fm = i_in.form1;//�����÷��Ӹ�			
		fm.fst_pay_amt.value=parseDecimal(fm.fst_pay_amt.value);//�ݾ׺�ȯ
//		if(parseDigit(fm.fst_pay_amt.value).length == 0){ alert('1ȸ�� ��ȯ�ݾ��� Ȯ���Ͻʽÿ�'); return; }		
		if(i_fm.alt_amt[0] != null){
			i_fm.alt_amt[0].value = fm.fst_pay_amt.value;
			i_fm.rtn_cont_amt.value = fm.rtn_cont_amt.value;			
			i_in.cal_rest();
		}
	}
	
	function save(){
		var fm = document.form1;
		var i_fm = i_in.form1;//�����÷��Ӹ�					
		if(!isDate(fm.fst_pay_dt.value)){ alert('ȸ����ȯ���� Ȯ���Ͻʽÿ�'); return; }
//		if((!isCurrency(fm.fst_pay_amt.value)) || (parseDigit(fm.fst_pay_amt.value).length == 0)){
//			alert('1ȸ�� ��ȯ�ݾ��� Ȯ���Ͻʽÿ�'); return;	
//		}
		if(i_in.getDefMon() > 1){ alert('0ȸ�� �����ϰ� 1ȸ�� �������� Ȯ���Ͻʽÿ�.'); return; }		
		if(confirm('����Ͻðڽ��ϱ�?')){
			i_fm.lend_dt.value = fm.lend_dt.value;		
			i_in.in_save();
		}
	}

	function go_to_list(){
		location='bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
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
//out.println(request.getParameter("cont_term"));if(1==1)return;
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String rtn_seq = request.getParameter("rtn_seq_r")==null?"1":request.getParameter("rtn_seq_r");
	int cont_term = request.getParameter("cont_term")==null?0:AddUtil.parseInt(request.getParameter("cont_term"));
	
	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	CommonDataBase c_db = CommonDataBase.getInstance();
	
%>
<body>
<form name='form1' method="POST">
<input type='hidden' name='cont_term' value='<%=cont_term%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='lend_dt' value='<%=bl.getCont_dt()%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > �����ڱݰ��� > ���������� > <span class=style5>�Һα� ��ȯ ������</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr><td class=h></td></tr>
    <tr> 
        <td align="right">
	    <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
		<a href="javascript:save()" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a>
		<%}%>
	    &nbsp;&nbsp;<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_list.gif" align="absmiddle" border="0"></a>
	  	&nbsp;&nbsp;<a href="javascript:history.go(-1);"><img src="/acar/images/center/button_back_p.gif" align="absmiddle" border="0"></a>
	    </td>
    </tr>
    <tr>
        <td class=line2 colspan=2></td>
    </tr>
    <tr> 
        <td class='line' colspan="2"> 
            <table border="0" cellspacing="1" cellpadding="0" width=100%>
                <tr> 
                    <td width='8%' class='title'>�������</td>
                    <td width='12%'>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
                    <td width='8%' class='title'>�����</td>
                    <td width='12%'>&nbsp;<%=bl.getCont_dt()%></td>
                    <td class='title' width="8%">�����ѱݾ�</td>
                    <td align="right" width="12%"><%=AddUtil.parseDecimalLong(bl.getCont_amt())%>��&nbsp;</td>
                    <td class='title' width="9%">����</td>
                    <td width="11%">&nbsp;<%=bl.getLend_int()%>%</td>
                    <td width='9%' class='title'>������</td>
                    <td width="11%">&nbsp;<%if(bl.getRtn_way().equals("1")){%>�ڵ���ü<%}else if(bl.getRtn_way().equals("2")){%>����<%}else if(bl.getRtn_way().equals("3")){%>��Ÿ<%}%>
                    </td>
                </tr>
                <tr>
                    <td class='title'>����ݾ�</td>
                    <td align="right">&nbsp;<input type='text' name='rtn_cont_amt' value='<%if(bl.getRtn_cont_amt() != 0){ out.println(AddUtil.parseDecimalLong(bl.getRtn_cont_amt())); }else{ out.println(Util.parseDecimal(bl.getCont_amt()));}%>' size='11' maxlength='11' class='num' <%if(cont_term>=1){%>class='num' onBlur='javascript:set_fst_amt()'<%}else{%>class='whitenum' readonly<%}%>>&nbsp;</td>
                    <td class='title'>��ȯ�ѱݾ�</td>
                    <td align="right"><%=Util.parseDecimal(bl.getRtn_tot_amt())%>��&nbsp;</td>
                    <td class='title'>�Һ�Ƚ��</td>
                    <td>&nbsp;<%=bl.getCont_term()%>ȸ </td>
                    <td class='title'>����ȯ�ݾ�</td>
                    <td align="right"><%=Util.parseDecimal(bl.getAlt_amt())%>��&nbsp;</td>
                    <td class='title'>��������</td> 
                    <td>&nbsp;<%=bl.getRtn_est_dt()%>��<input type='hidden' name='rtn_est_dt' value='<%=bl.getRtn_est_dt()%>'></td>
                </tr>
                <tr> 
                    <td class='title'>�Һμ�����</td>
                    <td align="right"><%=Util.parseDecimal(bl.getCharge_amt())%>��&nbsp;</td>
                    <td class='title'>������</td>
                    <td align="right"><%=Util.parseDecimal(bl.getNtrl_fee())%>��&nbsp;</td>
                    <td class='title'>������</td> 
                    <td align="right"><%=Util.parseDecimal(bl.getStp_fee())%>��&nbsp;</td>
                    <td class='title'>1ȸ�� ������</td>
                    <td>&nbsp;<input type='text' size='11' name='fst_pay_dt' value='<%=bl.getFst_pay_dt()%>' maxlength='10' <%if(cont_term>=1){%>class='text' onBlur='javascript:set_est_dt()'<%}else{%>class='whitenum' readonly<%}%>></td>
                    <td class='title'>1ȸ�� ��ȯ�ݾ�</td>
                    <td>&nbsp;<input type='text' name='fst_pay_amt' value='<%=Util.parseDecimal(bl.getAlt_amt())%>' size='9' maxlength='11' <%if(cont_term>=1){%>class='num' onBlur='javascript:set_fst_amt()'<%}else{%>class='whitenum' readonly<%}%>></td>
                </tr>
            </table>
        </td>
    </tr>
</table>
<br>
<%//if(!bl.getRtn_move_st().equals("0")){%>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һαݽ�����</span></td>
	</tr>
	<tr>
        <td class=line2></td>
    </tr>
	<tr>	
		<td class='line'>
			<table border='0' cellspacing='1' cellpadding='0' width='100%'>
				<tr>
					<td width='6%' class='title'>ȸ��</td>
					<td width='12%' class='title'>������</td>
					<td width='15%' class='title'>�Һο���</td>
					<td width='15%' class='title'>����</td>
					<td width='15%' class='title'>�Һα�</td>
					<td width='17%' class='title'>�Һα��ܾ�</td>
					<td width='8%' class='title'>���翩��	</td>
					<td width='12%' class='title'>������</td>							
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>
<%	if(cont_term>=1){%>	
	<tr>
		<td colspan='2'>
			<iframe src="bank_scd_i_in.jsp?auth_rw=<%=auth_rw%>&lend_id=<%=lend_id%>&rtn_seq=<%=rtn_seq%>" name="i_in" width="100%" height="350" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>							
		</td>
	</tr>
<%	}%>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width='6%' class='title'>�հ� </td>
					<td width='12%'>&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='tot_alt_prn' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='tot_alt_int' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width='15%' align='right'><input type='text' name='tot_alt_amt' size='11' value='' class='whitenum' readonly>��&nbsp;</td>
					<td colspan='3'></td>
				</tr>
			</table>
		</td>
		<td width='17'></td>
	</tr>					
</table>
<%//}%>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>
