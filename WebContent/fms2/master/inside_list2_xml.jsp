<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	

	
	Vector jarr = ad_db.getInsideReq02();
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
					
			
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CLIENT_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("USER_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CLR_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell><!-- 내장색상 추가(20190828)  -->
				<cell><![CDATA[<%=ht.get("CS_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLV_BRCH")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("ONE_SELF")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLV_EST_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLV_DT_AS")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INIT_REG_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NUM")%>]]></cell>
			</row>
<%}

}%>

</rows>	