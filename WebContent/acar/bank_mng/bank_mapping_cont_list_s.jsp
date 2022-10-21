<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<%
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	
	Vector conts = abl_db.getMappingContList(cont_bn);
	int cont_size = conts.size();
%>
<form  name="form1" method="POST">
<table border=0 cellspacing=0 cellpadding=0 width=680>
    <tr>
        <td class=line>
            <table border=0 cellspacing=1 width=680>
<%	if(cont_size > 0){
		for(int i = 0 ; i < cont_size ; i++){
			Hashtable cont = (Hashtable)conts.elementAt(i);	%>
            	<tr>
            		<td width='80'  align='center'><%=cont.get("RENT_DT")%></td>
            		<td width='100' align='center'><%=cont.get("RENT_L_CD")%></td>
            		<td width='150' align='center'><%=cont.get("FIRM_NM")%></td>
            		<td width='200' align='center'><%=cont.get("CAR_NM")%></td>
            		<td width='100' align='center'><%=cont.get("CAR_NO")%></td>
            		<td width='50'  align='center'><input type="radio" name="r_select" value="<%=cont.get("CAR_MNG_ID")%>"></td>
            	</tr>
<%		}
	}else{%>
				<tr>
					<td colspan='5' align='center'>등록된 데이타가 없습니다</td>
				</tr>
<%	}	%>
            </table>
         </td>
    </tr>
</table>
</form>
<script language='javascript'>
<!--
	parent.form1.cons_size.value = '<%=cont_size%>';
-->
</script>
</body>
</html>
