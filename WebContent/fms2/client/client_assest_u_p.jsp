<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.client.*"%>
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
		
	//���ڻ�����
	ClientAssestBean  c_assest = al_db.getClientAssest(client_id, seq);
		

%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
		
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

<form name='form1' action='./client_assest_i_a.jsp' method='post'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'>
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='client_id' value='<%=client_id%>'>
<input type='hidden' name='seq' value='<%=seq%>'>
<input type='hidden' name='firm_nm' value='<%=firm_nm%>'>

<table border=0 cellspacing=0 cellpadding=0 width='700'>
  <tr>
    <td><font color="navy">��������  -> </font><font color="navy">�ŷ�ó ����</font>-> <font color="red">�ŷ�ó �ڻ� ���� </font></td>
  </tr>
  <tr>
    <td class='line'>             
    	  <table border="0" cellspacing="1" cellpadding="0" width=700>
		          <tr>
		            
		            <td width="10%" rowspan="2" rowspan="4"  class=title>����</td>
		            <td colspan="2" class=title>������1</td>
		            <td colspan="2" class=title>������2</td>
		          </tr>
		          <tr>
		            <td width="13%" class=title>����</td>
		            <td width="30%" class='title'>�ּ�</td>
		            <td width="13%" class=title>����</td>
		            <td width="31%" class='title'>�ּ�</td>
		          </tr>
		          <script src="http://dmaps.daum.net/map_js_init/postcode.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
		          <tr>
		            <td class=title>����</td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_ass1_type' size='13' maxlength='20' class='text' value='<%=c_assest.getC_ass1_type()%>'>
		            </td>
		            <td>&nbsp;
						<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="<%=c_assest.getC_ass1_zip()%>">
						<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr" size="34" value="<%=c_assest.getC_ass1_addr()%>">
		            </td>
		            <td align="center">&nbsp;
		                <input type='text' name='c_ass2_type' size='13' maxlength='20' class='text' value='<%=c_assest.getC_ass2_type()%>' >
		            </td>
					<script>
						function openDaumPostcode1() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip1').value = data.zonecode;
									document.getElementById('t_addr1').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
		            <td>&nbsp;
						<input type="text" name="t_zip"  id="t_zip1" size="7" maxlength='7' value="<%=c_assest.getC_ass2_zip()%>">
						<input type="button" onclick="openDaumPostcode1()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr1" size="34" value="<%=c_assest.getC_ass2_addr()%>">
		            </td>
		          </tr>
		          
		          <tr>
		            <td class=title>��ǥ�̻�</td>
		            <td align="center">&nbsp;
		                <input type='text' name='r_ass1_type' size='13' maxlength='20' class='text' value='<%=c_assest.getR_ass1_type()%>' >
		            </td>
					<script>
						function openDaumPostcode2() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip2').value = data.zonecode;
									document.getElementById('t_addr2').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
		            <td>&nbsp;
						<input type="text" name="t_zip"  id="t_zip2" size="7" maxlength='7' value="<%=c_assest.getR_ass1_zip()%>">
						<input type="button" onclick="openDaumPostcode2()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr2" size="34" value="<%=c_assest.getR_ass1_addr()%>">
		            </td>
		            <td align="center">&nbsp;
		                <input type='text' name='r_ass2_type' size='13' maxlength='20' class='text' value='<%=c_assest.getR_ass2_type()%>' >
		            </td>
					<script>
						function openDaumPostcode3() {
							new daum.Postcode({
								oncomplete: function(data) {
									document.getElementById('t_zip3').value = data.zonecode;
									document.getElementById('t_addr3').value = data.roadAddress;
									
								}
							}).open();
						}
					</script>
		            <td>&nbsp;
		            	<input type="text" name="t_zip"  id="t_zip3" size="7" maxlength='7' value="<%=c_assest.getR_ass2_zip()%>">
						<input type="button" onclick="openDaumPostcode3()" value="�����ȣ ã��"><br>
						&nbsp;<input type="text" name="t_addr" id="t_addr3" size="34" value="<%=c_assest.getR_ass2_addr()%>">
		            </td>
		          </tr>
		        </table>
	</td>
  </tr>
  <tr height="30">
	  <td align='left'>*���� �� ���λ���ڴ� <font color=red>��ǥ�̻�</font>���� �ڻ��� �Է��Ͻø� �˴ϴ�. 
      </td>
  </tr>
  <tr height="30">
    <td align='right'><a href='javascript:save()' onMouseOver="window.status=''; return true"><img src="/images/confirm.gif" width="50" height="18" aligh="absmiddle" border="0"></a> &nbsp;&nbsp;<a href='javascript:history.go(-1);'><img src="/images/list.gif" width="50" height="18" aligh="absmiddle" border="0"></a></td>
  </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>