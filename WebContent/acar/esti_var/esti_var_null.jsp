<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String sel = request.getParameter("sel")==null?"":request.getParameter("sel");
	String a_c = request.getParameter("a_c")==null?"":request.getParameter("a_c");
	String a_e = request.getParameter("a_e")==null?"":request.getParameter("a_e");
	String m_st = request.getParameter("m_st")==null?"":request.getParameter("m_st");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	Vector cars = e_db.getSearchCode(a_c, m_st);
	int car_size = cars.size();
	int indexV = 0;
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;

<%	if(car_size > 0){%>

	te.length = <%= car_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%		for(int i = 0 ; i < car_size ; i++){
			Hashtable car = (Hashtable)cars.elementAt(i);%>
				te.options[<%=i+1%>].value = '<%=car.get("NM_CD")%>';
				te.options[<%=i+1%>].text = '<%=car.get("NM")%>';
<%		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%	}	%>

//-->
</script>
</head>
<body>
</body>
</html>
