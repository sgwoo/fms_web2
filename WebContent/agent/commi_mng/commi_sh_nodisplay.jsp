<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*"%>
<%@ page import="acar.common.*"%>
<%@ include file="/agent/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<%
	String com_id	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	Vector offices = c_db.getCarOffList(com_id);
	int off_size = offices.size();
%>
<script language='javascript'>
<!--
<%	if(off_size > 0){%>
		parent.drop_off();
		parent.add_off('0', '', '전체');
<%		for(int i = 0 ; i < off_size ; i++){
			Hashtable office = (Hashtable)offices.elementAt(i);%>
			parent.add_off(<%=(i+1)%>, '<%=office.get("CAR_OFF_ID")%>', '<%=office.get("CAR_OFF_NM")%>');
<%		}
	}else{%>
		parent.drop_off();
		parent.add_off(0, '', '등록된 영업소가 없습니다');
<%	}%>
-->
</script>
</head>
<body>
</body>
</html>
