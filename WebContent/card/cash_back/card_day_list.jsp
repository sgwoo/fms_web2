<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.common.*, acar.util.*, acar.user_mng.*, card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String s_yy 	= request.getParameter("s_yy")==null?"":request.getParameter("s_yy");
	String s_mm 	= request.getParameter("s_mm")==null?"":request.getParameter("s_mm");
	
	String scd_dt = request.getParameter("scd_dt")==null?"":request.getParameter("scd_dt");
	String card_kind = request.getParameter("card_kind")==null?"":request.getParameter("card_kind");
	
	Vector vt = CardDb.getCardDayList(s_yy, s_mm, scd_dt, card_kind);
	int vt_size = vt.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
%>


<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function CardBaseUp(serial){
		var fm = document.form1;
		fm.serial.value = serial;
		fm.target = "_self";
		fm.action = "card_day_ui.jsp";
		fm.submit();				
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post' target=''>
<input type='hidden' name='s_yy' value='<%=s_yy%>'>
<input type='hidden' name='s_mm' value='<%=s_mm%>'>
<input type='hidden' name='scd_dt' value='<%=scd_dt%>'>
<input type='hidden' name='card_kind' value='<%=card_kind%>'>
<input type='hidden' name='serial' value=''>
<input type='hidden' name='tm' value='1'>

  <table border="0" cellspacing="0" cellpadding="0" width=1200>
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=c_db.getNameByIdCode("0031", card_kind, "")%> <%=AddUtil.ChangeDate2(scd_dt)%> 현항</span></td>
	  </tr>
	  <tr><td class=line2></td></tr>
    <tr>
        <td class="line" >
	        <table border="0" cellspacing="1" cellpadding="0" width='100%'>
                <tr>
                    <td width='5%' class='title'>연번</td>
                    <td width='8%' class='title'>사용일자</td>
                    <td width='15%' class='title'>카드NO</td>
                    <td width='8%' class='title'>사용구분</td>
                    <td width='18%' class='title'>적요</td>
                    <td width='10%' class='title'>사용금액</td>
                    <td width='5%' class='title'>적립율</td>
                    <td width='10%' class='title'>적립금액</td>
                    <td width='8%' class='title'>입금예정일</td>
                    <td width='8%' class='title'>입금일자</td>
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
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("EST_DT")))%></td>
                    <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
                    <td align="center">
                    	<%if(String.valueOf(ht.get("INCOM_DT")).equals("") && !String.valueOf(ht.get("SAVE_AMT")).equals("0")){%>
                    	  <a href="javascript:CardBaseUp('<%=ht.get("SERIAL")%>')" onMouseOver="window.status=''; return true"><img src="/acar/images/center/button_in_modify.gif" align="absmiddle" border="0"></a>
                    	<%}%>
                    </td>
                </tr>
		            <%	}%>
                <tr>
                    <td class='title' colspan='5'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td>&nbsp;</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td>&nbsp;</td>
                </tr>		            
		            <%}else{%>
                <tr>
                    <td colspan="11" align="center">등록된 데이타가 없습니다.</td>
                </tr>
		            <%}%>
            </table>
	    </td>
    </tr> 
    <tr><td class=h></td></tr>  
    <tr> 
      <td align="right">
	      <a href="javascript:window.close();"><img src=/acar/images/center/button_close.gif border=0 align=absmiddle></a>
      </td>
    </tr>    
  </table>
</form>
</body>
</html>
