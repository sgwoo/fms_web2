<%@ page contentType="text/html; charset=euc-kr" %>
<%@ page language="java" %> 
<%@ page import="java.util.*" %>
<%@ page import="acar.util.*" %>
<%@ page import="acar.common.*" %>
<%@ page import="acar.car_office.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	String h_sel = "";
	String h_car_comp_id = "";
	String h_car_off_id = "";
	int count = 0;
	
	if(request.getParameter("h_sel") != null)		h_sel = request.getParameter("h_sel");
	if(request.getParameter("h_car_comp_id") != null)		h_car_comp_id =request.getParameter("h_car_comp_id");
	if(request.getParameter("h_car_off_id") != null)		h_car_off_id = request.getParameter("h_car_off_id");
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--

	te = parent.d_content.CarOffEmpForm.<%=h_sel%>;
<%

	Vector offices = c_db.getCarOffList(h_car_comp_id);
	int off_size = offices.size();
	int indexV = 0;
	if(off_size > 0)
	{
%>
	te.length = <%= off_size+1 %>;
	te.options[0].value = '';
	te.options[0].text = '선택';

<%
		for(int i = 0 ; i < off_size ; i++)
		{
			Hashtable office = (Hashtable)offices.elementAt(i);
			if(office.get("CAR_OFF_ID").equals(h_car_off_id))
				indexV = i+1;
%>
	te.options[<%=i+1%>].value = '<%= office.get("CAR_OFF_ID") %>';
	te.options[<%=i+1%>].text = '<%= office.get("CAR_OFF_NM") %>';
<%	
		}
	}else{
%>
	
	te.length = 1;
	te.options[0].value = '';
	te.options[0].text = '선택';
	//alert("해당 항목이 존재하지 않습니다.");
<%
	}
%>
	te.selectedIndex = <%= indexV %>;
//-->
</script>
</head>
<body>
<form action="./car_office_p_frame.jsp" name="form1" method="post">
</form>
</body>
</html>
