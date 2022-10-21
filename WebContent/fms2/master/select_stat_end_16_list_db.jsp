<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%> 

<%//@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//�űԿ��� �ߴ��ϰ� �뿩��� ��ӽ�(���簡ġ) ���������θ���Ʈ
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String save_dt 	= request.getParameter("save_dt")==null?"":request.getParameter("save_dt");
	String s_unit 	= request.getParameter("s_unit")==null?"":request.getParameter("s_unit");
	
	Vector vt = ad_db.getSelectStatEndCont17ListDB(save_dt);
	int vt_size = vt.size();
	
	long sum_amt[] = new long[20];
%>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+save_dt+"_select_stat_end_16_list_db.xls");
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
		
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
</head>
<body>
<table border="1" cellspacing="0" cellpadding="0" width=4750>
	<tr>
	  <td rowspan='2' width="50" align="center">����</td>
	  <td rowspan='2' width="200" align="center">������</td>
	  <td rowspan='2' width="100" align="center">������ȣ</td>
	  <td rowspan='2' width="100" align="center">�ڵ��������</td>
	  <td rowspan='2' width="200" align="center">����</td>	  
	  <td rowspan='2' width="200" align="center">����</td>
	  <td rowspan='2' width="100" align="center">��������</td>
	  <td rowspan='2' width="100" align="center">��౸��</td>
	  <td rowspan='2' width="100" align="center">�뵵����</td>
	  <td rowspan='2' width="100" align="center">��������</td>
	  <td rowspan='2' width="100" align="center">��������</td>
	  <td rowspan='2' width="100" align="center">��������</td>
	  
	  <td colspan='2' align="center">�뿩�Ⱓ</td>
	  <td colspan='3' align="center">�ܿ��Ⱓ</td>
	  <td colspan='4' align="center">��ä</td>
	  <td colspan='7' align="center">�ڻ�</td>
	  <td colspan='9' align="center">�׸� ���簡ġ</td>
	  <td colspan='8' align="center">���簡ġ ����� �׸� �ݾ�</td>
	</tr>
	<tr>
	  <td width="100" align="center">������</td>
	  <td width="100" align="center">������</td>
	  <td width="100" align="center">����</td>
	  <td width="100" align="center">��</td>
	  <td width="100" align="center">����+��</td>	  
	  <td width="100" align="center">������</td>
	  <td width="100" align="center">������<br>���簡ġ</td>
	  <td width="100" align="center">�ܿ�������</td>
	  <td width="100" align="center">������ܰ�</td>
	  <td width="100" align="center">������ܰ�<br>���簡ġ</td>
	  <td width="100" align="center">����<br>���簡ġ</td>
	  <td width="100" align="center">�뿩��+����ȿ��<br>���簡ġ</td>
	  <td width="100" align="center">�뿩��<br>���簡ġ</td>
	  <td width="100" align="center">�̼��뿩��</td>	  
	  <td width="100" align="center">������簡ġ</td>
	  <td width="100" align="center">�����</td>
	  <td width="100" align="center">�뿩��</td>
	  <td width="100" align="center">���Ҽ�ȯ�Ծ�<br>6�����̳�</td>
	  <td width="100" align="center">�����</td>
	  <td width="100" align="center">�ڵ�����</td>
	  <td width="100" align="center">�Ϲݽ������</td>
	  <td width="100" align="center">�ڵ����˻��</td>
	  <td width="100" align="center">������ȿ��</td>
	  <td width="100" align="center">������ȿ��</td>
	  <td width="100" align="center">���ô뿩��ȿ��</td>
	  <td width="100" align="center">���뿩��</td>
	  <td width="100" align="center">�������</td>
	  <td width="100" align="center">���ڵ�����</td>
	  <td width="100" align="center">���Ϲݽ������</td>
	  <td width="100" align="center">���ڵ����˻��</td>
	  <td width="100" align="center">�������</td>
	  <td width="100" align="center">10�������Һα�</td>
	  <td width="100" align="center">�ܿ��˻��</td>	  
	</tr>
	<%	int etc_count = 0;
			for(int i = 0 ; i < vt_size ; i++){
				Hashtable ht = (Hashtable)vt.elementAt(i);
				etc_count++;				
	%>
	<tr>	
	  <td align="center"><%=etc_count%></td>
	  <td align="center"><%=ht.get("NM")%></td>
	  <td align="center"><%=ht.get("CAR_NO")%></td>
	  <td align="center"><%=ht.get("INIT_REG_DT")%></td>
	  <td align="center"><%=ht.get("CAR_NM")%></td>
	  <td align="center"><%=ht.get("FIRM_NM")%></td>
	  <td align="center"><%=ht.get("RENT_ST")%></td>
	  <td align="center"><%=ht.get("CAR_ST")%></td>
	  <td align="center"><%=ht.get("CAR_USE")%></td>
	  <td align="center"><%=ht.get("RENT_WAY")%></td>
	  <td align="center"><%=ht.get("B_CAR_MON")%></td>
	  <td align="center"><%=ht.get("B_END_MON")%></td>
	  <td align="center"><%=ht.get("RENT_START_DT")%></td>
	  <td align="center"><%=ht.get("RENT_END_DT")%></td>
	  <td align="center"><%=ht.get("N_MON")%></td>
	  <td align="center"><%=ht.get("N_DAY")%></td>
	  <td align="center"><%=ht.get("N_MONDAY")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_GRT_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("D_EXT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_OPT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CAR_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT_2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT_1")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_DLY_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_PAY_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_CLS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_TAX_AMT2")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_INS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_TAX_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_SERV_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_MAINT_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_GRT_EFF_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_PP_EFF_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_IFEE_EFF_AMT")))%></td>
	  
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_FEE_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_INS_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_TAX_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_SERV_AMT")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("B_MAINT_AMT")))%></td>
	  <td align="center"><%=ht.get("B_CLS_PER")%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("A_G")))%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(String.valueOf(ht.get("O_MAINT_AMT")))%></td>	  
	</tr>
	<%			
					sum_amt[0] = sum_amt[0] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT")));
					sum_amt[1] = sum_amt[1] + AddUtil.parseLong(String.valueOf(ht.get("D_GRT_AMT2")));
					sum_amt[2] = sum_amt[2] + AddUtil.parseLong(String.valueOf(ht.get("D_EXT_AMT")));
					sum_amt[3] = sum_amt[3] + AddUtil.parseLong(String.valueOf(ht.get("B_OPT_AMT")));
					sum_amt[4] = sum_amt[4] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT")));
					sum_amt[5] = sum_amt[5] + AddUtil.parseLong(String.valueOf(ht.get("A_CAR_AMT2")));
					sum_amt[6] = sum_amt[6] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT_2")));
					sum_amt[7] = sum_amt[7] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT_1")));
					sum_amt[8] = sum_amt[8] + AddUtil.parseLong(String.valueOf(ht.get("A_DLY_AMT")));
					sum_amt[9] = sum_amt[9] + AddUtil.parseLong(String.valueOf(ht.get("A_PAY_AMT")));
					sum_amt[10] = sum_amt[10] + AddUtil.parseLong(String.valueOf(ht.get("A_CLS_AMT")));
					sum_amt[11] = sum_amt[11] + AddUtil.parseLong(String.valueOf(ht.get("A_FEE_AMT")));
					sum_amt[12] = sum_amt[12] + AddUtil.parseLong(String.valueOf(ht.get("A_TAX_AMT2")));
					sum_amt[13] = sum_amt[13] + AddUtil.parseLong(String.valueOf(ht.get("A_INS_AMT")));
					sum_amt[14] = sum_amt[14] + AddUtil.parseLong(String.valueOf(ht.get("A_TAX_AMT")));
					sum_amt[15] = sum_amt[15] + AddUtil.parseLong(String.valueOf(ht.get("A_SERV_AMT")));
					sum_amt[16] = sum_amt[16] + AddUtil.parseLong(String.valueOf(ht.get("A_MAINT_AMT")));
					sum_amt[17] = sum_amt[17] + AddUtil.parseLong(String.valueOf(ht.get("A_GRT_EFF_AMT")));
					sum_amt[18] = sum_amt[18] + AddUtil.parseLong(String.valueOf(ht.get("A_PP_EFF_AMT")));
					sum_amt[19] = sum_amt[19] + AddUtil.parseLong(String.valueOf(ht.get("A_IFEE_EFF_AMT")));
			}
			
	%>
	<tr>
	  <td colspan="16" align="center">�հ�</td>	  
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
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[12])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[13])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[14])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[15])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[16])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[17])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[18])%></td>
	  <td align="right"><%=AddUtil.parseDecimalLong(sum_amt[19])%></td>
	  <td colspan="8">&nbsp;</td>
	</tr>	
</table>
</form>
</body>
</html>
