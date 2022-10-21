<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.bill_mng.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>�ŷ�ó ��ǥ �̷�</title>
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<%
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String buy_id 		= request.getParameter("buy_id")==null?"":request.getParameter("buy_id");
	
	String ven_st = "";
	String mychk = "";
	long total_amt = 0;	
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	Vector vts = CardDb.getCardDocVendorNowYearList(ven_code);
	int vt_size = vts.size();
	
	Hashtable ven = neoe_db.getTradeCase(ven_code);//-> neoe_db ��ȯ
	
	
%>
<form name='form1' method='post' action='vendor_list.jsp'>
<input type='hidden' name='ven_code' value='<%=ven_code%>'>
<input type='hidden' name='cardno' value='<%=cardno%>'>
<input type='hidden' name='buy_id' value='<%=buy_id%>'>
  <table border="0" cellspacing="0" cellpadding="0" width=900>
    	<tr>
		<td colspan=4>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;
						<span class=style1>�繫ȸ�� > ������ǥ���� > <span class=style5>�ŷ�ó ��ǥ �̷�</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr><td></td></tr>    
    <tr> 
      <td align='right'>	  	
	    ( �Ƹ���ī ����ڹ�ȣ : 128-81-47957, ��ȸ�� ����ڹ�ȣ : <%=AddUtil.ChangeEnt_no(String.valueOf(ven.get("S_IDNO")))%> )
	    <a href="http://www.nts.go.kr/cal/cal_check_02.asp" target="_blank"><img src=/acar/images/center/button_in_search_gsc.gif border=0 align=absmiddle></a>
		&nbsp;&nbsp;
      	<a href="javascript:window.close()"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a> 
      </td>
    </tr>	
    <tr>
        <td class=line2></td>
    </tr>	
    <tr> 
      <td class='line'> 
        <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <tr> 
            <td width='30' class='title'>����</td>
            <td width="130" class='title'>�ŷ�ó</td>			
            <td width="80" class='title'>�ŷ�����</td>			
            <td width="130" class='title'>ī���ȣ</td>
            <td width="70" class='title'>��������</td>			
            <td width="70" class='title'>���ް�</td>						
            <td width="70" class='title'>�ΰ���</td>
            <td width="70" class='title'>�ݾ�</td>			
            <td width="30" class='title'>�ο�</td>
            <td width="70" class='title'>������</td>						
            <td width="150" class='title'>����</td>									
          </tr>
          <%for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vts.elementAt(i);
				
				if(String.valueOf(ht.get("CARDNO")).equals(cardno) && String.valueOf(ht.get("BUY_ID")).equals(buy_id)){
					mychk = "me";
				}%>
          <tr> 
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=i+1%></td>
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=ht.get("VEN_NAME")%></td>			
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BUY_DT")))%></td>			
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=ht.get("CARDNO")%></td>
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%if(String.valueOf(ht.get("VEN_ST")).equals("1")){%>�Ϲݰ���<%}else if(String.valueOf(ht.get("VEN_ST")).equals("2")){%>���̰���<%}else if(String.valueOf(ht.get("VEN_ST")).equals("3")){%>�鼼<%}else if(String.valueOf(ht.get("VEN_ST")).equals("4")){%>�񿵸�����(�������/��ü)<%}%></td>									
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> style='text-align:right'><%=Util.parseDecimal(String.valueOf(ht.get("BUY_S_AMT")))%></td>            
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> style='text-align:right'><%=Util.parseDecimal(String.valueOf(ht.get("BUY_V_AMT")))%></td>            			
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> style='text-align:right'><%=Util.parseDecimal(String.valueOf(ht.get("BUY_AMT")))%></td>            						
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=ht.get("USER_SU")%></td>
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=ht.get("USER_CONT")%></td>						
            <td <%if(mychk.equals("me"))%>class="title_pn"<%%> align="center"><%=ht.get("ACCT_CONT")%></td>									
          </tr>
                <%mychk = "";
				total_amt = total_amt + Long.parseLong(String.valueOf(ht.get("BUY_AMT")));
				}%>		
		  <tr>
		    <td class="title" colspan="7">�հ�</td>
			<td style="text-align:right" class="title"><%=Util.parseDecimal(total_amt)%></td>
		    <td class="title" colspan="3">&nbsp;</td>			
		  </tr>		  
        </table>
      </td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
  </table>
</form>
</body>
</html>