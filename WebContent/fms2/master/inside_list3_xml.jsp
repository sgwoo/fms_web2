<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector jarr = ad_db.getInsideReq03(start_dt, end_dt);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
					
			
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NUM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("S_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("SH_CODE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_Y_FORM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DPM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("AUTO_YN")%>]]></cell>   <!-- 추가 -->
				<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRST_CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INIT_REG_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLV_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_FS_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_FV_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_FSV_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CLR_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DC_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("PURC_GU")%>]]></cell>
			</row>
<%}

}%>

</rows>	