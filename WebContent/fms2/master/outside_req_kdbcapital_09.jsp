<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt_09")==null?"":request.getParameter("end_dt_09");
	
	
	Hashtable ht = ad_db.getOutsideReq09(end_dt);
	
	Vector vt = ad_db.getOutsideReq09_2(end_dt);	
	int vt_size = vt.size();	
	
	long sum0 = 0;
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
  <input type='hidden' name='end_dt' value='<%=end_dt%>'>
  <table border="0" cellspacing="1" cellpadding="0" width=850>
	<tr>
	  <td align="right"><%=AddUtil.getDate3(end_dt)%> ����</td>
	</tr>
	<tr>
	  <td>1. ������</td>
	</tr>		
	<%	sum0 = 0;%>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">����</td>
				  <td width="25%" class="title">����</td>
				  <td width="25%" class="title">���λ����/����</td>
				  <td width="25%" class="title">���</td>
				</tr>
				<tr>
				  <td class="title">�������</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
				  <td align="center">�뿩���</td>
				</tr>
				<tr>
				  <td class="title">�����(�鸸��)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT1")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT2")))/1000000)%></td>
				  <td align="center">�������뿩��</td>
				</tr>
			</table>
		</td>
	</tr>				
	<%	sum0  = AddUtil.parseLong(String.valueOf(ht.get("CNT1")))+AddUtil.parseLong(String.valueOf(ht.get("CNT2")));%>	
	<!--
	<tr>
		<td>* ����հ� : <%=sum0%></td>
	</tr>	
	-->
	<tr>
	  <td>2. ������ ����</td>
	</tr>		
	<%	sum0 = 0;%>
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" rowspan='2' class="title">����</td>
				  <td class="title" colspan='2'>�������</td>
				  <td class="title" colspan='2'>��ΰ���(�鸸��)</td>
				  <td width="15%" rowspan='2' class="title">���</td>
				</tr>
				<tr>
				  <td width="15%" class="title">LPG</td>
				  <td width="15%" class="title">���ָ�</td>
				  <td width="15%" class="title">LPG</td>
				  <td width="15%" class="title">���ָ�</td>
				</tr>				
				<tr>
				  <td class="title">��Ʈ</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT3")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT4")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT3")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT4")))/1000000)%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT5")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT6")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT5")))/1000000)%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT6")))/1000000)%></td>
				  <td align="center"></td>
				</tr>
			</table>
		</td>
	</tr>				
	<%	sum0  = AddUtil.parseLong(String.valueOf(ht.get("CNT3")))+AddUtil.parseLong(String.valueOf(ht.get("CNT4")))+AddUtil.parseLong(String.valueOf(ht.get("CNT5")))+AddUtil.parseLong(String.valueOf(ht.get("CNT6")));%>	
	<!--
	<tr>
		<td>* ����հ� : <%=sum0%></td>
	</tr>	
	-->
	<tr>
	  <td>3. �����纰</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">����</td>
				  <td width="40%" class="title">���</td>
				  <td width="35%" class="title">��ΰ���</td>
				</tr>

				<%	for(int i = 0 ; i < vt_size ; i++){
						Hashtable ht2 = (Hashtable)vt.elementAt(i);
						sum0  = sum0  + AddUtil.parseLong(String.valueOf(ht2.get("CNT0")));
			%>
				<tr>
				  <td class="title"><%=ht2.get("NM")%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht2.get("CNT0")))%></td>
				  <td align="center"></td>
				</tr>
				<%	}%>
			</table>
		</td>
	</tr>
	<!--
	<tr>
		<td>* ����հ� : <%=sum0%></td>
	</tr>
	-->
	<tr>
	  <td>4. ����������</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">����</td>
				  <td width="40%" class="title">���</td>
				  <td width="35%" class="title">��ΰ���</td>
				</tr>
				<tr>
				  <td class="title">����(1500cc����)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT7")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">����(2000cc����)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT8")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">����(2000cc�̻�)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT9")))%></td>
				  <td align="center"></td>
				</tr>
				<tr>
				  <td class="title">��Ÿ(ȭ��,����)</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT10")))%></td>
				  <td align="center"></td>
				</tr>
			</table>
		</td>
	</tr>	
	<tr>
	  <td>5. ���Ⱓ��</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">����</td>
				  <td width="75%" class="title">���</td>
				</tr>
				<tr>
				  <td class="title">12����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT11")))%></td>
				</tr>
				<tr>
				  <td class="title">24����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT12")))%></td>
				</tr>
				<tr>
				  <td class="title">36����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT13")))%></td>
				</tr>
				<tr>
				  <td class="title">48����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT14")))%></td>
				</tr>
				<tr>
				  <td class="title">60����</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT15")))%></td>
				</tr>
				<tr>
				  <td class="title">��Ÿ</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT16")))%></td>
				</tr>
			</table>
		</td>
	</tr>		
	<tr>
	  <td>6. ��ĺ� ������Ȳ</td>
	</tr>		
	<%	sum0 = 0;%>		
	<tr> 
		<td class=line>
			<table border=0 cellspacing=1 width=100%>		
				<tr>
				  <td width="25%" class="title">����</td>
				  <td width="40%" class="title">�������</td>
				  <td width="35%" class="title">��ΰ���(�鸸��)</td>
				</tr>
				<%
					int v_year = 0;
					for(int i = AddUtil.parseInt(end_dt.substring(0,4)) ; i >= AddUtil.parseInt(end_dt.substring(0,4))-7 ; i--){
						v_year = i;
				%>
				<tr>
				  <td class="title"><%=v_year%>���</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+v_year)))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT"+v_year)))/1000000)%></td>
				</tr>
				<%}%>
				<tr>
				  <td class="title"><%=v_year%>������</td>
				  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT"+v_year+"B")))%></td>
				  <td align="right"><%=AddUtil.parseDecimalLong(AddUtil.parseLong(String.valueOf(ht.get("AMT"+v_year+"B")))/1000000)%></td>
				</tr>
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
