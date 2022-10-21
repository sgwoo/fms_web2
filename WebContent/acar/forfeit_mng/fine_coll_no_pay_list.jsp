<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>


<%
	AddForfeitDatabase afdb = AddForfeitDatabase.getInstance();
	
	Vector vt = afdb.getFineCollNoPayList();
	int vt_size = vt.size();
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<table border=0 cellspacing=0 cellpadding=0 width=3400>
    <tr>
        <td>            
            <table border=1 cellspacing=1 width=100%>
			  <tr>
			    <td width="100" rowspan="2" align="center">����</td>
			    <td width="200" rowspan="2" align="center">û�����</td>				
			    <td width="100" rowspan="2" align="center">������ȣ</td>
			    <td width="200" rowspan="2" align="center">����</td>
			    <td width="100" rowspan="2" align="center">����ȣ</td>
			    <td width="100" rowspan="2" align="center">�Ű�<br>
		        ����</td>
			    <td width="100" rowspan="2" align="center">�뿩<br>
		        ����</td>
			    <td width="100" rowspan="2" align="center">���<br>
		        ����</td>
			    <td colspan="3" align="center">���뿩</td>
			    <td colspan="4" align="center">�ܱ�뿩</td>																																
			    <td width="100" rowspan="2" align="center">���ʿ���</td>
			    <td width="100" rowspan="2" align="center">�������</td>
			    <td width="100" rowspan="2" align="center">�������</td>
			    <td width="100" rowspan="2" align="center">��������</td>
			    <td width="100" rowspan="2" align="center">��������</td>
			    <td width="400" rowspan="2" align="center">�������</td>
			    <td width="200" rowspan="2" align="center">���ݳ���</td>
			    <td width="100" rowspan="2" align="center">���ι��</td>
			    <td width="100" rowspan="2" align="center">������������</td>
			    <td width="100" rowspan="2" align="center">���α�����</td>
			    <td width="100" rowspan="2" align="center">������</td>
			  </tr>
			  <tr>
			    <td width="200" align="center">��</td>
		        <td width="100" align="center">�뿩������</td>
		        <td width="100" align="center">�뿩������</td>
			    <td width="100" align="center">����</td>
			    <td width="200" align="center">�����</td>
			    <td width="100" align="center">������</td>
			    <td width="100" align="center">������</td>
			  </tr>
			  <%for(int i = 0 ; i < vt_size ; i++){
					Hashtable ht = (Hashtable)vt.elementAt(i);%>			  
			  <tr>
			    <td align="center"><%=i+1%></td>
			    <td align="center"><%=ht.get("GOV_NM")%></td>				
			    <td align="center"><%=ht.get("CAR_NO")%></td>
			    <td align="center"><%=ht.get("CAR_NM")%></td>
			    <td align="center"><%=ht.get("RENT_L_CD")%></td>
			    <td align="center"><%=ht.get("SUI_ST")%></td>
			    <td align="center"><%=ht.get("USE_ST")%></td>
			    <td align="center"><%=ht.get("CAR_ST")%></td>
			    <td align="center"><%=ht.get("FIRM_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("MIN_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("MAX_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("RENT_ST")%>&nbsp;</td>
			    <td align="center"><%=ht.get("CUST_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("DELI_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("RET_DT")%>&nbsp;</td>
			    <td align="center"><%=ht.get("BUS_NM")%></td>
			    <td align="center"><%=ht.get("BUS_NM2")%></td>
			    <td align="center"><%=ht.get("MNG_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("FAULT_NM")%>&nbsp;</td>
			    <td align="center"><%=ht.get("VIO_DT")%></td>
		        <td align="center"><%=ht.get("VIO_PLA")%></td>
		        <td align="center"><%=ht.get("VIO_CONT")%></td>
		        <td align="center"><%=ht.get("PAID_ST")%></td>
		        <td align="center"><%=ht.get("REC_DT")%>&nbsp;</td>
		        <td align="center"><%=ht.get("PAID_END_DT")%>&nbsp;</td>
		        <td align="center"><%=ht.get("COLL_DT")%>&nbsp;</td>
			  </tr>
			  <%}%>
          </table>
        </td>
    </tr>
</table>
</body>
</html>