<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	//카드기본현황 조회
	Vector vt = CardDb.getCardBaseStat();
	int vt_size = vt.size();
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;
	long total_amt5 = 0;
	long total_amt6 = 0;
	long total_amt7 = 0;
	long total_amt8 = 0;
	long total_amt9 = 0;
	long total_amt10 = 0;
		
	if(vt_size > 0){
		for (int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
			total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
			total_amt7 = total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
			total_amt8 = total_amt8 + AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
			total_amt9 = total_amt9 + AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
			total_amt10 = total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
		}
	}
	
	
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
  function CardStatBase(st, card_kind){
		var fm = document.form1;
		fm.st.value = st;
		fm.card_kind.value = card_kind;
		fm.action = "card_base_list.jsp";
		window.open("about:blank", "CardBaseList", "left=350, top=50, width=1000, height=800, scrollbars=yes, status=yes");
		fm.target = "CardBaseList";
		fm.submit();
  }
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='cash_back_sc.jsp' method='post' target='t_content'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='st' value=''>
<input type='hidden' name='card_kind' value=''>
  <table border="0" cellspacing="0" cellpadding="0" width=1280>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>HOME</span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td colspan='2' rowspan='3' class='title'>구분</td>
                    <td colspan='3' class='title'>사용금액</td>
                    <td colspan='7' class='title'>Cash back</td>
                </tr>
                <tr>
                    <td rowspan='2' width='9%' class='title'>전월</td>
                    <td rowspan='2' width='9%' class='title'>당월</td>
                    <td rowspan='2' width='9%' class='title'>합계</td>
                    <td colspan='2' class='title'>전월</td>
                    <td colspan='2' class='title'>당월</td>
                    <td colspan='2' class='title'>합계</td>
                    <td rowspan='2' width='9%' class='title'>미수적립금</td>
                </tr>                
                <tr>
                    <td width='9%' class='title'>적립금</td>
                    <td width='9%' class='title'>입금액</td>
                    <td width='9%' class='title'>적립금</td>
                    <td width='9%' class='title'>입금액</td>
                    <td width='9%' class='title'>적립금</td>
                    <td width='9%' class='title'>입금액</td>
                </tr>                
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            float incom_per1	= AddUtil.parseFloat(String.valueOf(ht.get("AMT1")))/AddUtil.parseFloat(String.valueOf(total_amt1))*100;
					            float incom_per2	= AddUtil.parseFloat(String.valueOf(ht.get("AMT2")))/AddUtil.parseFloat(String.valueOf(total_amt2))*100;
					            float incom_per3	= AddUtil.parseFloat(String.valueOf(ht.get("AMT3")))/AddUtil.parseFloat(String.valueOf(total_amt3))*100;
					            float incom_per4	= AddUtil.parseFloat(String.valueOf(ht.get("AMT4")))/AddUtil.parseFloat(String.valueOf(total_amt4))*100;
					            float incom_per5	= AddUtil.parseFloat(String.valueOf(ht.get("AMT5")))/AddUtil.parseFloat(String.valueOf(total_amt5))*100;
					            float incom_per6	= AddUtil.parseFloat(String.valueOf(ht.get("AMT6")))/AddUtil.parseFloat(String.valueOf(total_amt6))*100;
					            float incom_per7	= AddUtil.parseFloat(String.valueOf(ht.get("AMT7")))/AddUtil.parseFloat(String.valueOf(total_amt7))*100;
					            float incom_per8	= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")))/AddUtil.parseFloat(String.valueOf(total_amt8))*100;
					            float incom_per9	= AddUtil.parseFloat(String.valueOf(ht.get("AMT9")))/AddUtil.parseFloat(String.valueOf(total_amt9))*100;
					            float incom_per10	= AddUtil.parseFloat(String.valueOf(ht.get("AMT10")))/AddUtil.parseFloat(String.valueOf(total_amt10))*100;
					      %>
                <tr>
                    <td rowspan='2' class='title' width='6%'><%=c_db.getNameByIdCode("0031", String.valueOf(ht.get("CARD_KIND")), "")%></td>
                    <td class='title' width='4%'>금액</td>
                    <td align="right"><a href="javascript:CardStatBase('1', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT1")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('2', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT2")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('3', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT3")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('4', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT4")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('5', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT5")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('6', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT6")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('7', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT7")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('8', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT8")))%></a></td>
                    <td align="right"><a href="javascript:CardStatBase('9', '<%=ht.get("CARD_KIND")%>')" onMouseOver="window.status=''; return true"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT9")))%></a></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("AMT10")))%></td>
                </tr>
                <tr>
                    <td class='title'>점유비</td>                    
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per1),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per2),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per3),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per4),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per5),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per6),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per7),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per8),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per9),2)%>%</td>
                    <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(incom_per10),2)%>%</td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' rowspan='2'>합계</td>
                    <td class='title'>금액</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt6)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt7)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt8)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt9)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt10)%></td>
                </tr>		            
                <tr>
                    <td class='title'>점유비</td>                    
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                    <td align="right">100%</td>
                </tr>
		            <%}else{%>
                <tr>
                    <td colspan="12" align="center">등록된 데이타가 없습니다.</td>
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
