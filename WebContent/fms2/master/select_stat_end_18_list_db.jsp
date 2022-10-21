<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�뿩�Ͻ������ ���갡ġ(������) - ���˿�
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String s_unit 	= request.getParameter("s_unit")==null?"":request.getParameter("s_unit");
	
	Vector vt = ad_db.getSelectStatEndCont18ListDB(save_dt);
	int vt_size = vt.size();
	
	long sum_amt[] = new long[12];
	long h_sum_amt[] = new long[12];

	int rowspan_cnt1 = 0;
	int rowspan_cnt2 = 0;
	int rowspan_cnt3 = 0;
	
	for(int i = 0 ; i < vt_size ; i++){
		Hashtable ht = (Hashtable)vt.elementAt(i);
		if(String.valueOf(ht.get("ETC")).equals("1")) rowspan_cnt1++;
		if(String.valueOf(ht.get("ETC")).equals("2")) rowspan_cnt2++;
		if(String.valueOf(ht.get("ETC")).equals("3")) rowspan_cnt3++;
	}
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
<table border="1" cellspacing="0" cellpadding="0" width=1600>
	<tr>
	  <td colspan="15" align="center">�� �뿩�Ͻ������ ���갡ġ</td>
	</tr>		
	<tr>
	  <td colspan="15" align="right">����:��, ��������(<%=save_dt%>)</td>
	</tr>			
	<tr>
	  <td rowspan='2' colspan='3' class="title">����</td>
	  <td colspan='3' class="title">�������</td>
	  <td colspan='4' class="title">��ä</td>
	  <td colspan='4' class="title">�ڻ�</td>
	  <td rowspan='2' width="110" class="title">�ڻ�-��ä</td>
	</tr>
	<tr>
	  <td width="110" class="title">��ȯ��</td>
	  <td width="110" class="title">��ȯ�Ϸ�</td>
	  <td width="110" class="title">�հ�</td>
	  <td width="110" class="title">�����ܾ�</td>
	  <td width="110" class="title">������</td>	  
	  <td width="110" class="title">�ܿ�������</td>
	  <td width="110" class="title">�հ�</td>
	  <td width="110" class="title">���������ܰ�</td>
	  <td width="110" class="title">�̼��뿩��</td>
	  <td width="110" class="title">�����</td>
	  <td width="110" class="title">�հ�</td>	  
	</tr>
	<%	int etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("1")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt1+1%>' class="title">��<br>��</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_ALT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_EXT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CLS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("C_AMT")))%></td>
	</tr>
	<%			
					sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("D_ALT_AMT")));
					sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("D_EXT_AMT")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT")));
					sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("A_CLS_AMT")));
					sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
					sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("C_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">�Ұ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	</tr>
	<%
			for(int i = 0 ; i < 12 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("2")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt2+1%>' class="title">��<br>��<br>��<br>��</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_ALT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_EXT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CLS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("C_AMT")))%></td>
	</tr>
	<%	
	sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
	sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
	sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
	sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("D_ALT_AMT")));
	sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT")));
	sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("D_EXT_AMT")));
	sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
	sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT")));
	sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT")));
	sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("A_CLS_AMT")));
	sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
	sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("C_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">�Ұ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	</tr>	
	<%
			for(int i = 0 ; i < 12 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>	
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("3")){
					etc_count++;
	%>
	<tr>
		<%if(etc_count==1){%>
	  <td width="40" rowspan='<%=rowspan_cnt3+1%>' class="title">��<br>��<br>��<br>��<br>��<br>��<br>��<br>��</td>
	  <%}%>
	  <td width="40" align="center"><%=etc_count%></td>
	  <td width="200" align="center"><%=ht.get("NM")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_ALT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_EXT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CLS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("C_AMT")))%></td>
	</tr>
	<%			
	sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("CNT1")));
	sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("CNT2")));
	sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
	sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("D_ALT_AMT")));
	sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT")));
	sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("D_EXT_AMT")));
	sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
	sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT")));
	sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT")));
	sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("A_CLS_AMT")));
	sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
	sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("C_AMT")));
				}
			}
	%>
	<tr>
	  <td colspan="2" class="title">�Ұ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[11])%></td>
	</tr>	
	<%
			for(int i = 0 ; i < 12 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
				sum_amt[i]   = 0;
			}
	%>		
	<tr>
	  <td colspan="3" class="title">�հ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[11])%></td>
	</tr>		
	<%	etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				if(String.valueOf(ht.get("ETC")).equals("")){
	%>
	<tr>
	  <td colspan='3' class="title">������</td>
	  <td align="right"></td>
	  <td align="right"></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("CNT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_ALT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_EXT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CLS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("C_AMT")))%></td>
	</tr>
	<%	
	sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("CNT")));
	sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("D_ALT_AMT")));
	sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT")));
	sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("D_EXT_AMT")));
	sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("D_AMT")));
	sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT")));
	sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT")));
	sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("A_CLS_AMT")));
	sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("A_AMT")));
	sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("C_AMT")));
				}
			}
	%>
	<%
			for(int i = 0 ; i < 12 ; i++){
				h_sum_amt[i] = h_sum_amt[i] + sum_amt[i];
			}
	%>			
	<tr>
	  <td colspan="3" class="title">�Ѱ�</td>	  
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[0])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[1])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[2])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[3])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[4])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[5])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[6])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[7])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[8])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[9])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[10])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(h_sum_amt[11])%></td>
	</tr>		
</table>
</form>
</body>
</html>
