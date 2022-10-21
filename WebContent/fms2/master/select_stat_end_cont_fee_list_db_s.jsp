<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=select_stat_end_cont_fee_list_db_e.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndContFeeListDB(save_dt);
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
  <table border="1" cellspacing="0" cellpadding="0" width=1450>
	<tr>
	  <td colspan="16" align="center"><%=save_dt%> �����Ȳ</td>
	</tr>		
	<tr>
	  <td colspan="15">&nbsp;</td>
	  <td>(���ް�����)</td>
	</tr>		
	<tr>
	  <td width="50" class="title">����</td>
	  <td width="100" class="title">í����ȣ</td>
	  <td width="100" class="title">����</td>
	  <td width="100" class="title">���ʵ����</td>
	  <td width="100" class="title">�뵵����</td>
	  <td width="100" class="title">��౸��</td>
	  <td width="100" class="title">��������</td>
	  <td width="100" class="title">����ȣ</td>
	  <td width="100" class="title">����������</td>
	  <td width="100" class="title">����������</td>
	  <td width="100" class="title">�������ô뿩��</td>
	  <td width="100" class="title">�������뿩��</td>
	  <td width="100" class="title">�����Ⱓ</td>
	  <td width="100" class="title">�뿩������</td>
	  <td width="100" class="title">�뿩������</td>	  
	  <td width="100" class="title">����������</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	  <td align="center"><%=ht.get("CAR_USE")%></td>
	  <td align="center"><%=ht.get("RENT_ST")%></td>
	  <td align="center"><%=ht.get("CAR_ST")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>	  
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("PP_S_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("IFEE_S_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_S_AMT")))%></td>
	  <td align="center"><%=ht.get("CON_MON")%></td>
	  <td align="center"><%=ht.get("RENT_START_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>
	  <td align="center"><%=ht.get("SCD_END_DT")%></td>  
	</tr>
	<%		
		}%>
  </table>
</form>
</body>
</html>
