<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String cust_st = request.getParameter("cust_st")==null?"":request.getParameter("cust_st");
	
	String h_con = request.getParameter("h_con")==null?"":request.getParameter("h_con");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("./zip_s.jsp?str="+str, "ZIP", "left=100, top=100, height=500, width=400, scrollbars=yes");
	}
		
	function save(){
		var fm = document.form1;	
		if(fm.cust_nm.value == ''){		alert('����ڸ� �Է��Ͻʽÿ�');	fm.cust_nm.focus(); return;	}
		else if((fm.ssn.value == '')){	alert('�ֹε�Ϲ�ȣ�� �Է��Ͻʽÿ�'); fm.ssn.focus(); return; }		
		else if((fm.zip.value == '')){	alert('�����ȣ�� �Է��Ͻʽÿ�'); return; }		
		else if((fm.addr.value == '')){	alert('�ּҸ� �Է��Ͻʽÿ�'); return; }						
		else if((fm.m_tel.value == '')){alert('�޴����� �Է��Ͻʽÿ�'); fm.m_tel.focus(); return; }
		
		//���������ȣ �ڸ���üũ �� formating ���� �߰�(2018.02.07)
		if(fm.lic_no.value!=""){
			var chk_lic_no_res = CheckLic_no(fm.lic_no.value);
			if(chk_lic_no_res=='N'){	return false;	}
		}
		
		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}				
	}
-->
</script>
</head>
<body leftmargin="15" onload="javascript:document.form1.cust_nm.focus();">
<form name='form1' action='./client_i_a.jsp' method='post'>
<input type='hidden' name='h_con' value='<%=h_con%>'>
<input type='hidden' name='h_wd' value='<%=h_wd%>'>
<input type='hidden' name='rent_st' value='<%=rent_st%>'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
  <table border=0 cellspacing=0 cellpadding=0 width='720'>
    <tr>
      <td><font color="navy">����ý��� -> ��������</font><font color="red">�ܱ�ŷ�ó ��� </font></td>
  </tr>
  <tr>
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="1" width=720>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>����</td>
            <td> 
              <select name="cust_st">
                <option value="1">����</option>
                <option value="2" selected>����</option>
                <option value="3">���λ����(�Ϲݰ���)</option>
                <option value="4">���λ����(���̰���)</option>
                <option value="5">���λ����(�鼼�����)</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>����</td>
            <td> 
              <input type="text" name="cust_nm" value="" size="30" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">��ȣ</td>
            <td> 
              <input type="text" name="firm_nm" value="" size="50" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>�ֹε�Ϲ�ȣ</td>
            <td> 
              <input type="text" name="ssn" value="" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">����ڵ�Ϲ�ȣ</td>
            <td> 
              <input type="text" name="enp_no" value="" size="20" class=text>
            </td>
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
            <td class=title width="100"><font color="#FF0000">*</font>�ּ�</td>
            <td> 
				<input type="text" name='zip' id="zip" size="7" maxlength='7'>
				<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
				&nbsp;&nbsp;<input type="text" name='addr' id="addr" size="80">
            </td>
          </tr>
          <tr> 
            <td class=title width="100">���������ȣ</td>
            <td> 
              <input type="text" name="lic_no" value="" size="20" class=text onBlur='javscript:this.value = ChangeLic_no(this.value);'>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">������������</td>
            <td> 
              <select name="lic_st">
                <option value="1">1������</option>
                <option value="2" selected>2������</option>
              </select>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">��ȭ��ȣ</td>
            <td> 
              <input type="text" name="tel" value="" class=text size="20">
            </td>
          </tr>
          <tr> 
            <td class=title width="100"><font color="#FF0000">*</font>�޴���</td>
            <td> 
              <input type="text" name="m_tel" value="" size="20" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">�̸����ּ�</td>
            <td> 
              <input type="text" name="email" value="" size="50" class=text>
            </td>
          </tr>
          <tr> 
            <td class=title width="100">Ư�̻���</td>
            <td> 
              <textarea name="etc" cols="90" class="text" rows="3"></textarea>
            </td>
          </tr>
        </table>
      </td>
  </tr>  
  <tr height="30">
	  <td align='right'>
	  <%if(auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")){%>
	    <a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/confirm.gif" width="50" height="18" aligh="absmiddle" border="0"></a>
      <%}%>
        &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a> 
      </td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>