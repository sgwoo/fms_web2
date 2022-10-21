<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String set_code  = Long.toString(System.currentTimeMillis());
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=inside_req_list1_excel_"+set_code+".xls");
%>
<%@ page import="java.util.*,acar.util.*, java.net.*"%>
<%@ page import="acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>


<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector jarr = ad_db.getInsideReq01("");
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
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
  <table border="1" cellspacing="0" cellpadding="0" width=7308>
	<tr>
  <td width=56 style='border-left:none;width:42pt'>����</td>
  <td width=105 style='border-left:none;width:79pt'>����ȣ</td>
  <td width=175 style='border-left:none;width:131pt'>����</td>
  <td width=77 style='border-left:none;width:58pt'>�𵨸�</td>
  <td width=105 style='border-left:none;width:79pt'>������ȣ</td>
  <td width=112 style='border-left:none;width:84pt'>��ȣ</td>
  <td width=161 style='border-left:none;width:121pt'>�����</td>
  <td width=105 style='border-left:none;width:79pt'>��������</td>
  <td width=105 style='border-left:none;width:79pt'>�뵵����</td>
  <td width=91 style='border-left:none;width:68pt'>�뿩����</td>
  <td width=91 style='border-left:none;width:68pt'>�뿩���</td>
  <td width=252 style='border-left:none;width:189pt'>���뿩��</td>
  <td width=105 style='border-left:none;width:79pt'>�뿩������</td>
  <td width=105 style='border-left:none;width:79pt'>�뿩������</td>
  <td width=112 style='border-left:none;width:84pt'>����</td>
  <td width=119 style='border-left:none;width:89pt'>��ⷮ</td>
  <td width=112 style='border-left:none;width:84pt'>��������</td>
  <td width=91 style='border-left:none;width:68pt'>���û��ݾ�</td>
  <td width=91 style='border-left:none;width:68pt'>���û��</td>
  <td width=126 style='border-left:none;width:95pt'>�������ݾ�</td>
  <td width=105 style='border-left:none;width:79pt'>�������</td>
  <td width=91 style='border-left:none;width:68pt'>�������</td>
  <td width=112 style='border-left:none;width:84pt'>Ź�۷�</td>
  <td width=105 style='border-left:none;width:79pt'>�Һ��ڰ��հ�</td>
  <td width=105 style='border-left:none;width:79pt'>��������</td>
  <td width=105 style='border-left:none;width:79pt'>����DC</td>
  <td width=105 style='border-left:none;width:79pt'>���԰��հ�</td>
  <td width=105 style='border-left:none;width:79pt'>�����</td>
  <td width=371 style='border-left:none;width:278pt'>���������</td>
  <td width=161 style='border-left:none;width:121pt'>����</td>
  <td width=182 style='border-left:none;width:137pt'>��������Ÿ�</td>
	</tr>
	<%	for(int i = 0 ; i < jarr_size ; i++) {			
			Hashtable ht = (Hashtable)jarr.elementAt(i);%>
	<tr>
				<td><%=i+1%></td>
				<td><%=ht.get("RENT_L_CD")%></td>
				<td><%=ht.get("CAR_NM")%></td>
				<td><%=ht.get("CAR_NAME")%></td>
				<td><%=ht.get("CAR_NO")%></td>
				<td><%=ht.get("FIRM_NM")%></td>
				<td><%=ht.get("CLIENT_NM")%></td>
				<td><%=ht.get("CAR_GU")%></td>
				<td><%=ht.get("CAR_ST")%></td>
				<td><%=ht.get("RENT_ST")%></td>
				<td><%=ht.get("RENT_WAY")%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%></td>
				<td><%=ht.get("RENT_START_DT")%></td>
				<td><%=ht.get("RENT_END_DT")%></td>
				<td><%=ht.get("CAR_KD")%></td>
				<td><%=ht.get("DPM")%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("OPT_C_AMT")))%></td>
				<td><%=ht.get("OPT")%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("CLR_C_AMT")))%></td>
				<td><%=ht.get("COLO")%></td>
				<td><%=ht.get("IN_COL")%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("SD_C_AMT")))%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("CAR_CT_AMT")))%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("DC_C_AMT")))%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%></td>
				<td><%=ht.get("DLV_DT")%></td>
				<td><%=ht.get("INIT_REG_DT")%></td>
				<td><%=ht.get("FUEL_KD")%></td>
				<td><%=Util.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%></td>
	</tr>
	<%	}%>
  </table>
</body>
</html>
