<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.client.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<jsp:useBean id="al_db" scope="page" class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	String user_id = login.getCookieValue(request, "acar_id");
	String br_id = login.getCookieValue(request, "acar_br");
	String auth_rw = rs_db.getAuthRw(user_id, "01", "03", "07");
	
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
		
	//���繫��ǥ
	ClientFinBean c_fin = al_db.getClientFin(client_id);

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//�����ȣ �˻�
	function search_zip(str){
		window.open("/acar/common/zip_s.jsp?idx="+str, "ZIP", "left=100, top=100, height=500, width=400, resizable=yes, scrollbars=yes, status=yes");
	
	}
		
	function save(){
		var fm = document.form1;	

		if(confirm('����Ͻðڽ��ϱ�?')){
			fm.target='i_no';
			fm.submit();
		}
	}
	
//-->
</script>
</head>
<body leftmargin="15" >

<form name='form1' action='./client_fin_i_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>

<table border=0 cellspacing=0 cellpadding=0 width='700'>
  <tr>
    <td><font color="navy">��������  -> </font><font color="navy">�ŷ�ó ����</font>-> <font color="red">����繫��ǥ ��� </font></td>
  </tr>
  <tr>
    <td class='line'> 
    
       <table border="0" cellspacing="1" cellpadding="0" width=100%>
		          <tr>
		       
		            <td colspan="2" rowspan="2" class=title>����<br>yyyy-mm-dd</td>
		            <td width="42%" class=title>���(
		                <input type='text' name='c_kisu' size='10'   maxlength='20' class='text' >
		      ��)</td>
		            <td width="43%" class=title>����(
		                <input type='text' name='f_kisu' size='10'   maxlength='20' class='text' >
		      ��)</td>
		          </tr>
		          <tr>
		            <td class=title>(
		            	<input type='text' name='c_ba_year_s' size='12' class='text' maxlength='12'   onBlur='javascript:this.value=ChangeDate(this.value)' value="">~<input type='text' name='c_ba_year' size='10' class='text' maxlength='10'   onBlur='javascript:this.value=ChangeDate(this.value)' value=""> )</td>
		     
		            <td class='title'>(
		            	<input type='text' name='f_ba_year_s' size='12' class='text' maxlength='12'   onBlur='javascript:this.value=ChangeDate(this.value)' value="">~<input type='text' name='f_ba_year' size='10' class='text' maxlength='10'   onBlur='javascript:this.value=ChangeDate(this.value)' value=""> )</td>
		              
		          </tr>
		          <tr>
		            <td colspan="2" class=title>�ڻ��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_asset_tot' size='10' value='' maxlength='13' class='num'  onBlur='javascript:this.value=parseDecimal(this.value)'; >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_asset_tot' size='10' value='' maxlength='13' class='num'   onBlur='javascript:this.value=parseDecimal(this.value)'; >
		      �鸸�� </td>
		          </tr>
		          <tr>
		            <td width="3%" rowspan="2" class=title>��<br>
		      ��</td>
		            <td width="9%" class=title>�ں���</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap' size='10' value='' maxlength='13' class='num'   onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap' size='10' value='' maxlength='13' class='num'   onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		          </tr>
		          <tr>
		            <td class=title>�ں��Ѱ�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_cap_tot' size='10' value='' maxlength='13' class='num'   onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸��</td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_cap_tot' size='10' value='' maxlength='13' class='num'    onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸��</td>
		          </tr>
		          <tr>
		            <td colspan="2" class=title>����</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_sale' size='10' value='' maxlength='13' class='num'  onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_sale' size='10' value='' maxlength='13' class='num'   onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		          </tr>
		          <tr>
		            <td colspan="2" class=title>��������</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_profit' size='10'  maxlength='13' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		            <td align="center">&nbsp;
		                <input type='text' name='f_profit' size='10'  maxlength='13' class='num' value='' onBlur='javascript:this.value=parseDecimal(this.value);' >
		      �鸸�� </td>
		          </tr>				  
		        </table>
		 
	</td>
  </tr>
   <tr height="30">
    <td align='right'>&nbsp;</td>
  </tr>
  <tr height="30">
    <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/confirm.gif" width="50" height="18" aligh="absmiddle" border="0"></a> &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>