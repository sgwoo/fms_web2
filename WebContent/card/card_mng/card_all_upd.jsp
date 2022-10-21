<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*, acar.pay_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	String vid[] 	= request.getParameterValues("ch_cd");
	String cardno 	= "";
	
	int vid_size = vid.length;
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("CODE", "Y");
	int ck_size = card_kinds.size();
	
	
	
	//������¹�ȣ -> neoe_db ��ȯ
	Vector banks = ps_db.getDepositList();
	int bank_size = banks.size();
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	//����
	function Save(){
		var fm = document.form1;
		if(confirm('�ϰ������Ͻðڽ��ϱ�?')){					
			fm.action='card_all_upd_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}

	//�׿�����ȸ
	function Neom_search(s_kd){
		var fm = document.form1;
		fm.s_kd.value = s_kd;
		if(s_kd == 'cardno')	fm.t_wd.value = fm.cardno.value;
		window.open("about:blank",'Neom_search','scrollbars=yes,status=no,resizable=yes,width=600,height=500,left=250,top=250');		
		fm.action = "neom_search.jsp";
		fm.target = "Neom_search";
		fm.submit();		
	}
	function Neom_enter(s_kd) {
		var keyValue = event.keyCode;
		if (keyValue =='13') Neom_search(s_kd);
	}	
	
	//������ȸ
	function User_search(nm, idx){
		var fm = document.form1;
		var t_wd = fm.user_nm[idx].value;
		window.open("about:blank",'User_search','scrollbars=yes,status=no,resizable=yes,width=400,height=400,left=250,top=250');		
		fm.action = "user_search.jsp?nm="+nm+"&idx="+idx+"&t_wd="+t_wd;
		fm.target = "User_search";
		fm.submit();		
	}
	function enter(nm, idx) {
		var keyValue = event.keyCode;
		if (keyValue =='13') User_search(nm, idx);
	}		
//-->
</script>

</head>
<body topmargin="10">
<form action="card_all_upd_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<%for(int i=0;i < vid_size;i++){
	cardno = vid[i];%>
<input type='hidden' name='cardno' value='<%=cardno%>'>
<%}%>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�繫ȸ�� > ����ī����� > <span class=style5>�ſ�ī�� �ϰ�����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tr><td class=line2></td></tr> 	
    <tr>
      <td class="line">
	<table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='10%' class='title'>����</td>		  
            <td width='10%' class='title'>��������</td>
            <td width='20%' class='title'>�׸�</td>
            <td width="60%" class='title'>����</td>
          </tr>		  
          <tr>
            <td class='title'>1</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="1"></td>
            <td class='title'>�뵵����</td>
            <td>&nbsp;
              <select name="card_st" >
            	<option value=''>����</option>
		<option value='1'>�����ڱݿ�</option>
		<option value='2'>����</option>
		<option value='3'>��/�������޿�</option>
		<option value='4'>�����н�</option>				
		<option value='5'>���ݳ��ο�</option>	
		<option value='6'>����Ʈ</option>			
              </select>        
	    </td>
          </tr>
          <tr>
	    <td class='title'>2</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="2"></td>
            <td class='title'>ī������</td>
            <td>&nbsp;
              <select name="card_type" >
            	<option value=''>����</option>
		<option value='1'>VISA</option>
		<option value='2'>MASTER</option>
		<option value='3'>BC</option>
		<option value='4'>DYNASTY</option>				
              </select>        
	    </td>
          </tr>
          <tr>
	    <td class='title'>3</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="3"></td>
            <td class='title'>ī������</td>
            <td>&nbsp;
              <select name="card_kind" >
            	<option value=''>����</option>
            	<%if(ck_size > 0){
			for (int i = 0 ; i < ck_size ; i++){
				Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
            	<option value='<%= card_kind.get("CODE") %>'><%= card_kind.get("CARD_KIND") %></option>
            	<%	}
		}%>
              </select>      
	    </td>
          </tr>
          <tr>
	    <td class='title'>4</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="4"></td>
            <td class='title'>�ŷ�ó</td>
            <td>&nbsp;  
	      <input type='text' name='ven_code' value='' size="6" class="text" redeonly>&nbsp;<input name="ven_name" type="text" class="text" value="" size="30"> <a href="javascript:search('');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>			
          <tr>
	    <td class='title'>5</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="5"></td>
            <td class='title'>������</td>
            <td>&nbsp; �ſ� 
              <input type="text" name="pay_day" size="2" class=text>
              �� ���� </td>
          </tr>
          <tr>
	    <td class='title'>6</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="6"></td>
            <td class='title'>ī����Ⱓ</td>
            <td>&nbsp;
              <select name="use_s_m" >
                <option value="">����</option>			  
                <option value="1">������</option>
                <option value="2">����</option>
              </select>
              <input type="text" name="use_s_day" size="2" class=text>
		�� ~ 
	      <select name="use_e_m" >
                <option value="">����</option>			  
  		<option value="2">����</option>
  		<option value="3">���</option>
	      </select>
	      <input type="text" name="use_e_day" size="2" class=text>
		��</td>
          </tr>
          <tr>
	    <td class='title'>7</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="7"></td>
            <td class='title'>�ѵ�����</td>
            <td>&nbsp;
	      <select name="limit_st" >
                <option value="">����</option>			
                <option value="1">�����ѵ�</option>
                <option value="2">�����ѵ�</option>
              </select></td>
          </tr>
          <tr>
	    <td class='title'>8</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="8"></td>
            <td class='title'>�ѵ��ݾ�</td>
            <td>&nbsp;
	      <input type="text" name="limit_amt" size="10" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
		��</td>
          </tr>
          <tr>
	    <td class='title'>9</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="9"></td>
            <td class='title'>ī���������</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="text" onBlur='javascript:this.value=ChangeDate(this.value)' value="" size="12"></td>
          </tr>
          <tr>
	    <td class='title'>10</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="10"></td>
            <td class='title'>���ϸ�������</td>
            <td>&nbsp;
              <select name="mile_st" >
                <option value="">����</option>
                <option value="1">����</option>
                <option value="2">�װ���</option>
              </select></td>
          </tr>
          <tr>
	    <td class='title'>11</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="11"></td>
            <td class='title'>���ϸ���������</td>
            <td>&nbsp;
              <input type="text" name="mile_per" size="10" value="" class=text>
      	    </td>
          </tr>
          <tr>
	    <td class='title'>12</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="12"></td>
            <td class='title'>���ϸ����ѵ��ݾ�</td>
            <td>&nbsp;
              <input type="text" name="mile_amt" size="10" value="" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      		��</td>
          </tr>			
          <tr>
	    <td class='title'>13</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="13"></td>
            <td class='title'>ī�������</td>
            <td>&nbsp;
		  <input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('card_mng_id', 0)">
		  <input type='hidden' name='card_mng_id' value=''>
              	  <a href="javascript:User_search('card_mng_id', 0);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
          <tr>
	    <td class='title'>14</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="14"></td>
            <td class='title'>��ǥ������</td>
            <td>&nbsp;
              	<input name="user_nm" type="text" class="text" value="" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('doc_mng_id', 1)">
		<input type='hidden' name='doc_mng_id' value=''>
              	<a href="javascript:User_search('doc_mng_id', 1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
          <tr>
	    <td class='title'>15</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="15"></td>
            <td class='title'>�߱�����</td>
            <td>&nbsp;
                  <input name="card_sdate" type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>
          <tr>
	    <td class='title'>16</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="16"></td>
            <td class='title'>��������</td>
            <td>&nbsp;
                  <input name="card_edate" type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
          </tr>	
          <tr>
	    <td class='title'>17</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="17"></td>
            <td class='title'>��������</td>
            <td>&nbsp;
            	<select name='acc_no'>
                  <option value=''>���¸� �����ϼ���</option>
		  <%	if(bank_size > 0){
				for(int i = 0 ; i < bank_size ; i++){
					Hashtable bank = (Hashtable)banks.elementAt(i);%>
		  <option value='<%= bank.get("DEPOSIT_NO")%>'>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
		  <%		}
			}%>
                </select>
	      </td>
            </tr>	
        <tr>
	    <td class='title'>18</td>		  
            <td class='title'><input type="checkbox" name="u_chk" value="18"></td>
            <td class='title'>���ұ���</td>
            <td>&nbsp;
            	<select name="card_paid" >
            	<option value=''>����</option>
				<option value='2'>����ī��</option>
				<option value='3'>�ĺ�ī��</option>
				<option value='5'>����Ʈ</option>
				<option value='7'>ī���Һ�</option>
          	  </select> 
	      </td>
            </tr>	
          </table>
        </td>
      </tr>		
      <tr> 
      	 <td align="right">
      	 	<a href="javascript:window.Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
      		&nbsp;
	  	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
      </tr>
</table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
