<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.car_mst.*" %>

<%
	CarMstDatabase cdb = CarMstDatabase.getInstance();
	
	String sel = request.getParameter("sel")==null?"":request.getParameter("sel");
	String car_comp_id = request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id");
	String code = request.getParameter("code")==null?"":request.getParameter("code");
	int count = 0;	
%>
<html>
<head>
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	te = parent.<%=sel%>;

<%	Vector offices = cdb.getCarKindList(car_comp_id);
	int off_size = offices.size();
	int indexV = 0;
	if(off_size > 0){%>

	te.length = <%= off_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%		for(int i = 0 ; i < off_size ; i++){
			Hashtable office = (Hashtable)offices.elementAt(i);
			if(office.get("CODE").equals(code))
				indexV = i+1;
%>

	te.options[<%=i+1%>].value = '<%= office.get("CODE") %>';
	te.options[<%=i+1%>].text = '[<%= office.get("CAR_CD") %>]<%= office.get("CAR_NM") %>';

<%		}
	}else{	%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';
	//alert("해당 항목이 존재하지 않습니다.");

<%	}	%>

	te.selectedIndex = <%= indexV %>;

//-->
</script>
</head>
<body>
</body>
</html>
