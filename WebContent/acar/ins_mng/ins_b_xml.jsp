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

	
	Vector jarr = ai_db.getInsChangeList(dt, st_dt, end_dt);
	
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
					
			cont_bk = "";
			ch_item = "";
			car_no=ht.get("CAR_NO")+"^javascript:insDisp(&#39;";
			car_no+= ht.get("RENT_MNG_ID")+"&#39;,&#39;"+ht.get("RENT_L_CD")+"&#39;,&#39;"+ht.get("CAR_MNG_ID")+"&#39;,&#39;"+ht.get("INS_ST")+"&#39;)";
			car_no+="^_self";
				if(ht.get("CH_ITEM").equals("1")) {
					ch_item="�빰���Աݾ�";
					cont_bk = ht.get("GCP_KD")+"";  
				}if(ht.get("CH_ITEM").equals("2"))  {
					ch_item="�ڱ��ü����Աݾ�(���/���)";
				}if(ht.get("CH_ITEM").equals("3")) {
					ch_item="������������Ư��";
				}
				if(ht.get("CH_ITEM").equals("4")){
					ch_item="�ڱ��������ذ��Աݾ�";
				}
				if(ht.get("CH_ITEM").equals("5")) {
					ch_item="���ɺ���";
				  cont_bk = ht.get("DRIVING_AGE")+""; }
				if(ht.get("CH_ITEM").equals("6")){
					ch_item="�ִ�īƯ��";
				}
				if(ht.get("CH_ITEM").equals("7")) {
					ch_item="�빰+�ڱ��ü����Աݾ�";
				}
				if(ht.get("CH_ITEM").equals("8")) {
					ch_item="��������";
				}
				if(ht.get("CH_ITEM").equals("9")){
					ch_item="�ڱ����������ڱ�δ��";
				}
				if(ht.get("CH_ITEM").equals("10")){
					ch_item="����2���Աݾ�";
				}
				if(ht.get("CH_ITEM").equals("11")){
					ch_item="������ü";
				}
				if(ht.get("CH_ITEM").equals("12")){
					ch_item="�ڱ��ü����Աݾ�(�λ�)";
				}
				if(ht.get("CH_ITEM").equals("13")) {
					ch_item="��Ÿ";
			}
				if(ht.get("CH_ITEM").equals("14")){ 
					ch_item="��������������Ư��";
				 cont_bk = ht.get("COM_EMP_YN")+""; }
				if(ht.get("CH_ITEM").equals("15")) {
					ch_item="�Ǻ�����";
				}
				if(ht.get("CH_ITEM").equals("16")){
					ch_item="���谻��";
				}
				if(ht.get("CH_ITEM").equals("17")) {
					ch_item="���ڽ�Ư��";
				 cont_bk = ht.get("BLACKBOX_YN")+"";	}		
			
			
			%>
			
			<row  id='<%=i+1%>'>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=car_no%>]]></cell>
				<cell><![CDATA[<%=ht.get("INS_COM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("INS_CON_NO")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(ht.get("INS_START_DT")+"")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(ht.get("INS_EXP_DT")+"")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(ht.get("REG_DT")+"")%>]]></cell>
				<cell><![CDATA[<%=ch_item%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_BEFORE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_AFTER")%>]]></cell>
				<cell><![CDATA[<%=cont_bk%>]]></cell>
				<cell><![CDATA[<%=ht.get("CH_AMT")%>]]></cell>
				<cell><![CDATA[<%=ht.get("I_SU")%>]]></cell>
			</row>
<%}

}%>

</rows>	