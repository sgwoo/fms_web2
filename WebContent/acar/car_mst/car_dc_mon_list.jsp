<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.car_mst.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	AddCarMstDatabase cmb = AddCarMstDatabase.getInstance();
	
	//����� ������ D/C
	Vector vt = cmb.getCarDcMonList("1");	
	int vt_size = vt.size();
	
%>

<html>
<head>
<title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--

//-->
</script>
</head>
<body>  
    <table border="1" cellspacing="0" cellpadding="0" width=800>
	<tr>
	  <td colspan="10" align="center">����� ������ D/C</td>
	</tr>	
	<tr>
	  <td colspan="10" align="center">&nbsp;</td>
	</tr>			
	<tr>
	  <td width="100" class="title">����</td>
	  <td width="200" class="title">����</td>	  
	  <td width="90" class="title">����</td>
	  <td width="80" class="title">DC�ݾ�</td>
	  <td width="50" class="title">DC��</td>
	  <td width="50" class="title">DC��<br>����<br>����</td>			
	  <td width="50" class="title">����<br>����<br>����<br>����</td>			
	  <td width="80" class="title">����<br>DC�ݾ�</td>
	  <td width="50" class="title">����<br>DC��</td>
	  <td width="50" class="title">����<br>DC��<br>����<br>����</td>			
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align='center'><%=ht.get("CAR_D")%></td>
	  <td align="center"><%=ht.get("CAR_D_DT2")%></td>
	  <td align="center"><%=ht.get("CAR_D_P")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER_B")%></td>
	  <td align="center"><%=ht.get("LS_YN")%></td>
	  <td align="center"><%=ht.get("CAR_D_P2")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER2")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER_B2")%></td>
	</tr>
	<%	}%>
	<tr>
	  <td colspan="10" align="center">&nbsp;</td>
	</tr>		
	<tr>
	  <td colspan="10" align="center">������ ������ D/C</td>
	</tr>	
	<tr>
	  <td colspan="10" align="center">&nbsp;</td>
	</tr>			
	<tr>
	  <td width="100" class="title">����</td>
	  <td width="200" class="title">����</td>	  
	  <td width="90" class="title">����</td>
	  <td width="80" class="title">DC�ݾ�</td>
	  <td width="50" class="title">DC��</td>
	  <td width="50" class="title">DC��<br>����<br>����</td>			
	  <td width="50" class="title">����<br>����<br>����<br>����</td>			
	  <td width="80" class="title">����<br>DC�ݾ�</td>
	  <td width="50" class="title">����<br>DC��</td>
	  <td width="50" class="title">����<br>DC��<br>����<br>����</td>			
	</tr>
	<%	//������ ������ D/C
		vt = cmb.getCarDcMonList("2");	
		vt_size = vt.size();
		
		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align='center'><%=ht.get("CAR_D")%></td>
	  <td align="center"><%=ht.get("CAR_D_DT2")%></td>
	  <td align="center"><%=ht.get("CAR_D_P")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER_B")%></td>
	  <td align="center"><%=ht.get("LS_YN")%></td>
	  <td align="center"><%=ht.get("CAR_D_P2")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER2")%></td>
	  <td align="center"><%=ht.get("CAR_D_PER_B2")%></td>
	</tr>
	<%	}%>	
  </table>
</body>
</html>