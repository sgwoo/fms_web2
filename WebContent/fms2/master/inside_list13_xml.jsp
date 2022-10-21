<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*,acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String car_nm = request.getParameter("car_nm")==null?"":request.getParameter("car_nm");

	Vector jarr = ad_db.getInsideReq13(start_dt, end_dt, car_nm);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int jarr_size = 0;
	
	jarr_size = jarr.size();

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("EST_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("USER_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("REG_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("COL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("GARNISH_COL")%>]]></cell>
			</row>
<%}

}%>

</rows>	