<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*, acar.forfeit_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" scope="page" class="acar.forfeit_mng.FineGovBean"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	AddForfeitDatabase a_fdb = AddForfeitDatabase.getInstance();
	
	Vector unRegs = a_fdb.getUnRegList();
	int unReg_size = unRegs.size();
	
		
%>

<html>
<head><title>FMS</title>
<script language='javascript'>

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method='post'>
<table border="1" cellspacing="0" cellpadding="0" width=540>
	<tr>
		<td class='title' width=5%>No</td>
	    <td width=15% class='title'>차량번호</td>
	    <td width=25% class='title'>납세번호</td>
	    <td width=15% class='title'>위반일시</td>
	    <td width=20% class='title'>위반장소</td>
	    <td width=15% class='title'>등록일시</td>
    </tr>
    <%	for(int i = 0 ; i < unReg_size ; i++){
			Hashtable ht = (Hashtable)unRegs.elementAt(i);
			%>
				<tr> 
					<td  width='5%' class='center content_border' style="text-align:center;"><%=i+1%></td>
					<td  width='15%' class='center content_border' style="text-align:center;"><%=ht.get("CAR_NO")%></td>
					<td  width='25%' class='center content_border' style="text-align:center;"><%=ht.get("PAID_NO")%></td>
					<td  width='15%' class='center content_border' style="text-align:center;"><%=ht.get("VIO_DT")%></td>
					<td  width='20%' class='center content_border'><%=ht.get("VIO_PLA")%></td>
					<td  width='15%' class='center content_border' style="text-align:center;"><%=ht.get("REG_DT")%></td>					
				</tr>
  	<% }%>
</table>
</form>
</body>
</html>
