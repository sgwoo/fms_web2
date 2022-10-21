<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*"%>
<jsp:useBean id="CodeDb" class="acar.ma.CodeDatabase" scope="page" />
<jsp:useBean id="OeOffDb" scope="page" class="acar.oe.OeOffDatabase"/>
<jsp:useBean id="OeOffBn" scope="page" class="acar.beans.OeOffBean"/>
<jsp:useBean id="OeEmpDb" scope="page" class="acar.oe.OeEmpDatabase"/>
<jsp:useBean id="OeEmpBn" scope="page" class="acar.beans.OeEmpBean"/>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	
	Vector OeOffList = OeOffDb.getOeOffList("", "", "", "", "", "", "", "", "", "", "", "", "", gubun, gu_nm, "", "2", "asc");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
</head>

<body>
<% if(!gu_nm.equals("")){ %>
<table width="500" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="1">
	<%	if(OeOffList.size() > 0 ){
			for(int i=0; i<OeOffList.size(); i++){
      			Hashtable ht = (Hashtable)OeOffList.elementAt(i); %>
        <tr> 
          <td align='center' width="10%"><%= i+1 %></td>
          <td align='center' width="20%"><%= ht.get("CAR_COMP_NM") %></td>
          <td align='center' width="20%"><%= ht.get("OWNER") %></td>
          <td align='center' width="30%"><a href="javascript:parent.set_caroff('<%= ht.get("CAR_OFF_ID") %>','<%= ht.get("CAR_COMP_NM") %>','<%= ht.get("CAR_OFF_NM") %>')" onMouseOver="window.status=''; return true"><%= ht.get("CAR_OFF_NM") %></a></td>
          <td align='center' width="20%"><%= ht.get("OFF_TEL") %></td>
        </tr>
     <%}
	 }else{%>		
        <tr> 
          <td colspan="5" align="center">해당자료가 없읍니다.</td>
        </tr>
	<% } %>		
      </table></td>
  </tr>
</table>
<% } %>
</body>
</html>
