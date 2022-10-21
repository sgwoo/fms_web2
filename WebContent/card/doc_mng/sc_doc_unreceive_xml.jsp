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
			<cell><![CDATA[<%=i+1%>]]></cell><!--����0-->
 	 		<cell><![CDATA[�̼���]]></cell><!--����1-->
	 	 	<cell><![CDATA[<%=ht.get("CARDNO")%>]]></cell><!--ī���ȣ2-->
 	 		<cell><![CDATA[<%=ht.get("CARD_NAME")%>]]></cell><!--������3-->
	 		<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACKDATE")))%>]]></cell><!--�ŷ�����4-->
			<cell><![CDATA[<%=ht.get("MERCNAME")%>]]></cell><!--�ŷ�ó5-->	
			<cell><![CDATA[<%=ht.get("CSAMOUNT")%>]]></cell><!--���ް�6-->	
			<cell><![CDATA[<%=ht.get("CSVAT")%>]]></cell><!--�ΰ���7-->
	 	 	<cell><![CDATA[<%=ht.get("ACKAMOUNT")%>]]></cell><!--�ݾ�8-->
	 	</row>
	<%}
	}%>

</rows>
