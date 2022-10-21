<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%//@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*, acar.user_mng.*, acar.ext.*"%>
<jsp:useBean id="ae_db" scope="page" class="acar.ext.AddExtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	Vector exts = ae_db.getGrtStatList();
	int grt_size = exts.size();
	
	long total_amt1	= 0;
%>

<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
//-->
</script>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width=800>
    <tr>
	  <td align='center'>(주)아마존카 장기대여보증금</td>
	</tr>
    <tr>
	  <td align='right'><%=AddUtil.getDate()%></td>
	</tr>
    <tr>
        <td class='line'>
	        <table border="1" cellspacing="1" cellpadding="0" width='100%'>
		        <tr>
        			<td width='50' class='title'>연번</td>				  				  
        			<td width='80' class='title'>거래처코드</td>
        			<td width='300' class='title'>거래처</td>
        			<td width='120' class='title'>사업자등록번호</td>
        			<td width='150' class='title'>보증금</td>				  
        			<td width='100' class='title'>비고</td>
		        </tr>		
		  		<%	for(int i = 0 ; i < grt_size ; i++){
						Hashtable ht = (Hashtable)exts.elementAt(i);
						
						total_amt1 	= total_amt1 + Long.parseLong(String.valueOf(ht.get("GRT_AMT")));%>
		        <tr>
        			<td align='center'><%=i+1%></td>
        		    <td><%=ht.get("VEN_CODE")%></td>
        		    <td><%=ht.get("FIRM_NM")%></td>
        		    <td align='center'><%=ht.get("ENP_NO")%></td>					
        			<td align='right'><%=AddUtil.parseDecimal(String.valueOf(ht.get("GRT_AMT")))%></td>				  				  
        		    <td><%//=ht.get("PAY_ST")%></td>													  								  				  			
		        </tr>
				<%	}%>
		        <tr>
        			<td align='center' colspan='4'>합계</td>				  				  
        			<td align='right' ><%=Util.parseDecimal(total_amt1)%></td>				  				  				
        			<td>&nbsp;</td>				  				  						
		        </tr>						
		    </table>
	    </td>
    </tr>  		    		  
</table>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>

