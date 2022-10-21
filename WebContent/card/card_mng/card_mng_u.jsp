<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*, acar.pay_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	PaySearchDatabase ps_db = PaySearchDatabase.getInstance();
	
	//ī������
	CardBean c_bean = CardDb.getCard(cardno);
	
	//�ŷ�ó����
	Hashtable v_ht = new Hashtable();
	if(!c_bean.getCom_code().equals("")){
		v_ht = neoe_db.getVendorCase(c_bean.getCom_code());
	}
	
	//������¹�ȣ
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
	function Save_neom(){
		var fm = document.form1;
		if(confirm('����Ͻðڽ��ϱ�?')){					
			fm.action='card_mng_neom_i_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
	
	//����
	function Save(){
		var fm = document.form1;
		
		if(fm.use_s_m.value == fm.use_e_m.value){
			if(toInt(fm.use_s_day.value) >= toInt(fm.use_e_day.value)){
				alert('ī����Ⱓ ���ڸ� Ȯ���Ͻʽÿ�.'); return;
			}
		}
		
		if(confirm('�����Ͻðڽ��ϱ�?')){					
			fm.action='card_mng_u_a.jsp';		
			fm.target='i_no';
			fm.submit();
		}
	}
		
	//�ŷ�ó��ȸ�ϱ�
	function search(idx){
		var fm = document.form1;
		var t_wd = "ī��";
		if(fm.ven_name.value != '')	t_wd = fm.ven_name.value;
		window.open("/acar/con_debt/vendor_list.jsp?idx="+idx+"&t_wd="+t_wd, "VENDOR_LIST", "left=300, top=300, width=450, height=400, scrollbars=yes");		
	}	
	
	function Close(){
		var fm = document.form1;
		fm.action='card_mng_sc.jsp';		
		fm.target='c_foot';
		fm.submit();
		
		window.close();
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
<body topmargin="10" onload="javascript:document.form1.card_name.focus();">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value='u'>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ����ī����� > <span class=style5>�ſ�ī�� ����</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td class=h></td></tr>  
	<tr><td class=line2></td></tr>  
    <tr>
        <td class="line">
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='22%'  class='title'>�ſ�ī���ȣ</td>
                    <td>&nbsp;
                      <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" redeonly>
                      <%if(neoe_db.getCodeByNm("cardno", cardno).equals("")){//-> neoe_db ��ȯ%>
                      <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
			  <a href="javascript:Save_neom();">�׿��� ī�� <img src=/acar/images/center/button_reg.gif border=0 align=absmiddle></a>
		      <%}%>
		      <%}%>
		    </td>
                </tr>
                <tr>
                      <td class='title'>ī������</td>
                      <td>&nbsp;
                      	  <%=c_bean.getCard_kind()%>
                          <input type='hidden' name='card_kind' value='<%=c_bean.getCard_kind()%>'>
                          <input type='hidden' name='card_kind_cd' value='<%=c_bean.getCard_kind_cd()%>'>
                      </td>
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
                    <td width='22%' class='title'>�뵵����</td>
                    <td>&nbsp;
                  	  <select name="card_st" >
                    	<option value=''>����</option>
        				<option value='1' <%if(c_bean.getCard_st().equals("1")){%>selected<%}%>>�����ڱݿ�</option>
        				<option value='2' <%if(c_bean.getCard_st().equals("2")){%>selected<%}%>>����</option>
        				<option value='3' <%if(c_bean.getCard_st().equals("3")){%>selected<%}%>>��/�������޿�</option>
        				<option value='4' <%if(c_bean.getCard_st().equals("4")){%>selected<%}%>>�����н�</option>						
					<option value='5' <%if(c_bean.getCard_st().equals("5")){%>selected<%}%>>���ݳ��ο�</option>	
					<option value='6' <%if(c_bean.getCard_st().equals("6")){%>selected<%}%>>����Ʈ</option>								
                  	  </select>        
        			  </td>
                </tr>		  

          <tr>
            <td class='title'>���ұ���</td>
            <td>&nbsp;
          	  <select name="card_paid" >
            	<option value=''>����</option>
				<option value='2' <%if(c_bean.getCard_paid().equals("2")){%>selected<%}%>>����ī��</option>
				<option value='3' <%if(c_bean.getCard_paid().equals("3")){%>selected<%}%>>�ĺ�ī��</option>
				<option value='5' <%if(c_bean.getCard_paid().equals("5")){%>selected<%}%>>����Ʈ</option>
				<option value='7' <%if(c_bean.getCard_paid().equals("7")){%>selected<%}%>>ī���Һ�</option>
          	  </select>        
			  </td>
          </tr>                      
            <tr>
              <td class='title'>�ŷ�ó</td>
              <td>&nbsp;
                  <input type='text' name='ven_code' value='<%=c_bean.getCom_code()%>' size="6" class="text" redeonly>&nbsp;<input name="ven_name" type="text" class="text" value="<%=v_ht.get("VEN_NAME")%>" size="30">&nbsp; <a href="javascript:search('');"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a>
                                </td>
            </tr>
            <tr>
              <td class='title'>����ڱ���</td>
              <td>&nbsp;
                  <input name="card_name" type="text" class="text" value="<%=c_bean.getCard_name()%>" size="30"></td>
            </tr>
            <tr>
              <td class='title'>�߱�����</td>
              <td>&nbsp;
                  <input name="card_sdate" type="text" class="text" value="<%=AddUtil.ChangeDate2(c_bean.getCard_sdate())%>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>��������</td>
              <td>&nbsp;
                  <input name="card_edate" type="text" class="text" value="<%=AddUtil.ChangeDate2(c_bean.getCard_edate())%>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>������</td>
              <td>&nbsp; �ſ�
                  <input type="text" name="pay_day" size="2" value="<%=c_bean.getPay_day()%>" class=text>
     			 �� ���� 
			  </td>
            </tr>
            <tr>
              <td class='title'>��������</td>
              <td>&nbsp; <select name='acc_no'>
                        <option value=''>���¸� �����ϼ���</option>
					    <%	if(bank_size > 0){
								for(int i = 0 ; i < bank_size ; i++){
									Hashtable bank = (Hashtable)banks.elementAt(i);%>
						<option value='<%= bank.get("DEPOSIT_NO")%>' <%if(c_bean.getAcc_no().equals(String.valueOf(bank.get("DEPOSIT_NO")))){%>selected<%}%>>[<%=bank.get("CHECKD_NAME")%>]<%= bank.get("DEPOSIT_NO")%>&nbsp;:&nbsp;<%= bank.get("DEPOSIT_NAME")%></option>
			            <%		}
							}%>

                      </select>
			  </td>
            </tr>
            <tr>
              <td class='title'>ī����Ⱓ</td>
              <td>&nbsp;
                  <select name="use_s_m" >
                    <option value="1" <%if(c_bean.getUse_s_m().equals("1")){%>selected<%}%>>������</option>
                    <option value="2" <%if(c_bean.getUse_s_m().equals("2")){%>selected<%}%>>����</option>
                  </select>
                  <input type="text" name="use_s_day" size="2" value="<%=c_bean.getUse_s_day()%>" class=text>
			      �� ~
			      <select name="use_e_m" >
			        <option value="2" <%if(c_bean.getUse_e_m().equals("2")){%>selected<%}%>>����</option>
			        <option value="3" <%if(c_bean.getUse_e_m().equals("3")){%>selected<%}%>>���</option>
			      </select>
				  <%if(c_bean.getUse_e_day().equals("99")){%>
			      <input type="text" name="use_e_day" size="2" value="��" class=text>
				  <%}else{%>
			      <input type="text" name="use_e_day" size="2" value="<%=c_bean.getUse_e_day()%>" class=text>
				  <%}%>
				  ��
      		  </td>
            </tr>
            <tr>
              <td class='title'>�ѵ�����</td>
              <td>&nbsp;
                  <select name="limit_st" >
                    <option value="1" <%if(c_bean.getLimit_st().equals("1")){%>selected<%}%>>�����ѵ�</option>
                    <option value="2" <%if(c_bean.getLimit_st().equals("2")){%>selected<%}%>>�����ѵ�</option>
                </select></td>
            </tr>
            <tr>
              <td class='title'>�ѵ��ݾ�</td>
              <td>&nbsp;
                  <input type="text" name="limit_amt" size="15" value="<%=AddUtil.parseDecimalLong(c_bean.getLimit_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      		��</td>
            </tr>
            <tr>
              <td class='title'>���ϸ�������</td>
              <td>&nbsp;
                  <select name="mile_st" >
                    <option value="" <%if(c_bean.getMile_st().equals("")){%>selected<%}%>>����</option>
                    <option value="1" <%if(c_bean.getMile_st().equals("1")){%>selected<%}%>>����</option>
                    <option value="2" <%if(c_bean.getMile_st().equals("2")){%>selected<%}%>>�װ���</option>
                </select></td>
            </tr>
            <tr>
              <td class='title'>���ϸ���������</td>
              <td>&nbsp;
                  <input type="text" name="mile_per" size="10" value="<%=c_bean.getMile_per()%>" class=text>
      		</td>
            </tr>
            <tr>
              <td class='title'>���ϸ����ѵ��ݾ�</td>
              <td>&nbsp;
                  <input type="text" name="mile_amt" size="15" value="<%=Util.parseDecimal(c_bean.getMile_amt())%>" class=num onBlur='javascript:this.value=parseDecimal(this.value)'>
      		��</td>
            </tr>			
          <tr>
            <td class='title'>ī���������</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(c_bean.getReceive_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="11"></td>
          </tr>
          <tr>
            <td class='title'>ī�������</td>
            <td>&nbsp;
			  <input name="user_nm" type="text" class="text" value="<%=c_db.getNameById(c_bean.getCard_mng_id(),"USER")%>" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('card_mng_id', 0)">
			  <input type='hidden' name='card_mng_id' value='<%=c_bean.getCard_mng_id()%>'>
              <a href="javascript:User_search('card_mng_id',0);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
          <tr>
            <td class='title'>��ǥ������</td>
            <td>&nbsp;
              <input name="user_nm" type="text" class="text" value="<%=c_db.getNameById(c_bean.getDoc_mng_id(),"USER")%>" size="10" style='IME-MODE: active' onKeyDown="javasript:enter('doc_mng_id', 1)">
			  <input type='hidden' name='doc_mng_id' value='<%=c_bean.getDoc_mng_id()%>'>
              <a href="javascript:User_search('doc_mng_id',1);"><img src=/acar/images/center/button_in_search1.gif border=0 align=absmiddle></a></td>
          </tr>
            <tr>
              <td class='title'>���</td>
              <td>&nbsp;
                  <input type="text" name="etc" size="65" value="<%=c_bean.getEtc()%>" class=text>
              </td>			  
            </tr>
            <tr>
              <td class='title'>�󼼿뵵</td>
              <td>&nbsp;
                  <input type="text" name="card_chk" size="50" value="<%=c_bean.getCard_chk()%>" class=text>
              </td>			  
            </tr>
			<%if(c_bean.getUse_yn().equals("N")){%>
            <tr>
              <td class='title'>�������</td>
              <td>&nbsp;
                  <input name="cls_dt" type="text" class="text" value="<%=AddUtil.ChangeDate2(c_bean.getCls_dt())%>" size="11" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>������</td>
              <td>&nbsp;
                  <input type="text" name="cls_cau" size="70" value="<%=c_bean.getCls_cau()%>" class=text>
              </td>
            </tr>			
			<%}else{%>
			<input type='hidden' name='cls_dt' value='<%=AddUtil.ChangeDate2(c_bean.getCls_dt())%>'>
			<input type='hidden' name='cls_cau' value='<%=c_bean.getCls_cau()%>'>			
			<%}%>			
          </table></td>
  </tr>
    <tr> 
      <td align="right">
        <%if( auth_rw.equals("2") || auth_rw.equals("4") || auth_rw.equals("6")) {%>
        <a href="javascript:Save();"><img src=/acar/images/center/button_modify.gif border=0 align=absmiddle></a>
        &nbsp;
        <%}%>
	<a href="javascript:Close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>
<!--	
    <tr>
      <td><hr></td>
    </tr>  
    <tr>
      <td><font color="#0099CC"><img src="../../images/arrow2.gif" width="12" height="9">������ :</font>
        <select name="pay_month" >
		<%for(int i =2000; i<AddUtil.getDate2(1)+1; i++){%>
          <option value="<%=i%>" selected><%=i%>�⵵</option>
		<%}%>
        </select>
	  </td>
    </tr>  
    <tr>
      <td class="line"><table border="0" cellspacing="1" cellpadding="0" width='100%'>
        <tr>
          <td width='15%' class='title'>��</td>
          <td width="35%" class='title'>�Ǽ�</td>
          <td width="50%" class='title'>�ݾ�</td>
        </tr>
		<%for(int i =1; i<=12; i++){%>
        <tr>
          <td align="center"><%=i%>��</td>
          <td>&nbsp;</td>
          <td>&nbsp;</td>
        </tr>
		<%}%>
      </table></td>
    </tr>  -->
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
