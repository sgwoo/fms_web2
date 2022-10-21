<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.partner.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //1:��Ұ��, 2:�Ҽ�, 3:��Ұ�� �����Ȳ ������
	String serv_id = request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
		
	Hashtable ht = se_dt.getsd_vidw_modify(off_id, serv_id);				
%>

<html>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<head><title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<script language='javascript' src='/include/common.js'></script>
<link rel="stylesheet" href="//code.jquery.com/ui/1.11.4/themes/smoothness/jquery-ui.css">
<script src="//code.jquery.com/jquery.min.js"></script>
<script src="//code.jquery.com/ui/1.11.4/jquery-ui.min.js"></script>
 
<script>
$(function() {
  $( "#sd_dt" ).datepicker({
	  
    dateFormat: 'yy-mm-dd',
    prevText: '���� ��',
    nextText: '���� ��',
    monthNames: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    monthNamesShort: ['1��','2��','3��','4��','5��','6��','7��','8��','9��','10��','11��','12��'],
    dayNames: ['��','��','ȭ','��','��','��','��'],
    dayNamesShort: ['��','��','ȭ','��','��','��','��'],
    dayNamesMin: ['��','��','ȭ','��','��','��','��'],
    showMonthAfterYear: true,
    yearSuffix: '��'
  });
});
</script>
<script language='javascript'>
<!--	
		
	//���
	function sd_save(){
		var fm = document.form1;
		
		<%if(serv_id.equals("")){%>
		if(!confirm('����Ͻðڽ��ϱ�?')){	return;	}	
		fm.cmd.value = 'i';
		<%}else{%>
		if(!confirm('�߰��Ͻðڽ��ϱ�?')){	return;	}	
		fm.cmd.value = 'i2';
		<%}%>
		fm.action = "sd_view_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}
	
	function sd_update(){
		var fm = document.form1;
		
		if(!confirm('���� �Ͻðڽ��ϱ�?')){	return;	}	
		fm.cmd.value = 'sd_modify';
		fm.action = "sd_view_reg_a.jsp";
		fm.target = "i_no";
		fm.submit()
		
	}

//-->
</script>
</head>

<body>
<form name='form1' method='post' >
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=ck_acar_id%>'>
<input type='hidden' name='off_id' value='<%=off_id%>'>
<input type='hidden' name='serv_id' value='<%=serv_id%>'>
<input type='hidden' name='cmd' value=''>
<%if(serv_id.equals("")){%>  
<div class="navigation">
	<span class=style1></span><span class=style5>�����Ȳ �űԵ��</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
			<table border="0" cellspacing="1" cellpadding="0" width=100%>
			<tr> 
				<td class='title' width=15%>����</td>
				<td colspan="3">&nbsp;
					<select name="gubun">
						<option value="1">�湮</option>
						<option value="2">��ȭ(����)</option>
						<option value="3">��ȭ(�߽�)</option>
						<option value="4">����(����)</option>
						<option value="5">����(�߽�)</option>
						<option value="6">����</option>
					</select>
				</td>
			</tr>
			<tr> 
				<td class='title' width=15%>�������</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="sd_dt" id="sd_dt" size="12" value="<%=AddUtil.getDate()%>" class="date-picker" title="YYYY-MM-DD" READONLY>�س�¥�� �����ϸ� �޷��� ǥ�õǾ� ���ϴ� ��¥�� ������ �� �ֽ��ϴ�.</td>
			</tr>
			<tr> 
				<td class='title' width=15%>�ŷ�ó �����</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="g_smng1" size="20"  class="text" value="">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng2" size="20"  class="text" value="">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng3" size="20"  class="text" value=""></td>
			</tr>
			<tr>	
				<td class='title' width=15%>��� �����</td>
				<td colspan="3">&nbsp;
					<select name="d_smng1">
						<option value="-">��� ����� ����</option>
						<option value="��ǥ�̻�">��ǥ�̻�</option>
						<option value="�ѹ�����">�ѹ�����</option>
						<option value="���¿����">���¿����</option>
						<option value="�Ǹ���븮">�Ǹ���븮</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng2">
						<option value="-">��� ����� ����</option>
						<option value="��ǥ�̻�">��ǥ�̻�</option>
						<option value="�ѹ�����">�ѹ�����</option>
						<option value="���¿����">���¿����</option>
						<option value="�Ǹ���븮">�Ǹ���븮</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng3">
						<option value="-">��� ����� ����</option>
						<option value="��ǥ�̻�">��ǥ�̻�</option>
						<option value="�ѹ�����">�ѹ�����</option>
						<option value="���¿����">���¿����</option>
						<option value="�Ǹ���븮">�Ǹ���븮</option>
					</select>
			</tr>
			<tr> 
				<td class='title' width=15%>�ݸ�</td>
				<td>&nbsp;&nbsp;<input type="text" name="item1" size="20"  class="text" value=""></td>
				<td class='title' width=15%>�ѵ�</td>
				<td>&nbsp;&nbsp;<input type="text" name="item2" size="20"  class="text" value=""></td>
			</tr>
			<tr> 
				<td class='title' width=15%>�����Ȳ</td>
				<td colspan="3">&nbsp;&nbsp;<textarea name="note" cols=80 rows=4>&nbsp;</textarea>
			</tr>
          
        </table>
      </td>
    </tr>
	<tr>
        <td><input type="button" class="button" value="�űԵ��" onclick="sd_save()"/></td>
    </tr>
</table>	
<%}else if(!serv_id.equals("")){%>  	
<div class="navigation">
	<span class=style1></span><span class=style5>�����Ȳ �������</span>
</div>
<table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
      <td class="line"> 
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
			<tr> 
				<td class='title' width=15%>����</td>
				<td colspan="3">&nbsp;
					<select name="gubun">
						<option value="1" <%if(ht.get("GUBUN").equals("1"))%>selected<%%>>�湮</option>
						<option value="2" <%if(ht.get("GUBUN").equals("2"))%>selected<%%>>��ȭ(����)</option>
						<option value="3" <%if(ht.get("GUBUN").equals("3"))%>selected<%%>>��ȭ(�߽�)</option>
						<option value="4" <%if(ht.get("GUBUN").equals("4"))%>selected<%%>>����(����)</option>
						<option value="5" <%if(ht.get("GUBUN").equals("5"))%>selected<%%>>����(�߽�)</option>
						<option value="6" <%if(ht.get("GUBUN").equals("6"))%>selected<%%>>����</option>
					</select>
				</td>
			</tr>
			<tr> 
				<td class='title' width=15%>�������</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="sd_dt" id="sd_dt" size="12" value="<%=AddUtil.ChangeDate2(String.valueOf(ht.get("SD_DT")))%>" class="date-picker" title="YYYY-MM-DD" READONLY>�س�¥�� �����ϸ� �޷��� ǥ�õǾ� ���ϴ� ��¥�� ������ �� �ֽ��ϴ�.</td>
			</tr>
			<tr> 
				<td class='title' width=15%>�ŷ�ó �����</td>
				<td colspan="3">&nbsp;&nbsp;<input type="text" name="g_smng1" size="20"  class="text" value="<%if(!ht.get("G_SMNG1").equals("")){%><%=ht.get("G_SMNG1")%><%}%>">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng2" size="20"  class="text" value="<%if(!ht.get("G_SMNG2").equals("")){%><%=ht.get("G_SMNG2")%><%}%>">&nbsp;&nbsp; / 
				&nbsp;&nbsp;<input type="text" name="g_smng3" size="20"  class="text" value="<%if(!ht.get("G_SMNG3").equals("")){%><%=ht.get("G_SMNG3")%><%}%>"></td>
			</tr>
			<tr>	
				<td class='title' width=15%>��� �����</td>
				<td colspan="3">&nbsp;
					<select name="d_smng1">
						<option value="-" <%if(ht.get("D_SMNG1").equals("-"))%>selected<%%>>��� ����� ����</option>
						<option value="��ǥ�̻�" <%if(ht.get("D_SMNG1").equals("��ǥ�̻�"))%>selected<%%>>��ǥ�̻�</option>
						<option value="�ѹ�����" <%if(ht.get("D_SMNG1").equals("�ѹ�����"))%>selected<%%>>�ѹ�����</option>
						<option value="���¿����" <%if(ht.get("D_SMNG1").equals("���¿����"))%>selected<%%>>���¿����</option>
						<option value="�Ǹ���븮" <%if(ht.get("D_SMNG1").equals("�Ǹ���븮"))%>selected<%%>>�Ǹ���븮</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng2">
						<option value="-" <%if(ht.get("D_SMNG2").equals("-"))%>selected<%%>>��� ����� ����</option>
						<option value="��ǥ�̻�" <%if(ht.get("D_SMNG2").equals("��ǥ�̻�"))%>selected<%%>>��ǥ�̻�</option>
						<option value="�ѹ�����" <%if(ht.get("D_SMNG2").equals("�ѹ�����"))%>selected<%%>>�ѹ�����</option>
						<option value="���¿����" <%if(ht.get("D_SMNG2").equals("���¿����"))%>selected<%%>>���¿����</option>
						<option value="�Ǹ���븮" <%if(ht.get("D_SMNG2").equals("�Ǹ���븮"))%>selected<%%>>�Ǹ���븮</option>
					</select>&nbsp;&nbsp; / 
				&nbsp;&nbsp;<select name="d_smng3">
						<option value="-" <%if(ht.get("D_SMNG3").equals("-"))%>selected<%%>>��� ����� ����</option>
						<option value="��ǥ�̻�" <%if(ht.get("D_SMNG3").equals("��ǥ�̻�"))%>selected<%%>>��ǥ�̻�</option>
						<option value="�ѹ�����" <%if(ht.get("D_SMNG3").equals("�ѹ�����"))%>selected<%%>>�ѹ�����</option>
						<option value="���¿����" <%if(ht.get("D_SMNG3").equals("���¿����"))%>selected<%%>>���¿����</option>
						<option value="�Ǹ���븮" <%if(ht.get("D_SMNG3").equals("�Ǹ���븮"))%>selected<%%>>�Ǹ���븮</option>
					</select>
			</tr>
			<tr> 
				<td class='title' width=15%>�ݸ�</td>
				<td>&nbsp;&nbsp;<input type="text" name="item1" size="20"  class="text" value="<%=ht.get("ITEM1")%>"></td>
				<td class='title' width=15%>�ѵ�</td>
				<td>&nbsp;&nbsp;<input type="text" name="item2" size="20"  class="text" value="<%=ht.get("ITEM2")%>"></td>
			</tr>
			<tr> 
				<td class='title' width=15%>�����Ȳ</td>
				<td colspan="3">&nbsp;&nbsp;<textarea name="note" cols=80 rows=4>&nbsp;<%=ht.get("NOTE")%></textarea>
			</tr>
          
        </table>
      </td>
    </tr>
	<tr>
      <td align="right">
		<input type="button" class="button" value="����" onclick="sd_update()"/>
		<input type="button" class="button" value="�ݱ�" onclick="window.close()"/>
	  </td>
    </tr>
<%}%>	
    <tr>
        <td></td>
    </tr>
    
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe> 
</body>
</html>
