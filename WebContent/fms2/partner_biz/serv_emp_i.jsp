<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.partner.*" %>
<%@ page import="acar.car_office.*, acar.pay_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String off_type 	= request.getParameter("off_type")==null?"1":request.getParameter("off_type");
	String cmd 	= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String off_id 	= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	
	
	//�α��λ�������� ��������
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	
	Serv_EmpDatabase se_dt = Serv_EmpDatabase.getInstance();
	
	Hashtable ht = se_dt.getServOff(off_id);

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<%@ include file="/acar/getNaviCookies.jsp" %>
<script language='javascript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
function ServOffReg(){
	var fm = document.form1;
	//if(fm.off_nm.value==""){ alert("��ȣ�� �Է��� �ּ���!"); fm.off_nm.focus(); return; }

	if(!confirm('�ش��ü�� ����Ͻðڽ��ϱ�?')){ return; }
	fm.cmd.value = "emp_i";
	fm.action = "serv_emp_a.jsp";
	fm.target = "i_no";
	fm.submit();
}


//-->
</script>
</head>
<body leftmargin="10">


<form action="" name="form1" method="post" >
<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
<input type="hidden" name="user_id" value="<%=user_id%>">
<input type="hidden" name="cmd" value="">
<input type='hidden' name='off_id' value='<%=off_id%>'> 
<div class="navigation">
	<span class=style1>���԰��� ></span><span class=style5>������� ���</span>
</div>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table border="0" cellspacing="1" width=100%>
				<tr>
					<td class="title" width="10%">����</td>
					<td class="title" width="10%">�μ�</td>
					<td class="title" width="10%">��å</td>
					<td class="title" width="10%">����</td>
					<td class="title" width="10%">��ǥ��ȭ</td>
					<td class="title" width="10%">������ȭ</td>
					<td class="title" width="10%">�ѽ�</td>
					<td class="title" width="10%">�޴���</td>
				</tr>
				<tr>
					<td rowspan="4" colspan="1" align="center"><input type="text" name="emp_nm" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="dept_nm" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="pos" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_level" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_tel" value="<%=ht.get("OFF_TEL")%>" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_htel" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_fax" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_mtel" value="" size="15" class=text></td>
				</tr>
				<tr>
					<td rowspan="1" colspan="3" class="title">E-mail</td>
					<td class="title">���ʵ��</td>
					<td class="title">������</td>
					<td class="title">������</td>
					<td class="title">��ȿ����</td>
				</tr>
				<tr>
					<td rowspan="1" colspan="3" align="center"><input type="text" name="emp_email" value="" size="50" class=text></td>
					<td align="center"><input type="text" name="reg_dt" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="upt_dt" value="" size="15" class=text></td>
					<td align="center"><input type="text" name="emp_role" value="" size="15" class=text></td>
					<td align="center">
						<select name="emp_valid">
							<option value="1">��ȿ</option>
							<option value="2">�μ�����</option>
							<option value="3">����</option>
							<option value="4">��ȿ</option>
						</select>
					</td>
				</tr>
				<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
				<script>
					function openDaumPostcode() {
						new daum.Postcode({
							oncomplete: function(data) {
								document.getElementById('emp_post').value = data.zonecode;
								document.getElementById('emp_addr').value = data.address +" (" + data.buildingName +")" ;
								
							}
						}).open();
					}
				</script>	
				<tr>
					<td class="title">�ּ�</td>
					<td rowspan="1" colspan="6">
					&nbsp;<input type="text" name="emp_post" id="emp_post" size="10" value="<%=ht.get("OFF_POST")%>" maxlength='7'>&nbsp;<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
					&nbsp;<input type="text" name="emp_addr" id="emp_addr" size="100" value="<%=ht.get("OFF_ADDR")%>">
					</td>
				</tr>
			</table>
        </td>
    </tr>
	<tr> 
        <td align="right">
		<input type="button" class="button" value="����" onclick="ServOffReg()"/>
		<input type="button" class="button" value="�ݱ�" onclick="window.close()"/>
		
		<!--<a href='javascript:ServOffReg()' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">���</a> 
        &nbsp;&nbsp;<a href='javascript:self.close();window.close();' onMouseOver="window.status=''; return true" class="ml-btn-4" style="text-decoration: none;">�ݱ�</a> -->
        </td>
    </tr>
  </form>
</table>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize>
</iframe>
</body>
</html>