<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*, acar.common.*" %>
<%@ page import="acar.serv_off.*" %>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	ServOffDatabase sod = ServOffDatabase.getInstance();
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String h_wd = request.getParameter("h_wd")==null?"":request.getParameter("h_wd");

	ServOffBean so_r [] = sod.getServOffAll(h_wd);
	
	CommonDataBase c_db = CommonDataBase.getInstance();

%>
<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='javascript'>
<!--
-->
</script>
</head>

<body>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr>
      <td class="line"><table border="0" cellspacing="1" cellpadding="0" width=100%>
          <%for(int i=0; i<so_r.length; i++){
        so_bean = so_r[i];
%>
          <tr> 
            <td width=5% align='center'><%= i+1 %>&nbsp;</td>
            <td width=20% align='center'><a href="javascript:parent.select('<%= so_bean.getOff_id() %>')" onMouseOver="window.status=''; return true"><%= so_bean.getOff_nm() %></a></td>
			<td width=15% align='center'><%= so_bean.getEnt_no() %></td>
			<td width=10% align='center'><%= so_bean.getOff_st() %>급</td>
			<td width=15% align='center'><%= c_db.getNameById(so_bean.getCar_comp_id(), "CAR_COM") %></td>            
            <td width=10% align='center'><%= so_bean.getOwn_nm() %></td>
            <td width=25% align='center'><%= so_bean.getOff_addr() %></td>
          </tr>
          <%}
if(so_r.length == 0) { %>
          <tr> 
            <td colspan="7" align='center'>해당 정비업체가 없읍니다.</td>
          </tr>
          <%}%>
        </table></td>
    </tr>
  </table>
</body>
</html>