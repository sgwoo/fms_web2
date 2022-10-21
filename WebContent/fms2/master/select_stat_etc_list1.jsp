<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSelectStatEtc_list1();
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
	    <td><img src=/acar/images/center/icon_arrow.gif align=absmiddle> <span class=style2>ARS파트너현황 </span></td>
	  </tr>
    <tr>
        <td class=h></td>
    </tr>  
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>
			    <tr>
			      <td width="50" rowspan='2' class="title">연번</td>
				  <td colspan='2' class="title">담당자(정)</td>
				  <td colspan='2' class="title">파트너(부1)</td>
				  <td colspan='2' class="title">파트너(부2)</td>				  
			    </tr>
			    <tr>
				  <td width="100" class="title">지점</td>
				  <td width="100" class="title">성명</td>
				  <td width="100" class="title">지점</td>
				  <td width="100" class="title">성명</td>
				  <td width="100" class="title">지점</td>
				  <td width="100" class="title">성명</td>
			    </tr>			    
			    <%	for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);					
				%>
			    <tr>
				  <td class="title"><%=i+1%></td>
				  <td align="center"><%=ht.get("BR_NM")%></td>
				  <td align="center"><%=ht.get("USER_NM")%></td>
				  <td align="center"><%=ht.get("BR_NM_1")%></td>
				  <td align="center"><%=ht.get("USER_NM_1")%></td>
				  <td align="center"><%=ht.get("BR_NM_2")%></td>
				  <td align="center"><%=ht.get("USER_NM_2")%></td>
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


