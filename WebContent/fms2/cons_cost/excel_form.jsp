<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_cons_cost_excel_form.xls");
%>

<%
	AddCarMstDatabase a_cmd = AddCarMstDatabase.getInstance();
	
	Vector vt = a_cmd.getConsCostCarForm();
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=1000>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="100" rowspan="2" align="center">제조사</td>
			    <td width="200" rowspan="2" align="center">차명</td>
			    <td width="100" rowspan="2" align="center">출하장</td>				
				<td colspan="5" align="center">인수지점</td>
			   </tr>
			   <tr>
			    <td width="100" align="center">서울본사</td>
			    <td width="100" align="center">부산지점</td>
			    <td width="100" align="center">대전지점</td>				
			    <td width="100" align="center">대구지점</td>
			    <td width="100" align="center">광주지점</td>				
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);
					%>
			  <tr>
			    <td><%=ht.get("NM")%></td>
			    <td><%=ht.get("CAR_NM")%></td>
			    <td></td>
			    <td></td>
			    <td></td>
			    <td></td>
			    <td></td>
			    <td></td>
			  </tr>
			  <%}%>
            </table>
        </td>
    </tr>
</table>
</body>
</html>