<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String settle_year 	= request.getParameter("settle_year")==null?"":request.getParameter("settle_year");
	String table_width	= request.getParameter("table_width")==null?"":request.getParameter("table_width");
	
	
	Vector vt = ad_db.getSettleAccount_list10(settle_year);
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
  <input type='hidden' name='settle_year' value='<%=settle_year%>'>
<table border="0" cellspacing="1" cellpadding="0" width=<%=table_width%>>
	<tr>
	  <td colspan="15" align="center"><%=settle_year%>�� ���ݰ�꼭 ������� �̼�ä�Ǻ�-��������</td>
	</tr>
	<tr>
	  <td colspan="15">&nbsp;</td>
    </tr>
	<tr>
		<td class=line2></td>
	</tr>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
			  <tr>
				  <td width="50" class="title">����</td>
				  <td width="300" class="title">��ȣ</td>
				  <td width="100" class="title">����ڹ�ȣ<br>�������</td>
				  <td width="100" class="title">����ȣ</td>
				  <td width="50" class="title">�Ǽ�</td>
				  <td width="100" class="title">��꼭����</td>
				  <td width="200" class="title">�׸�</td>
				  <td width="100" class="title">������ȣ</td>
				  <td width="100" class="title">���ް�</td>
				  <td width="100" class="title">�ΰ���</td>
				  <td width="100" class="title">�հ�</td>
				  <td width="100" class="title">�����ٱݾ�</td>
				  <td width="100" class="title">�Աݱݾ�</td>
				  <td width="100" class="title">�ܾ�</td>
				  <td width="100" class="title">��ü�ϼ�</td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
			   		Hashtable ht = (Hashtable)vt.elementAt(i);%>
			  <tr>
				  <td align="center"><%=i+1%></td>
				  <td align="center"><%=ht.get("RECCONAME")%></td>
				  <td align="center"><%=ht.get("RECCOREGNO")%></td>
				  <td align="center"><%=ht.get("RENT_L_CD")%></td>
				  <td align="right"><%=ht.get("CNT")%></td>
				  <td align="center"><%=ht.get("TAX_DT")%></td>
				  <td align="center"><%=ht.get("ITEM_G")%></td>
				  <td align="center"><%=ht.get("ITEM_CAR_NO")%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ITEM_SUPPLY"))))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ITEM_VALUE"))))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("ITEM_AMT"))))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("EXT_AMT"))))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("EXT_PAY_AMT"))))%></td>
				  <td align="right"><%=AddUtil.parseDecimal(AddUtil.parseLong(String.valueOf(ht.get("JAN_AMT"))))%></td>
				  <td align="center"><%=ht.get("DLY_DAYS")%></td>
			  </tr>
			  <%}%>
			</table>
		</td>
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
