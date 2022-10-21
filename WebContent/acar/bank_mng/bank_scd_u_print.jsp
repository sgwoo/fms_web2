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
	String rtn_seq = request.getParameter("rtn_seq")==null?"1":request.getParameter("rtn_seq");
	
	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	int cont_term = bl.getCont_term().equals("")?0:Integer.parseInt(bl.getCont_term());
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	Vector scds = abl_db.getBankScds(lend_id, rtn_seq);
	int scd_size = scds.size();
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
%>
<body>

<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr> 
        <td>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1><span class=style5>�Һα� ��ȯ ������</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
    				<td colspan='3'>&nbsp;<%=bl.getFst_pay_dt()%></td>
    				<td class='title'>1ȸ����ȯ�ݾ�</td>
    				<td colspan='5'>&nbsp;<%=Util.parseDecimal(bl.getFst_pay_amt())%>��&nbsp;</td>
    				<%	}else{%>
    				<td class='title'>1ȸ��������</td>
    				<td colspan='3'>&nbsp;<%=bl.getFst_pay_dt()%></td>
    				<td class='title'>1ȸ����ȯ�ݾ�</td>
    				<td colspan='5'>&nbsp;<%=Util.parseDecimal(bl.getFst_pay_amt())%>��&nbsp;</td>
    				<%	}%>				
			    </tr>				
		    </table>
	    </td>
	</tr>
</table>
<table border="0" cellspacing="0" cellpadding="0" width=750>
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
				<%	for(int i = 0 ; i < scd_size ; i++){
						BankScdBean scd = (BankScdBean)scds.elementAt(i);
						total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(scd.getAlt_prn_amt()));
						total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(scd.getAlt_int_amt()));
						total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(scd.getAlt_prn_amt()+scd.getAlt_int_amt()));
						%>
				<tr>
					<td width=6% align='center'><%=scd.getAlt_tm()%></td>
					<td width=12% align='center'><%=scd.getAlt_est_dt()%></td>
					<td width=14% align='right'><%=Util.parseDecimal(scd.getAlt_prn_amt())%></td>
					<td width=14% align='right'><%=Util.parseDecimal(scd.getAlt_int_amt())%></td>
					<td width=14% align='right'><%=Util.parseDecimal(scd.getAlt_prn_amt()+scd.getAlt_int_amt())%></td>
					<td width=18% align='right'><%=Util.parseDecimalLong(scd.getAlt_rest())%></td>
					<td width=10% align='center'><%if(scd.getPay_yn().equals("0")){%>N<%}else{%>Y<%}%>&nbsp;<%if(!scd.getCls_rtn_dt().equals("")){%>(�ߵ���ȯ)<%}%></td>
					<td width=12% align='center'><%=scd.getPay_dt()%></td>
				</tr>
				<%	}%>
				<tr>
					<td colspan='2' class='title'>�հ� </td>					
					<td width=14% align='right'><%=Util.parseDecimal(total_amt1)%></td>
					<td width=14% align='right'><%=Util.parseDecimal(total_amt2)%></td>
					<td width=14% align='right'><%=Util.parseDecimal(total_amt3)%></td>
					<td colspan='3'></td>
				</tr>
				
			</table>
		</td>
	</tr>
</table>
</body>
</html>
