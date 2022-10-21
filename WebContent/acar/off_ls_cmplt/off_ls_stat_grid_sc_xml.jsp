<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<rows>	

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")		==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")		==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")		==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	
	String dt	= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");

	Vector jarr = olcD.getCmplt_stat_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun2, gubun3, gubun_nm, br_id, s_au);
		

	int jarr_size = 0;
	
	jarr_size = jarr.size();
		
	long total_amt1 = 0;
	long total_amt2 = 0;
	long total_amt3 = 0;
	long total_amt5 = 0;
	long total_amt7 = 0;
	long total_amt10 = 0;	
	long total_amt11 = 0;
	long total_amt12 = 0;
	long total_amt13 = 0;
	long total_amt14 = 0;
	
	long out_amt = 0;
	long comm2_tot	=0;
	
	
	float use_per1 = 0;
	float use_per2 = 0;
	float use_per3 = 0;
	float use_per4 = 0;
	
	float use_cnt1 = 0;
	float use_cnt2 = 0;
	float use_cnt3 = 0;
	float use_cnt4 = 0;
	
	float avg_per1 = 0;
	float avg_per2 = 0;
	float avg_per3 = 0;
	float avg_per4 = 0;
		
	String car_no = "";
				
	if(jarr_size > 0 ) {
		
 
		for(int i = 0 ; i < jarr_size ; i++) {

			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
			car_no=ht.get("CAR_NO")+"^javascript:view_detail(&#39;"+ht.get("CAR_MNG_ID")+"&#39;, &#39;"+ht.get("SEQ")+"&#39;);^_self";
	
			if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
				comm2_tot 	= AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
		//		total_amt7	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			}else{
				out_amt = AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			//	total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			}
					
					
			float use_per = AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
						
			if(String.valueOf(ht.get("CLIENT_ID")).equals("000502")){//시화-현대글로비스(주)
				use_cnt1++;
				use_per1 = use_per1 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("013011")){//분당-현대글로비스(주)
				use_cnt2++;
				use_per2 = use_per2 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("022846")){//동화엠파크 013222-> 20150515 (주)케이티렌탈 022846
				use_cnt3++;
				use_per3 = use_per3 + use_per;
			}else if(String.valueOf(ht.get("CLIENT_ID")).equals("011723")||String.valueOf(ht.get("CLIENT_ID")).equals("020385")){//(주)서울자동차경매 -> 에이제이셀카 주식회사
				use_cnt4++;
				use_per4 = use_per4 + use_per;
			}
					
			%>
			
			<row  id='<%=i+1%>'>
			<cell><![CDATA[<%=i+1%>]]></cell>
			<cell><![CDATA[<%=car_no%>]]></cell>
			<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
			<cell><![CDATA[<%=ht.get("FIRM_NM")%><%=ht.get("ACTN_WH")%>]]></cell>
			<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%>]]></cell>
			<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>]]></cell>
			<cell><![CDATA[<%=ht.get("CAR_C_AMT")%>]]></cell>
			<cell><![CDATA[<%=ht.get("CAR_F_AMT")%>]]></cell>
			<cell><![CDATA[<%=ht.get("HP_PR")%>]]></cell>
			<cell><![CDATA[<%=ht.get("CAR_S_AMT")%>]]></cell>
			<cell><![CDATA[<%=ht.get("NAK_PR")%>]]></cell>
			<cell><![CDATA[<%=ht.get("HP_C_PER")%>]]></cell>
			<cell><![CDATA[<%=ht.get("HP_F_PER")%>]]></cell>
			<cell><![CDATA[<%=ht.get("HP_S_PER")%>]]></cell>
			<cell><![CDATA[<%=ht.get("HP_S_CHA_AMT")%>]]></cell>
			<cell><![CDATA[<%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER")),2)%>]]></cell>
			<cell><![CDATA[<%=AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER")),2)%>]]></cell>
			<cell><![CDATA[<%=ht.get("CAR_OLD_MONS")%>]]></cell>
			<cell><![CDATA[<%=ht.get("KM")%>]]></cell>
			<cell><![CDATA[<%=ht.get("ACTN_JUM")%>]]></cell>
			<cell><![CDATA[<%=ht.get("PARK_NM")%>]]></cell>
			<cell><![CDATA[<%=ht.get("ACCID_YN")%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(ht.get("HAP_AMT"))%>]]></cell>
			<cell><![CDATA[<%=AddUtil.parseFloatCipher(String.valueOf(ht.get("SE_PER")),2)%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(ht.get("COMM1_TOT"))%>]]></cell>
			<cell><![CDATA[<%=comm2_tot%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(out_amt)%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(ht.get("COMM3_TOT"))%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(ht.get("COMM_TOT"))%>]]></cell>
			<cell><![CDATA[<%=String.valueOf(ht.get("SUI_NM"))%>]]></cell>
			<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
			<cell><![CDATA[<%=ht.get("OPT_AMT")%>]]></cell>
			<cell><![CDATA[<%=ht.get("DPM")%>]]></cell>
			<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell>
			<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
			<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
			<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell>
			</row>

<%}

}%>
		
	

</rows>	
