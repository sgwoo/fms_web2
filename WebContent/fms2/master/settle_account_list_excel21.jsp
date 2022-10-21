<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=settle_account_list_excel21.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list21(settle_year);
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
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td align="center"><%=AddUtil.parseInt(settle_year+1)%>년  보증보험 가입현황 </td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
    </tr>		
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" class="title">연번</td>
				  <td width="100" class="title">상호</td>
			      <td width="100" class="title">차량번호</td>
				  <td width="100" class="title">차명</td>
				  <td width="100" class="title">보험가입일</td>				  
			      <td width="100" class="title">보험지점</td>
				  <td width="100" class="title">증권번호</td>
				  <td width="100" class="title">보증금액</td>				  
			      <td width="100" class="title">보험료</td>
				  <td width="100" class="title">보증시작일</td>
				  <td width="100" class="title">보증만료일</td>				  
			    </tr>			    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("FIRM_NM")%></td>
				  <td align="center"><%=ht.get("CAR_NO")%></td>
				  <td align="center"><%=ht.get("CAR_NM")%></td>
				  <td align="center"><%=ht.get("GI_DT")%></td>
				  <td align="center"><%=ht.get("GI_JIJUM")%></td>
				  <td align="center"><%=ht.get("GI_NO")%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GI_AMT"))))%></td>
				  <td align="right"><%=Util.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("GI_FEE"))))%></td>
				  <td align="center"><%=ht.get("GI_START_DT")%></td>
				  <td align="center"><%=ht.get("GI_END_DT")%></td>
			    </tr>
			    <%	}%>	
			</table>
		</td>
	</tr>		    	    
  </table>
</form>
</body>
</html>
