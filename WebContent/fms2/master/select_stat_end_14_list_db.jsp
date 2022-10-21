<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndCont14ListDB(save_dt);
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
  <table border="1" cellspacing="0" cellpadding="0" width=750>
	<tr>
	  <td colspan="8" align="center"><%=save_dt%> ��ü��Ȳ</td>
	</tr>		
	<tr>
	  <td colspan="7">&nbsp;</td>
	  <td>(�ΰ�������)</td>
	</tr>		
	<tr>
	  <td width="50" rowspan='3' class="title">����</td>
	  <td width="100" rowspan='3' class="title">����ȣ</td>
	  <td width="100" rowspan='3' class="title">������ȣ</td>
	  <td width="100" rowspan='3' class="title">���뿩��</td>
	  <td colspan='4' class="title">��ü����(<%=save_dt%>����)</td>
	</tr>
	<tr>
	  <td width="100" rowspan='2' class="title">��ü�뿩��(��)</td>
	  <td colspan='2' class="title">�̵����뿩��(��ü�뿩�� ����)</td>
	  <td width="100" rowspan='2' class="title">�հ�(��)+(��)</td>
	</tr>
	<tr>	  
	  <td width="100" class="title">����������</td>
	  <td width="100" class="title">�̵����뿩��(��)</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("RENT_L_CD")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_DLY_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("N_MON")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("FEE_EST_AMT")))%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("H_FEE_AMT")))%></td>
	</tr>
	<%		
		}%>
  </table>
</form>
</body>
</html>
