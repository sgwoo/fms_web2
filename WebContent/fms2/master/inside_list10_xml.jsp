<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	
	Vector jarr = ad_db.getInsideReq10(start_dt, end_dt);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();

	double age_3y_km = 0;
	String age_3y_km_str ="";
	
	if(jarr_size > 0) {
		for(int i = 0 ; i < jarr_size ; i++) {
			String jg_opt1 = "";
			String jg_opt2 = "";
			String jg_opt3 = "";
			String jg_opt4 = "";
			
			String v_t_bd1 ="";
			String v_t_bd2 ="";
			String v_t_bd3 ="";
			String v_t_bd4 ="";
			
			
			String jg_opt5 = "";
			String jg_opt6 = "";
			String jg_opt7 = "";
			String jg_opt8 = "";
			
			String v_t_bd5 ="";
			String v_t_bd6 ="";
			String v_t_bd7 ="";
			String v_t_bd8 ="";
			
			
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			Vector jarr2 = ad_db.getInsideReq10_1(Double.parseDouble(String.valueOf(ht.get("FW917"))), String.valueOf(ht.get("SH_CODE")), String.valueOf(ht.get("SEQ")));
			Vector jarr3 = ad_db.getInsideReq10_2(Double.parseDouble(String.valueOf(ht.get("GB917"))), String.valueOf(ht.get("SH_CODE")), String.valueOf(ht.get("SEQ")));
			age_3y_km = Double.parseDouble(String.valueOf(ht.get("S")))/36*Double.parseDouble(String.valueOf(ht.get("CAR_AGE_ORG")));
			age_3y_km_str = AddUtil.parseDecimal(Math.round(age_3y_km*10)/10.0);
			
			int jarr_size2 = 0;
			jarr_size2 = jarr2.size();
			
			int jarr_size3 = 0;
			jarr_size3 = jarr3.size();
			
 
			 for(int j = 0 ; j < jarr_size2 ; j++) {
				Hashtable ht2 = (Hashtable)jarr2.elementAt(j);
				if(j == 0 ){
					jg_opt1 = String.valueOf(ht2.get("JG_OPT_1"));
					v_t_bd1 = String.valueOf(ht2.get("V_T_BD"));
				}else if(j==1){
					jg_opt2 = String.valueOf(ht2.get("JG_OPT_1"));
					v_t_bd2 = String.valueOf(ht2.get("V_T_BD"));
					
				}else if(j==2){
					jg_opt3 = String.valueOf(ht2.get("JG_OPT_1"));
					v_t_bd3 = String.valueOf(ht2.get("V_T_BD"));
					
				}else if(j==3){
					jg_opt4 = String.valueOf(ht2.get("JG_OPT_1"));
					v_t_bd4 = String.valueOf(ht2.get("V_T_BD"));
				}
			} 
			 
			 for(int z = 0 ; z < jarr_size3 ; z++) {
					Hashtable ht3 = (Hashtable)jarr3.elementAt(z);
					if(z == 0 ){
						jg_opt5 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd5 = String.valueOf(ht3.get("V_T_BD"));
					}else if(z==1){
						jg_opt6 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd6 = String.valueOf(ht3.get("V_T_BD"));
						
					}else if(z==2){
						jg_opt7 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd7 = String.valueOf(ht3.get("V_T_BD"));
						
					}else if(z==3){
						jg_opt8 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd8 = String.valueOf(ht3.get("V_T_BD"));
					}
				} 
			
			 
			int car_amt_n_lo = 0;
	 		int car_amt_r_p = 0;
	 		int car_amt_r_n = 0;
	 		
	 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_N_LO")))>0 ) car_amt_n_lo =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_N_LO")))*10000);
	 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_P")))>0 )  	car_amt_r_p =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_P")))*10000);
	 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_N")))>0 )  car_amt_r_n =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_N")))*10000);
		
			%>
			
	 		<row  id='<%=ht.get("RENT_L_CD")%>'>
	 			<cell><![CDATA[]]></cell>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NUM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("RENT_L_CD")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("RENT_DT")))%>]]></cell>
				<cell><![CDATA[<%=ht.get("FIRM_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>]]></cell>   <!-- 추가 -->
				<cell><![CDATA[<%=ht.get("CAR_AGE")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("TOT_DIST"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell>
				<cell><![CDATA[<%=ht.get("M")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("N")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("O")%>]]></cell>
				<cell><![CDATA[<%=ht.get("P")%>]]></cell>
				<cell><![CDATA[<%=ht.get("Q")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("R")%>]]>%</cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("S"))%>]]></cell>
				<cell><![CDATA[<%=age_3y_km_str%>]]></cell>
				<cell><![CDATA[<%=ht.get("JG_1_SH_A_M_1")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("T")%>]]></cell>
				<cell><![CDATA[<%=ht.get("U")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("V")%>]]></cell>
				<cell><![CDATA[<%=ht.get("W")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("OPT")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("OPT_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CLR_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_FSV_AMT"))%>]]></cell>
				
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_n_lo)%>]]></cell>  <!--계약시점 환산 소비자가 -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_r_p)%>]]></cell>  <!--소비지가2 -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_r_n)%>]]></cell>  <!--계약시점 환산 소비자가2 -->
				<cell><![CDATA[<%=ht.get("AUTO")%>]]></cell>  <!--구동방식 --> 
				<cell><![CDATA[<%=ht.get("WHEEL_DRIVE")%>]]></cell>  <!--변속기2 -->
				<cell><![CDATA[<%=ht.get("OPTION_B")%>]]></cell>  <!--옵션2 -->
				<cell><![CDATA[<%=ht.get("GAESU_RATE_P")%>]]></cell>  <!--구입시점개소세율 -->
				<cell><![CDATA[<%=ht.get("GAESU_YN")%>]]></cell>  <!--구입시점개소세 과세여부 -->
				<cell><![CDATA[<%=ht.get("GAESU_REAL_AMT_P")%>]]></cell>  <!--구입시점 개소세 실감면액 -->
				<cell><![CDATA[<%=ht.get("GAESU_RATE_N")%>]]></cell>  <!--낙찰시점 개소세율 -->
				<cell><![CDATA[<%=ht.get("GAESU_N_YN")%>]]></cell>  <!--낙찰시점 개소세 과세여부 -->
				<cell><![CDATA[<%=ht.get("GAESU_REAL_AMT_N")%>]]></cell>  <!--낙찰시점 개소세 실감면액 -->
				
				<cell><![CDATA[<%=ht.get("JG_2")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_SLL_AMT"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("AH"))%>]]></cell> 
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("BC_B_E2"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("BC_FSV_PER")%>]]>%</cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("SH_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("SH_FSV_PER")%>]]>%</cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("AM"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("AN"))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("TOT_AMT"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("ACC_FSV_PER")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("DPM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_Y_FORM")%>]]></cell>
				<cell><![CDATA[<%=ht.get("AUTO_TN")%>]]></cell>
				<cell><![CDATA[<%=ht.get("DIST_CNG_YN")%>]]></cell>
				<cell><![CDATA[<%=ht.get("A_CNT_YN")%>]]></cell>
				<cell><![CDATA[<%=ht.get("AW")%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("AX")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("AY")))%>]]></cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("AZ"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("BA")%>]]></cell>
				<cell><![CDATA[<%=ht.get("BB")%>]]>%</cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("BC"))%>]]></cell>
				<cell><![CDATA[<%=ht.get("BD")%>]]>%</cell>
				<cell><![CDATA[<%=ht.get("BE")%>]]>%</cell>
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("BF"))%>]]></cell>
				<cell><![CDATA[<%=jg_opt1%>]]></cell>
				<cell><![CDATA[<%=v_t_bd1%>]]></cell>
				<cell><![CDATA[<%=jg_opt2%>]]></cell>
				<cell><![CDATA[<%=v_t_bd2%>]]></cell>
				<cell><![CDATA[<%=jg_opt3%>]]></cell>
				<cell><![CDATA[<%=v_t_bd3%>]]></cell>
				<cell><![CDATA[<%=jg_opt4%>]]></cell>
				<cell><![CDATA[<%=v_t_bd4%>]]></cell>
				<cell><![CDATA[<%=jg_opt5%>]]></cell>
				<cell><![CDATA[<%=v_t_bd5%>]]></cell>
				<cell><![CDATA[<%=jg_opt6%>]]></cell>
				<cell><![CDATA[<%=v_t_bd6%>]]></cell>
				<cell><![CDATA[<%=jg_opt7%>]]></cell>
				<cell><![CDATA[<%=v_t_bd7%>]]></cell>
				<cell><![CDATA[<%=jg_opt8%>]]></cell>
				<cell><![CDATA[<%=v_t_bd8%>]]></cell>
				
			</row> 
<%}

}%>

</rows>	