<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//ī������ ����Ʈ ��ȸ
	Vector card_kinds = CardDb.getCardKinds("CODE", "");
	int ck_size = card_kinds.size();	
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	String s_card = request.getParameter("s_card")==null?"":request.getParameter("s_card");
	String card_st = request.getParameter("card_st")==null?"":request.getParameter("card_st");
	
	//ī����� ����Ʈ ��ȸ
	Vector vt = new Vector();
	int vt_size = 0;	
	
	String content_code = "CARD_DOC";
	String content_seq  = card_kind; 
			
	//ī����� ��ĵ ����Ʈ ��ȸ
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;
	
	if(!card_kind.equals("")){
		vt = CardDb.getCardRegStat(card_kind, s_card);
		vt_size = vt.size();	
	
		attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);
		attach_vt_size = attach_vt.size();
	}
%>


<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function cng_card_kind(value){
		var fm = document.form1;
		fm.s_card.value = '';
		fm.action = "card_reg_sc.jsp";
		fm.target = "_self";
		fm.submit();
  }
  
	function card_Search(){
		var fm = document.form1;
		fm.action="card_reg_sc.jsp";
		fm.target="_self";
		fm.submit();
	}
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') card_Search();
	}	  
  
  function CardContReg(cardno, seq){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.seq.value = seq;
		fm.action = "card_cont_ui.jsp";
		window.open("about:blank", "CardContCase", "left=50, top=50, width=800, height=500, scrollbars=yes, status=yes");
		fm.target = "CardContCase";
		fm.submit();
  }
  
  function Card_cont_history(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_cont_list.jsp";
		window.open("about:blank", "CardContList", "left=50, top=50, width=1200, height=700, scrollbars=yes, status=yes");
		fm.target = "CardContList";
		fm.submit();
  }
  
	//��ĵ���
	function scan_reg(){
		window.open("reg_scan.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&card_kind=<%=card_kind%>", "SCAN", "left=10, top=10, width=720, height=400, scrollbars=yes, status=yes, resizable=yes");
	}	  
//-->
</script>
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='cardno' value=''>
<input type='hidden' name='seq' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>���(�ű�/����)</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='20%'  class='title'>�ŷ�ó��</td>
            <td>&nbsp;
              <select name="card_kind" id="card_kind" onChange="javascript:cng_card_kind(this.value)" >
                <option value=''>����</option>
                <%if(ck_size > 0){
                    for (int i = 0 ; i < ck_size ; i++){
                      Hashtable ht = (Hashtable)card_kinds.elementAt(i);
                      if(String.valueOf(ht.get("CARD_KIND")).equals("��������ī��")||String.valueOf(ht.get("CARD_KIND")).equals("�������ī��")||String.valueOf(ht.get("CARD_KIND")).equals("����ī��")) continue;
                %>
                <option value='<%= ht.get("CODE") %>' <%if(card_kind.equals(String.valueOf(ht.get("CODE")))){%>selected<%}%>><%= ht.get("CARD_KIND") %></option>
                <%	}
                  }
                %>
              </select>
              <%if(!card_kind.equals("")){// && vt_size > 2%>
              &nbsp;&nbsp;&nbsp;&nbsp;
              ī�� : <input name="s_card" type="text" class="text" value="<%=s_card%>" size="20" onKeyDown="javasript:enter()" style='IME-MODE: active'>
              &nbsp;<a href="javascript:card_Search();"><img src=/acar/images/center/button_in_search.gif border=0 align=absmiddle></a>
              <%}else{%>
              <input type='hidden' name='s_card' value=''>
              <%}%>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <%if(!card_kind.equals("")){%>
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><a href="javascript:CardContReg('','')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_reg.gif" align="absmiddle" border="0"></a></td>
    </tr>    
    <tr> 
        <td class=h></td>
    </tr>        
    <%if(vt_size > 0){%>
    <%  for (int i = 0 ; i < vt_size ; i++){
          Hashtable ht = (Hashtable)vt.elementAt(i);
          
          if( card_st.equals("") || 
        	  (card_st.equals("�����ڱݿ�") && String.valueOf(ht.get("CARD_ST")).equals(card_st)) || 
        	  (card_st.equals("��/�������޿�") && !String.valueOf(ht.get("CARD_ST")).equals("�����ڱݿ�")) || 
        	  (card_st.equals("���ݳ��ο�") && !String.valueOf(ht.get("CARD_ST")).equals("�����ڱݿ�"))
          ){
        	  
        		//ī������
        		CardBean c_bean = CardDb.getCard(String.valueOf(ht.get("CARDNO")));
        	  
       		 	  
    %>
    <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
          	<td width='5%' rowspan='4' class='title'><%=ht.get("CARD_PAID")%>
          		<br><a href="javascript:CardContReg('<%=ht.get("CARDNO")%>','<%=ht.get("SEQ")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_bg.gif" align="absmiddle" border="0"></a>
          	</td>
          	<td width='15%'  colspan=2 class='title'>ī��NO&nbsp;
          	 <a href="javascript:Card_cont_history('<%=ht.get("CARDNO")%>');"><img src=/acar/images/center/button_in_ir.gif border=0 align=absmiddle></a>	
          	</td>
            <td  width='30%' colspan=2>&nbsp;<font color=red><%=ht.get("CARDNO")%></font>
              &nbsp;&nbsp;&nbsp;&nbsp;
              <%if(!String.valueOf(ht.get("N_VEN_CODE")).equals("")){%>�Աݿ���:<%=ht.get("N_VEN_CODE")%>&nbsp;<%=ht.get("N_VEN_NAME")%><%}%>                       
            </td>
            <td  width='15%' colspan=2 class='title'>��ȿ�Ⱓ</td>
            <td >&nbsp;<%=AddUtil.ChangeDate2(c_bean.getCard_edate())%></td>
            <td  width='15%' colspan=2 class='title'>�߱�����</td>
            <td >&nbsp;<%=AddUtil.ChangeDate2(c_bean.getCard_sdate())%></td>
           </tr>
           <tr>  	
            <td rowspan=2  class='title'>�ſ��ѵ�</td>
            <td class='title'>�ݾ�</td>
            <td colspan=2 >&nbsp;<%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CONT_AMT")))%>��</td>
            <td rowspan=2  class='title'>���Ⱓ</td>
            <td class='title'>��������</td>
            <td>&nbsp;<%if(c_bean.getUse_s_m().equals("1")){%>������<%}%><%if(c_bean.getUse_s_m().equals("2")){%>����<%}%> <%=c_bean.getUse_s_day()%>��</td>
            <td rowspan=2  class='title'>CashBack</td>
            <td class='title'>������</td>
            <td>&nbsp;�Ϲ� : <%=ht.get("SAVE_PER1")%>%<%if(String.valueOf(ht.get("CARD_PAID")).equals("����ī��")||String.valueOf(ht.get("CARD_PAID")).equals("ī���Һ�")){%><br>&nbsp;���⿬�� : <%=ht.get("SAVE_PER2")%>%<%}%></td>            
          </tr>
          <tr>
            <td class='title'>��������</td>
            <td colspan=2>&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%></td>
            <td class='title'>��������</td>
            <td>&nbsp;<%if(c_bean.getUse_e_m().equals("2")){%>����<%}%><%if(c_bean.getUse_e_m().equals("3")){%>���<%}%> <%if(c_bean.getUse_e_day().equals("99")){%>����<%}else{%><%=c_bean.getUse_e_day()%>��<%} %></td>
            <td class='title'>�Աݿ�����</td>
            <td>&nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST1")).equals("Y")){%>����<%}%>
            	  &nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST2")).equals("Y")){%>������<%}%>
            	  &nbsp;<%if(String.valueOf(ht.get("SAVE_IN_DT_ST3")).equals("Y")){%>�ſ� <%=ht.get("SAVE_IN_DT")%>��<%}%>
            </td>          
          </tr> 
          <tr>
            <td colspan=2 class='title'>������� ��ȯ��������	</td>
            <td >&nbsp;�ſ� <%=ht.get("PAY_DAY")%>��</td>
            <td colspan=3  class='title'>�ſ�����ϼ�<%if(String.valueOf(ht.get("CARD_PAID")).equals("����ī��")){%><br>(����/���Ϻһ���)<%}%></td>
            <td  >&nbsp;<%=ht.get("GIVE_DAY")%>��
                    <%if(String.valueOf(ht.get("GIVE_DAY_ST")).equals("2")){%>
                    		(�޷���)
                    <%}else{%>
                    		(������)
                    <%}%>                       
            </td>
            <td colspan=2 class='title'>�ŷ�����(�뵵)</td>
            <td colspan=2>&nbsp;<%=ht.get("CARD_ST")%></td>
          </tr>     
        </table>
      </td>
    </tr>
    
    <tr> 
        <td class=h></td>
    </tr>
    
     <tr>
      <td class="line">
        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
          	<td width='5%' rowspan='4' class='title'>����� </td>
          	 <td class='title'>����</td>
             <td >&nbsp;<%=ht.get("AGNT_NM")%></td>
             <td width='5%' rowspan='4' class='title'>������</td>
          	 <td class='title'>����</td>  
          	 <td >&nbsp;<%=ht.get("MASTER_NM")%></td>
             <td width='15%' class='title'>�ڵ���ü�� ����</td> 
             <td colspan='2'>&nbsp;<%=c_bean.getAcc_no() %></td>     
           </tr>
           <tr>  	
            <td width='10%'  class='title'>����ó</td>
            <td width='10%'>&nbsp;<%=ht.get("AGNT_TEL")%></td>   
            <td width='10%' class='title'>����ó</td>
            <td width='10%'>&nbsp;<%=ht.get("MASTER_TEL")%></td>        
            <td rowspan='3'  class='title'>����</td>
            <td rowspan='3' colspan='2'>&nbsp;<%=ht.get("ETC")%></td>     
          </tr>
          <tr>
            <td class='title'>�μ�</td>        
            <td >&nbsp;</td>
            <td width='10%'  class='title'>�μ�</td>
            <td >&nbsp;</td>            
          </tr>  
          <tr>
            <td class='title'>E-Mail</td>       
            <td >&nbsp;</td>
            <td width='10%'  class='title'>E-Mail</td>
            <td>&nbsp;</td>            
          </tr>  
        </table>
      </td>
    </tr>
    
    <tr> 
        <td class=h></td>
    </tr>
    <tr> 
        <td><HR></td>
    </tr>  
    <%  	}%>
    <%  }%>    
    <%}%>
    <tr><td>�� ÷��(������) Scan&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:scan_reg()" title='����ϱ�'><img src=/acar/images/center/button_in_reg.gif align=absmiddle border=0></a></td></tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>����</td>
                    <td width='20%' class='title'>�������</td>
                    <td width='70%' class='title'>���ϸ�</td>
                    <td width='5%' class='title'>-</td>
                </tr>
                <%if(attach_vt_size > 0){
				            for (int i = 0 ; i < attach_vt_size ; i++){
					            Hashtable ht = (Hashtable)attach_vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=ht.get("REG_DATE")%></td>
                    <td align="center"><a href="javascript:openPopP('<%=ht.get("FILE_TYPE")%>','<%=ht.get("SEQ")%>');" title='����' ><%=ht.get("FILE_NAME")%></a></td>
                    <td align="center"><a href="https://fms3.amazoncar.co.kr/fms2/attach/delete.jsp?SEQ=<%=ht.get("SEQ")%>" target='_blank'><img src="/acar/images/center/button_in_delete.gif" align="absmiddle" border="0"></a></td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="4" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr>     
    <%}%>
  </table>
</form>
</body>
</html>
