<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename="+AddUtil.getDate(4)+"_acar_car_excel_list.xls");
%>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	int car_cnt 	= request.getParameter("car_cnt")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt"));
	
//	AdminDatabase ad_db = AdminDatabase.getInstance();
	
	Vector vt = ad_db.getMasterCarComAcarExcelList();
	int vt_size = vt.size();
	
//	if(car_cnt > 0 && vt_size > car_cnt) vt_size = car_cnt;
 	

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
  <table border="1" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="33" align="center"><%=c_db.getNameByIdCode("0032", "", car_ext)%> (��)�Ƹ���ī �������� ����Ʈ <%if(car_cnt>0){%>(<%=car_cnt%>��)<%}%></td>
	</tr>		
	<tr>
	  <td colspan="5" align="right"><%=AddUtil.getDate()%> ����</td>
	  <td colspan="28">&nbsp;</td>	  
	</tr>			
	<tr>
	  <td class="title">����</td>
	  <td class="title">����</td>	  
	  <td class="title">�������</td>	  
	  <td class="title">������ȣ</td>
	  <td class="title">����</td>
	  <td class="title">������</td>
	  <td class="title">����</td>			
	  <td class="title">�̼�</td>				  
	  <td class="title">����</td>
	  <td class="title">��</td>
	  <td class="title">�繫��</td>
	  <td class="title">�޴���</td>			
	  <td class="title">�ּ�</td>
	  <td class="title">�ǿ�����</td>
	  <td class="title">�����</td>
	  <td class="title">�뿩�Ⱓ</td>			
	  <td class="title">���ι��</td>
	  <td class="title">���ι��</td>
	  <td class="title">�빰���</td>
	  <td class="title">�ڱ��ü���_������</td>			
	  <td class="title">�ڱ��ü���_�λ�</td>
	  <td class="title">��������</td>
	  <td class="title">�����ڱ�δ��</td>
	  <td class="title">������</td>			
	  <td class="title">��������</td>
	  <td class="title">���ɹ���</td>			
	  <td class="title">�����</td>
	  <td class="title">�Ǻ�����</td>			
	  <td class="title">���ʵ����</td>	
	  <td class="title">�������</td>			
	  <td class="title">�뿩���</td>			
	  <td class="title">���������</td>			
	  <td class="title">����ó</td>	
	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%=ht.get("����")%></td>	  
	  <td align="center"><%=ht.get("�������")%></td>	  	
	  <td align="center"><%=ht.get("������ȣ")%></td>
	  <td align="center"><%=ht.get("����")%></td>
	  <td align="center"><%=ht.get("������")%></td>
	  <td align="center"><%=ht.get("����")%></td>
	  <td align="center"><%=ht.get("�̼�")%></td>	  
	  <td align="center"><%=ht.get("����")%></td>
	  <td align="center"><%=ht.get("��")%></td>
	  <td align="center"><%=ht.get("�繫��")%></td>
	  <td align="center"><%=ht.get("�޴���")%></td>
	  <td align="center"><%=ht.get("�ּ�")%></td>
	  <td align="center"><%=ht.get("�ǿ�����")%></td>
	  <td align="center"><%=ht.get("�����")%></td>
	  <td align="center"><%=ht.get("�뿩�Ⱓ")%></td>
	  <td align="center"><%=ht.get("���ι��")%></td>
	  <td align="center"><%=ht.get("���ι��")%></td>
	  <td align="center"><%=ht.get("�빰���")%></td>
	  <td align="center"><%=ht.get("�ڱ��ü���_������")%></td>
	  <td align="center"><%=ht.get("�ڱ��ü���_�λ�")%></td>
	  <td align="center"><%=ht.get("��������")%></td>
	  <td align="center"><%=ht.get("�����ڱ�δ��")%></td>
	  <td align="center"><%=ht.get("������")%></td>	  
	  <td align="center"><%=ht.get("��������")%></td>
	  <td align="center"><%=ht.get("���ɹ���")%></td>	  
	  <td align="center"><%=ht.get("�����")%></td>
	  <td align="center"><%=ht.get("�Ǻ�����")%></td>	  
	  <td align="center"><%=ht.get("���ʵ����")%></td>
	  <td align="center"><%=ht.get("�������")%></td>
	  <td align="center"><%=ht.get("�뿩���")%></td>	  
	  <td align="center"><%=ht.get("���������")%></td>
	  <td align="center"><%=ht.get("����ó")%></td>	 
	  
	</tr>
	<%	}%>
  </table>
</form>
<script language='javascript'>
<!--
//-->
</script>
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>
