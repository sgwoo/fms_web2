<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector jarr = ad_db.getInsideReq01(end_dt);
	int jarr_size = 0;
	jarr_size = jarr.size();
		
	if(jarr_size > 0) {	
		for(int i = 0 ; i < jarr_size ; i++) {
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CLIENT_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_GU")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_WAY")%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("FEE_AMT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_START_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_END_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_KD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DPM")%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("CAR_C_AMT")))%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("OPT_C_AMT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("CLR_C_AMT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("SD_C_AMT")))%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("CAR_CT_AMT")))%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("DC_C_AMT")))%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("CAR_F_AMT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("DLV_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INIT_REG_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell>
				<cell><![CDATA[<%=Util.parseDecimal(String.valueOf(ht.get("TODAY_DIST")))%>]]></cell>
			</row>
<%}

}%>

</rows>	