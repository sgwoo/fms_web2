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
	
	Vector vt = ad_db.getOutsideReq04_20100413(end_dt);
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
  <table border="0" cellspacing="1" cellpadding="0" width=1050>
	<tr>
	  <td colspan="12" align="center">중요계약사항 변경내역 </td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td colspan="7">&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="50" rowspan="3" class="title">연번</td>
				  <td width="100" rowspan="3" class="title">차량번호</td>
				  <td width="150" rowspan="3" class="title">차종</td>
				  <td colspan="5" class="title">중요계약사항변경내역</td>
				  <td width="100" rowspan="3" class="title">대출일자</td>
				</tr>
				<tr>
				  <td colspan="2" class="title">변경전</td>
			      <td colspan="3" class="title">변경후</td>
			    </tr>
				<tr>
				  <td width="150" class="title">계약자</td>
			      <td width="100" class="title">계약일자</td>
			      <td width="150" class="title">계약자</td>
				  <td width="100" class="title">변경일자</td>
				  <td width="100" class="title">변경사유</td>
				</tr>
				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht = (Hashtable)vt.elementAt(i);
			%>
				<tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center">&nbsp;<%=ht.get("CAR_NO")%></td>
				  <td align="center">&nbsp;<%=ht.get("CAR_NM")%></td>
				  <td align="center">&nbsp;<%=ht.get("FIRM_NM")%></td>
				  <td align="center">&nbsp;<%=ht.get("RENT_DT")%></td>
				  <td align="center">&nbsp;<%=ht.get("FIRM_NM2")%></td>
				  <td align="center">&nbsp;<%=ht.get("CLS_DT")%></td>
				  <td align="center">&nbsp;<%=ht.get("CLSST")%></td>
				  <td align="center">&nbsp;<%=ht.get("LEND_DT")%></td>
				</tr>
				<%	}%>
			</table>
		</td>
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
