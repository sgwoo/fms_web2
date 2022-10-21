<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*, acar.util.*" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String sel 			= request.getParameter("sel")			==null?"":request.getParameter("sel");
	String car_comp_id 	= request.getParameter("car_comp_id")	==null?"":request.getParameter("car_comp_id");
	String mode 		= request.getParameter("mode")			==null?"":request.getParameter("mode");
	
	//차명
	Vector vt2 = olcD.getSuiAbNm("2", car_comp_id);
	int vt_size2 = vt2.size();
	
	out.println(vt_size2);

%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;

	<%if(vt_size2 > 0){%>
	
			te.length = <%= vt_size2+1 %>;
			te.options[0].value = '';
			te.options[0].text  = '전체';
		
	
	<%		for(int i = 0 ; i < vt_size2 ; i++){
				Hashtable ht = (Hashtable)vt2.elementAt(i);							
	%>
					te.options[<%=i+1%>].value = '<%=ht.get("AB_NM")%>';
					te.options[<%=i+1%>].text  = '<%=ht.get("AB_NM")%>';
	<%		}%>
	<%	}%>
	

//-->
</script>
</head>
<body>
</body>
</html>
