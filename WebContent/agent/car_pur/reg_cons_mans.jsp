<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.consignment.*"%>
<jsp:useBean id="cs_db" scope="page" class="acar.consignment.ConsignmentDatabase"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String car_comp_id 	= request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String off_id 		= request.getParameter("off_id")==null?"":request.getParameter("off_id");
	String dlv_ext 		= request.getParameter("dlv_ext")==null?"":request.getParameter("dlv_ext");
	
	//���븮�� ����Ʈ
	Vector vt = cs_db.getConsignmentPurManList(car_comp_id, off_id, dlv_ext);
	int vt_size = vt.size();	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--

//-->
</script>
</head>

<body>
<center>
<form name='form1' action='' method='post'>
<table border="0" cellspacing="0" cellpadding="0" width=670>	    
    <tr>
        <td class=line2></td>
    </tr>
    <tr>
	<td class='line'>
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
		<tr>
		    <td width='10%' rowspan="3" class='title'>���繫��</td>
		    <td colspan="5" class='title'>Ź�۾�ü</td>				  				  
		    <td width='10%' rowspan="3" class='title'>�������</td>
		</tr>
		<tr>
		    <td width='13%' rowspan="2" class='title'>��ȣ</td>
		    <td width='13%' rowspan="2" class='title'>��ȭ��ȣ</td>		    
		    <td colspan="3" class='title'>���븮��</td>				  				  
		</tr>
		<tr>
		    <td width='10%' class='title'>����</td>
		    <td width='16%' class='title'>�������</td>
		    <td width='10%' class='title'>��ȭ��ȣ</td>		    
		</tr>
<%		for(int i = 0 ; i < vt_size ; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
%>
		<tr>
		    <td align='center'><%=ht.get("DLV_EXT")%></td>
		    <td align='center'><%=ht.get("OFF_NM")%></td>
		    <td align='center'><%=ht.get("OFF_TEL")%></td>
		    <td align='center'><%=ht.get("MAN_NM")%></td>
		    <td align='center'><%=ht.get("MAN_SSN")%></td>
		    <td align='center'><%=ht.get("MAN_TEL")%></td>
		    <td align='center'><%=ht.get("REG_DT")%></td>
		</tr>
<%		}%>		
	    </table>
	</td>
    </tr>
</table>
</form>
<script language="JavaScript">
<!--	
//-->
</script>
</center>
</body>
</html>
