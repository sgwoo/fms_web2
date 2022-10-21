<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<%@ page import="card.*"%>
<jsp:useBean id="CardDb" scope="page" class="card.CardDatabase"/>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	
	String venName = "";
	
	LoginBean login = LoginBean.getInstance();
	
	String acar_id = login.getCookieValue(request, "acar_id");
	
	Vector vts = CardDb.getUnreceivedScard();
	
	int vt_size = vts.size();
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "05", "10", "08");
	
	   
	if(vt_size > 0){
			 
		for(int i=0; i < vt_size; i++){
			Hashtable ht = (Hashtable)vts.elementAt(i);
			
%>
		
		<row  id='<%=i+1%>'>
			<cell><![CDATA[<%=i+1%>]]></cell><!--연번0-->
 	 		<cell><![CDATA[미수신]]></cell><!--상태1-->
	 	 	<cell><![CDATA[<%=ht.get("CARDNO")%>]]></cell><!--카드번호2-->
 	 		<cell><![CDATA[<%=ht.get("CARD_NAME")%>]]></cell><!--소유자3-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACKDATE")))%>]]></cell><!--거래일자4-->
			<cell><![CDATA[<%=ht.get("MERCNAME")%>]]></cell><!--거래처5-->	
			<cell><![CDATA[<%=ht.get("CSAMOUNT")%>]]></cell><!--공급가6-->	
			<cell><![CDATA[<%=ht.get("CSVAT")%>]]></cell><!--부가세7-->
	 	 	<cell><![CDATA[<%=ht.get("ACKAMOUNT")%>]]></cell><!--금액8-->
	 	</row>
	<%}
	}%>

</rows>
