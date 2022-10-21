<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String bank_cd 	= request.getParameter("bank_cd")==null?"":request.getParameter("bank_cd");
	
	Vector vt = ad_db.getOutsideReq11(bank_cd);
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
  <input type='hidden' name='bank_cd' value='<%=bank_cd%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=1550>
	<tr>
	  <td colspan="16" align="center">계약분석</td>
	</tr>		
	<tr>
	  <td colspan="16">&nbsp;</td>	  
	</tr>		
	<tr>
	  <td width="50" rowspan="2" class="title">연번</td>
	  <td width="100" rowspan="2" class="title">차대번호</td>
	  <td width="100" rowspan="2" class="title">차량번호</td>
	  <td width="100" rowspan="2" class="title">차명</td>	  
	  <td width="100" rowspan="2" class="title">상호</td>
	  <td width="100" rowspan="2" class="title">고객구분</td>
	  <td colspan="2" class="title">사업구분</td>
	  <td width="100" rowspan="2" class="title">대여개월수</td>
	  <td width="100" rowspan="2" class="title">대여개시일</td>
	  <td width="100" rowspan="2" class="title">대여만료일</td>
	  <td width="100" rowspan="2" class="title">총대여료</td>
	  <td width="100" rowspan="2" class="title">잔여대여료</td>
	  <td width="100" rowspan="2" class="title">월대여료</td>
	  <td width="100" rowspan="2" class="title">대출실행일</td>	
	  <td width="100" rowspan="2" class="title">대출현황</td>  
	</tr>
	<tr>
	  <td width="100" class="title">업태</td>
	  <td width="100" class="title">종목</td>
    </tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			sum1  = sum1  + Util.parseLong(String.valueOf(ht.get("TOT_AMT")));
			sum2  = sum2  + Util.parseLong(String.valueOf(ht.get("JAN_FEE_AMT")));
			sum3  = sum3  + Util.parseLong(String.valueOf(ht.get("FEE_AMT")));%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("CAR_NUM")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CLIENT_ST")%></td>
	  <td align="center"><%=ht.get("BUS_CDT")%></td>
	  <td align="center"><%=ht.get("BUS_ITM")%></td>
	  <td align="center"><%=ht.get("CON_MON")%></td>
	  <td align="center"><%=ht.get("RENT_START_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("TOT_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("JAN_FEE_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
	  <td align="center"><%=ht.get("LEND_DT")%></td>
	  <td align="center"><%=ht.get("ALLOT_ST")%></td>
	</tr>
	<%	}%>
	<tr>
	  <td colspan="11" align="center">합계</td>	  
	  <td align="right"><%=Util.parseDecimal(sum1)%></td>
	  <td align="right"><%=Util.parseDecimal(sum2)%></td>
	  <td align="right"><%=Util.parseDecimal(sum3)%></td>
	  <td align="center"></td>	  
	  <td align="center"></td>
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
