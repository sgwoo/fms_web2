<?xml version="1.0" encoding="euc-kr"?>
<%@ page contentType="text/xml; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*" %>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %> 

<rows>	

<%
		String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
		String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
		String start_dt = request.getParameter("start_dt")==null?"":request.getParameter("start_dt");	
		String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
		
		Vector jarr = ad_db.getInsideReq11(start_dt, end_dt);
		
		int jarr_size = 0;
		
		jarr_size = jarr.size();
		
		if(jarr_size > 0) {
			for(int i = 0 ; i < jarr_size ; i++) {
				
				double car_age = 0;
				double car_age_org = 0;
				double o_e = 0;
				double sh_a_m_1 = 0;
				
				String jg_1    = "";
				String jg_c_1   = "";
				String jg_g_9   = "";
				String jg_g_10   = "";
				String jg_4   	= "";
				String jg_14   	= "";
				double y3_km   		= 0;
				String u   		= "";
				String n_var1   = "";
				String jg_g_21   = "";
				String jg_2   = "";
				String o_s   = "";
				
				String b_o_13   = "";
				String agree_dist   = "";
				String o_13   = "";

				
				
				String opt = "";
				int opt_amt = 0;
				int accid_serv_amt1 = 0;
				int accid_serv_amt2 = 0;
				
				
				double age_3y_km = 0.0; 
				String jg_1_sh_a_m_1 = ""; 
				
				double fw917 = 0.0;
		
				Hashtable ht = (Hashtable)jarr.elementAt(i);
				Hashtable ht2 = ad_db.getInsideReq11_1(String.valueOf(ht.get("CAR_MNG_ID")));
				
				if(ht.get("CAR_AGE")!=null) car_age	= Double.parseDouble(String.valueOf(ht.get("CAR_AGE")));
				if(ht.get("CAR_AGE_ORG")!=null) car_age_org	= Double.parseDouble(String.valueOf(ht.get("CAR_AGE_ORG")));
		
				if(ht2.get("JG_1") !=null) jg_1 	=  String.valueOf(ht2.get("JG_1"));
				if(ht2.get("JG_C_1")!=null) jg_c_1 	= String.valueOf(ht2.get("JG_C_1"));
				if(ht2.get("JG_G_9")!=null) jg_g_9 	= String.valueOf(ht2.get("JG_G_9"));
				if(ht2.get("JG_G_10")!=null) jg_g_10 = String.valueOf(ht2.get("JG_G_10"));
				if(ht2.get("JG_4")!=null) jg_4 	= String.valueOf(ht2.get("JG_4"));
				if(ht2.get("SH_A_M_1")!=null) sh_a_m_1 = Double.parseDouble(String.valueOf(ht2.get("SH_A_M_1")));
				if(ht2.get("JG_14")!=null) jg_14 	= String.valueOf(ht2.get("JG_14"));
				if(ht2.get("Y3_KM")!=null) y3_km	= Double.parseDouble(String.valueOf(ht2.get("Y3_KM")));
				if(ht2.get("U")!=null) u 		= String.valueOf(ht2.get("U"));
				if(ht2.get("N_VAR1")!=null) n_var1 	= String.valueOf(ht2.get("N_VAR1"));
				if(ht2.get("JG_G_21")!=null) jg_g_21 = String.valueOf(ht2.get("JG_G_21"));
				if(ht2.get("JG_2")!=null) jg_2 	= String.valueOf(ht2.get("JG_2"));
				if(ht2.get("O_S")!=null) o_s 	= String.valueOf(ht2.get("O_S"));
		
				if(ht2.get("O_E")!=null) o_e 	=  Double.parseDouble(String.valueOf(ht2.get("O_E")));
				
				if(ht2.get("B_O_13")!=null) b_o_13 = String.valueOf(ht2.get("B_O_13"));
				if(ht2.get("AGREE_DIST")!=null) agree_dist = String.valueOf(ht2.get("AGREE_DIST"));
				if(ht2.get("O_13")!=null) o_13 = String.valueOf(ht2.get("O_13"));
		
				if(ht.get("OPT")!=null) opt = String.valueOf(ht.get("OPT"));
				//	if(ht.get("OPT_AMT")!=null) opt_amt = Integer.parseInt(String.valueOf(ht2.get("OPT_AMT")));
				
				if(ht2.get("FW917")!=null && !String.valueOf(ht2.get("FW917")).equals("")) fw917 	=  Double.parseDouble(String.valueOf(ht2.get("FW917")));
					
				if(fw917 == 0 && ht.get("FW917")!=null && !String.valueOf(ht.get("FW917")).equals("")){
					fw917 =  Double.parseDouble(String.valueOf(ht.get("FW917")));
				}
				
				if(y3_km >0 && car_age_org >0){
					age_3y_km = Math.round(((y3_km/36)*car_age_org)*10)/10.0; 	
				}
				if(o_e>0 && sh_a_m_1>0){
					jg_1_sh_a_m_1 =  String.format("%.2f",Math.round((o_e * sh_a_m_1)*100)/100.0);
				}
				
				Vector amts = olcD.getServiceAmt2(String.valueOf(ht.get("CAR_MNG_ID")));	//�����ݾ� 1~2�� ���ϱ�
				
				Vector jarr2 = new Vector();
				
				
				if(		fw917 !=0 
						&& ht2.get("SH_CODE") != null && !String.valueOf(ht2.get("SEQ")).equals("")
						&& ht2.get("SEQ") != null && !String.valueOf(ht2.get("SEQ")).equals("")
					){
					
					jarr2 = ad_db.getInsideReq10_1(fw917, String.valueOf(ht2.get("SH_CODE")), String.valueOf(ht2.get("SEQ")));
				}
				
				
				String jg_opt1 = "";
				String jg_opt2 = "";
				String jg_opt3 = "";
				String jg_opt4 = "";
				
				String v_t_bd1 ="";
				String v_t_bd2 ="";
				String v_t_bd3 ="";
				String v_t_bd4 ="";
				
				int jarr_size2 = 0;
				jarr_size2 = jarr2.size();
				for (int j = 0; j < jarr_size2; j++) {
					
					Hashtable ht3 = (Hashtable) jarr2.elementAt(j);
					if (j == 0) {
						jg_opt1 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd1 = String.valueOf(ht3.get("V_T_BD"));
					} else if (j == 1) {
						jg_opt2 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd2 = String.valueOf(ht3.get("V_T_BD"));
		
					} else if (j == 2) {
						jg_opt3 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd3 = String.valueOf(ht3.get("V_T_BD"));
		
					} else if (j == 3) {
						jg_opt4 = String.valueOf(ht3.get("JG_OPT_1"));
						v_t_bd4 = String.valueOf(ht3.get("V_T_BD"));
					}
				}
				
				int amt_size = amts.size();
		 		int amt_1nd = 0;
		 		int amt_2nd =  0;
		 		int total_amt =  0;
		 		if(amt_size > 0){
		 			for(int j = 0 ; j < amt_size ; j++){
		 				Hashtable ht4 = (Hashtable)amts.elementAt(j);
		 				if(j==0){
		 					amt_1nd = Integer.parseInt(String.valueOf(ht4.get("TOT_AMT")));
		 					total_amt = amt_1nd;
		 				}else if(j==1){
		 					amt_2nd = Integer.parseInt(String.valueOf(ht4.get("TOT_AMT")));
		 					total_amt += amt_2nd;
		 				}else{
		 					total_amt+=Integer.parseInt(String.valueOf(ht4.get("TOT_AMT")));
		 				}
		 			}
		 		}
		 		int car_amt_n_lo = 0;
		 		int car_amt_r_p = 0;
		 		int car_amt_r_n = 0;
		 		
		 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_N_LO")))>0 ) car_amt_n_lo =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_N_LO")))*10000);
		 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_P")))>0 )  	car_amt_r_p =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_P")))*10000);
		 		if(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_N")))>0 )  car_amt_r_n =(int)(Double.parseDouble(String.valueOf(ht.get("CAR_AMT_R_N")))*10000);
 		
 		
 		//Hashtable ht5  = ad_db.getActionInfo(String.valueOf(ht.get("CAR_NO")));
 		
 	
	%>
	 		<row  id='<%=ht.get("CAR_MNG_ID")%>'>
				<cell><![CDATA[]]></cell>
				<cell><![CDATA[<%=i+1%>]]></cell>
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT")))%>]]></cell> <!-- ������� -->
				<cell><![CDATA[<%=ht.get("ACTN_WH")%>]]></cell> <!-- ����� -->
				<cell><![CDATA[<%=ht.get("ACTN_CNT")%>]]></cell> <!-- ���ȸ�� -->
				<cell><![CDATA[<%=ht.get("ACTN_NUM")%>]]></cell> <!-- ��ǰ��ȣ -->
				<cell><![CDATA[<%=ht.get("CAR_NO")%>]]></cell> <!-- ������ȣ -->
				<cell><![CDATA[<%=ht.get("CAR_NM")%>]]></cell> <!-- ���� -->
				<cell><![CDATA[<%=ht.get("CAR_NAME")%>]]></cell> <!-- �� -->
				<cell><![CDATA[<%=AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))%>]]></cell> <!-- ���ʵ���� -->
				<cell><![CDATA[<%=car_age%>]]></cell> <!-- ���� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("KM"))%>]]></cell> <!-- ��������Ÿ� -->
				<cell><![CDATA[<%=ht.get("JG_CODE")%>]]></cell><!-- �����ڵ� -->
				<cell><![CDATA[<%=jg_1 %>]]>%</cell>	<!--����������24�ܰ��� -->
				<cell><![CDATA[<%=jg_c_1%>]]>%</cell>  <!--0���������ܰ� -->
				<cell><![CDATA[<%=jg_g_9%>]]></cell>  <!--0�����ܰ����� -->
				<cell><![CDATA[<%=jg_g_10%>]]></cell>  <!--0�������� ������ -->
				<cell><![CDATA[<%=jg_4%>]]>%</cell>  <!--�����ܰ��� -->
				<cell><![CDATA[<%=sh_a_m_1%>]]>%</cell>  <!--�����߰��� �������� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(y3_km)%>]]></cell>  <!--3�� ǥ������Ÿ� -->
				<cell><![CDATA[<%=jg_14%>]]></cell>  <!--�ش� ���� ǥ�� ����Ÿ� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(age_3y_km)%>]]></cell>  <!--�ش����� ǥ������Ÿ� �ݿ� �ܰ��� -->
				<cell><![CDATA[<%=jg_1_sh_a_m_1%>]]>%</cell>  <!--�ʰ�10000km -->
				<cell><![CDATA[<%=u%>]]>%</cell>  <!--����/����Ÿ� -->
				<cell><![CDATA[<%=n_var1%>]]></cell>  <!--������ ����ȿ�� -->
				<cell><![CDATA[<%=jg_g_21%>]]></cell>  <!--����Ұ� ��� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_AMT"))%>]]></cell>  <!-- �⺻�� -->
				<cell><![CDATA[<%=opt%>]]></cell>  <!--�ɼ� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("OPT_AMT"))%>]]></cell>  <!--�ɼǰ��� -->
				<cell><![CDATA[<%=ht.get("COLO")%>]]></cell>  <!--���� -->
				<cell><![CDATA[<%=ht.get("IN_COL")%>]]></cell>  <!--������� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CLR_AMT"))%>]]></cell>  <!--���󰡰� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_FSV_AMT"))%>]]></cell>  <!--�Һ��ڰ� -->
				
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_n_lo)%>]]></cell>  <!--������ ȯ�� �Һ��ڰ� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_r_p)%>]]></cell>  <!--�Һ�����2 -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(car_amt_r_n)%>]]></cell>  <!--������ ȯ�� �Һ��ڰ�2 -->
				<cell><![CDATA[<%=ht.get("AUTO")%>]]></cell>  <!--������� --> 
				<cell><![CDATA[<%=ht.get("WHEEL_DRIVE")%>]]></cell>  <!--���ӱ�2 -->
				<cell><![CDATA[<%=ht.get("OPTION_B")%>]]></cell>  <!--�ɼ�2 -->
				<cell><![CDATA[<%=ht.get("GAESU_RATE_P")%>]]></cell>  <!--���Խ������Ҽ��� -->
				<cell><![CDATA[<%=ht.get("GAESU_YN")%>]]></cell>  <!--���Խ������Ҽ� �������� -->
				<cell><![CDATA[<%=ht.get("GAESU_REAL_AMT_P")%>]]></cell>  <!--���Խ��� ���Ҽ� �ǰ���� -->
				<cell><![CDATA[<%=ht.get("GAESU_RATE_N")%>]]></cell>  <!--�������� ���Ҽ��� -->
				<cell><![CDATA[<%=ht.get("GAESU_N_YN")%>]]></cell>  <!--�������� ���Ҽ� �������� -->
				<cell><![CDATA[<%=ht.get("GAESU_REAL_AMT_N")%>]]></cell>  <!--�������� ���Ҽ� �ǰ���� -->
				
				<cell><![CDATA[<%=jg_2%>]]></cell>  <!--�Ϲݽ¿�LPG -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_SLL_AMT"))%>]]></cell>  <!--���԰� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("HP_PR"))%>]]></cell>  <!--����� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(o_s)%>]]></cell>  <!--��������ݿ��� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("CAR_S_AMT"))%>]]></cell>  <!--�������� -->
				<cell><![CDATA[<%=ht.get("CAR_S_PER")%>]]>%</cell>  <!--�Һ��ڰ���� ����� �������� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("NAK_PR"))%>]]></cell><!-- ������ -->
				<cell><![CDATA[<%=ht.get("HP_C_PER")%>]]>%</cell><!-- �Һ��ڰ���� -->
				<cell><![CDATA[<%=ht.get("HP_F_PER")%>]]>%</cell><!-- ���԰� ��� -->
				<cell><![CDATA[<%=ht.get("HP_S_PER")%>]]>%</cell><!-- �������� ��� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("HP_S_CHA_AMT"))%>]]></cell><!-- �����ݾ� -->
				<cell><![CDATA[<%=ht.get("ABS_HP_S_CHA_PER")%>]]>%</cell><!-- ����%(����) -->
				<cell><![CDATA[<%=ht.get("HP_C_CHA_PER")%>]]>%</cell><!-- ����%(�Һ���) -->
				<cell><![CDATA[<%=ht.get("MIGR_STAT")%>]]></cell><!-- �������� -->
				<cell><![CDATA[<%=ht.get("ACTN_JUM")%>]]></cell><!-- ��������� -->
				<cell><![CDATA[<%=ht.get("ACCID_YN")%>]]></cell><!-- ������� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(amt_1nd)%>]]></cell><!-- 1�� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(amt_2nd)%>]]></cell><!-- 2�� -->
				<cell><![CDATA[<%=AddUtil.parseDecimal(ht.get("TOT_AMT"))%>]]></cell><!-- ��ü -->
				<cell><![CDATA[<%=ht.get("SE_PER")%>]]>%</cell><!-- �Һ��ڰ���� -->
				<cell><![CDATA[<%=ht.get("SUI_NM")%>]]></cell><!-- ������ -->
				<cell><![CDATA[<%=ht.get("DPM")%>]]></cell><!-- ��ⷮ -->
				<cell><![CDATA[<%=ht.get("FUEL_KD")%>]]></cell><!-- ���� -->
				<cell><![CDATA[<%=ht.get("CAR_Y_FORM")%>]]></cell><!-- �𵨿��� -->
				<cell><![CDATA[<%=ht.get("AUTO_YN")%>]]></cell><!-- ���ӱ� -->
				<cell><![CDATA[<%=ht.get("ACTN_RSN")%>]]></cell><!-- �򰡿��� -->
				<cell><![CDATA[<%=ht.get("A_CNT_YN")%>]]></cell><!-- ħ�������� -->
				<cell><![CDATA[<%=ht.get("DIST_CNG_YN")%>]]></cell><!-- ����Ǳ�ü���� -->
				<cell><![CDATA[<%=ht.get("CAR_PRE_NO")%>]]></cell><!-- ������������ȣ -->
				<cell><![CDATA[<%=ht.get("OFFER_CNT")%>]]></cell><!-- ����Ƚ�� -->
				<cell><![CDATA[<%=jg_opt1%>]]></cell>
				<cell><![CDATA[<%=v_t_bd1%>]]></cell>
				<cell><![CDATA[<%=jg_opt2%>]]></cell>
				<cell><![CDATA[<%=v_t_bd2%>]]></cell>
				<cell><![CDATA[<%=jg_opt3%>]]></cell>
				<cell><![CDATA[<%=v_t_bd3%>]]></cell>
				<cell><![CDATA[<%=jg_opt4%>]]></cell>
				<cell><![CDATA[<%=v_t_bd4%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_ID")%>]]></cell>
				<cell><![CDATA[<%=ht.get("CAR_SEQ")%>]]></cell>
			</row> 
<%}

}%>

</rows>	