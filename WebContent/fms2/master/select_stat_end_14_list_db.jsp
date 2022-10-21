<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndCont14ListDB(save_dt);
	int vt_size = vt.size();
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
  <table border="1" cellspacing="0" cellpadding="0" width=750>
	<tr>
	  <td colspan="8" align="center"><%=save_dt%> 연체현황</td>
	</tr>		
	<tr>
	  <td colspan="7">&nbsp;</td>
	  <td>(부가세포함)</td>
	</tr>		
	<tr>
	  <td width="50" rowspan='3' class="title">연번</td>
	  <td width="100" rowspan='3' class="title">계약번호</td>
	  <td width="100" rowspan='3' class="title">차량번호</td>
	  <td width="100" rowspan='3' class="title">월대여료</td>
	  <td colspan='4' class="title">연체관리(<%=save_dt%>현재)</td>
	</tr>
	<tr>
	  <td width="100" rowspan='2' class="title">연체대여료(가)</td>
	  <td colspan='2' class="title">미도래대여료(연체대여료 제외)</td>
	  <td width="100" rowspan='2' class="title">합계(가)+(나)</td>
	</tr>
	<tr>	  
	  <td width="100" class="title">남은개월수</td>
	  <td width="100" class="title">미도래대여료(나)</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("RENT_L_CD")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_DLY_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("N_MON")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_EST_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("H_FEE_AMT")))%></td>
	</tr>
	<%		
		}%>
  </table>
</form>
</body>
</html>
