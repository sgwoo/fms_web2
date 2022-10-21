<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getOutsideReq01(end_dt);
	int vt_size = vt.size();
	
	long sum0 = 0;
	long sum1 = 0;
	long sum2 = 0;
	long sum3 = 0;
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
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=1300>
	<tr>
	  <td colspan="9" align="center">고객분석</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td colspan="5">&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td width="50" rowspan="2" class="title">연번</td>
	  <td width="400" rowspan="2" class="title">상호</td>
	  <td width="100" rowspan="2" class="title">고객구분</td>
	  <td colspan="2" class="title">사업구분</td>
	  <td width="100" rowspan="2" class="title">대여대수</td>
	  <td width="100" rowspan="2" class="title">총대여료</td>
	  <td width="100" rowspan="2" class="title">잔여대여료</td>
	  <td width="100" rowspan="2" class="title">월대여료</td>	  
	</tr>
	<tr>
	  <td width="150" class="title">업태</td>
	  <td width="200" class="title">종목</td>
    </tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			sum0  = sum0  + Util.parseLong(String.valueOf(ht.get("CNT")));
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("JAN_FEE_AMT")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CLIENT_ST")%></td>
	  <td align="center"><%=ht.get("BUS_CDT")%></td>
	  <td align="center"><%=ht.get("BUS_ITM")%></td>
	  <td align="center"><%=ht.get("CNT")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("JAN_FEE_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
	</tr>
	<%	}%>
	<tr>
	  <td colspan="5" align="center">합계</td>	  
	  <td align="center"><%=Util.parseDecimal(sum0)%></td>
	  <td align="right"><%=Util.parseDecimal(sum1)%></td>
	  <td align="right"><%=Util.parseDecimal(sum2)%></td>
	  <td align="right"><%=Util.parseDecimal(sum3)%></td>	  
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
