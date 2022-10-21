<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//유동성장기차입금(1년이내도래분)
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	String save_dt2 = save_dt.substring(0,7);
	
	Vector vt = ad_db.getSelectStatEndDebt1YearEndListDB(save_dt, save_dt2);
	int vt_size = vt.size();
		
	long sum_amt = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		sum_amt  = sum_amt  + Util.parseLong(String.valueOf(ht.get("ALT_REST")));
	}	
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
  <table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="7" align="center"><%=save_dt%> 유동성장기차입금(1년이내도래분)</td>
	</tr>		
	<tr>
	  <td colspan="7">합계 : <%=AddUtil.parseDecimalLong(sum_amt)%> 원</td>	  
	</tr>		
	<tr>
	  <td width="50" class="title">연번</td>
	  <td width="200" class="title">금융사명</td>
	  <td width="300" class="title">거래처명</td>
	  <td width="100" class="title">차량번호</td>
	  <td width="150" class="title">상환잔액</td>
	  <td width="100" class="title">상환시작일</td>
	  <td width="100" class="title">상환만료일</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("CPT_NM")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_REST")))%></td>
	  <td align="center"><%=ht.get("ALT_START_DT")%></td>
	  <td align="center"><%=ht.get("ALT_END_DT")%></td>	  
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
