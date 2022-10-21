<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*"%>
<jsp:useBean id="CodeDb" class="acar.ma.CodeDatabase" scope="page" />
<jsp:useBean id="LcRentDb" scope="page" class="acar.lc.LcRentDatabase"/>
<%@ include file="/acar/cookies_base.jsp" %>

<%
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String gu_nm = request.getParameter("gu_nm")==null?"":request.getParameter("gu_nm");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	String chk = request.getParameter("chk")==null?"0":request.getParameter("chk");
	String title = "surety";
	
	Vector LcRentList = LcRentDb.getLcRentSearchList(gubun, gu_nm, chk, mode, "surety");
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../include/table.css">
</head>
<body>
<table width="680" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td class="line"><table width="100%" border="0" cellspacing="1" cellpadding="1">
	<%	if(LcRentList.size() > 0 ){
			for(int i=0; i<LcRentList.size(); i++){
      			Hashtable ht = (Hashtable)LcRentList.elementAt(i); %>
        <tr> 
          <td align='center' width="4%"><%= i+1 %></td>
          <td align='center' width="20%"><a href="javascript:parent.set_lc('<%= ht.get("RENT_MNG_ID") %>','<%= ht.get("RENT_L_CD") %>')" onMouseOver="window.status=''; return true"><%= ht.get("RENT_L_CD") %></a></td>
          <td align='center' width="20%"><%= ht.get("CAR_NO") %></td>
          <td align='center' width="20%"><%= ht.get("CAR_NM") %></td>
          <td align='center' width="20%"><%= ht.get("FIRM_NM") %></td>
          <td align='center' width="8%">
		  <%if(String.valueOf(ht.get("GI_ST")).equals("가입")){%>
		    <font color=red><%= ht.get("GI_ST") %></font>
		  <%}else{%>
		    <%= ht.get("GI_ST") %>
		  <%}%>
		  </td>
          <td align='center' width="8%">
		  <%if(String.valueOf(ht.get("NTR_YN")).equals("등록")){%>
		    <font color=red><%= ht.get("NTR_YN") %></font>
		  <%}else{%>
		    <%= ht.get("NTR_YN") %>
		  <%}%>
		  </td>
        </tr>
     <%}
	 }else{%>		
        <tr> 
          <td colspan="7" align="center">해당자료가 없읍니다.</td>
        </tr>
	<% } %>		
      </table></td>
  </tr>
</table>
</body>
</html>
