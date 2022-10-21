<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.bank_mng.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//����Ʈ ����
	function go_to_list(){
		var fm = document.form1;
		var auth_rw = fm.auth_rw.value;
		var br_id 	= fm.br_id.value;
		var user_id	= fm.user_id.value;
		var gubun1 	= fm.gubun1.value;
		var gubun2 	= fm.gubun2.value;
		var gubun3 	= fm.gubun3.value;
		var gubun4 	= fm.gubun4.value;		
		var st_dt 	= fm.st_dt.value;
		var end_dt 	= fm.end_dt.value;
		var s_kd 	= fm.s_kd.value;
		var t_wd 	= fm.t_wd.value;
		var sort_gubun = fm.sort_gubun.value;
		var asc 	= fm.asc.value;
		if(fm.f_list.value == 'pay'){
			location = "/acar/con_debt/debt_frame_s.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}else{
//			location = "/acar/forfeit_mng/forfeit_s_frame.jsp?auth_rw="+auth_rw+"&br_id="+br_id+"&user_id="+user_id+"&gubun1="+gubun1+"&gubun2="+gubun2+"&gubun3="+gubun3+"&gubun4="+gubun4+"&st_dt="+st_dt+"&end_dt="+end_dt+"&s_kd="+s_kd+"&t_wd="+t_wd+"&sort_gubun="+sort_gubun+"&asc="+asc;
		}
	}		
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<%
	String auth = request.getParameter("auth")==null?"":request.getParameter("auth");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"1":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"6":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"3":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":AddUtil.ChangeString(request.getParameter("st_dt"));
	String end_dt = request.getParameter("end_dt")==null?"":AddUtil.ChangeString(request.getParameter("end_dt"));
	String s_kd = request.getParameter("s_kd")==null?"0":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"0":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"0":request.getParameter("asc");
	
	String f_list = request.getParameter("f_list")==null?"pay":request.getParameter("f_list");
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String rtn_seq = request.getParameter("rtn_seq")==null?"":request.getParameter("rtn_seq");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	BankLendBean bl = abl_db.getBankLendScd(lend_id, rtn_seq);
	int cont_term = bl.getCont_term().equals("")?0:Integer.parseInt(bl.getCont_term());
	
	//height
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int cnt = 7; //��Ȳ ��� ������ �Ѽ�
	int height = AddUtil.parseInt(s_height)-emp_top_height-sh_height-(cnt*sc_line_height)-50;//��Ȳ ���μ���ŭ ���� ���������� ������
	
	if(mode.equals("view")){
		height = 450;
	}
%>
<body>
<form name='form1' method="post">
<input type='hidden' name='cont_term' value='<%=cont_term%>'>
<input type='hidden' name='m_id' value='<%=m_id%>'>
<input type='hidden' name='l_cd' value='<%=l_cd%>'>
<input type='hidden' name='car_id' value='<%=c_id%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='rtn_seq' value='<%=rtn_seq%>'>

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
<input type='hidden' name='f_list' value='<%=f_list%>'>
<input type='hidden' name='sh_height' value='<%=sh_height%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr> 
        <td colspan=2>
            <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���������� > �Һαݰ��� > <span class=style5>�Һα� ��ȯ ������(�������)</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>            
        </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<%if(!mode.equals("view")){%>
	<tr>
		<td align='right' colspan=2>
			<a href='javascript:go_to_list()'><img src=../images/center/button_list.gif align=absmiddle border=0></a>
		</td>
	</tr>
	<%}%>
	<tr> 
        <td class=line2 colspan=2></td>
    </tr>
	<tr>
	    <td class='line' colspan=2>
		    <table border="0" cellspacing="1" cellpadding="1" width=100%>
		 	    <tr>
    		 		<td width=8% class='title'>�������</td>
    		 		<td width=12%>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
    		 		<td width=8% class='title'>�����ȣ</td>
    		 		<td width=12%>&nbsp;<%=bl.getLend_no()%></td>
    		 		<td width=8% class='title'> �����	</td>
    				<td width=12%>&nbsp;<%=bl.getCont_dt()%></td>
    				<td width=8% class='title'> �Һ�Ƚ�� </td>
    		 		<td width=12%>&nbsp;<%=bl.getCont_term()%>ȸ </td>
    		 		<td width=8% class='title'> ������ </td>
    		 		<td width=12%>&nbsp;<%if(bl.getRtn_way().equals("1")){%>�ڵ���ü
    		 			<%}else if(bl.getRtn_way().equals("2")){%>����
    		 			<%}else if(bl.getRtn_way().equals("3")){%>��Ÿ <%}%></td>
		 	    </tr>
		 	    <tr>
    		 		<td class='title'> ����ݾ� </td>
    		 		<td>&nbsp;<%if(bl.getRtn_cont_amt() == 0){%><%=AddUtil.parseDecimalLong(bl.getCont_amt())%><%}else{%><%=AddUtil.parseDecimalLong(bl.getRtn_cont_amt())%><%}%>��</td>
    				<td class='title'> ���� </td>
    		 		<td>&nbsp;<%=bl.getLend_int()%> </td>
    		 		<td class='title'> ����ȯ�ݾ� </td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getAlt_amt())%>��</td>
    				<td class='title'> �Һμ����� </td>
    		 		<td>&nbsp;<%=Util.parseDecimal(bl.getCharge_amt())%>��</td>
    				<td class='title'>	�������� </title>
    				<td>&nbsp;<%=bl.getRtn_est_dt()%>��</td>	
			    </tr>
			    <tr>
    				<td class='title'>	������ </title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getNtrl_fee())%>��</td>
    				<td class='title'>	������ </title>
    				<td>&nbsp;<%=Util.parseDecimal(bl.getStp_fee())%>��</td>
    				<td class='title'>1ȸ��������</td>
    				<td>&nbsp;<%=bl.getFst_pay_dt()%></td>
    				<td colspan='2' class='title'>1ȸ����ȯ�ݾ� </td>
    				<td colspan='2'>&nbsp;<%=Util.parseDecimal(bl.getFst_pay_amt())%>��&nbsp;</td>
			    </tr>
		    </table>
	    </td>
    </tr>
    <tr>
        <td></td>
    </tr>
	<tr>
		<td colspan=2><img src=../images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һα� ������</span></td>
	</tr>
	<tr> 
        <td class=line2></td>
    </tr>
	<tr>	
		<td class='line'>
			<table border='0' cellspacing='1' cellpadding='0' width='100%'>
				<tr>
					<td width=5% class='title'>&nbsp;&nbsp;ȸ��&nbsp;&nbsp;</td>
					<td width=10% class='title'>&nbsp;&nbsp;������&nbsp;&nbsp;</td>
					<td width=15% class='title'>�Һο���</td>
					<td width=15% class='title'>����</td>
					<td width=15% class='title'>�Һα�</td>
					<td width=18% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;�Һα��ܾ�&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td width=10% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;���翩��&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td width=12% class='title'>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;������&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>							
				</tr>
			</table>
		</td>
		<td width='16'></td>
	</tr>
	<tr>
		<td colspan='2'>
			<iframe src="/acar/bank_mng/bank_scd_c_in2.jsp?lend_id=<%=lend_id%>&rtn_seq=<%=rtn_seq%>" name="i_in" width="100%" height="<%=height%>" cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling=yes, marginwidth=0, marginheight=0 >
			</iframe>							
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
					<td width=5% class='title'>�հ� </td>
					<td width=10%'>&nbsp;</td>
					<td width=15% align='right'><input type='text' name='tot_alt_prn' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=15% align='right'><input type='text' name='tot_alt_int' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=15% align='right'><input type='text' name='tot_alt_amt' size='10' value='' class='whitenum' readonly>��&nbsp;</td>
					<td width=40%></td>
				</tr>
			</table>
		</td>
		<td width=16>&nbsp;</td>
	</tr>					
</table>
</form>
</iframe>
</body>
</html>
