<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=ins_stat_sc_in_excel.xls");
%>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "3":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"1":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
	
	int count =0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	Vector vt = ai_db.getInsureStatList(s_kd, t_wd, gubun1);
	int vt_size = vt.size();
%>

<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
//-->
</script>
</head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
<body >
<table border="0" cellspacing="0" cellpadding="0" width='2280'>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='2280'>
			  <tr>
				<td width='40' rowspan="2" class='title'>����</td>
				<td colspan="5" class='title'>��������</td>
				  <td colspan="2" class='title'>&nbsp;</td>
				  <td style="font-size:8pt" width='150' rowspan="2" class='title'>�Ǻ�����</td>
				  <td style="font-size:8pt" colspan="7" class='title'>���谡�Ի���</td>
				  <td style="font-size:8pt" colspan="2" class='title'>����Ⱓ</td>
			      <td style="font-size:8pt" colspan="9" class='title'>�����</td>				
			  </tr>    
			  <tr>
				<td style="font-size:8pt" width='100' class='title'>������ȣ</td>
		        <td style="font-size:8pt" width='80' class='title'>�����Һз�</td>
		        <td style="font-size:8pt" width='80' class='title'>�������ڵ�</td>
		        <td style="font-size:8pt" width='80' class='title'>�������ڵ�</td>
		        <td style="font-size:8pt" width='150' class='title'>����</td>
				  <td style="font-size:8pt" width='80' class='title'>���ʵ����</td>
				  <td style="font-size:8pt" width='80' class='title'>�����</td>
				  <td style="font-size:8pt" width='80' class='title'>��������</td>
				  <td style="font-size:8pt" width='80' class='title'>���Կ���</td>
				  <td style="font-size:8pt" width='80' class='title'>�빰</td>
				  <td style="font-size:8pt" width='80' class='title'>�ڼ�-���</td>
				  <td style="font-size:8pt" width='80' class='title'>�ڼ�-�λ�</td>				  
				  <td style="font-size:8pt" width='80' class='title'>����-����</td>
			      <td style="font-size:8pt" width='80' class='title'>����-�ڱ�</td>
			      <td style="font-size:8pt" width='80' class='title'>������</td>
			      <td style="font-size:8pt" width='80' class='title'>������</td>
			      <td style="font-size:8pt" width='80' class='title'>���ι��1</td>
			      <td style="font-size:8pt" width='80' class='title'>���ι��2</td>
			      <td style="font-size:8pt" width='80' class='title'>�빰���</td>
			      <td style="font-size:8pt" width='80' class='title'>�ڱ��ü</td>
			      <td style="font-size:8pt" width='80' class='title'>��������</td>
			      <td style="font-size:8pt" width='80' class='title'>�д������</td>
			      <td style="font-size:7pt" width='80' class='title'>�ڱ���������</td>
			      <td style="font-size:8pt" width='80' class='title'>Ư��</td>
			      <td style="font-size:8pt" width='80' class='title'>�Ѻ����</td>
				
		      </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td class='line'>
			<table border="0" cellspacing="1" cellpadding="0" width='2280'>
<%
		for(int i = 0 ; i < vt_size ; i++)
		{
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
				<tr>
					<td style="font-size:8pt"  width='40' align='center'><%=i+1%></td>
					<td style="font-size:8pt"  width='100' align='center'><%=ht.get("������ȣ")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�����Һз�")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�������ڵ�")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�������ڵ�")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("����")%>'><%=Util.subData(String.valueOf(ht.get("����")), 10)%></span></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("���ʵ����")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�����")%></td>
					<td style="font-size:8pt"  width='150' align='center'><span title='<%=ht.get("�Ǻ�����")%>'><%=Util.subData(String.valueOf(ht.get("�Ǻ�����")), 10)%></span></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("��������")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("���ɹ���")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�빰���")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�ڱ��ü���_������")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�ڱ��ü���_�λ�")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("��������")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("�����ڱ�δ��")%></td>					
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("���������")%></td>
					<td style="font-size:8pt"  width='80' align='center'><%=ht.get("���踸����")%></td>										
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("����1")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("����2")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("�빰")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("�ڼ�")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("������")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("�д��")%>&nbsp;</td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("����")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("Ư��")%></td>
				    <td style="font-size:8pt"  width='80' align='right'><%=ht.get("�Ѻ����")%></td>					
				</tr>
<%
		}
%>
			</table>
		</td>
		</tr>
</table>
</body>
</html>