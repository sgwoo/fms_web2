<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, java.net.*, acar.util.*, acar.admin.*, acar.common.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	String start_dt 	= request.getParameter("start_dt")	==null?"":request.getParameter("start_dt");	
	String end_dt 	= request.getParameter("end_dt")	==null?"":request.getParameter("end_dt");
	String jg_code 	= request.getParameter("jg_code")	==null?"":request.getParameter("jg_code");
	String car_nm 	= request.getParameter("car_nm")		==null?"":request.getParameter("car_nm");
	if(!car_nm.equals(""))	car_nm = URLDecoder.decode(car_nm, "EUC-KR");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	Vector jarr = ad_db.getInsideReq08_2(start_dt, end_dt, jg_code, car_nm);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
		
	if(jarr_size > 0) {
		
		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			%>
			
			<row  id='<%=ht.get("CAR_MNG_ID")%>'>
				<cell><![CDATA[]]></cell>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_OFF_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NUM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("S_ST")%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell>
			
				<!-- 2 -->
				<cell><![CDATA[<%=ht.get("SH_CODE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell> 
				<cell><![CDATA[<%=ht.get("CAR_Y_FORM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DPM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("AUTO_YN")%>]]></cell>   <!-- 추가 -->
				
				<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_ID")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_SEQ")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRST_CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INIT_REG_DT")%>]]></cell>
				
				<!-- 4 -->
				<cell><![CDATA[<%=ht.get("DLV_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_2")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("OPT_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CLR_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("SUM_AMT"))%>]]></cell>

				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_FS_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_FV_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_FSV_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("DC_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("ECAR_PUR_SUB_AMT"))%>]]></cell>		

				<!-- 6 -->
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("GARNISH_COL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("PURC_GU")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				
				
				<cell><![CDATA[<%=ht.get("RENT_DT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CON_MON")%>]]></cell>
				<cell><![CDATA[<%=ht.get("MAX_JA")%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT_PER")%>]]></cell>
				
				 <!-- 8 -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("GRT_AMT_S"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("GUR_P_PER")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("PP_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("PERE_R_PER")%>]]></cell>				
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("IFEE_AMT"))%>]]></cell>

				<cell><![CDATA[<%=ht.get("PERE_R_MTH")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("GI_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("CLS_R_PER")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("RENT_FEE"))%>]]></cell>				
				
				<!-- 10 -->
				<cell><![CDATA[<%=ht.get("USER_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_EXT")%>]]></cell>
				<cell><![CDATA[&nbsp;<%=ht.get("P_ADDR")%>]]></cell>				
				<cell><![CDATA[<%=ht.get("RPT_NO")%>]]></cell>
				
				<cell><![CDATA[<%=ht.get("MGR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("MGR_M_TEL")%>]]></cell>
				<cell><![CDATA[<%=ht.get("MGR_EMAIL")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("AGREE_DIST"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_COMP_ID")%>]]></cell>
			</row>
<%}

}%>

</rows>	