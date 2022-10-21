<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.fee.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//ī�������
	Hashtable card_kind = CardDb.getCardKind(gubun2);
	
	Vector vts = CardDb.getCardKindPayStat(s_br, chk1, chk2, chk3, chk4, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, st_dt, end_dt, s_kd, t_wd1, t_wd2, sort, asc);
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
    <tr><td class=line2></td></tr>
    <tr>
      <td class="line">
	      <table border="0" cellspacing="1" cellpadding="0" width='100%'>	      	
            <tr>
              <td width='15%'  class='title'>ī������</td>
              <td>&nbsp;<%=card_kind.get("CARD_KIND")%>
              </td>
            </tr>
          <tr>
            <td class='title'>�ŷ�ó</td>
            <td>&nbsp;<%=card_kind.get("COM_NAME")%>
			  </td>
          </tr>			
          <tr>
            <td class='title'>�߱޸ż�</td>
            <td>&nbsp;<%=card_kind.get("CARD_CNT")%>��
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
            <td width='5%' class='title'>����</td>
            <td width='10%' class='title'>�뵵����</td>
            <td width='20%' class='title'>ī���ȣ</td>
            <td width='20%' class='title'>����ڱ���</td>
            <td width='15%' class='title'>�ѵ�</td>
            <td width='15%' class='title'>���ݾ�</td>
            <td width='15%' class='title'>�ѵ��ܾ�</td>
          </tr>
		  <%if(vt_size > 0){
				long t_amt[] = new long[12];
				String limit_st = "";%>
          <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vts.elementAt(i);
					long h_amt = AddUtil.parseLong(String.valueOf(ht.get("LIMIT_AMT")));
					long j_amt = h_amt-AddUtil.parseLong(String.valueOf(ht.get("BUY_AMT")));
					limit_st = String.valueOf(ht.get("LIMIT_ST"));
					if(limit_st.equals("2")) j_amt = 0;
					%>		  
          <tr>
            <td align="center"><%=i+1%></td>
            <td align="center"><%=ht.get("CARD_ST")%></td>
            <td align="center"><%=ht.get("CARDNO")%></td>
            <td align="center"><%=ht.get("CARD_NAME")%></td>
            <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LIMIT_AMT")))%>��&nbsp;</td>
            <td align="right"><%=AddUtil.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%>��&nbsp;</td>
            <td align="right"><%=AddUtil.parseDecimal(j_amt)%>��&nbsp;</td>
		  </tr>					
            <%	if(limit_st.equals("1"))		t_amt[0] += AddUtil.parseLong(String.valueOf(ht.get("LIMIT_AMT")));
				else							t_amt[1]  = AddUtil.parseLong(String.valueOf(ht.get("LIMIT_AMT")));
												t_amt[3] += AddUtil.parseLong(String.valueOf(ht.get("BUY_AMT")));
				if(limit_st.equals("1"))		t_amt[4] += j_amt;
				else							t_amt[5]  = j_amt;
			}%>		
          <tr>
            <td class=title colspan="4" align="center">�հ�</td>
            <td class=title style="text-align:right">
			<%if(limit_st.equals("1")){%>
			<%=AddUtil.parseDecimalLong(t_amt[0])%>��&nbsp;
			<%}else{%>
			<%=AddUtil.parseDecimalLong(t_amt[1])%>��&nbsp;
			<%}%>
			</td>
            <td class=title style="text-align:right"><%=AddUtil.parseDecimalLong(t_amt[3])%>��&nbsp;</td>
            <td class=title style="text-align:right">
			<%if(limit_st.equals("1")){%>
			<%=AddUtil.parseDecimalLong(t_amt[0]-t_amt[3])%>��&nbsp;
			<%}else{%>
			<%=AddUtil.parseDecimalLong(t_amt[1]-t_amt[3])%>��&nbsp;
			<%}%>			
			</td>
		  </tr>					  
          <%}else{%>	
          <tr align="center">
            <td colspan="8">��ϵ� ����Ÿ�� �����ϴ�.</td>
            </tr>		  
          <%}%>		  		  	  		  
        </table>
	</td>
  </tr>
  </table>
</form>
</body>
</html>
