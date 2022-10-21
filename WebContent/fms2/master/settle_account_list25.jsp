<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*, card.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	//카드종류 리스트 조회
	Vector card_kinds = CardDb.getCardKinds("CARD_SCD", "");
	int ck_size = card_kinds.size();	
	
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt4 = 0;	
	long total_amt5 = 0;	
	long total_amt6 = 0;
	
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year)%>년 카드캐쉬백 입금현황 </td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>
    <%	for (int j = 0 ; j < ck_size ; j++){
        	Hashtable ht2 = (Hashtable)card_kinds.elementAt(j);
        	
        	Vector vt = ad_db.getSettleAccount_list25(ht2.get("CODE")+"", settle_year);
        	int vt_size = vt.size();
        	
        	total_amt1 = 0;
        	total_amt2 = 0;
        	total_amt3 = 0;
        	total_amt4 = 0;
        	total_amt5 = 0;
        	total_amt6 = 0;
        	
        	if(vt_size>0){
        	
    %>		
    <tr>
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2><%=ht2.get("CARD_KIND")%></span></td>
	  </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="100" class="title">입금일자</td>
				  <td width="120" class="title">사용금액</td>
				  <td width="120" class="title">예정금액<br>(A)</td>
				  <td width="120" class="title">입금처리금액<br>(B)</td>
				  <td width="120" class="title">손익금액<br>(C)</td>
				  <td width="120" class="title">실입금금액<br>(B-C)</td>
				  <td width="120" class="title">차액<br>(A-B)</td>
			    </tr>
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					
					total_amt1 = total_amt1 + AddUtil.parseLong(String.valueOf(ht.get("SCD_AMT")));
	      			total_amt2 = total_amt2 + AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT")));	      			
	      			total_amt3 = total_amt3 + AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT")));
	      			total_amt4 = total_amt4 + AddUtil.parseLong(String.valueOf(ht.get("M_AMT")));
	      			total_amt5 = total_amt5 + AddUtil.parseLong(String.valueOf(ht.get("R_INCOM_AMT")));	      			
	      			total_amt6 = total_amt6 + AddUtil.parseLong(String.valueOf(ht.get("DEF_AMT")));
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=AddUtil.ChangeDate2(String.valueOf(ht.get("INCOM_DT")))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("SCD_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("SAVE_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("INCOM_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("M_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("R_INCOM_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("DEF_AMT"))))%></td>
			    </tr>
			    <%	}%>	
                <tr>
                    <td class='title' colspan='2'>합계</td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt1)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt2)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt3)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt4)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt5)%></td>
                    <td align="right"><%=AddUtil.parseDecimalLong(total_amt6)%></td>                    
                </tr>		  			    
			</table>
		</td>
	</tr>		
	<%		}
    	}
	%>    
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
