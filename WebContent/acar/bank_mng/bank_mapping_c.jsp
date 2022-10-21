<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
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
		location='/acar/bank_mng/bank_mapping_u.jsp?lend_id='+document.form1.lend_id.value+'&car_mng_id='+document.form1.car_mng_id.value;
	}
	
	function go_list()
	{
		parent.location='/acar/bank_mng/bank_con_c.jsp?auth_rw='+document.form1.auth_rw.value+'&lend_id='+document.form1.lend_id.value;	
	}
//-->
</script>
</head>
<%
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String car_mng_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
	
	BankMappingBean bm = new BankMappingBean();
%>
<body>
<form name="form1" method="POST">
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='car_mng_id' value='<%=car_mng_id%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<table border=0 cellspacing=0 cellpadding=0 width=680>
    <tr>
    	<td ><font color="navy">�繫���� -> ���������� -> </font><font color="red">������ȸ</font></td>
    </tr>
	<tr>
		<td align='right'>
<%
if(auth_rw.equals("3") || auth_rw.equals("4") || auth_rw.equals("6"))	{
%>	
		<a href='javascript:go_modify()';  onMouseOver="window.status=''; return true">����ȭ��</a>&nbsp;
<%	}
%>
		
		<a href='javascript:go_list()'; onMouseOver="window.status=''; return true">����Ʈ��</a>
		</td>
	</tr>
   <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=680>
                
                <tr>
                    <td width='80' class=title>�����û��</td>
                    <td width='90'>&nbsp;<%=bm.getLoan_st_dt()%></td>
                    <td width='70' class=title>���ް���</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bm.getSup_amt())%>��</td>
                    <td width='70' class=title>����ݾ�</td>
                    <td width='100'>&nbsp;<%=Util.parseDecimal(bm.getLoan_amt())%>��</td>
                    <td width='80' class=title>����������</td>
                    <td width='90'>&nbsp;<%=bm.getRef_dt()%></td>
                </tr>
                <tr>
                    <td class=title>����������</td>
                    <td>&nbsp;<%=bm.getSup_dt()%></td>
                    <td class=title>���⸸����</td>
                    <td>&nbsp;<%=bm.getLoan_end_dt()%></td>
                    <td class=title>��������</td>
                    <td>&nbsp;<%=bm.getF_rat()%>(%)</td>
                    <td class=title>�����ڱݾ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(bm.getF_amt())%>��</td>
                </tr>
                <tr>
                    <td class=title>�����ڱⰣ</td>
                    <td>&nbsp;<%=bm.getF_term()%>����</td>
                    <td class=title>�ϼ�</td>
                    <td>&nbsp;<%=bm.getDays()%>��</td>
                    <td class=title>�����Աݾ�</td>
                    <td>&nbsp;<%=Util.parseDecimal(bm.getDif_amt())%>��</td>
                    <td class=title>���������</td>
                    <td>&nbsp;<%=bm.getLoan_ack_dt()%></td>
                </tr>
                <tr>
                    <td rowspan='2' class=title>�����Ա���</td>
                    <td rowspan='2' >&nbsp;<%=bm.getLoan_rec_dt()%></td>
                    <td rowspan='2'  class=title>��Ÿ</td>
                    <td rowspan='2'  align="center" colspan=5><%=Util.htmlBR(bm.getNote())%></td>
                    
                </tr>
                
            </table>
        </td>
    </tr>
    <tr>
    	<td></td>
    </tr>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=680>
            	<tr>
            		<td width='80' class=title>�������</td>
            		<td width='100' class=title>����ȣ</td>
            		<td width='150' class=title>�����</td>
            		<td width='200' class=title>����</td>
            		<td width='150' class=title>������ȣ</td>
            	</tr>
            	<tr>
            		<td align='center'><%=bm.getRent_dt()%></td>
            		<td align='center'><%=bm.getRent_l_cd()%></td>
            		<td align='center'><%=bm.getFirm_nm()%></td>
            		<td align='center'><%=bm.getCar_nm()%></td>
            		<td align='center'><%=bm.getCar_no()%></td>            		
            	</tr>
           </table>
		</td>
	</tr>
</table>
</form>
</body>
<iframe src="about:blank" name="i_no" width="300" height="80" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</iframe>
</iframe>
</html>