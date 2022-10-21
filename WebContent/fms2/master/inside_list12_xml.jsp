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
	String fuel_kd = request.getParameter("fuel_kd")==null?"":request.getParameter("fuel_kd");

	Vector jarr = ad_db.getInsideReq12(start_dt, end_dt, fuel_kd);
	CommonDataBase c_db = CommonDataBase.getInstance();
	int jarr_size = 0;
	
	jarr_size = jarr.size();

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NUM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FUEL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INIT_REG_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RETN_WAY")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("EST_REA")%>]]></cell>
				<cell><![CDATA[<%=ht.get("ADDR")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CON_MON")%>]]></cell><!-- 내장색상 추가(20190828)  -->
				<cell><![CDATA[<%=c_db.getNameById(String.valueOf(ht.get("BUS_ID")),"USER")%>]]></cell>
				<cell><![CDATA[<%=c_db.getNameById(String.valueOf(ht.get("BUS_ID2")),"USER")%>]]></cell>
				<cell><![CDATA[<%=c_db.getNameById(String.valueOf(ht.get("MNG_ID")),"USER")%>]]></cell>
			</row>
<%}

}%>

</rows>	