<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.cont.*, acar.debt.*, acar.common.*, acar.util.*, acar.user_mng.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--		
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
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
	String car_id 	= request.getParameter("c_id")==null?"":request.getParameter("c_id");

	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id = login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "05", "02");
	
	ContDebtBean debt = a_db.getContDebt(m_id, l_cd);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int tot_amt_tm = debt.getTot_alt_tm().equals("")?0:Integer.parseInt(debt.getTot_alt_tm());
	
	//�������
	Hashtable cont = ad_db.getAllotByCase(m_id, l_cd);
	
	if(car_id.equals("")) car_id = debt.getCar_mng_id();
	
	Vector debts = d_db.getDebtScd(car_id);
	int debt_size = debts.size();
		
	if(tot_amt_tm == 0) tot_amt_tm = debt_size;
	
	long total_amt1	= 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	
	
	
%>


<table border="0" cellspacing="0" cellpadding="0" width=750>
	<tr> 
        <td colspan=2>
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
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
	    <td class='line' colspan=2>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>
		 	    <tr>
    		 		<td class='title'>����ȣ</td>
    		 		<td>&nbsp;<%=debt.getRent_l_cd()%> </td>
    		 		<td class='title'> ����ݾ� </td>
    		 		<td>&nbsp;<%=Util.parseDecimal(debt.getLend_prn())%>��&nbsp;</td>
    		 		<td class='title'>�����ȣ</td>
    		 		<td>&nbsp;<%=debt.getLend_no()%> </td>
    		 		<td class='title'> �Һα�����	</td>
    				<td colspan='3' align='left'>&nbsp;<%=c_db.getNameById(debt.getCpt_cd(), "BANK")%>&nbsp;&nbsp;(<%=cont.get("CAR_NO")%>)</td>
		 	    </tr>
			    <tr>
    				<td width=9% class='title'>�Һ�Ƚ��</td>
    		 		<td width=12%>&nbsp;<%=debt.getTot_alt_tm()%>ȸ&nbsp;</td>
    				<td width=9% class='title'> ���� </td>
    		 		<td width=12%>&nbsp;<%=debt.getLend_int()%>%&nbsp;</td>
    				<td width=10% class='title'> �Һμ����� </td>
    		 		<td width=12%>&nbsp;<%=Util.parseDecimal(debt.getAlt_fee())%>��&nbsp;</td>
    		 		<td width=11% class='title'>������</title>
    				<td width=9%>&nbsp;<%=Util.parseDecimal(debt.getNtrl_fee())%>��&nbsp;</td>
    				<td width=7% class='title'>������</title>
    				<td width=9%'>&nbsp;<%=Util.parseDecimal(debt.getStp_fee())%>��&nbsp;</td>			
			    </tr>
			    <tr>
    				<td class='title'>�Һα�</td>
    		 		<td>&nbsp;<%=Util.parseDecimal(debt.getAlt_amt())%>��&nbsp;</td>
    		 		<td class='title'>��������</title>
    				<td>&nbsp;<%=debt.getRtn_est_dt()%>��</td>
    				<td class='title'>1ȸ��������</td>
    				<td>&nbsp;<%=debt.getFst_pay_dt()%></td>
    				<td class='title'>1ȸ����ȯ�ݾ� </td>
				<td colspan='3'>&nbsp;<%=Util.parseDecimal(debt.getFst_pay_amt())%>��</td>
			    </tr>
			    <tr>
    				<td class='title'>�ߵ���ȯ<br>������</td>
    		 		<td>&nbsp;<%=debt.getCls_rtn_fee_int()%>%&nbsp;</td>
    				<td class='title'>�ߵ���ȯ<br>Ư�̻���</td>
    				<td colspan='7'>&nbsp;<%=debt.getCls_rtn_etc()%></td>
			    </tr>				
		    </table>
	    </td>
	</tr>
	<tr> 
        <td class=h></td>
    </tr>
	<tr>
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һαݽ�����</span></td>
	</tr>	
    <tr> 
        <td class=line2></td>
    </tr>
	<tr>
		<td class='line'>
		 	<table border="0" cellspacing="1" cellpadding="0" width=100%>
				<tr>
					<td width=7% class='title'>ȸ��</td>
					<td width=12% class='title'>������</td>
					<td width=15% class='title'>�Һο���</td>
					<td width=15% class='title'>����</td>
					<td width=15% class='title'>�Һα�</td>
					<td width=15% class='title'>�Һα� �ܾ�</td>
					<td width=9% class='title'>���翩��</td>
					<td width=12% class='title'>������</td>
				</tr>
				<%for(int i = 0 ; i < debt_size ; i++){
					DebtScdBean a_debt = (DebtScdBean)debts.elementAt(i);
					total_amt1 	= total_amt1 + AddUtil.parseLong(String.valueOf(a_debt.getAlt_prn()));
					total_amt2 	= total_amt2 + AddUtil.parseLong(String.valueOf(a_debt.getAlt_int()));
					total_amt3 	= total_amt3 + AddUtil.parseLong(String.valueOf(a_debt.getAlt_prn()+a_debt.getAlt_int()));
					%>
			       <tr>
					<td align='center'><%=a_debt.getAlt_tm()%></td>
					<td align='center'><%=a_debt.getAlt_est_dt()%></td>
					<td align='right'><%=Util.parseDecimal(a_debt.getAlt_prn())%></td>
					<td align='right'><%=Util.parseDecimal(a_debt.getAlt_int())%></td>
					<td align='right'><%=Util.parseDecimal(a_debt.getAlt_prn()+a_debt.getAlt_int())%></td>
					<td align='right'><%=Util.parseDecimal(a_debt.getAlt_rest())%></td>
					<td align='center'><%if(a_debt.getPay_yn().equals("0")){%>N<%}else{%>Y<%}%></td>
					<td align='center'><%=a_debt.getPay_dt()%></td>
				</tr>					
				<%}%>	
				<tr>
					<td colspan='2' class='title'>�հ� </td>	
					<td align='right'><%=Util.parseDecimal(total_amt1)%></td>
					<td align='right'><%=Util.parseDecimal(total_amt2)%></td>
					<td align='right'><%=Util.parseDecimal(total_amt3)%></td>
					<td colspan='3'></td>
				</tr>				
			</table>
		</td>
	</tr>
</table>
</body>
</html>
