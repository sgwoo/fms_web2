<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.ma.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
%>

<html>
<head>
<title>����/������</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("./s_zip.jsp?idx="+str, "ZIP", "left=300, top=300, height=300, width=350, scrollbars=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.site_nm.value == '')			{	alert('����(����)���� �Է��Ͻʽÿ�');		return;	 }
		else if(fm.zip.value == '')			{	alert('�����ȣ�� �Է��Ͻʽÿ�'); 			return; }		
		else if(fm.addr.value == '')		{	alert('�ּҸ� �Է��Ͻʽÿ�'); 				return; }
		
		if(!confirm('����Ͻðڽ��ϱ�?'))	return;

		fm.target='i_no';
		fm.submit();
	}

//-->
</script>
</head>
<body onload="javascript:document.form1.site_nm.focus();">
<form name='form1' action='./s_site_i_a.jsp' method='post'>
<input type="hidden" name="client_id" value="<%=client_id%>">
<table border=0 cellspacing=0 cellpadding=0 width='520'>
  <tr>
      <td><font color="navy">[ ����/���� ��� ]</font></td>
  </tr>
  <tr>
    <td class='line'>            
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td width='141' colspan="2" class='title'> ��ȣ��</td>
            <td align='left'>&nbsp; <%=firm_nm%> </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>��������</td>
            <td>&nbsp;
			  <input type="radio" name="site_st" value="1" checked>
              ���� 
              <input type="radio" name="site_st" value="2">
              ����</td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>������</td>
            <td>&nbsp; <input type='text' name='site_nm' value='' size='15' maxlength='15' class='text' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>������</td>
            <td>&nbsp; <input type='text' name='site_jang' value='' size='15' maxlength='15' class='text' style='IME-MODE: active'></td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>����ڹ�ȣ</td>
            <td>&nbsp; 
			  <input type='text' name='enp_no1' value='' size='3' class='text' maxlength='3'>
              - 
              <input type='text' name='enp_no2' value='' size='2' class='text' maxlength='2'>
              - 
              <input type='text' name='enp_no3' value='' size='5' class='text' maxlength='5'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>���������</td>
            <td>&nbsp; <input type='text' name='open_year' size='12' class='text' maxlength='12' onBlur='javascript:this.value=ChangeDate(this.value)' value=""> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>��ȭ��ȣ</td>
            <td>&nbsp; <input type='text' name='tel' value='' size='15' maxlength='15' class='text'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>�ѽ���ȣ</td>
            <td>&nbsp; <input type='text' name='fax' value='' size='15' maxlength='15' class='text'></td>
          </tr>
		  <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
			<script>
				function openDaumPostcode() {
					new daum.Postcode({
						oncomplete: function(data) {
							document.getElementById('zip').value = data.zonecode;
							document.getElementById('addr').value = data.address;
							
						}
					}).open();
				}
			</script>
          <tr> 
            <td height="26" colspan="2" class='title'>�ּ�</td>
            <td height="26">&nbsp; <input type="text" name='zip' id="zip" size="7" maxlength='7'>
			<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
			&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="47">
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>������̸�</td>
            <td>&nbsp; <input type='text' name='agnt_nm' size='20' class='text' maxlength='40' value="" style='IME-MODE: active'> 
            </td>
          </tr>
          <tr> 
            <td colspan="2" class='title'>�������ȭ</td>
            <td>&nbsp; <input type='text' name='agnt_tel' size='20' class='text' maxlength='40' value=""> 
            </td>
          </tr>
        </table>
	</td>
  </tr>
  <tr height="30">
	  <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="../images/bbs/but_in.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="../images/bbs/but_backgo.gif" width="70" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>