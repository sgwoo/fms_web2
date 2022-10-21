<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="acar.insur.*"%> 
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");	
	String dt = request.getParameter("dt")==null?"":request.getParameter("dt");		
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	if(!st_dt.equals("")) st_dt = AddUtil.replace(st_dt, "-", "");
	if(!end_dt.equals("")) end_dt = AddUtil.replace(end_dt, "-", "");
	
	InsDatabase ai_db = InsDatabase.getInstance();

	
	Vector jarr = ai_db.getInsChangeList2();
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	String nn= "";
	String cont_bk = "";
	String ch_item = "";
	String jobjString = "";
	String car_no = "";

		
	if(jarr_size > 0) {
		
	
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
					
			
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INS_CON_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("ENP_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INS_START_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INS_EXP_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_ITEM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_ITEM_BEFORE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_ITEM_AFTER")%>]]></cell>		
				
			</row>
<%}

}%>

</rows>	