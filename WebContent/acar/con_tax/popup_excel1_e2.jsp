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
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//�α���-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//�α���-������
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String nb_dt = request.getParameter("nb_dt")==null?"":request.getParameter("nb_dt");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String est_mon = request.getParameter("est_mon")==null?"":request.getParameter("est_mon");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort_gubun = request.getParameter("sort_gubun")==null?"":request.getParameter("sort_gubun");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	
	
	Vector taxs = t_db.getTaxExcelList_e2(br_id, gubun1, gubun2, gubun3, "", gubun5, st_dt, end_dt, s_kd, t_wd, sort_gubun, asc);
	int tax_size = taxs.size();
	
	 Date d = new Date();
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		//System.out.println("���糯¥ : "+ sdf.format(d));
		String filename = sdf.format(d)+"_�����Һ񼼵��.xls";
		filename = java.net.URLEncoder.encode(filename, "UTF-8");
		response.setContentType("application/octer-stream");
		response.setHeader("Content-Transper-Encoding", "binary");
		response.setHeader("Content-Disposition","attachment;filename=\"" + filename + "\"");
		response.setHeader("Content-Description", "JSP Generated Data");
	
	
%>
<table border="1" cellspacing="0" cellpadding="0" width=100%>
	<tr>
		<td>���ⱸ��</td>
		<td>���ⱸ�и�</td>
		<td>�����ڵ�</td>
		<td>�����ڵ��</td>
		<td>���⿬����</td>
		<td>������ǰ����</td>
		<td>������ǰ������</td>
		<td>������ǰ��</td>
		<td>�԰�</td>
		<td>�����ȣ</td>
		<td>����</td>
		<td>���Ⱑ��</td>
		<td>ģȯ�������鼼��</td>
		<td>���������鼼��</td>
		<td>�������鼼��</td>
		<td>����ǥ��</td>
		<td>����</td>
		<td>����</td>
		<td>���⼼��</td>
		<td>�鼼�̳�����</td>
		<td>��������</td>
		<td>�����Ҽ���</td>
		<td>������</td>
		<td>�����Ư����</td>
		<td>����ó����ڵ�Ϲ�ȣ</td>
		<td>����ó��ȣ</td>
		<td>������ι�ȣ/���������ȣ</td>
		<td>���Կ�����</td>
		<td>�뵵���濬����</td>
		<td>�������뵵(�����뱸��)</td>
		<td>������ġ��</td>
	</tr>
	<%
		//������ǰ���Ǹ�(����)���� ���� -------------------------------------------------------------------------
		if(tax_size > 0){
			for(int i = 0 ; i < tax_size ; i++){
				Hashtable tax = (Hashtable)taxs.elementAt(i);
	%>
	<tr>
		<td align="center"><%="'01"%><!--���ⱸ��--></td>
		<td align="center"><!--���ⱸ�и�--></td>
		<td align="center">200001<!--�����ڵ�--></td>
		<td align="center"><!--�����ڵ��--></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("TAX_COME_DT")))%><!--���⿬����--></td>
		<td align="center"><%=tax.get("TAX_CODE")%><!--������ǰ����--></td>
		<td align="center"><!--������ǰ������--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NO")),29," ")%><!--������ǰ��--></td>
		<td align="center">��<!--�԰�--></td>
		<td align="center"><%=AddUtil.rpad((String)(tax.get("CAR_NUM")),30," ")%><!--�����ȣ--></td>
		<td align="center">1<!--����--></td>
		<td align="center"><%=AddUtil.lpad((String)tax.get("CAR_FS_AMT"),13,"0")%><!--���Ⱑ��--></td>
		<td align="center"><%=tax.get("BK_122")%><!--ģȯ�������鼼��--></td>
		<td align="center"><!--���������鼼��--></td>
		<td align="center"><%=tax.get("CH_327")%><!--�������鼼��--></td>
		<td align="center"><!--����ǥ��--></td>
		<td align="center"><!--����--></td>
		<td align="center"><!--����--></td>
		<td align="center"><!--���⼼��--></td>
		<td align="center"><!--�鼼�̳�����--></td>
		<td align="center">0<!--��������--></td>
		<td align="center"><!--�����Ҽ���--></td>
		<td align="center"><!--������--></td>
		<td align="center"><!--�����Ư����--></td>
		<td align="center">128-81-47957<!--����ó����ڵ�Ϲ�ȣ--></td>
		<td align="center">(��)�Ƹ���ī<!--����ó��ȣ--></td>
		<td align="center"><!--������ι�ȣ--></td>
		<td align="center"><%=(String)(tax.get("INIT_REG_DT"))%><!--���Կ�����--></td>
		<td align="center"><%=AddUtil.getReplace_dt(String.valueOf(tax.get("RENT_START_DT")))%><!--�뵵���濬����--></td>
		<td align="center">Y<!--�������뵵(�����뱸��)--></td>
		<td align="center"><!--������ġ��--></td>
	</tr>
	<%	}
		}
	%>
</table>
</body>
</html>