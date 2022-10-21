<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	
	Vector vt = ad_db.getSelectStatEndFeeDlyListDB(save_dt);
	int vt_size = vt.size();
	
	long sum_cnt = 0;
	long sum_amt = 0;
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
  <input type='hidden' name='save_dt' value='<%=save_dt%>'>
  <table border="1" cellspacing="0" cellpadding="0" width=650>
	<tr>
	  <td colspan="5" align="center"><%=save_dt%> �뿩�Ῥü��Ȳ</td>
	</tr>		
	<tr>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>
	  <td>&nbsp;</td>	  
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td width="50" class="title">����</td>
	  <td width="300" class="title">�ŷ�ó��</td>
	  <td width="100" class="title">������ȣ</td>
	  <td width="100" class="title">��ü�Ǽ�</td>
	  <td width="100" class="title">��ü�뿩��</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("�ŷ�ó��")%></td>
	  <td align="center"><%=ht.get("������ȣ")%></td>
	  <td align="center"><%=ht.get("��ü�Ǽ�")%></td>
	  <td align="right"><%=Util.parseDecimal(String.valueOf(ht.get("��ü�ݾ�")))%></td>	  
	</tr>
	<%		sum_cnt  = sum_cnt  + Util.parseLong(String.valueOf(ht.get("��ü�Ǽ�")));
				sum_amt  = sum_amt  + Util.parseLong(String.valueOf(ht.get("��ü�ݾ�")));
		}%>

	<tr>
	  <td colspan="3" class="title">�հ�</td>	  
	  <td align="right"><%=Util.parseDecimal(sum_cnt)%></td>
	  <td align="right"><%=Util.parseDecimal(sum_amt)%></td>	  
	</tr>

  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
