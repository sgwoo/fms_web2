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
			<cell><![CDATA[<%=i+1%>]]></cell><!--연번0-->
 	 		<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell><!--차량번호1-->
	 	 	<cell><![CDATA[&nbsp;&nbsp;<%=ht.get("CAR_NM")%>]]></cell><!--차종2-->
	 	 	<cell><![CDATA[
		 	 	<%if(String.valueOf(ht.get("PREPARE")).equals("예비") && !String.valueOf(ht.get("CAR_ST")).equals("2")){%>
		 	 			고객차량
		 	 	<%}else if(String.valueOf(ht.get("PREPARE")).equals("예비") && String.valueOf(ht.get("CAR_ST")).equals("4")){%>
		 	 			월레트고객	
		 	 	<%}else if(String.valueOf(ht.get("PREPARE")).equals("매각")){%>
		 	 			매각		
		 	 	<%}else if(!String.valueOf(ht.get("PREPARE")).equals("예비")){%>
		 	 			임시	
		 	 	<%}else{%>
		 	 			<%=ht.get("PREPARE")%>	<%if(String.valueOf(ht.get("SECONDHAND")).equals("1")){%>(재리스)<%}%>
		 	 	<%}%>				
	 	 	]]></cell><!--구분3-->
 	 		<cell><![CDATA[<%=Util.parseDecimal((String)ht.get("CAR_KM"))%>&nbsp;&nbsp;]]></cell><!--주행거리4-->
	 	 	<cell><![CDATA[<%=ht.get("USERS_COMP")%>]]></cell><!--담당자5-->
	 		<cell><![CDATA[<%=ht.get("DRIVER_NM")%>]]></cell><!--차량운전자6-->
			<cell><![CDATA[<%=ht.get("PARK_PLACE")%>]]></cell><!--주차장7-->
			<cell><![CDATA[<%if(ht.get("IO_GUBUN").equals("1")){%>입고<%}else if(ht.get("IO_GUBUN").equals("2")){%>출고<%}%>]]></cell><!--주차장8-->				
	 	 	<cell><![CDATA[<%=ht.get("END_PLACE")%>]]></cell><!--입/출고일시9-->
	 	 	<cell><![CDATA[<%=ht.get("REG_DT")%>]]></cell><!--입/출고일시9-->
			<cell><![CDATA[<%=ht.get("PARK_MNG")%>]]></cell><!--등록자10-->	
	 		<cell><![CDATA[<%=ht.get("CAR_KEY_CAU")%>]]></cell><!--키위치/사유13-->
	 	</row>
<%		}
	}else{	%>
	<row>
		<cell></cell>
		<cell></cell>
		<cell> 검색된 입/출고 내역이 없습니다.</cell>
	</row>
<%	}%>
</rows>
