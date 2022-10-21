<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.parking.*" %>
<jsp:useBean id="pk_db" scope="page" class="acar.parking.ParkIODatabase"/>
<jsp:useBean id="parkIObean" class="acar.parking.ParkIOBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	String park_id 	= request.getParameter("park_id")==null?"1":request.getParameter("park_id");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"1":request.getParameter("gubun2");
	String io_gubun	= request.getParameter("io_gubun")==null?"1":request.getParameter("io_gubun");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String s_dt 	= request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt		= request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	
	
	
	Vector vt = new Vector();
	vt = pk_db.getPark_IO_list(park_id, gubun1, gubun2, io_gubun, t_wd, s_dt, e_dt);
	int vt_size = vt.size();
	if(vt_size > 0 ){
		for(int i=0; i < vt_size; i++){
			
		Hashtable ht = (Hashtable)vt.elementAt(i);
		
		
%>	
		<row  id='<%=i+1%>'>
			<cell><![CDATA[<%=i+1%>]]></cell><!--����0-->
 	 		<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell><!--������ȣ1-->
	 	 	<cell><![CDATA[&nbsp;&nbsp;<%=ht.get("CAR_NM")%>]]></cell><!--����2-->
	 	 	<cell><![CDATA[
		 	 	<%if(String.valueOf(ht.get("PREPARE")).equals("����") && !String.valueOf(ht.get("CAR_ST")).equals("2")){%>
		 	 			������
		 	 	<%}else if(String.valueOf(ht.get("PREPARE")).equals("����") && String.valueOf(ht.get("CAR_ST")).equals("4")){%>
		 	 			����Ʈ��	
		 	 	<%}else if(String.valueOf(ht.get("PREPARE")).equals("�Ű�")){%>
		 	 			�Ű�		
		 	 	<%}else if(!String.valueOf(ht.get("PREPARE")).equals("����")){%>
		 	 			�ӽ�	
		 	 	<%}else{%>
		 	 			<%=ht.get("PREPARE")%>	<%if(String.valueOf(ht.get("SECONDHAND")).equals("1")){%>(�縮��)<%}%>
		 	 	<%}%>				
	 	 	]]></cell><!--����3-->
 	 		<cell><![CDATA[<%=Util.parseDecimal((String)ht.get("CAR_KM"))%>&nbsp;&nbsp;]]></cell><!--����Ÿ�4-->
	 	 	<cell><![CDATA[<%=ht.get("USERS_COMP")%>]]></cell><!--�����5-->
	 		<cell><![CDATA[<%=ht.get("DRIVER_NM")%>]]></cell><!--����������6-->
			<cell><![CDATA[<%=ht.get("PARK_PLACE")%>]]></cell><!--������7-->
			<cell><![CDATA[<%if(ht.get("IO_GUBUN").equals("1")){%>�԰�<%}else if(ht.get("IO_GUBUN").equals("2")){%>���<%}%>]]></cell><!--������8-->				
	 	 	<cell><![CDATA[<%=ht.get("END_PLACE")%>]]></cell><!--��/����Ͻ�9-->
	 	 	<cell><![CDATA[<%=ht.get("REG_DT")%>]]></cell><!--��/����Ͻ�9-->
			<cell><![CDATA[<%=ht.get("PARK_MNG")%>]]></cell><!--�����10-->	
	 		<cell><![CDATA[<%=ht.get("CAR_KEY_CAU")%>]]></cell><!--Ű��ġ/����13-->
	 	</row>
<%		}
	}else{	%>
	<row>
		<cell></cell>
		<cell></cell>
		<cell> �˻��� ��/��� ������ �����ϴ�.</cell>
	</row>
<%	}%>
</rows>
