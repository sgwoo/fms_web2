<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.oe.*" %>
<jsp:useBean id="oeem_db" scope="page" class="acar.oe.OeEmpDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");	
	
	Vector coe_r = oeem_db.getCarOffEmpAll(gubun, gu_nm, sort_gubun, sort);
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
	<%	if(coe_r.size() > 0 ){
			for(int i=0; i<coe_r.size(); i++){
      			Hashtable ht = (Hashtable)coe_r.elementAt(i); %>
        <tr> 
          <td align='center' width="10%"><%= i+1 %></td>
          <td align='center' width="25%"><%= ht.get("CAR_COMP_NM") %></td>
          <td align='center' width="25%"><%= ht.get("CAR_OFF_NM") %></td>
          <td align='center' width="20%"><a href="javascript:parent.set_emp('<%= ht.get("CAR_COMP_ID") %>','<%= ht.get("CAR_COMP_NM") %>','<%= ht.get("CAR_OFF_ID") %>','<%= ht.get("CAR_OFF_NM") %>','<%= ht.get("POS") %>','<%= ht.get("EMP_ID") %>','<%= ht.get("EMP_NM") %>')" onMouseOver="window.status=''; return true"><%= ht.get("EMP_NM") %></a></td>
          <td align='center' width="20%"><%= ht.get("M_TEL") %></td>
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
