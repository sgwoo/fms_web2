<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	//ī������
	CardBean c_bean = CardDb.getCard(cardno);
	
	//�ŷ�ó���� -> neoe_db ��ȯ
	Hashtable v_ht = new Hashtable();
	if(!c_bean.getCom_code().equals("")){
		v_ht = neoe_db.getVendorCase(c_bean.getCom_code());
	}
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("", "");
	int ck_size = card_kinds.size();
	
	
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
		if(confirm('����Ͻðڽ��ϱ�?')){					
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
//-->
</script>

</head>
<body topmargin="10">
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='mode' value='d'>
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ����ī����� > <span class=style5>�ſ�ī�� ���</span></span></td>
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
                                </td>
            </tr>
          </table></td>
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
          	  <select name="card_st" disabled>
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
              <td width='22%' class='title'>ī������</td>
              <td>&nbsp;
                  <select name="card_kind" disabled>
                    <option value=''>����</option>
                    <%	if(ck_size > 0){
						for (int i = 0 ; i < ck_size ; i++){
							Hashtable card_kind = (Hashtable)card_kinds.elementAt(i);%>
                    <option value='<%= card_kind.get("CARD_KIND") %>' <%if(String.valueOf(card_kind.get("CARD_KIND")).equals(c_bean.getCard_kind())){%>selected<%}%>><%= card_kind.get("CARD_KIND") %></option>
                    <%		}
					}%>
                  </select>
              </td>
            </tr>
            <tr>
              <td class='title'>�ŷ�ó</td>
              <td>&nbsp;
                  <input type='text' name='ven_code' value='<%=c_bean.getCom_code()%>' size="6" class="white" redeonly>&nbsp;<input name="ven_name" type="text" class="white" value="<%=v_ht.get("VEN_NAME")%>" size="30">&nbsp;
                                </td>
            </tr>
            <tr>
              <td class='title'>����ڱ���</td>
              <td>&nbsp;
                  <input name="card_name" type="text" class="whitetext" value="<%=c_bean.getCard_name()%>" size="30"></td>
            </tr>
            <tr>
              <td class='title'>�߱�����</td>
              <td>&nbsp;
                  <input name="card_sdate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_sdate())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>��������</td>
              <td>&nbsp;
                  <input name="card_edate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_edate())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>������</td>
              <td>&nbsp; �ſ�
                  <input type="text" name="pay_day" size="2" value="<%=c_bean.getPay_day()%>" class=whitetext>
     			 �� ���� 
			  </td>
            </tr>
            <tr>
              <td class='title'>ī����Ⱓ</td>
              <td>&nbsp;
                  <select name="use_s_m" disabled>
                    <option value="1" <%if(c_bean.getUse_s_m().equals("1")){%>selected<%}%>>������</option>
                    <option value="2" <%if(c_bean.getUse_s_m().equals("2")){%>selected<%}%>>����</option>
                  </select>
                  <input type="text" name="use_s_day" size="2" value="<%=c_bean.getUse_s_day()%>" class=whitetext>
			      �� ~
			      <select name="use_e_m" disabled>
			        <option value="2" <%if(c_bean.getUse_e_m().equals("2")){%>selected<%}%>>����</option>
			        <option value="3" <%if(c_bean.getUse_e_m().equals("3")){%>selected<%}%>>���</option>
			      </select>
				  <%if(c_bean.getUse_e_day().equals("99")){%>
			      <input type="text" name="use_e_day" size="2" value="��" class=whitetext>
				  <%}else{%>
			      <input type="text" name="use_e_day" size="2" value="<%=c_bean.getUse_e_day()%>" class=whitetext>
				  <%}%>
				  ��
      		  </td>
            </tr>
            <tr>
              <td class='title'>�ѵ�����</td>
              <td>&nbsp;
                  <select name="limit_st" disabled>
                    <option value="1" <%if(c_bean.getLimit_st().equals("1")){%>selected<%}%>>�����ѵ�</option>
                    <option value="2" <%if(c_bean.getLimit_st().equals("2")){%>selected<%}%>>�����ѵ�</option>
                </select></td>
            </tr>
            <tr>
              <td class='title'>�ѵ��ݾ�</td>
              <td>&nbsp;
                  <input type="text" name="limit_amt" size="10" value="<%=AddUtil.parseDecimalLong(c_bean.getLimit_amt())%>" class=whitenum onBlur='javascript:this.value=parseDecimal(this.value)'>
      		��</td>
            </tr>
          <tr>
            <td class='title'>ī���������</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getReceive_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="12"></td>
          </tr>
          <tr>
            <td class='title'>ī�������</td>
            <td>&nbsp;
			  <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getCard_mng_id(),"USER")%>" size="10" style='IME-MODE: active'><input type='hidden' name='card_mng_id' value='<%=c_bean.getCard_mng_id()%>'>
              <!--<input type="button" name="b_ms2" value="�˻�" class="btn" onClick="javascript:User_search('card_mng_id', 0);" >--></td>
          </tr>
          <tr>
            <td class='title'>��ǥ������</td>
            <td>&nbsp;
              <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getDoc_mng_id(),"USER")%>" size="10" style='IME-MODE: active'><input type='hidden' name='doc_mng_id' value='<%=c_bean.getDoc_mng_id()%>'>
            </td>
          </tr>
            <tr>
              <td class='title'>���</td>
              <td>&nbsp;
                  <input type="text" name="etc" size="70" value="<%=c_bean.getEtc()%>" class=whitetext>
              </td>
            </tr>
            <tr>
              <td class='title'>�������</td>
              <td>&nbsp;
                  <input name="cls_dt" type="text" class="text" value="" size="12" onBlur='javascript:this.value=ChangeDate(this.value)'></td>
            </tr>
            <tr>
              <td class='title'>������</td>
              <td>&nbsp;
                  <input type="text" name="cls_cau" size="68" value="" class=text>
              </td>
            </tr>			
          </table></td>
  		</tr>
    	<tr> 
      	  <td align="right">
      	  	<a href="javascript:window.Save();"><img src=/acar/images/center/button_dis.gif border=0 align=absmiddle></a>
      		&nbsp;
	  	<a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a></td>
    	</tr>	
  </table>
</form>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
