<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.speedmate.*" %>
<jsp:useBean id="sm_db" scope="page" class="acar.speedmate.SpeedMateDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_sk_speedmate_excel2.xls");
%>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd2	= request.getParameter("s_kd2")==null?"":request.getParameter("s_kd2");
	String st_dt2 	= request.getParameter("st_dt2")==null?"":request.getParameter("st_dt2");
	String end_dt2 	= request.getParameter("end_dt2")==null?"":request.getParameter("end_dt2");
	
	Vector vt = sm_db.SpeedMateExcelListN(s_kd2, st_dt2, end_dt2);
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
  <table border="1" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="9" align="center">(주)아마존카 해지차량 리스트 </td>
	</tr>		
	<tr>
	  <td colspan="9" align="right"><%if(s_kd2.equals("1")){%><%=AddUtil.getDate()%> 기준<%}else{%>기간 : <%=st_dt2%>~<%=end_dt2%><%}%></td>
	</tr>			
	<tr>
	  <td class="title">연번</td>
	  <td class="title">차량번호</td>	  
	  <td class="title">차종</td>	  	  
	  <td class="title">차명</td>
	  <td class="title">차정</td>
	  <td class="title">연료</td>
	  <td class="title">주행거리</td>			
	  <td class="title">연식</td>				  
	  <td class="title">변속기</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%=ht.get("차량번호")%></td>	  
	  <td align="center"><%=ht.get("차종")%></td>	  	  
	  <td align="center"><%=ht.get("차명")%></td>
	  <td align="center"><%=ht.get("차정")%></td>
	  <td align="center"><%=ht.get("유종")%></td>
	  <td align="center"><%=ht.get("현주행거리")%></td>	  
	  <td align="center"><%=ht.get("연식")%></td>
	  <td align="center"><%=ht.get("변속기")%></td>
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
