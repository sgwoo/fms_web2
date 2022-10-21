<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String cardno 	= request.getParameter("cardno")==null?"":request.getParameter("cardno");

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//ī������
	CardBean c_bean = CardDb.getCard(cardno);
	
	Vector vts = CardDb.getCardMngHList(cardno);
	int vt_size = vts.size();
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//ī�峻�뺸��
	function CardMngUpd(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_u.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}
	//ī�����ó���ϱ�
	function CardMngDel(cardno){
		var fm = document.form1;
		fm.cardno.value = cardno;
		fm.action = "card_mng_d.jsp";
		window.open("about:blank", "CardMngView", "left=50, top=50, width=600, height=550, scrollbars=yes, status=yes");
		fm.target = "CardMngView";
		fm.submit();
	}	
//-->
</script>
</head>
<body>
<form action="./client_mng_frame.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='idx' value='<%=idx%>'>
<input type='hidden' name='cardno' value=''>
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
    <tR>
        <td class=line2></td>
    </tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
            <tr>
              <td width='15%'  class='title'>�ſ�ī���ȣ</td>
              <td>&nbsp;
                  <input name="cardno" type="text" class="whitetext" value="<%=cardno%>" size="30" redeonly> 
              </td>
            </tr>
          <tr>
            <td class='title'>����ڱ���</td>
            <td>&nbsp; 
			  <input name="card_name" type="text" class="whitetext" value="<%=c_bean.getCard_name()%>" size="30" redeonly></td>
          </tr>			
          <tr>
            <td class='title'>�߱�����</td>
            <td>&nbsp;
			  <input name="card_sdate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_sdate())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)' redeonly></td>
          </tr>
          <tr>
            <td class='title'>��������</td>
            <td>&nbsp;
			  <input name="card_edate" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getCard_edate())%>" size="12" onBlur='javascript:this.value=ChangeDate(this.value)' redeonly></td>
          </tr>
          <tr>
            <td class='title'>ī���������</td>
            <td>&nbsp;
              <input name="receive_dt" type="text" class="whitetext" value="<%=AddUtil.ChangeDate2(c_bean.getReceive_dt())%>" onBlur='javascript:this.value=ChangeDate(this.value)' size="12" redeonly></td>
          </tr>
          <tr>
            <td class='title'>ī�������</td>
            <td>&nbsp;
                <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getCard_mng_id(),"USER")%>" size="10" style='IME-MODE: active' redeonly>
                <input type='hidden' name='card_mng_id' value='<%=c_bean.getCard_mng_id()%>'>
                            </td>
          </tr>
          <tr>
            <td class='title'>��ǥ������</td>
            <td>&nbsp;
                <input name="user_nm" type="text" class="whitetext" value="<%=c_db.getNameById(c_bean.getDoc_mng_id(),"USER")%>" size="10" style='IME-MODE: active' redeonly>
                <input type='hidden' name='doc_mng_id' value='<%=c_bean.getDoc_mng_id()%>'>
                            </td>
          </tr>
          </table></td>
  </tr>
    <tr> 
      <td align="right">&nbsp;</td>
    </tr>
    <tR>
        <td class=line2></td>
    </tr>		  
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
            <td width='5%' class='title'>����</td>
            <td width='20%' class='title'>�ٹ���</td>
            <td width='15%' class='title'>�μ�</td>
            <td width='20%' class='title'>�̸�</td>
            <td width='20%' class='title'>ī��������</td>
            <td width='20%' class='title'>ī��ȸ����</td>
            </tr>
		  <%if(vt_size > 0){%>
          <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vts.elementAt(i);%>		  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("BR_NM")%></td>
            <td align="center"><%=ht.get("DEPT_NM")%></td>
            <td align="center"><%=ht.get("USER_NM")%></td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_S_DT")))%></td>
            <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("USE_E_DT")))%></td>
            <%	}%>		  
          <%}else{%>	
          <tr align="center">
            <td colspan="7">��ϵ� ����Ÿ�� �����ϴ�.</td>
            </tr>		  
          <%}%>		  		  	  		  
        </table>
	</td>
  </tr>
  </table>
</form>
</body>
</html>
