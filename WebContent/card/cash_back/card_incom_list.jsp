<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String scd_dt 	= request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	Vector vt = CardDb.getCardIncomList(scd_dt, card_kind);
	int vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<%@ include file="/include/search_hidden.jsp" %>
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameByIdCode("0031", card_kind, "")%> <%=AddUtil.ChangeDate2(scd_dt)%> 현항</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width='10%' class='title'>사용일자</td>
                    <td width='15%' class='title'>카드NO</td>
                    <td width='10%' class='title'>사용구분</td>
                    <td width='30%' class='title'>적요</td>
                    <td width='10%' class='title'>사용금액</td>
                    <td width='5%' class='title'>적립율</td>
                    <td width='10%' class='title'>적립금액</td>
                    <td width='5%' class='title'>-</td>
                </tr>
                <%if(vt_size > 0){
				            for (int i = 0 ; i < vt_size ; i++){
					            Hashtable ht = (Hashtable)vt.elementAt(i);
					            total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("BASE_AMT")));
					            total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));
					      %>
                <tr>
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("BASE_DT")))%></td>
                    <td align="center"><%=ht.get("CARDNO")%></td>
                    <td align="center"><%=ht.get("BASE_G")%></td>
                    <td>&nbsp;<%=ht.get("BASE_BIGO")%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BASE_AMT")))%></td>
                    <td align="center"><%=ht.get("SAVE_PER")%>%</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SAVE_AMT")))%></td>
                    <td align="center"></td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='5'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="9" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 
    <tr><td>※ 일부 입금되어 잔액인 경우 적립금액이 입금현황과 다를 수 있습니다.</td></tr>  
    <tr> 
      <td align="right">
	      <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>    
  </table>
</form>
</body>
</html>
