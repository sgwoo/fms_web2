<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, java.text.*, java.util.*,jxl.*"%>
<%@ page import="acar.con_tax.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.con_tax.TaxDatabase"/>
<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<link rel=stylesheet type="text/css" href="../../include/table.css">
<body>
<%
	String excel_s_dt = request.getParameter("excel_s_dt")==null?"":request.getParameter("excel_s_dt");
	String excel_e_dt = request.getParameter("excel_e_dt")==null?"":request.getParameter("excel_e_dt");
	
	Vector taxs = t_db.getTaxExcelList_e3(excel_s_dt, excel_e_dt);
	int tax_size = taxs.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("���糯¥ : "+ sdf.format(d));
		String filename = sdf.format(d)+"_�����Һ񼼱Ⱓ��ȸ.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>���ⱸ��</td>
		<td>�����ڵ�</td>
		<td>���⿬����</td>
		<td>������ǰ��</td>
		<td>�԰�</td>
		<td>�����ȣ</td>
		<td>����</td>
		<td>���Ⱑ��</td>
		<td>ģȯ�������鼼��</td>
		<td>�������鼼��</td>
		<td>����ǥ��</td>
		<td>����</td>
		<td>���⼼��</td>
		<td>������</td>
		<td>����ó����ڵ�Ϲ�ȣ</td>
	</tr>
	<%
		//������ǰ���Ǹ�(����)���� ���� -------------------------------------------------------------------------
		if(tax_size > 0){
			for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
	%>
	<tr>
		<td align="center"><%=tax.get("ST1")%><!--���ⱸ��--></td>
		<td align="center"><%=tax.get("ST2")%><!--�����ڵ�--></td>	
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("TAX_COME_DT")))%><!--���⿬����--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NO")),29," ")%><!--������ǰ��--></td>
		<td align="center">��<!--�԰�--></td>		
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NUM")),30," ")%><!--�����ȣ--></td>
		<td align="center">1<!--����--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("CAR_FS_AMT"),13,"0")%><!--���Ⱑ��--></td>
		<td align="center"><%=tax.get("BK_122")%><!--ģȯ�������鼼��--></td>
		<td align="center"><%=tax.get("CH_327")%><!--�������鼼��--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("SUR_AMT"),13,"0")%><!--����ǥ��--></td>
		<td align="center"><%=tax.get("TAX_RATE")%><!--����--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("SPE_TAX_AMT"),13,"0")%><!--���⼼��--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("EDU_TAX_AMT"),13,"0")%><!--������--></td>
		<td align="center">128-81-47957<!--����ó����ڵ�Ϲ�ȣ--></td>
	</tr>
	<%	}
		}
	%>
</table>
</body>
</html>