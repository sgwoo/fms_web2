<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	String save_dt2 = save_dt.substring(0,7);
	
	Vector vt = ad_db.getSelectStatEndCont15ListDB(save_dt2);	
	int vt_size = vt.size();
	
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
  <table border="1" cellspacing="0" cellpadding="0" width=1250>
	<tr>
	  <td colspan="12" align="center"><%=save_dt%> �����纰������Ȳ</td>
	</tr>		
	<tr>
	  <td colspan="10">&nbsp;</td>
	  <td colspan="2" align="right">(����:��, ���ݱ���)</td>
	</tr>		
	<tr>
	  <td rowspan='2' width="50" class="title">����</td>
	  <td rowspan='2' width="200" class="title">�������</td>
	  <td colspan='3' class="title">��������</td>
	  <td colspan='4' class="title">��ȯ����</td>
	  <td colspan='3' class="title">�����㺸</td>
	</tr>		
	<tr>	  
	  <td width="100" class="title">��������</td>
	  <td width="100" class="title">��������</td>
	  <td width="100" class="title">����ݾ�</td>
	  <td width="100" class="title">��ȯ���</td>
	  <td width="100" class="title">�Һΰ�����</td>
	  <td width="100" class="title">�����ݸ�</td>
	  <td width="100" class="title">�ܾ�</td>
	  <td width="100" class="title">�����缳��</td>
	  <td width="100" class="title">ä�Ǿ����</td>
	  <td width="100" class="title">��ǥ�̻纸��</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			
			sum_amt = sum_amt + AddUtil.parseLong(String.valueOf(ht.get("ALT_REST")));
	%>
	<tr>
	  <td class="title"><%=i+1%></td>
	  <td align="center"><%=ht.get("CPT_NM")%></td>
	  <td align="center"><%=ht.get("ALT_START_DT")%></td>
	  <td align="center"><%=ht.get("ALT_END_DT")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("LEND_PRN")))%></td>
	  <td align="center"><%=ht.get("RTN_CDT")%></td>
	  <td align="center"><%=ht.get("TOT_ALT_TM")%></td>
	  <td align="right"><%=ht.get("LEND_INT")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_REST")))%></td>
	  <td align="center"></td>
	  <td align="center"></td>
	  <td align="center"></td>  
	</tr>
	<%		
		}%>
	<tr>
	  <td colspan="8" align="center">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt)%></td>
	  <td colspan="3" align="right">&nbsp;</td>
	</tr>				
  </table>
</form>
</body>
</html>
