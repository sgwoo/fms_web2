<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String swd = request.getParameter("swd")==null?"":request.getParameter("swd");
	String idx = request.getParameter("idx")==null?"":request.getParameter("idx");
	String str = request.getParameter("str")==null?"":request.getParameter("str");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>������ �˻�</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function save(){
		document.form1.submit();
	}
	
	function sezip(zip_str, addr_str){
		var fm = document.form1;
		var idx = fm.idx.value;
		var str = fm.str.value;

		if(idx != ""){
			window.opener.form1.zip[idx].value = zip_str;
			window.opener.form1.addr[idx].value = addr_str;
		}else if(str == "r"){
			window.opener.form1.t_r_site_zip.value = zip_str;
			window.opener.form1.t_r_site_addr.value = addr_str;
		}else if(str == "g"){
			window.opener.form1.t_car_mgr_zip.value = zip_str;
			window.opener.form1.t_car_mgr_addr.value = addr_str;
		}else{
			window.opener.form1.addr.focus();			
			window.opener.form1.zip.value = zip_str;
			window.opener.form1.addr.value = addr_str;
		}
		window.close();
	}
	function enter(){
		var keyValue = event.keyCode;
		if (keyValue =='13') save();
	}
	function set_decision(arg){
		opener.document.form1.decision_1.value = arg;
		this.close();
	}
-->
</script>

</head>
<body onload="javascript:document.form1.swd.focus();">
<p>
<form name='form1' action='s_zip.jsp' method='post'>

<table border="0" cellspacing="0" cellpadding="0" width=300>
	<tr>
		
    <td align='left'><< ������ �˻� >></td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=300>
				<tr>
					
          <td class='title'> ����</td>
					<td align='center'>
						<input type='text' name='swd' size='10' class='text' value='<%=swd%>' onKeyDown='javascript:enter()' style='IME-MODE: active'>
            <a href='#' onMouseOver="window.status=''; return true">�˻�</a> 
          </td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td></td>
	</tr>

	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width=301>
        <tr> 
          <td class='title' width='34'>����</td>
          <td class='title' width='82'> ������</td>
          <td width="56" class='title'>�μ�</td>
          <td width="52" class='title'>����</td>
          <td width="71" class='title'> ����</td>
        </tr>
        <tr> 
          <td align='center'>1</td>
          <td align='center'>���� </td>
          <td><div align="center">�ѹ���</div></td>
          <td><div align="center">����</div></td> 
          <td><a href="javascript:set_decision('�Ⱥ���')"><div align="center"> �Ⱥ��� </div></a></td> 
        </tr>
        <tr> 
          <td align='center'>2</td>
          <td align='center'>����</td>
          <td><div align="center">������</div></td>
          <td><div align="center">����</div></td>
          <td><a href="javascript:set_decision('��ä��')"><div align="center">��ä��</div></a></td>
        </tr>
        <tr> 
          <td colspan='5'> �˻��� ����� �����ϴ� </td>
        </tr>
      </table>
		</td>
	</tr>
</table>
</body>
</html>