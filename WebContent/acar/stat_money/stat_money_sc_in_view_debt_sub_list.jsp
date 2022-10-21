<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.stat_account.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.stat_account.StatAccountDatabase"/>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();

	String s_ym = request.getParameter("alt_est_m")==null?"":request.getParameter("alt_est_m");
	
	Vector accs = ac_db.getStatMoneyDebtList(s_ym);
	int acc_size = accs.size();	
	
	long total_amt1[]	 		= new long[13];
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

-->
</script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css"> 
</head>
<body>
<form action="" name="form1" method="POST">
  <table border="0" cellspacing="0" cellpadding="0" width=1400>
    <tr>
        <td class=line2></td>
    </tr>
    <tr> 
        <td class=line> 
            <table width=100% border="0" cellspacing="1" cellpadding="0">
                <tr align="center"> 
                    <td width="50" rowspan="2" class=title>연번</td>
                    <td width="150" rowspan="2" class=title>금융사</td>
                    <%for (int i = 0 ; i < 1 ; i++){
        				Hashtable acc = (Hashtable)accs.elementAt(i);%>
        			<td colspan="2" class=title><%=acc.get("MM1")%></td>	
        			<td colspan="2" class=title><%=acc.get("MM2")%></td>
        			<td colspan="2" class=title><%=acc.get("MM3")%></td>
        			<td colspan="2" class=title><%=acc.get("MM4")%></td>
        			<td colspan="2" class=title><%=acc.get("MM5")%></td>
        			<%}%>	                    
                </tr>
                <tr align="center">
                  <%for (int j = 0 ; j < 5 ; j++){%>
                  <td width="120" class=title>할부원금</td>
                  <td width="120" class=title>전월대비</td>
                  <%} %>
                </tr>  
              <%for (int i = 0 ; i < acc_size ; i++){
    				Hashtable acc = (Hashtable)accs.elementAt(i);
		            for(int j = 0 ; j <= 5 ; j++){
						total_amt1[j]	= total_amt1[j] + AddUtil.parseLong(String.valueOf(acc.get("AMT"+j)));
						if(j>0){
							total_amt1[j+5]	= total_amt1[j+5] + AddUtil.parseLong(String.valueOf(acc.get("AMT"+j))) - AddUtil.parseLong(String.valueOf(acc.get("AMT"+(j-1))));							
						}	
					}
		             
				%>
                <tr> 
                    <td align="center"><%=i+1%></td>
                    <td align="center"><%=acc.get("CPT_NM")%></td>
                    <%for(int j = 1 ; j <= 5 ; j++){ %>
   				    <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(acc.get("AMT"+j)))%></td>
   				    <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(acc.get("AMT"+j)))-AddUtil.parseLong(String.valueOf(acc.get("AMT"+(j-1)))))%></td>
				    <%} %>				    
                </tr>
                  <%	
        		  }%>
                <tr> 
                    <td height="20" colspan='2' class=title align="center">합계</td>
                    <%for(int j = 1 ; j <= 5 ; j++){ %>
                    <td height="20" class=title align="right" style='text-align:right'><%=Util.parseDecimal(total_amt1[j])%></td>
                    <td height="20" class=title align="right" style='text-align:right'><%=Util.parseDecimal(total_amt1[j+5])%></td>
                    <%} %>
                </tr>
            </table>
        </td>
    </tr>
</table>		
</form>
</body>
</html>
