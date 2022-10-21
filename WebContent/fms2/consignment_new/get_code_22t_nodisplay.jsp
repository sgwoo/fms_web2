<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.common.*"%> 
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
		
	String off_id = request.getParameter("off_id")==null?"":request.getParameter("off_id");
	Vector  codes = new Vector();
	int c_size = 0;	
	  //전국탁송
	if ( off_id.equals("009217")  ) {
		codes = c_db.getCodeAllV_0022_New("0022");	
		c_size = codes.size();
//	} else	if ( off_id.equals("010255")  ) {
//		codes = c_db.getCodeAllV_0022_w("0022");	
//		c_size = codes.size();	
//	} else	if ( off_id.equals("011790")  ) {
//		codes = c_db.getCodeAllV_0022_d("0022");	
//		c_size = codes.size();		
	} else {
	//	codes = c_db.getCodeAllV_0022_all("0022");	
		codes = c_db.getCodeAllV_0022_NNew("0022");	//아마존탁송코드 제외
		c_size= codes.size();
	}	 
		
%>
<html>
<head><title>FMS</title>
<script language='javascript'>
<!--
<%			for(int i = 0 ; i < c_size ; i++){
				Hashtable code = (Hashtable)codes.elementAt(i);%>
				parent.add_deposit(0, '', '선택');	
				parent.add_deposit(<%=(i+1)%>, '<%=code.get("NM_CD")%>', '<%=code.get("NM")%>');				
				
<%	}	%>
-->
</script>
</head>
<link rel=stylesheet type="text/css" href="/include/table.css">
<body leftmargin="15">
</body>
</html>

	