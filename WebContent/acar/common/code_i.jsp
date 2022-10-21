<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<jsp:useBean id="code_bean" scope="page" class="acar.common.CodeBean"/>
<%@ include file="/acar/cookies.jsp" %>


<%
	LoginBean login = LoginBean.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();

	String user_id = "";
	String user_nm = "";
   	String auth_rw = "";
   	String cmd = "";
	int count = 0;
	
	if(request.getParameter("auth_rw") != null)	auth_rw = request.getParameter("auth_rw");
	user_id = login.getCookieValue(request, "acar_id");
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String c_st 		= request.getParameter("c_st")==null?"":request.getParameter("c_st");
	String reg_code 		= request.getParameter("r_code")==null?"":request.getParameter("r_code");
		
	Vector CodeList = c_db.getCodeList();	/* �ڵ� master ��ȸ */
	int code_size = CodeList.size();

	
%>
<html>
<head><title>FMS</title>
<script language="JavaScript" src="/include/common.js"></script>
<script language='javascript'>
<!--
function CodeReg()
{
	var theForm = document.CodeRegForm;
	if(theForm.code.value == '')		{	alert('�ڵ带 �Է��Ͻʽÿ�');	return;	}
	else if(theForm.nm_cd.value == '')	{	alert('����ڵ���� �Է��Ͻʽÿ�');	return;	}
	else if(theForm.nm.value == '')	{	alert('�ڵ��Ī�� �Է��Ͻʽÿ�');	return;	}
		
	theForm.cmd.value = "i";
	theForm.target="i_no";
	theForm.submit();
}
function CodeClose()
{

	self.close();
	window.close();
}

<!--
	function search()
	{
		document.form1.submit();
	}
//-->
-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body onLoad="javascript:self.focus()">
<!-- <center> -->
<form action="./code_null_ui.jsp" name="CodeRegForm" method="post">
<input type='hidden' name='from_page' value='<%=from_page%>'>
<table border="0" cellspacing="0" cellpadding="0" width=100% style="margin: 0 auto;">
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0 background=../images/center/menu_bar_bg.gif>
                <tr>
                    <td width=7><img src=../images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=../images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Master > �ڵ���� > <span class=style5>�ڵ� ���</span></span></td>
                    <td width=7><img src=../images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
	<tr>
        <td class=line2></td>
    </tr>
	
	<tr>
	<td class='line'>
		 <table border="0" cellspacing="1" cellpadding="0" width=100%>
			
			<tr>
				<td width=150 class="title">�ڵ屸��</td>
				<td width=200>&nbsp;
				  <%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
				  ���رݸ�
				  <input type="hidden" name="c_st" value="<%=c_st%>">
				  <%}else{%>
				  			<% if (reg_code.equals("reg_code")) { %>
									<select name='c_st'>
								    	<option value='0003' selected>����</option>
								    </select>
							<% } else { %>
									<select name='c_st'>
								    	<option value=''>����</option>
								      	<%if(code_size > 0){
										for(int i = 0 ; i < code_size ; i++){
											Hashtable codeH = (Hashtable)CodeList.elementAt(i);	%>
	                		      		<option value='<%=codeH.get("C_ST")%>' <%if(c_st.equals(String.valueOf(codeH.get("C_ST")))){%>selected<%}%>> <%= codeH.get("NM_CD")%> </option>
		                		        <%}
								  		}%>
			              			</select>
							<% } %>
              		<%}%>
              		</td>
				<td width=150 class="title">�ڵ�</td>
				<td width=200>&nbsp;
				  <input type='text' name="code" size='5' class='text'> 
				</td>				
			</tr>			
			<tr>
				<td class="title">����ڵ��</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="nm_cd" size='40' class='text'></td>
			</tr>				
			<tr>
				<td class="title">�ڵ��Ī</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="nm" size='40' class='text'></td>
			</tr>				
		        <%if(from_page.equals("/fms2/bank_mng/working_fund_frame.jsp")){%>
		        <input type="hidden" name="cms_bk" value="">
		        <%}else{%>
			<tr>
			<% if (reg_code.equals("reg_code")) { %>
				<td class="title">���ι�ȣ</td>
				<td colspan="3" align="left">&nbsp;
				<input type='text' name="app_st" size='15' class='text'></td>
			<% } else { %>
				<td class="title">Ź�۱ݾ�</td>
				<td colspan="3" align="left">&nbsp;
				<input type='text' name="app_st" size='15' class='text'></td>
			<% } %>			
			</tr>
			<tr>
				<td class="title">CMS����ڵ�</td>
				<td colspan="3" align="left">&nbsp;
				  <input type='text' name="cms_bk" size='5' class='text'></td>
			</tr>	
			<% if (reg_code.equals("reg_code")) { %>
			<tr>
				<td class="title">����</td>
				<td colspan="3" align="left">&nbsp;
				      <input type='radio' name="t_gubun" value='1' checked>����&nbsp;
		              <input type='radio' name="t_gubun" value='2'>ĳ��Ż&nbsp;
	        	      <input type='radio' name="t_gubun" value='3'>��������&nbsp;
			      	  <input type='radio' name="t_gubun" value='4'>��Ÿ�������	
				</td>
			</tr>
			<tr>
				<td class="title">�����Ī</td>
				<td colspan="3" align="left">&nbsp;
					<input type="text" name="t_nm" value="" size="50" class="text">
				</td>
			</tr>					
			<tr>
				<td class=title rowspan="2">�ּ�</td>
				<td colspan=3>&nbsp;
					<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
					<script>
						function openDaumPostcode() {
							new daum.Postcode({
								oncomplete: function(data) {
									// �˾����� �˻���� �׸��� Ŭ�������� ������ �ڵ带 �ۼ��ϴ� �κ�.
	
									// ���θ� �ּ��� ���� ��Ģ�� ���� �ּҸ� �����Ѵ�.
									// �������� ������ ���� ���� ��쿣 ����('')���� �����Ƿ�, �̸� �����Ͽ� �б� �Ѵ�.
									var fullRoadAddr = data.roadAddress; // ���θ� �ּ� ����
									var extraRoadAddr = ''; // ���θ� ������ �ּ� ����
	
									// ���������� ���� ��� �߰��Ѵ�. (�������� ����)
									// �������� ��� ������ ���ڰ� "��/��/��"�� ������.
									if(data.bname !== '' && /[��|��|��]$/g.test(data.bname)){
										extraRoadAddr += data.bname;
									}
									// �ǹ����� �ְ�, ���������� ��� �߰��Ѵ�.
									if(data.buildingName !== '' && data.apartment === 'Y'){
									   extraRoadAddr += (extraRoadAddr !== '' ? ', ' + data.buildingName : data.buildingName);
									}
									// ���θ�, ���� ������ �ּҰ� ���� ���, ��ȣ���� �߰��� ���� ���ڿ��� �����.
									if(extraRoadAddr !== ''){
										extraRoadAddr = ' (' + extraRoadAddr + ')';
									}
									// ���θ�, ���� �ּ��� ������ ���� �ش� ������ �ּҸ� �߰��Ѵ�.
									if(fullRoadAddr !== ''){
										fullRoadAddr += extraRoadAddr;
									}
									
									document.getElementById('t_zip').value = data.zonecode;
									document.getElementById('t_addr').value = fullRoadAddr;
									
									// ����ڰ� '���� ����'�� Ŭ���� ���, ���� �ּҶ�� ǥ�ø� ���ش�.
									if(data.autoRoadAddress) {
										//����Ǵ� ���θ� �ּҿ� ������ �ּҸ� �߰��Ѵ�.
										var expRoadAddr = data.autoRoadAddress + extraRoadAddr;
										document.getElementById('t_addr').innerHTML = '(���� ���θ� �ּ� : ' + expRoadAddr + ')';
	
									} else if(data.autoJibunAddress) {
										var expJibunAddr = data.autoJibunAddress;
										document.getElementById('t_addr').innerHTML = '(���� ���� �ּ� : ' + expJibunAddr + ')';
	
									} else {
										document.getElementById('t_addr').innerHTML = '';
									}
								}
							}).open();
						}
					</script>	  
					<input type="text" name="t_zip"  id="t_zip" size="7" maxlength='7' value="">
					<input type="button" onclick="openDaumPostcode()" value="�����ȣ ã��">
				</td>
			</tr>
			<tr>
				<!-- <td class=title></td> -->
				<td colspan=3>&nbsp;
					<input type="text" name="t_addr" id="t_addr" size="50" value="">
				</td>
			</tr>
			<% }%>
			
			<%}%>								
			
		</table>
		<input type="hidden" name="user_id" value="<%=user_id%>">
		<input type="hidden" name="auth_rw" value="<%=auth_rw%>">
		<input type="hidden" name="cmd" value="">
	</td>
	</tr>
    <tr>
        <td class=h></td>
    </tR>
    <tr>    	
        <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>�Һα�</span></td>
    </tr>
    <tr>
        <td class=line2></td>
    </tr>	
    <tr>
        <td class='line'>
		    <table border="0" cellspacing="1" cellpadding="0" width=100%>			
			    <tr>
    				<td width=150 class="title">����ȯ�� �ݾ�ó�� </td>
    				<td width=550>&nbsp;
    				  <select name='var1'>
		                <option value="">����</option>
		                <option value="1" <%if(code_bean.getVar1().equals("1")){%>selected<%}%>>�Ҽ��� ����</option> 
		                <option value="7" <%if(code_bean.getVar1().equals("7")){%>selected<%}%>>������ ����</option>		                		                
		              </select>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">���ڰ����</td>
    				<td>&nbsp;
    				  <select name='var2'>
		                <option value="">����</option>
		                <option value="1" <%if(code_bean.getVar2().equals("1")){%>selected<%}%>>12����������</option>
		                <option value="2" <%if(code_bean.getVar2().equals("2")){%>selected<%}%>>���̿�������(365��)</option>
		                <option value="4" <%if(code_bean.getVar2().equals("4")){%>selected<%}%>>���̿�������(�����ϼ�)</option>
		                <option value="3" <%if(code_bean.getVar2().equals("3")){%>selected<%}%>>�����Է°�</option>
		              </select>
    				</td>
    			</tr>			
    			<tr>
    				<td class="title">���� �ݾ�ó��</td>
    				<td>&nbsp;
   				      <select name='var3'>	
    				    <option value="">����</option>	                
		                <option value="1" <%if(code_bean.getVar3().equals("1")){%>selected<%}%>>�Ҽ��� ����</option>
		                <option value="8" <%if(code_bean.getVar3().equals("8")){%>selected<%}%>>�Ҽ��� ����</option>
		                <option value="2" <%if(code_bean.getVar3().equals("2")){%>selected<%}%>>�Ҽ��� �ݿø�</option>
		                <option value="7" <%if(code_bean.getVar3().equals("7")){%>selected<%}%>>������ ����</option><!-- ���������� �߰� 20180918 -->
		                <option value="3" <%if(code_bean.getVar3().equals("3")){%>selected<%}%>>������ ����</option>
		                <option value="4" <%if(code_bean.getVar3().equals("4")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="5" <%if(code_bean.getVar3().equals("5")){%>selected<%}%>>�ʿ����� ����</option>
		                <option value="6" <%if(code_bean.getVar3().equals("6")){%>selected<%}%>>�ʿ����� �ݿø�</option> 
		              </select>
    				</td>
    			</tr>		
    			<tr>
    				<td class="title">1ȸ�� ���ڰ��</td>
    				<td>&nbsp;
    				    <input type="checkbox" name="var4" value="Y" <%if(code_bean.getVar4().equals("Y")){%>checked<%}%>> 1ȸ�� ���� ���ڰ�� �Ѵ�.
    				</td>
    			</tr>		 
    			<tr>
    				<td class="title">������ȸ�� ���ڰ��</td>
    				<td>&nbsp;
    				    <input type="checkbox" name="var5" value="Y" <%if(code_bean.getVar5().equals("Y")){%>checked<%}%>> ������ȸ�� ���� ���ڰ�� �Ѵ�. (������ȸ�� �������� ����� ����)
    				</td>
    			</tr>	   	
    			<tr>
    				<td class="title">���ڰ�� ���� ���Կ���</td>
    				<td>&nbsp;
    				  <select name='var6'>
		                <option value="">����</option>
		                <option value="2" <%if(code_bean.getVar6().equals("2")){%>selected<%}%>>���� �һ���</option>
		                <option value="1" <%if(code_bean.getVar6().equals("1")){%>selected<%}%>>���� ����</option>		                		                
		              </select>
    				</td>
    			</tr>	 		
		    </table>		
	    </td>
	</tr>  	
    <tr>
        <td class=h></td>
    </tr>
	<tr>
		<td colspan='4' align='right'><a href="javascript:CodeReg()"><img src=../images/pop/button_reg.gif border=0></a> <a href="javascript:CodeClose()"><img src=../images/pop/button_close.gif border=0></a></td>
	</tr>
</table>
</form>
<!-- </center> -->
<iframe src="about:blank" name="i_no" width="0" height="0" cellpadding="0" cellspacing="0" border="1" frameborder="0" noresize>
</body>
</html>