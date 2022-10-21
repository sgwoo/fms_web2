<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ page import="acar.cont.*"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='../../include/common.js'></script>
<script language='javascript'>
<!--
	//�˻��ϱ�
	function search()
	{
		var fm = document.form1;
		
		if(td_bank.style.display == ''){/*�����˻�*/
			fm.s_wd.value = fm.s_bank.options[fm.s_bank.selectedIndex].value;
		}else if(td_brch.style.display == ''){/*�����Ұ˻�*/
			fm.s_wd.value = fm.s_brch.options[fm.s_brch.selectedIndex].value;		
		}else if(td_bus.style.display == ''){ //���������
			fm.s_wd.value = fm.s_bus.options[fm.s_bus.selectedIndex].value;
		}else if(td_mng.style.display == ''){ //���������
			fm.s_wd.value = fm.s_mng.options[fm.s_mng.selectedIndex].value;
		}	
		
		fm.mode.value = 'search';		
		fm.action ='con_sc.jsp';
		fm.target ='c_foot';
		fm.submit();
	}
	
	//���÷��� Ÿ��
	function cng_input(){
		var fm = document.form1;
		if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '5'){ //������ ���ý� ���ฮ��Ʈ ���÷���
			td_input.style.display	= 'none';
			td_bank.style.display 	= '';
			td_brch.style.display	= 'none';			
			td_bus.style.display	= 'none';
			td_mng.style.display	= 'none';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '7'){ //������ ���ý� �����Ҹ���Ʈ ���÷���
			td_input.style.display	= 'none';
			td_bank.style.display 	= 'none';
			td_brch.style.display	= '';		
			td_bus.style.display	= 'none';
			td_mng.style.display	= 'none';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '8'){ //���������
			td_input.style.display	= 'none';
			td_bank.style.display 	= 'none';
			td_brch.style.display	= 'none';			
			td_bus.style.display	= '';
			td_mng.style.display	= 'none';
		}else if(fm.s_kd.options[fm.s_kd.selectedIndex].value == '9'){ //���������
			td_input.style.display	= 'none';
			td_bank.style.display 	= 'none';
			td_brch.style.display	= 'none';			
			td_bus.style.display	= 'none';
			td_mng.style.display	= '';
		}else{
			td_input.style.display	= '';
			td_bank.style.display 	= 'none';
			td_brch.style.display	= 'none';			
			td_bus.style.display	= 'none';
			td_mng.style.display	= 'none';
		}
		
		if(fm.s_kd.value == '0'){ /*��ü�˻�*/
			fm.s_rent_l_cd.value='';
			fm.s_client_nm.value='';
			fm.s_car_no.value='';
			fm.s_rent_s_dt.value='';
			fm.s_wd.value='';
			fm.s_bank.value='';
			fm.s_brch.value='';
			fm.s_bus.value='';
			fm.s_mng.value='';
		}	
	}
	
	function enter() 
	{
		var keyValue = event.keyCode;
		if (keyValue =='13') search();
	}	
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body leftmargin="15" javascript="document.form1.s_rent_l_cd.focus();">
<%
	//�˻�����
	String s_rent_l_cd 	= request.getParameter("s_rent_l_cd")	==null?"":request.getParameter("s_rent_l_cd");
	String s_client_nm 	= request.getParameter("s_client_nm")	==null?"":request.getParameter("s_client_nm");
	String s_car_no 	= request.getParameter("s_car_no")		==null?"":request.getParameter("s_car_no");
	String s_rent_s_dt 	= request.getParameter("s_rent_s_dt")	==null?"":request.getParameter("s_rent_s_dt");
	String s_kd 		= request.getParameter("s_kd")			==null?"":request.getParameter("s_kd");
	String s_wd 		= request.getParameter("s_wd")			==null?"":request.getParameter("s_wd");
	String s_bank 		= request.getParameter("s_bank")		==null?"":request.getParameter("s_bank");
	String s_brch 		= request.getParameter("s_brch")		==null?"":request.getParameter("s_brch");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//�ڵ� ����:�����
	CodeBean[] banks = c_db.getCodeAll("0003");
	int bank_size = banks.length;
	//������ ����Ʈ ��ȸ
	Vector branches = c_db.getBranchList();
	int brch_size = branches.size();

	Vector users = c_db.getUserList("", "", "BUS_EMP"); //��������� ����Ʈ
	int user_size = users.size();	
	Vector users2 = c_db.getUserList("", "", "MNG_EMP"); //��������� ����Ʈ
	int user_size2 = users2.size();	

%>
<form name='form1' method='post' action='/acar/search/con_sc.jsp' target='c_foot'>
  <input type='hidden' name='h_kwd' value=''>
  <input type='hidden' name='mode' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=900>
    <tr valign="top"> 
      <td colspan='9'> <font face="Verdana, Arial, Helvetica, sans-serif" color="#999999" size="3">Search</font> 
      </td>
    </tr>
    <tr> 
      <td width='135' align='left'>����ȣ: 
        <input type='text' style='IME-MODE:inactive' name='s_rent_l_cd' size='10' class='text' value='<%=s_rent_l_cd%>' onKeyDown='javascript:enter()'>
        &nbsp;</td>
      <td width='110' align='left'>��ȣ: 
        <input type='text' style='IME-MODE:active' name='s_client_nm' size='10' class='text' value='<%=s_client_nm%>' onKeyDown='javascript:enter()'>
      </td>
      <td width='135' align='left'>������ȣ: 
        <input type='text' style='IME-MODE:active' name='s_car_no' size='10' class='text' value='<%=s_car_no%>' onKeyDown='javascript:enter()'>
      </td>
      <td width='147' align='left'>�����: 
        <input type='text' name='s_rent_s_dt' size='11' class='text' value='<%=s_rent_s_dt%>' onKeyDown='javascript:enter()'>
      </td>
      <td align="left" width="155">��Ÿ��ȸ: 
        <select name='s_kd' onChange='javascript:cng_input()'>
          <option value=''  <%if(s_kd.equals("")){%>selected<%}%>>����</option>
          <option value='0' <%if(s_kd.equals("0")){%>selected<%}%>>��ü</option>
          <option value='1' <%if(s_kd.equals("1")){%>selected<%}%>>�뿩������</option>
          <option value='2' <%if(s_kd.equals("2")){%>selected<%}%>>�����</option>
          <option value='3' <%if(s_kd.equals("3")){%>selected<%}%>>�����ȣ</option>
          <option value='5' <%if(s_kd.equals("5")){%>selected<%}%>>������</option>
          <option value='6' <%if(s_kd.equals("6")){%>selected<%}%>>��ุ����</option>
          <option value='8' <%if(s_kd.equals("8")){%>selected<%}%>>���������</option>
          <option value='9' <%if(s_kd.equals("9")){%>selected<%}%>>���������</option>
		  <option value='7' <%if(s_kd.equals("7")){%>selected<%}%>>������</option>
        </select>
      </td>
	  <!--�ܾ�˻�-->
      <td width='80' id='td_input' align='left' style='display:none'> 
        <input type='text' style='IME-MODE:active' name='s_wd' size='10' class='text' value='<%=s_wd%>' onKeyDown='javascript:enter()'>
      </td>
	  <!--������˻�-->
      <td width='100' id='td_bank' align='left' style='display:none'> 
        <select name='s_bank'>
          <% //������ ����Ʈ
		if(bank_size > 0){
			for(int i = 0 ; i < bank_size ; i++){
				CodeBean bank = banks[i];
%>
          <option value='<%= bank.getCode()%>' <%if(s_bank.equals(bank.getCode())){%>selected<%}%>><%= bank.getNm()%></option>
<%			}
		}
%>
        </select>
      </td>
	  <!--�����Ұ˻�-->
      <td width='100' id='td_brch' align='left' style='display:none'> 
		<select name='s_brch'>
		<% //������ ����Ʈ
		if(brch_size > 0){
			for (int i = 0 ; i < brch_size ; i++){
				Hashtable branch = (Hashtable)branches.elementAt(i);
%>			          		
		  <option value='<%= branch.get("BR_ID") %>'  <%if(s_brch.equals(String.valueOf(branch.get("BR_ID")))){%>selected<%}%>> <%= branch.get("BR_NM")%> </option>
<%			}
		}
%>
		</select>
      </td>	  
	  <!--��������ڰ˻�-->
      <td width='100' id='td_bus' align='left' style='display:none'> 
		<select name='s_bus'>
		<% //��������� ����Ʈ
			if(user_size > 0){
				for (int i = 0 ; i < user_size ; i++){
					Hashtable user = (Hashtable)users.elementAt(i);	%>
                <option value='<%=user.get("USER_ID")%>' <%if(s_wd.equals(user.get("USER_ID"))) out.println("selected");%>><%=user.get("USER_NM")%></option>
         <%		}
			}		%>
		</select>
      </td>	  
	  <!--��������ڰ˻�-->
      <td width='100' id='td_mng' align='left' style='display:none'> 
		<select name='s_mng'>
		<% //��������� ����Ʈ
			if(user_size2 > 0){
				for (int i = 0 ; i < user_size2 ; i++){
					Hashtable user2 = (Hashtable)users2.elementAt(i);	%>
                <option value='<%=user2.get("USER_ID")%>' <%if(s_wd.equals(user2.get("USER_ID"))) out.println("selected");%>><%=user2.get("USER_NM")%></option>
         <%		}
			}		%>
		</select>
      </td>	  
      <td><a href='javascript:search()' onMouseOver="window.status=''; return true">��ȸ</a>&nbsp;&nbsp;<a href='javascript:parent.window.close()' onMouseOver="window.status=''; return true">�ݱ�</a></td>
    </tr>
  </table>
</form>

</body>
</html>
