<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.car_service.*" %>
<%@ page import="acar.serv_off.*" %>
<%@ include file="/acar/cookies.jsp" %>
<jsp:useBean id="so_bean" class="acar.serv_off.ServOffBean" scope="page"/>

<%
	String off_nm = request.getParameter("off_nm")==null?"":request.getParameter("off_nm");
	
	ServOffDatabase sod = ServOffDatabase.getInstance();
	ServOffBean so_r [] = sod.getServOffAll(off_nm);
%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function DispServOff(off_id, off_nm, own_nm, off_tel, off_fax, ent_no, off_post, off_addr)
{
	var theForm = opener.document.form1;
	theForm.cust_id.value = off_id;
	theForm.cust_nm.value = off_nm;
	self.close();
	window.close();
}
function ServOffRegOpen()
{
	var SUBWIN="/acar/serv_off/serv_off_i_open.jsp";	
	window.open(SUBWIN, "ServOffReg", "left=100, top=100, width=850, height=250, scrollbars=yes");
}
//-->
</script>
</head>
<body leftmargin="15">
<table border=0 cellspacing=0 cellpadding=0 width="180">
  <tr>
	<td align=right><a href="javascript:ServOffRegOpen()">등록</a>&nbsp;&nbsp;<a href="javascript:self.close()">닫기</a></td>
  </tr>
  <tr>
    <td class=line>
      <table border="0" cellspacing="1" width="180">
        <tr>
          <td class=title width=180>정비업체</td>
        </tr>
		<%for(int i=0; i<so_r.length; i++){
        	so_bean = so_r[i];%>				
		<tr>
		  <td align=center>
			<a href="javascript:DispServOff('<%=so_bean.getOff_id()%>','<%=so_bean.getOff_nm()%>','<%=so_bean.getOwn_nm()%>','<%=so_bean.getOff_tel()%>','<%=so_bean.getOff_fax()%>','<%=so_bean.getEnt_no()%>','<%=so_bean.getOff_post()%>','<%=so_bean.getOff_addr()%>')"><%=so_bean.getOff_nm()%></a>
		  </td>
		</tr>	
		<%}%>                   	
      </table>
    </td>
  </tr>    
</table>
</body>
</html>