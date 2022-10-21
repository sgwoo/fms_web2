<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="page" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript" src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function go_modify()
	{
		location='/acar/bank_mng/bank_lend_u.jsp?lend_id='+document.form1.lend_id.value;
	}
	
	function reg_cont()
	{
		window.open('/acar/bank_mng/bank_mapping_i.jsp?lend_id='+document.form1.lend_id.value, "MAPPING", "left=100, top=100, width=700, height=400");
	}
	
	function mapping_list()
	{
		window.open('/acar/bank_mng/bank_con_c.jsp?auth_rw='+document.form1.auth_rw.value+'&lend_id='+document.form1.lend_id.value, "MAPPING_LIST", "left=100, top=100, width=700, height=400");
	}
	
	function go_to_list()
	{
		location='/acar/bank_mng/bank_frame_s.jsp?auth_rw='+document.form1.auth_rw.value;
	}	
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	BankLendBean bl = bl_db.getBankLend(lend_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector agnts = bl_db.getBankAgnts(lend_id);
	int agnt_size = agnts.size();
%>
<body leftmargin="15">
<form name="form1" method="POST">
<input type='hidden' name='lend_id' value='<%=bl.getLend_id()%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td ><font color="navy">�繫���� -> ���������� -> </font><font color="red">������ȸ</font></td>
    </tr>
    
    <tr>
    	<td>
			<table border="0" cellspacing="1" width=800>
				<tr>
			    	<td>< �������� ></td>
			    	<td align='right'>
<%	if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6")){%>
			    		<a href='javascript:go_modify();' onMouseOver="window.status=''; return true">����ȭ��</a>
<%	}%>
			    		&nbsp;&nbsp;<a href='javascript:go_to_list();' onMouseOver="window.status=''; return true">����Ʈ��</a>
			    	</td>
			    </tr>
			</table>
		</td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td width='80' class=title>�����</td>
                    <td width='150'>&nbsp;<%=bl.getCont_dt()%></td>
                    <td width='100' class=title>�������</td>
                    <td width='150'>&nbsp;<%=c_db.getNameById(bl.getCont_bn(), "BANK")%></td>
                    <td width='80' class=title>��౸��</td>
                    <td width='180'>&nbsp;<%=bl.getCont_st()%></td>
                </tr>
                <tr>
                    <td class=title>��������</td>
                    <td>&nbsp;<%=bl.getBn_br()%></td>
                    <td class=title>������ȭ��ȣ</td>
                    <td>&nbsp;<%=bl.getBn_tel()%></td>
                    <td class=title>�����ѽ���ȣ</td>
                    <td>&nbsp;<%=bl.getBn_fax()%></td>
                </tr>
                
            </table>
        </td>
    </tr>
	<tr>
    	<td>< ������� ></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td width='80' class=title>�����ȣ</td>
                    <td width='90'>&nbsp;<%=bl.getLend_no()%></td>
                    <td width='70' class=title>����ݾ�</td>
                    <td width='90'>&nbsp;<%=AddUtil.parseDecimalLong(bl.getCont_amt())%>��</td>
                    <td width='70' class=title>��������</td>
                    <td width='80'>&nbsp;<%=bl.getLend_int()%>(%)</td>
                    <td width='70' class=title>��������</td>
                    <td width='90'>&nbsp;<%=Util.parseDecimal(bl.getLend_int_amt())%>��</td>
                    <td width='70' class=title>��ȯ�ѱݾ�</td>
                    <td width='90'>&nbsp;<%=Util.parseDecimal(bl.getRtn_tot_amt())%>��</td>
                </tr>
                <tr>
                    <td class=title>��ȯ������</td>
                    <td>&nbsp;<%=bl.getCont_start_dt()%></td>
                    <td class=title>��ȯ������</td>
                    <td>&nbsp;<%=bl.getCont_end_dt()%></td>
                   	<td class=title>��ȯ�Ⱓ</td>
                    <td colspan='3'>&nbsp;<%=bl.getCont_start_dt()%>~<%=bl.getCont_end_dt()%></td>
                   	<td class=title>��ȯ����</td>
                    <td>&nbsp;<%=bl.getCont_term()%>����</td>
                </tr>
                <tr>
             		<td class=title>��ȯ������</td>
                    <td>&nbsp;<%=bl.getRtn_est_dt()%>��</td>
                    <td class=title>����ȯ�ݾ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(bl.getAlt_amt())%>��</td>
                    <td class='title'>��ȯ����</td>
					<td>&nbsp;<%if(bl.getRtn_cdt().equals("1")){%>�����ݱյ�
						<%}else if(bl.getRtn_cdt().equals("2")){%>���ݱյ� <%}%>
					</td>
					<td class='title'>��ȯ���</td>
					<td colspan='3'>&nbsp;<%if(bl.getRtn_way().equals("1")){%>�ڵ���ü
										<%}else if(bl.getRtn_way().equals("2")){%>����
										<%}else if(bl.getRtn_way().equals("3")){%>��Ÿ <%}%>
					</td>
                </tr>
                <tr>
                	<td class='title'>������</td>
                	<td>&nbsp;<%=Util.parseDecimal(bl.getCharge_amt())%>��</td>
                	<td class='title'>������</td>
                	<td>&nbsp;<%=Util.parseDecimal(bl.getNtrl_fee())%>��</td>
                	<td class='title'>������</td>
                	<td colspan='5'>&nbsp;<%=Util.parseDecimal(bl.getStp_fee())%>��</td>
                </tr>
                <tr>
                	<td class='title'>ä��Ȯ������</td>
                	<td colspan='9'>&nbsp;<%if(bl.getBond_get_st().equals("1")){%>��༭
										<%} else if(bl.getBond_get_st().equals("2")){%>��༭+�ΰ�����
										<%} else if(bl.getBond_get_st().equals("3")){%>��༭+�ΰ�����+������
										<%} else if(bl.getBond_get_st().equals("4")){%>��༭+�ΰ�����+������+LOAN ���뺸���������
										<%} else if(bl.getBond_get_st().equals("5")){%>��༭+�ΰ�����+������+LOAN ���뺸����������
										<%} else if(bl.getBond_get_st().equals("6")){%>��༭+���뺸����<%}%>
                	</td>
                </tr>                    
            </table>
        </td>
    </tr>
    <tr>
    	<td><�������></td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                
                <tr>
                    <td  width='100' class=title>��������</td>
                    <td width='400'>&nbsp;<%=bl.getF_rat()%>(%)</td>
                    <td width='100' class=title>����</td>
                    <td width='400'>&nbsp;<%=bl.getCondi()%></td>
                    
                </tr>
                <tr>
                    <td class=title>�����û��<br>�غ񼭷�</td>
                    <td colspan=3>&nbsp;<%=Util.htmlBR(bl.getDocs())%></td>
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
    	<td></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=800>
            	<tr>
                    <td width='100' class=title>�����ݾ�</td>
                    <td width='150'>&nbsp;<%=Util.parseDecimal(bl.getPm_amt())%>��</td>
                    <td width='150' class=title>������αݾ�</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bl.getLend_a_amt())%>��</td>
                    <td width='100' class=title>�����ܾ�</td>
                    <td width='200'>&nbsp;<%=Util.parseDecimal(bl.getPm_rest_amt())%>��</td>
                </tr>
            </table>
         </td>
    </tr>
    <tr>
    	<td align="right">
    	<a href="javascript:mapping_list()"  onMouseOver="window.status=''; return true">���ະ�Һ� ����Ʈ</a>
<% if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>    	&nbsp;|&nbsp;<a href="javascript:reg_cont()"  onMouseOver="window.status=''; return true">���⺰���</a></td>
<%	}
%>
    </tr>
</table>
<table border=0 cellspacing=0 cellpadding=0 width=800>
    <tr>
    	<td colspan='2' width='820'><�����������></td>
    </tr>
	<tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td width='150' class=title>�����</td>
                    <td width='150' class=title>����</td>
                    <td width='150' class=title>����ó</td>
                    <td width='350' class=title>������̸���</td>
                </tr>
<%
	if(agnt_size > 0)
	{
		for(int i = 0 ; i < agnt_size ; i++)
		{
			BankAgntBean agnt = (BankAgntBean)agnts.elementAt(i);
%>
                <tr>
                	<td align='center'><%=agnt.getBa_nm()%></td>
                	<td align='center'><%=agnt.getBa_title()%></td>
                	<td align='center'><%=agnt.getBa_tel()%></td>
                	<td align='center'><%=agnt.getBa_email()%></td>
                </tr>
<%		}
	}else{
%>
					<td colspan='4'>��ϵ� ����ڰ� �����ϴ�</td>
<%	}
%>
            </table>
        </td>	
	</tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>