<%@ page language="java" contentType="application/vnd.ms-excel; charset=euc-kr" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
response.setHeader("Content-Type", "application/vnd.ms-xls");
response.setHeader("Content-Disposition", "inline; filename=car_maint_excel_list2.xls");
%>
<%@ page import="java.util.*, acar.util.*, acar.master_car.*" %>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"1":request.getParameter("s_kd");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"5":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
			
	Vector vt = mc_db.getSsmotersComAcarExcelList(gubun3, gubun2, s_kd, st_dt, end_dt, gubun1, t_wd, gubun4);
	int vt_size = vt.size();
	
	String gubun4_nm = "";
	
	 if ( gubun4.equals("011614")) {
    	  gubun4_nm = "����";
	 } else	  if ( gubun4.equals("008462")) {
        	  gubun4_nm = "��������";	  
    } else {
    	 gubun4_nm = "�����ڵ���";   
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

<form name='form1' action='' method='post'>
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>
  <table border="1" cellspacing="0" cellpadding="0">
	<tr>
	  <td colspan="23" align="center">(��)�Ƹ���ī �˻� ����Ʈ </td>
	</tr>	
	
	<tr>
	  <td colspan="23" align="center">��ü: <%=gubun4_nm%></td>
	</tr>		
			
	<tr>
	  <td class="title">����</td>
	  <td class="title">����&nbsp; ���ɿ���</td>	  
	  <td class="title">�������</td>	  	  
	  <td class="title">������ȣ</td>
	  <td class="title">����</td>
	  <td class="title">������</td>
	  <td class="title">����</td>			  
	  <td class="title">����</td>
	  <td class="title">��</td>
	  <td class="title">�繫��</td>
	  <td class="title">�ּ�</td>
	  <td class="title">����������</td>		 	
	  <td class="title">�ǿ�����</td>
	  <td class="title">�뿩�Ⱓ</td>			
	  <td class="title">���ʵ����</td>		
	  <td class="title">���ɸ�����</td>		
	  <td class="title">�������</td>
	  <td class="title">�뿩���</td>
	  <td class="title">���������</td>			
	  <td class="title">����ó</td>	
	  <td class="title">�˻���</td>	
	  <td class="title">����</td>	
	  <td class="title">�˻�ݾ�</td>	
			  	  	  	  
	</tr>
	<%	for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);%>
	<tr>
	  <td align="center"><%=i+1%></td>
	  <td align="center"><%if( String.valueOf(ht.get("GUBUN")).equals("1") ){%>�Ƿ�<%}else if (String.valueOf(ht.get("GUBUN")).equals("2") ){%>�Ϸ�<%}else if (String.valueOf(ht.get("GUBUN")).equals("4") ){%>��Ÿ<%}else{ %>���<%}%>
	  &nbsp;&nbsp;<%=ht.get("AG")%></td>	   
	  <td align="center"><%=ht.get("�������")%></td>	  	  
	  <td align="center"><%=ht.get("������ȣ")%></td>
	  <td align="center"><%=ht.get("����")%></td>
	  <td align="center"><%=ht.get("������")%></td>
	  <td align="center"><%=ht.get("����")%></td>
	
	  <td align="center"><%=ht.get("����")%></td>
	  <td align="center"><%if( String.valueOf(ht.get("CAR_ST")).equals("4") ) {%> (��)<%} else { %>&nbsp;<%} %><%=ht.get("��")%></td>
	  <td align="center"><%=ht.get("�繫��")%></td>
	  <td align="left"><%=ht.get("�ּ�")%></td>
	  <td align="center"><%=ht.get("����������")%></td>
	  <td align="center"><%=ht.get("�ǿ�����")%></td>
	  <td align="center"><%=ht.get("�뿩�Ⱓ")%></td>
	  <td align="center"><%=ht.get("���ʵ����")%></td>
	  <td align="center"><%=ht.get("���ɸ�����")%></td>
	  <td align="center"><%=ht.get("�������")%></td>	 
	  <td align="center"><%=ht.get("�뿩���")%></td>	 
	  <td align="center"><%=ht.get("���������")%></td>
	  <td align="center"><%=ht.get("����ó")%></td>	 
	  <td align="center"><%=ht.get("�˻���")%></td>	
	  <td align="center"><%=ht.get("����")%></td>	
	  <td align="right"><%=AddUtil.parseDecimal(ht.get("�˻�ݾ�"))%></td>	 
	   
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
