<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ssn	 	= request.getParameter("ssn")==null?"":request.getParameter("ssn");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	if(ssn.equals("")) return;
	
	String min_mon = ad_db.getSelectFeeArrearYmdMinMonSsn(ssn);
	
	if(min_mon.equals("")) return;
	
	Vector vt = ad_db.getSelectFeeArrearYmdSsnList(ssn, min_mon);
	int vt_size = vt.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
	long sum4 = 0;
	long sum5 = 0;
	long sum6 = 0;
	long sum7 = 0;
	long sum8 = 0;
	long sum9 = 0;
	long sum10 = 0;
	
	int fee_size = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(i>0){
			sum0  = sum0  + Util.parseLong(String.valueOf(ht.get("FEE_AMT0")));
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("FEE_AMT1")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("FEE_AMT2")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("FEE_AMT3")));
			sum4  = sum4  + Util.parseLong(String.valueOf(ht.get("FEE_AMT4")));
			sum5  = sum5  + Util.parseLong(String.valueOf(ht.get("FEE_AMT5")));
			sum6  = sum6  + Util.parseLong(String.valueOf(ht.get("FEE_AMT6")));
			sum7  = sum7  + Util.parseLong(String.valueOf(ht.get("FEE_AMT7")));
			sum8  = sum8  + Util.parseLong(String.valueOf(ht.get("FEE_AMT8")));
			
			sum9  = sum9  + Util.parseLong(String.valueOf(ht.get("DLY_AMT")));
			sum10 = sum10  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
		}
	}
	
	if(sum0>0) fee_size++;
	if(sum1>0) fee_size++;
	if(sum2>0) fee_size++;
	if(sum3>0) fee_size++;
	if(sum4>0) fee_size++;
	if(sum5>0) fee_size++;
	if(sum6>0) fee_size++;
	if(sum7>0) fee_size++;
	if(sum8>0) fee_size++;
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
  <table border="1" cellspacing="0" cellpadding="0" width=900>
	<tr>
	  <td colspan="<%=fee_size+5%>" align="center">법인/주민번호 [<%=AddUtil.ChangeEnpH(ssn)%>] 고객별 대여료 연체리스트</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <%if(sum0>0){%><td>&nbsp;</td><%}%>	  
	  <%if(sum1>0){%><td>&nbsp;</td><%}%>	  	  
	  <%if(sum2>0){%><td>&nbsp;</td><%}%>
	  <%if(sum3>0){%><td>&nbsp;</td><%}%>
	  <%if(sum4>0){%><td>&nbsp;</td><%}%>	  
	  <%if(sum5>0){%><td>&nbsp;</td><%}%>
	  <%if(sum6>0){%><td>&nbsp;</td><%}%>	  
	  <%if(sum7>0){%><td>&nbsp;</td><%}%>
	  <%if(sum8>0){%><td>&nbsp;</td><%}%>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	</tr>		
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<%		if(i==0){%>
	<tr>
	  <td class="title"><%=ht.get("FIRM_NM")%></td>
	  <td class="title"><%=ht.get("CAR_NO")%></td>
	  <td class="title"><%=ht.get("EST_DAY")%></td>	  
	  <%if(sum0>0){%><td class="title"><%=ht.get("FEE_AMT0")%></td><%}%>
	  <%if(sum1>0){%><td class="title"><%=ht.get("FEE_AMT1")%></td><%}%>
	  <%if(sum2>0){%><td class="title"><%=ht.get("FEE_AMT2")%></td><%}%>
	  <%if(sum3>0){%><td class="title"><%=ht.get("FEE_AMT3")%></td><%}%>
	  <%if(sum4>0){%><td class="title"><%=ht.get("FEE_AMT4")%></td><%}%>  
	  <%if(sum5>0){%><td class="title"><%=ht.get("FEE_AMT5")%></td><%}%>
	  <%if(sum6>0){%><td class="title"><%=ht.get("FEE_AMT6")%></td><%}%>  
	  <%if(sum7>0){%><td class="title"><%=ht.get("FEE_AMT7")%></td><%}%>
	  <%if(sum8>0){%><td class="title"><%=ht.get("FEE_AMT8")%></td><%}%>  
	  <td class="title">연체료</td>	  	  	  	  
	  <td class="title">합계</td>	  	  	  	  	  
	</tr>
	<%		}else{%>
	<tr>
	  <td class="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("EST_DAY")%></td>	  
	  <%if(sum0>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT0")))%></td><%}%>
	  <%if(sum1>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT1")))%></td><%}%>
	  <%if(sum2>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT2")))%></td><%}%>
	  <%if(sum3>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT3")))%></td><%}%>
	  <%if(sum4>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT4")))%></td><%}%>	  	  	  
	  <%if(sum5>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT5")))%></td><%}%>	  	  	  	  
	  <%if(sum6>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT6")))%></td><%}%>	  	  	  	  	  
	  <%if(sum7>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT7")))%></td><%}%>	  	  	  	  
	  <%if(sum8>0){%><td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT8")))%></td><%}%>	  	  	  	  	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("DLY_AMT")))%></td>	  	  	  	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>	  	  	  	  	  
	</tr>	
	<%			
			}%>
	<%	}%>
	<tr>
	  <td colspan="3" class="title">합계</td>	  
	  <%if(sum0>0){%><td align="right"><%=Util.parseDecimal(sum0)%></td><%}%>
	  <%if(sum1>0){%><td align="right"><%=Util.parseDecimal(sum1)%></td><%}%>
	  <%if(sum2>0){%><td align="right"><%=Util.parseDecimal(sum2)%></td><%}%>
	  <%if(sum3>0){%><td align="right"><%=Util.parseDecimal(sum3)%></td><%}%>
	  <%if(sum4>0){%><td align="right"><%=Util.parseDecimal(sum4)%></td><%}%>
	  <%if(sum5>0){%><td align="right"><%=Util.parseDecimal(sum5)%></td><%}%>	  
	  <%if(sum6>0){%><td align="right"><%=Util.parseDecimal(sum6)%></td><%}%>	  	  
	  <%if(sum7>0){%><td align="right"><%=Util.parseDecimal(sum7)%></td><%}%>	  
	  <%if(sum8>0){%><td align="right"><%=Util.parseDecimal(sum8)%></td><%}%>	  	  
	  <td align="right"><%=Util.parseDecimal(sum9)%></td>
	  <td align="right"><%=Util.parseDecimal(sum10)%></td>
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
