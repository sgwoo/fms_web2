<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<jsp:useBean id="cd_bean" class="acar.common.CodeBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	
	String emp_id = "";						//�������ID
    String car_off_id = "";					//������ID
    String car_off_nm = "";					//�����Ҹ�Ī
    String car_comp_id = "";					//�ڵ���ȸ��ID
    String car_comp_nm = "";					//�ڵ���ȸ�� ��Ī
    String cust_st = "";						//������
    String emp_nm = "";						//����
    String emp_ssn = "";						//�ֹε�Ϲ�ȣ
    String car_off_tel = "";					//�繫����ȭ
    String car_off_fax = "";					//�ѽ�
    String emp_m_tel = "";					//�ڵ���
    String emp_pos = "";						//����
    String emp_email = "";					//�̸���
    String emp_bank = "";					//����
    String emp_acc_no = "";					//���¹�ȣ
    String emp_acc_nm = "";					//������
    String emp_post = "";
    String emp_addr = "";
    String cmd = "";
	int count = 0;
	
	if(request.getParameter("cmd") != null) cmd = request.getParameter("cmd");
	if(request.getParameter("car_off_id") != null) car_off_id = request.getParameter("car_off_id");
	if(request.getParameter("car_off_nm") != null) car_off_nm = request.getParameter("car_off_nm");
	if(request.getParameter("car_comp_id") != null) car_comp_id = request.getParameter("car_comp_id");
	if(request.getParameter("car_comp_nm") != null) car_comp_nm = request.getParameter("car_comp_nm");

	CodeBean cd_r [] = c_db.getCodeAll("0003");	//������� �����´�.
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function search_zip()
{
	window.open("./zip_s_p.jsp", "�����ȣ�˻�", "left=100, height=200, width=350, height=300, scrollbars=yes");
}
function CarOffEmpReg()
{
	var theForm = document.CarOffEmpForm;
	if(!CheckField())
	{
		return;
	}
	if(!confirm('����Ͻðڽ��ϱ�?'))
	{
		return;
	}
	theForm.emp_ssn.value = theForm.emp_ssn1.value+""+theForm.emp_ssn2.value;
	theForm.cmd.value = "i";
	theForm.target = "i_no"
	theForm.submit();
}
function CheckField()
{
	var theForm = document.CarOffEmpForm;
	if(theForm.emp_nm.value=="")
	{
		alert("�̸��� �Է��Ͻʽÿ�.");
		theForm.emp_nm.focus();
		return false;
	}
	if(theForm.emp_m_tel.value=="")
	{
		alert("�޴�����ȣ�� �Է��Ͻʽÿ�.");
		theForm.emp_m_tel.focus();
		return false;
	}
	return true;
}
//-->
</script>
</head>
<body leftmargin="15" onLoad="javascript:self.focus()">

<table border=0 cellspacing=0 cellpadding=0 width="800">
<form action="./car_off_p_open_null_ui.jsp" name="CarOffEmpForm" method="POST" >
	<tr>
    	<td ><font color="navy">�������� -> �ڵ��������Ұ��� -> </font><font color="red">����������</font></td>
    </tr>
    <tr>
    	<td>
            <table border="0" cellspacing="1" cellpadding="3" width="800">
            	<tr>
			    	<td width=100 align="right">�ڵ���ȸ�� : </td>
			    	<td width=150><%= car_comp_nm %><input type="hidden" name="car_comp_id" value="<%= car_comp_id %>"></td>
			    	<td width=100 align="right">�ڵ��������� : </td>
			        <td width=150><%= car_off_nm %><input type="hidden" name="car_off_id" value="<%= car_off_id %>"></td>
			    	<td  width=300 align="right">
            			<a href="javascript:CarOffEmpReg()" onMouseOver="window.status=''; return true">���</a>&nbsp;
			    	</td>
            	</tr>
            </table>
        </td>
    </tr>
    <tr>
        <td class=line>
            <table border="0" cellspacing="1" width=800>
                <tr>
                    <td class=title>������</td>
                    <td align=center colspan=5>
                    	<input type="radio" name="cust_st" value="2"  <% if(cust_st.equals("2")||cust_st.equals("")) out.println("checked"); %>>����ҵ�&nbsp;
                    	<input type="radio" name="cust_st" value="3"  <% if(cust_st.equals("3")) out.println("checked"); %>>��Ÿ����ҵ�&nbsp;
                    </td>
                    
                    
                </tr>
                <tr>
                    <td class=title width=120>����</td>
               		<td align=center width=140><input type="hidden" name="emp_id" value="<%= emp_id %>"><input type="text" name="emp_nm" value="<%= emp_nm %>" size="21" class=text></td>
                    <td class=title width=120>�ֹε�Ϲ�ȣ</td>
               		<td align=center width=150><input type="text" name="emp_ssn1" value="" size="6" maxlength=6 class=text> - <input type="text" name="emp_ssn2" value="" size="7" maxlength=7 class=text><input type="hidden" name="emp_ssn" value="<%= emp_ssn %>"></td>
               		<td class=title width=120>�ڵ�����ȣ</td>
               		<td align=center width=150><input type="text" name="emp_m_tel" value="<%= emp_m_tel %>" size="23" class=text></td>
                </tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('emp_post').value = data.zonecode;
								document.getElementById('emp_addr').value = data.address;
								
							}
						}).open();
					}
				</script>				
               	<tr>
                    <td class=title width=120>�ּ�</td>
               		<td colspan=5>&nbsp;
					<input type="text" name='emp_post' id="emp_post" value="<%= emp_post %>" size="7" maxlength='7'>
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;&nbsp;<input type="text" name='emp_addr' id="emp_addr" value="<%=emp_addr%>" size="90">
					
					</td>
               	</tr>
                <tr>
                    
               		<td class=title>����</td>
               		<td align=center><input type="text" name="emp_pos" value="<%= emp_pos %>" size="21" class=text></td>
               		<td class=title>E-MAIL</td>
               		<td align=center colspan=3><input type="text" name="emp_email" value="<%= emp_email %>" size="69" class=text></td>
                </tr>
                
                <tr>
                    <td class=title>���°�������</td>
               		<td align=center>
						<select name="emp_bank" style="width:135">
							<option value="">����</option>
<%
    for(int i=0; i<cd_r.length; i++){
        cd_bean = cd_r[i];
%>
            				<option value="<%= cd_bean.getNm() %>"><%= cd_bean.getNm() %></option>
<%}%> 					</select>
						<script>
						document.CarOffEmpForm.emp_bank.value = '<%= emp_bank %>';
						</script>
               		</td>
               		<td class=title>���¹�ȣ</td>
               		<td align=center><input type="text" name="emp_acc_no" value="<%= emp_acc_no %>" size="23" class=text></td>
               		<td class=title>������</td>
               		<td align=center ><input type="text" name="emp_acc_nm" value="<%= emp_acc_nm %>" size="23" class=text></td>
                </tr>
            </table>
        </td>
    </tr>

</table>
<input type="hidden" name="cmd" value="">
</form>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>

</body>
</html>
