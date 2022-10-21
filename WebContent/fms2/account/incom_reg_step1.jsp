<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.bill_mng.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	//�α���ID&������ID
	LoginBean login = LoginBean.getInstance();
	if(user_id.equals("")) 	user_id = login.getCookieValue(request, "acar_id");
	if(br_id.equals(""))	br_id 	= login.getCookieValue(request, "acar_br");
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "01", "13");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//����� ����Ʈ
	Vector users = c_db.getUserList("", "", "EMP");
	int user_size = users.size();
	
	//�׿���-��������
	CodeBean[] banks = neoe_db.getCodeAll();
	int bank_size = banks.length;

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
	<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	//���༱�ý� ���¹�ȣ ��������
	function change_bank(){
		var fm = document.form1;
		var bank_code = fm.bank_code.options[fm.bank_code.selectedIndex].value;
		fm.bank_code2.value = bank_code.substring(0,3);
		fm.bank_name.value = bank_code.substring(3);
		
		drop_deposit();		

		if(bank_code == ''){
			fm.bank_code.options[0] = new Option('����', '');
			return;
		}else{
			fm.target='i_no';
			fm.action='/fms2/con_fee/get_deposit_nodisplay.jsp?bank_code='+bank_code.substring(0,3);
			fm.submit();
		}
	}
	
	function drop_deposit(){
		var fm = document.form1;
		var deposit_len = fm.deposit_no.length;
	//	alert(deposit_len);
		for(var i = 0 ; i < deposit_len ; i++){
			fm.deposit_no.options[deposit_len-(i+1)] = null;
		}
	}
		
	function add_deposit(idx, val, str){
		document.form1.deposit_no[idx] = new Option(str, val);		
	}

	
	//���÷���
	function cng_input1(){
		var fm = document.form1;

		tr_pay1.style.display		= 'none';
		tr_pay2.style.display		= 'none';		
		tr_pay3.style.display		= 'none';
		tr_pay5.style.display		= 'none';
		
		if(fm.ip_method[0].checked == true)			tr_pay1.style.display		= '';
		if(fm.ip_method[1].checked == true)			tr_pay2.style.display		= '';						
		if(fm.ip_method[2].checked == true)			tr_pay3.style.display		= '';
		if(fm.ip_method[3].checked == true)			tr_pay5.style.display		= '';
							
	}	
		
	
	function save(){
	
		var fm = document.form1;
		if(fm.incom_dt.value == '')		{ alert('�Ա����ڸ� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.incom_amt.value == '' || fm.incom_amt.value == '0')		{ alert('�Աݾ��� Ȯ���Ͻʽÿ�.'); 	return;}
	//	if(fm.incom_gubun.value == '')	{ alert('�Է±����� Ȯ���Ͻʽÿ�.'); 	return;}
		if(fm.ip_method.value == '')	{ alert('�Աݱ����� Ȯ���Ͻʽÿ�.'); 	return;}
	
		
		//������ ��� 
		if(fm.ip_method[0].checked == true){	
		   //���� erp ���� ����� ���
			if ( fm.incom_gubun[1].checked == true) {
				if(fm.bank_code3.value == '')	{ alert('������ Ȯ���Ͻʽÿ�.'); 	return;}
				if(fm.deposit_no3.value == '')	{ alert('���¹�ȣ�� Ȯ���Ͻʽÿ�.'); 	return;}
			}else {
				if(fm.bank_code.value == '')	{ alert('������ Ȯ���Ͻʽÿ�.'); 	return;}
				if(fm.deposit_no.value == '')	{ alert('���¹�ȣ�� Ȯ���Ͻʽÿ�.'); 	return;}
			}	
			if(fm.remark.value == '')		{ alert('���並 Ȯ���Ͻʽÿ�.'); 	return;}
		//	if(fm.bank_office.value == '')	{ alert('�ŷ����� Ȯ���Ͻʽÿ�.'); 	return;}	
		}else if (fm.ip_method[1].checked == true){ //ī��	
			if(fm.card_cd[0].checked == false && fm.card_cd[1].checked == false && fm.card_cd[2].checked == false  && fm.card_cd[3].checked == false  && fm.card_cd[4].checked == false && fm.card_cd[5].checked == false && fm.card_cd[6].checked == false && fm.card_cd[7].checked == false  && fm.card_cd[8].checked == false  && fm.card_cd[9].checked == false  && fm.card_cd[10].checked == false && fm.card_cd[11].checked == false  )	{ alert('ī��縦 �����ϼ���.'); 	return;}
		//	if(fm.card_no.value == '')	{ alert('ī���ȣ�� Ȯ���Ͻʽÿ�.'); 	return;}
			
		} else if(fm.ip_method[2].checked == true){ //����	
			if(fm.cash_area.value == '')	{ alert('������Ҹ� Ȯ���Ͻʽÿ�.'); 	return;}
			if(fm.cash_get_id.value == '')	{ alert('���ݻ���� Ȯ���Ͻʽÿ�.'); 	return;}
		
		} else if (fm.ip_method[3].checked == true){  //��ü	
			if(fm.remark5.value == '')	{ alert('������ Ȯ���Ͻʽÿ�.'); 	return;}
		}		
					
//		if ( fm.p_gubun[1].checked == true ) { alert('cms�� ok-bank���� ó���ϼ���.'); 	return;}
						
		//if(confirm('1�ܰ踦 ����Ͻðڽ��ϱ�?')){	
			fm.action='incom_reg_step1_a.jsp';	
			fm.target='d_content';
			fm.submit();
		//}		
	}
	
		//���� ������Ʈ��
	function search_shinhan_ebank()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/shinhan_erp_demand.jsp", "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}	
	
	function search_insidebank()
	{
		fm = document.form1;			
					
		window.open("/fms2/account/shinhan_erp_demand_inside.jsp", "AncDisp", "left=100, top=100, width=1100, height=700, scrollbars=yes, status=yes, resizable=yes");
	}	
	
//-->
</script> 

</head>
<body leftmargin="15">
<form action='' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>
  <input type='hidden' name="from_page" 	value="/fms2/account/incom_reg_step1.jsp">
  <input type='hidden' name='bank_code2' value=''>     
  <input type='hidden' name='deposit_no2'  value=''>    
  <input type='hidden' name='bank_name' 	value=''> 


  <table border='0' cellspacing='0' cellpadding='0' width='100%'>
	<tr>
		<td colspan=10>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ���ݰ��� > <span class=style5>
						�Աݿ����� [1�ܰ�]</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
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
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
		<!--	
          <tr> 
            <td class=title width=13%>ó������</td>
            <td>&nbsp;
			  <input type="radio" name="pay_st" value="1" checked>�ű��Ա�
			</td>					  
          </tr>		
          -->  
          <tr> 
            <td class=title width=13%>�Ա�����</td>
            <td>&nbsp;
			  <input type='text' name='incom_dt' size='11' maxlength='20' class='text' value="<%=AddUtil.getDate()%>" onBlur='javascript:this.value=ChangeDate(this.value)'>
			   &nbsp;<a href='javascript:search_insidebank()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���"><img src="/acar/images/center/button_search.gif" align=absmiddle border="0"></a>
		 	<!--  &nbsp;<a href='javascript:search_shinhan_ebank()' onMouseOver="window.status=''; return true" title="Ŭ���ϼ���">������Ʈ��</a> -->
	 
			   </td>
          </tr>		
          <tr> 
            <td class=title>�Աݾ�</td>
            <td>&nbsp;
			  <input type='text' name='incom_amt' size='12' maxlength='12' class='num' value='' onBlur="javascript:this.value=parseDecimal(this.value);" >&nbsp;��</td>
          </tr>		
        </table>
	  </td>
    </tr>

	<tr>
	  <td>&nbsp;</td>
	</tr>
	
	<tr>
		<td class=line2></td>
	</tr>
    <tr id=tr_pay0 style="display:''">
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>�Աݱ���</td>
            <td colspan="3">&nbsp;
			  <input type="radio" name="ip_method" value="1" checked onClick="javascript:cng_input1()">���� 
			  <input type="radio" name="ip_method" value="2" onClick="javascript:cng_input1()">ī�� 
              <input type="radio" name="ip_method" value="3" onClick="javascript:cng_input1()">����
              <input type="radio" name="ip_method" value="5" onClick="javascript:cng_input1()">��ü
           
			</td>
          </tr>		  		    
        </table>
	  </td>
    </tr>
    
   
    <tr>
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>�Է±���</td>
            <td colspan="3">&nbsp;
			  <input type="radio" name="incom_gubun" value="1" checked >�����Է� 
			  <input type="radio" name="incom_gubun" value="2" >���ݼ��� 
             
			</td>
          </tr>		  		    
        </table>
	  </td>
    </tr>
 
 
	<tr>
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
    <tr id=tr_pay1 style="display:''">
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>�Ա�����</td>
            <td>&nbsp;
			  <select name='bank_code' onChange='javascript:change_bank()'>
                      <option value=''>����</option>
                      <%if(bank_size > 0){
						for(int i = 0 ; i < bank_size ; i++){
							CodeBean bank = banks[i];	%>
                      <option value='<%= bank.getCode()%>:<%= bank.getNm()%>'><%= bank.getNm()%></option>
                      <%	}
					}	%>
                    </select>
                 <input type='text' name='bank_code3' readonly	value=''>     
                 <input type='hidden' name='tran_date' 	value=''> 
                 <input type='hidden' name='tran_date_seq' 	value=''> 
                 <input type='hidden' name='bank_id' 	value=''> 
                 <input type='hidden' name='acct_num' 	value=''> 
                 <input type='hidden' name='acct_seq' 	value=''> 
              
			</td>	
		  </tr>
		  <tr>
            <td class=title>���¹�ȣ</td>
            <td>&nbsp;
			  <select name='deposit_no'>
                      <option value=''>���¸� �����ϼ���</option>
                    </select>
              <input type='text' name='deposit_no3' readonly	value=''>          
			</td>
          </tr>		  
          <tr> 
            <td class=title>����</td>
            <td>&nbsp;
			  <input type='text' name='remark' size='100' class='text' value=""></td>
		  </tr>
		  <tr>			  
            <td class=title>�ŷ���</td>
            <td>&nbsp;
			  <input type='text' name='bank_office' size='40' class='text' value=''></td>
          </tr>		  
        </table>
	  </td>
    </tr>
    <tr id=tr_pay2 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>ī���</td>
            <td>&nbsp;
              <input type="radio" name="card_cd" value="1" >BC    <!-- BC -->
			  <input type="radio" name="card_cd" value="2" >����  <!--���� -->
			  <input type="radio" name="card_cd" value="3" >����  <!--���� -->
			  <input type="radio" name="card_cd" value="4" >�ϳ�  <!--��ȯ -> �ϳ�(20150624)-->
			  <input type="radio" name="card_cd" value="5" >�Ե�  <!--�Ե� -->
			  <input type="radio" name="card_cd" value="6" >����  <!--���� -->
			  <input type="radio" name="card_cd" value="7" >�Ｚ  <!--�Ｚ -->
			  <input type="radio" name="card_cd" value="8" >��Ƽ  <!--��Ƽ -->
			  <input type="radio" name="card_cd" value="9" >KCP  <!--��ȭ���� -->
			  <input type="radio" name="card_cd" value="12" >���̿�  <!--��ȭ���� --> 
			  <input type="radio" name="card_cd" value="11" >���̽�  <!--ī�� cms���� --> 
			  <input type="radio" name="card_cd" value="13" >�̳����� <!--sms����  --> 
			 
		<!--	   <input type="radio" name="card_cd" value="10" >KCP2  --><!--�¶��� --> 
             <input type='hidden' name='card_nm' size='40' class='text' value="">
			
			</td>				
          </tr>		
     		      
          <tr> 				  
            <td class=title>ī���ȣ</td>
            <td>&nbsp;
			  <input type='text' name='card_no' size='40' class='text' value="">
			</td>
          </tr>
       
          <tr> 
            <td class=title>����</td>
            <td>&nbsp;
			  <input type='text' name='remark1' size='100' class='text' value=""></td>
		  </tr>	  	
<!--		    
          <tr> 
            <td class=title>���ݻ��</td>
            <td>&nbsp;
			  <select name="card_get_id">
			    <option value="">����</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select></td>
          </tr>	
 -->       
        </table>
	  </td>
    </tr>
    <tr id=tr_pay3 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>�������</td>
            <td>&nbsp;
			  <input type='text' name='cash_area' size='40' class='text' value="">
			</td>					  
          </tr>		  
          <tr> 
            <td class=title>����</td>
            <td>&nbsp;
			  <input type='text' name='remark2' size='100' class='text' value=""></td>
		  </tr>	 
		  <tr> 
            <td class=title>���ݻ��</td>
            <td>&nbsp;
			  <select name="cash_get_id">
			    <option value="">����</option>
                <%if(user_size > 0){
					for(int i = 0 ; i < user_size ; i++){
						Hashtable user = (Hashtable)users.elementAt(i); %>
                <option value='<%=user.get("USER_ID")%>'><%=user.get("USER_NM")%></option>
                <%	}
				}		%>
              </select>
			</td>
          </tr>	 	  
        </table>
	  </td>
    </tr>
   
    <tr id=tr_pay5 style='display:none'>
      <td class=line> 
        <table border="0" cellspacing="1" cellpadding='0' width=100%>
          <tr> 
            <td class=title width=13%>����</td>
            <td>&nbsp;
			  <input type='text' name='remark5' size='100' class='text' value="">
			</td>					  
          </tr>		  
      
        </table>
	  </td>
    </tr>
    <tr>
      <td>&nbsp;</td>
    </tr>
       <%if(auth_rw.equals("4")||auth_rw.equals("6")){%> 
    <tr>
		<td align="right"><a href="javascript:save();"><img src=/acar/images/center/button_next.gif border=0 align=absmiddle></a></td>
	</tr>	
	<% } %>	
		
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
<script language="JavaScript">
<!--	
//-->
</script>
</body>
</html>
