<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	
	Vector vt = ad_db.getSelectStatEndAssetDB(save_dt, "stat");
	int vt_size = vt.size();
	
	long sum_cnt = 0;
	long sum_amt[] = new long[17];

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
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="11" align="center">�� ����� �ڵ��� �ڻ� �� (<%=save_dt%> ����)</td>
	</tr>		
	<tr>
	  <td colspan="11">1) ��ΰ��� ��� �ǰŷ���(������ڵ���)��Ȳ</td>
	</tr>		
	<tr>
	  <td rowspan='2' colspan='2' class="title">����</td>
	  <td rowspan='2' width="60" class="title">��ϴ��</td>
	  <td colspan='3' class="title">��氡</td>
	  <td colspan='3' class="title">��ΰ�</td>
	  <td colspan='2' class="title">�ǰŷ���(��������)</td>
	</tr>
	<tr>
	  <td width="120" class="title">��������</td>
	  <td width="120" class="title">�δ���</td>
	  <td width="120" class="title">�հ�</td>
	  <td width="120" class="title">�󰢴���</td>
	  <td width="120" class="title">�ܰ�</td>
	  <td width="60" class="title">�ܰ���</td>
	  <td width="120" class="title">����忹��<br>������<br>(VAT����)</td>
	  <td width="60" class="title">�ܰ���</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">��<br>��<br>��<br>��</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>��</td>
	  <td align="right"><%=ht.get("CNT")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_B_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_C_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEP_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("BOOK_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("BOOK_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SH_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SH_PER")),2)%></td>
	</tr>
	<%		sum_cnt    = sum_cnt    + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
				sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CAR_B_AMT")));
				sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CAR_C_AMT")));
				sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CAR_AMT")));
				sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("DEP_AMT")));
				sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("BOOK_AMT")));
				sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("SH_AMT")));
		}%>
	<tr>
	  <td colspan="2" class="title">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_cnt)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[4]))/AddUtil.parseFloat(String.valueOf(sum_amt[2]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[5]))/AddUtil.parseFloat(String.valueOf(sum_amt[2]))*100),2)%></td>
	</tr>
</table>
<p>
<p>
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="11">2) ��ä ��� �Ű����� ��Ȳ(���簡ġ����)</td>
	</tr>		
	<tr>
	  <td rowspan='3' colspan='2' class="title">����</td>
	  <td colspan='5' class="title">��ä��Ȳ</td>
	  <td colspan='3' class="title">���������Ȳ</td>
	</tr>
	<tr>
	  <td colspan='3' class="title">���Ա��ܾ�</td>
	  <td rowspan='2' width="120" class="title">������(��ġ��)</td>
	  <td rowspan='2' width="120" class="title">�հ�</td>
	  <td colspan='2' class="title">��������(VAT����)</td>
	  <td rowspan='2' width="120" class="title">����<br>(��������-��ä�հ�)</td>
	</tr>
	<tr>
	  <td width="120" class="title">����</td>
	  <td width="120" class="title">�ߵ���ȯ������(1%)</td>
	  <td width="120" class="title">�Ұ�</td>
	  <td width="120" class="title">�ݾ�</td>
	  <td width="60" class="title">��ä���</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);			
	%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">��<br>��<br>��<br>��</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>��</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_FEE")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PF_SUM")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GRT_AMT_S")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("DEBT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("SH_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SH_DEBT_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GAIN_SD_AMT")))%></td>
	</tr>
	<%		
				sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN")));
				sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("ALT_FEE")));
				sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PF_SUM")));
				sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("GRT_AMT_S")));
				sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("DEBT_AMT")));
				sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("GAIN_SD_AMT")));
		}%>
	<tr>
	  <td colspan="2" class="title">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[5]))/AddUtil.parseFloat(String.valueOf(sum_amt[10]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	</tr>
</table>
<p>
<p>	
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="10">3) ��ä ��� �����뿩�� ��Ȳ</td>
	</tr>		
	<tr>
	  <td rowspan='3' colspan='2' class="title">����</td>
	  <td colspan='3' class="title">��ä��Ȳ</td>
	  <td colspan='4' class="title">���������Ȳ</td>
	  <!-- <td rowspan='3' width="100" class="title">���</td> -->
	</tr>
	<tr>
	  <td colspan='3' class="title">���Ա��ܾ�</td>
	  <td colspan='2' class="title">�����뿩��<br>(���ް�)</td>
	  <td colspan='2' width="100" class="title">����<br>(�����뿩��-��ä�հ�)</td>
	</tr>
	<tr>
	  <td width="100" class="title">����</td> 
	  <td width="100" class="title">����</td>
	  <td width="100" class="title">�հ�</td>
	  <td width="100" class="title">�ݾ�</td>
	  <td width="100" class="title">��ä���</td>	  
	  <td width="100" class="title">�ݾ�</td>
	  <td width="100" class="title">��ä���</td>	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
	%>
	<tr>
		<%if(i==0){%>
	  <td width="40" rowspan='<%=vt_size%>' class="title">��<br>��<br>��<br>��</td>
	  <%}%>
	  <td width="60" align="center"><%=ht.get("YYYY")%>��</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_INT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("FEE_EST_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("FEE_DEBT_PER")),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("GAIN_FD_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(ht.get("GAIN_FD_PER")),2)%></td>
	  <!-- 
	  <%if(i==0){%>
	  <td rowspan='<%=vt_size+1%>'>
	  	1)�����󰢱����� �ո����̴�.<br><br>
	  	2)���ؽ����� �ڻ��� ó���� ��쿡�� ��ä ��ȯ���� ����� ����.<br><br>
	  	3)���� �뿩�� ��Ȳ �� ä���� ������� ������ �� �������� ����� ����.<br><br>
	  	4)�Ͻÿ� ��� ����� �ߵ������� ��쿡�� ���������� �߰��� ���������� ������ �� �������� ����� ������ ����.
	  </td>
	  <%}%>
	   -->
	</tr>
	<%		
				sum_amt[12] = sum_amt[12] + AddUtil.parseLong(String.valueOf(ht.get("FEE_EST_AMT")));
				sum_amt[13] = sum_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("GAIN_FD_AMT")));
				sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("ALT_INT2")));
				sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT2")));
				
		}%>
	<tr>
	  <td colspan="2" class="title">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[12])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[12]))/AddUtil.parseFloat(String.valueOf(sum_amt[8]))*100),2)%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[13])%></td>
	  <td align="right"><%=AddUtil.parseFloatCipher(String.valueOf(AddUtil.parseFloat(String.valueOf(sum_amt[13]))/AddUtil.parseFloat(String.valueOf(sum_amt[8]))*100),2)%></td>
	</tr>
</table>	
<%if(sum_amt[15]==0){

	Vector vt2 = ad_db.getSelectStatEndAssetDB_debt(save_dt);
	int vt_size2 = vt2.size();
%>
<p>
<p>	
<table border="1" cellspacing="0" cellpadding="0" width=1000>
	<tr>
	  <td colspan="7">4) ��ä��Ȳ</td>
	</tr>		
	<tr>
	  <td rowspan='2' class="title">����</td>
	  <td colspan='3' class="title">���Ա��ܾ�</td>
	  <td colspan='3' class="title">��ä��Ȳ</td>
	</tr>
	<tr>
	  <td width="150" class="title">����</td> 
	  <td width="150" class="title">�ߵ���ȯ������(1%)</td>
	  <td width="150" class="title">�Ұ�</td>
	  <td width="150" class="title">����</td> 
	  <td width="150" class="title">����</td>
	  <td width="150" class="title">�հ�</td>
	</tr>
	<%	for(int i = 0 ; i < vt_size2 ; i++){
			Hashtable ht = (Hashtable)vt2.elementAt(i);%>
	<tr>
	  <td width="100" align="center"><%=ht.get("YYYY")%>��</td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_FEE")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PF_SUM")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_PRN")))%></td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_INT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("ALT_AMT")))%></td>	  
	</tr>
	<%		
				sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PRN")));
				sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("ALT_FEE")));
				sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("ALT_PF_SUM")));
				sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("ALT_INT")));
				sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("ALT_AMT")));
				
		}%>
	<tr>
	  <td class="title">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>	  
	</tr>
</table>	
<%}%>
</form>
</body>
</html>
