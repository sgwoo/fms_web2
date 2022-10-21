<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	//ī����� ����Ʈ ��ȸ
	Vector vt = CardDb.getCardContStat();
	int vt_size = vt.size();	
%>

<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function CardRegSc(card_kind, card_st){
		var fm = document.form1;
		fm.card_kind.value = card_kind;
		fm.card_st.value = card_st;
		fm.target = "c_foot";
		fm.action = "card_reg_sc.jsp";
		fm.submit();		
	}
//-->
</script>
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='card_kind' value=''>
<input type='hidden' name='card_st' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>������Ȳ</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' rowspan='2' class='title'>����</td>
                    <td width='10%' rowspan='2' class='title'>�ŷ�ó</td>
                    <td colspan='2' class='title'>����ī��</td>
                    <td colspan='2' class='title'>�ŷ�����</td>
                    <td width='10%' rowspan='2' class='title'>�ſ��ѵ�<br>(����:���)</td>
                    <td colspan='4' class='title'>Cash back</td>
                </tr>
                <tr>
                    <td width='15%' class='title'>ī��NO</td>
                    <td width='10%' class='title'>��ȿ�Ⱓ</td>
                    <td width='8%' class='title'>����</td>
                    <td width='8%' class='title'>����</td>
                    <td width='10%' class='title'>��������</td>
                    <td width='10%' class='title'>�ſ�����ϼ�<br>(����/���� �һ���)</td>
                    <td width='7%' class='title'>�Ϲ�������</td>
                    <td width='7%' class='title'>���⿬��<br>������</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><a href="javascript:CardRegSc('<%=ht.get("CARD_KIND_CD")%>','<%=ht.get("CARD_ST")%>')" onMouseOver="window.status=''; return true"><%=ht.get("CARD_KIND_NM")%></a></td>
                    <td align="center"><%=ht.get("CARDNO")%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CARD_EDATE")))%></td>
                    <td align="center"><%=ht.get("CARD_ST")%></td>
                    <td align="center"><%=ht.get("CARD_PAID")%></td>
                    <td align="center"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("S_CONT_AMT")))%>���</td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("CONT_DT")))%></td>
                    <td align="center">
                      <%if(!String.valueOf(ht.get("CARD_ST")).equals("��/�������޿�") && !String.valueOf(ht.get("GIVE_DAY")).equals("")){%>
                        <%=ht.get("GIVE_DAY")%>��                        
                    	<%if(String.valueOf(ht.get("GIVE_DAY_ST")).equals("2")){%>
                    		(�޷���)
                    	<%}else{%>
                    		(������)
                    	<%}%>
                      <%}%>
                    </td>
                    <td align="center">
                    	<%if(String.valueOf(ht.get("CARD_ST")).equals("����")){%>
                    		<%=ht.get("SAVE_PER1")%>%~<%=ht.get("SAVE_PER2")%>%
                    	<%}else{%>
                    		<%=ht.get("SAVE_PER1")%>%
                    	<%}%>
                    </td>
                    <td align="center"><%=ht.get("SAVE_PER2")%>%</td>
                </tr>
		            <%	}%>
		            <%}else{%>
                <tr>
                    <td colspan="11" align="center">��ϵ� ����Ÿ�� �����ϴ�.</td>
                </tr>
		            <%}%>
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
