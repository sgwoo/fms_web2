<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.beans.*, acar.cl.*"%>
<%@ include file="/acar/cookies.jsp" %>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String client_id = request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String firm_nm = request.getParameter("firm_nm")==null?"":request.getParameter("firm_nm");
	
	ClientDatabase cl_db  = ClientDatabase.getInstance();
	
	Vector c_sites = cl_db.getClientSites(client_id);
	int c_site_size = c_sites.size();
%>

<html>
<head><title>사용본거지 관리</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script language='javascript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>
<link rel=stylesheet type="text/css" href="../include/table.css">
<body>
<table border="0" cellspacing="0" cellpadding="0" width=500>
    <tr> 
      <td class='line' colspan="2"> <table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%if(c_site_size > 0){
				for(int i = 0; i < c_site_size ; i++){
					ClSiteBean site = (ClSiteBean)c_sites.elementAt(i);%>
          <tr> 
            <td width="6%" align="center"><%=i+1%></td>
            <td width="37%">&nbsp;<%= site.getSite_nm() %></td>
            <td width="12%" align="center"><%= site.getZip() %></td>
            <td width="30%" align="left">&nbsp;<%= site.getAddr() %></td>
            <td width="15%" align="center"><%= site.getTel() %></td>
          </tr>
          <%	}
			}else{%>
          <tr> 
            <td colspan="5" align="center">해당 사용본거지가 없읍니다.</td>
          </tr>
          <%}%>
        </table></td>
    </tr>
  </table>
</body>
</html>
