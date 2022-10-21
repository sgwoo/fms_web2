<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*,acar.util.*"%>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	
	Vector vt = ad_db.getClientTradeErrorList();
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
	//�ŷ�ó ���� 
	function view_client(client_id)
	{
		var fm = document.form1;
		
		fm.client_id.value = client_id;
		fm.target = "d_content";
		fm.action = "client_c.jsp";
		fm.submit();
	}			
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
  <input type='hidden' name='client_id' value=''>  
  <table border="0" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>
			<table width=100% border=0 cellpadding=0 cellspacing=0>
				<tr>
					<td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
					<td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>�������� > ������ > <span class=style5>
						�׿�������ġ��Ȳ</span></span></td>
					<td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
				</tr>
			</table>
		</td>
	</tr>
    <tr>
      <td class=h></td>
    </tr>
	<tr>
	  <td>&nbsp;</td>
	</tr>		
	<tr>
	  <td class='line' >
		<table border="0" cellspacing="1" cellpadding="0" width='100%'>
		  <tr>
	        <td width="5%" rowspan="2" class="title">����</td>
	        <td width="15%" rowspan="2" class="title">�ŷ�ó�ڵ�</td>
	        <td colspan="2" class="title">�׿���</td>
	        <td colspan="2" class="title">FMS</td>
	      </tr>
		  <tr>
			<td width="25%" class="title">��ȣ</td>
			<td width="15%" class="title">����ڹ�ȣ</td>
			<td width="25%" class="title">��ȣ</td>
			<td width="15%" class="title">����ڹ�ȣ</td>
	      </tr>	  
	  <%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
		  <tr>
	        <td align="center"><%=i+1%></td>
	        <td align="center"><%=ht.get("CUST_CODE")%></td>
	        <td align="center"><%=ht.get("CUST_NAME")%></td>	  
	        <td align="center"><%=ht.get("S_IDNO")%></td>
	        <td align="center"><a href="javascript:view_client('<%=ht.get("CLIENT_ID")%>')" onMouseOver="window.status=''; return true"><%=ht.get("FIRM_NM")%></a></td>
	        <td align="center"><%=ht.get("ENP_NO")%></td>
		  </tr>
<%
		}
%>
		</table>
	  </td>	
	</tr>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
</body>
</html>
