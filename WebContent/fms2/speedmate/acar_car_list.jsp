<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String car_ext 	= request.getParameter("car_ext")==null?"":request.getParameter("car_ext");
	int car_cnt 	= request.getParameter("car_cnt")==null?0:AddUtil.parseDigit(request.getParameter("car_cnt"));
	
	Vector vt = ad_db.getMasterCarComAcarExcelList();
	int vt_size = vt.size();
	
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
<table border="0" cellspacing="0" cellpadding="0" width='3500'>
	 <tr>
        <td class=line2></td>
    </tr>
    <tr>
        <td class=line>
            <table width=100% border=0 cellspacing=1 cellpadding=0>
                <tr>
					<td colspan="33" align="center">(��)�Ƹ���ī �������� ����Ʈ</td>
				</tr>		
				<tr>
				  <td colspan="5" align="center"><%=AddUtil.getDate()%> ����</td>
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
	    </td>
    </tr>
</table>
</form>
</body>
</html>
