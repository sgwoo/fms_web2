<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.common.*" %>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<jsp:useBean id="cmp_db" scope="page" class="acar.stat_bus.CampaignDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 	= request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 	= request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 	= request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String st_dt 	= request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt 	= request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String sort 	= request.getParameter("sort")==null?"":request.getParameter("sort");
	
	String mode 	= request.getParameter("mode")==null?"1":request.getParameter("mode");
	
	int sh_height 	= request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//��ܱ���
   	
   	
   	CommonDataBase c_db = CommonDataBase.getInstance();	
   	
   	
   	
   	String save_dt 	= ad_db.getMaxSaveDt("stat_bus_cmp");
   	String v_year	= "";
	String v_tm	= "";
   	Vector vt = cmp_db.getCampaignList_2012_05_sc2(save_dt, "", "", "");//20120501 ķ���δ�� ����   	
   	//����Ͻ�
	if(vt.size()>0){
		for(int i=0; i<1; i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			v_year 	= (String)ht.get("YEAR");
			v_tm 	= (String)ht.get("TM");
		}
	}	
	//����ķ���κ��� : campaign_var ���̺�
	Hashtable ht3 = cmp_db.getCampaignVar(v_year, v_tm, "1"); //1�� ����
	String cs_dt 		= (String)ht3.get("CS_DT");
	String ce_dt 		= (String)ht3.get("CE_DT");  	

	
	Vector vts1 = ac_db.getSaleCostCampaignUserStatListRm(s_kd, t_wd, sort, st_dt, end_dt, gubun1, gubun2, gubun3, gubun4, gubun5, gubun6, cs_dt, ce_dt);
	int vt_size1 = vts1.size(); 
	

	Vector branches = c_db.getUserDepts("cmp"); 			//�μ� ����Ʈ
	int brch_size 	= branches.size();	   	

			
	
	String br_nm[]	 	= new String[brch_size];	
	
	for (int i = 0 ; i < brch_size ; i++){
        	Hashtable branch = (Hashtable)branches.elementAt(i);
        	br_nm[i] = String.valueOf(branch.get("NM"));
        }

	
	int br_car_type_size[]	 = new int[brch_size];
	
	
	int car_type_cnt   = 0;
	int car_type_size  = 0;
	int arg	 = 0;
	int arg1 = 0;
	int arg2 = 0;
	int arg3 = 0;
	int line = 0;
	
	
	
	
	int var_size = (vt_size1*5)+((brch_size+1)*5);//�����*5+(�μ�+�հ�)*5
	
	
	
   	String dept_nm[]		= new String[var_size];
	String user_nm[]		= new String[var_size];
	String enter_dt[]		= new String[var_size];
	String title[]			= new String[var_size];
	
   	long rent_way_2_cnt[]		= new long[var_size];//�⺻�Ŀ������
	long rent_way_1_cnt[]		= new long[var_size];//�ϹݽĿ������
	long rent_way_t_cnt[]		= new long[var_size];//��������Ұ�
	
   	long af_amt[]	 		= new long[var_size];
	long ea_amt[]	 		= new long[var_size];
	long bc_s_g[]	 		= new long[var_size];
	long fee_s_amt[]		= new long[var_size];
	
	long a_amt[]	 		= new long[var_size];
   	long s_tot[]	 		= new long[var_size];
	long ac_amt[]	 		= new long[var_size];
	long g_tot[]	 		= new long[var_size];
	long ave_amt[]			= new long[var_size];
	
   	float f_amt8[]			= new float[var_size];
   	float f_af_amt[]		= new float[var_size];
   	float f_fee_s_amt[]		= new float[var_size];
	
   	long amt1[]	 		= new long[var_size];
	long amt2[]	 		= new long[var_size];
	long amt3[]	 		= new long[var_size];
	long amt4[]	 		= new long[var_size];
	long amt5[]	 		= new long[var_size];
	long amt6[]	 		= new long[var_size];
	long amt7[]	 		= new long[var_size];
	long amt8[]	 		= new long[var_size];
	long amt9[]	 		= new long[var_size];
	long amt10[] 			= new long[var_size];
	long amt11[] 			= new long[var_size];
	long amt12[] 			= new long[var_size];
	long amt13[] 			= new long[var_size];
	long amt14[] 			= new long[var_size];
	long amt15[] 			= new long[var_size];
	long amt16[] 			= new long[var_size];
	long amt17[] 			= new long[var_size];
	long amt18[] 			= new long[var_size];
	long amt19[] 			= new long[var_size];
	long amt20[] 			= new long[var_size];
	long amt21[] 			= new long[var_size];
	long amt22[] 			= new long[var_size];
	long amt23[] 			= new long[var_size];
	long amt24[] 			= new long[var_size];
	long amt25[] 			= new long[var_size];
	long amt26[] 			= new long[var_size];
	long amt27[] 			= new long[var_size];
	long amt28[] 			= new long[var_size];
	long amt29[] 			= new long[var_size];
	long amt30[] 			= new long[var_size];
	long amt31[] 			= new long[var_size];
	long amt32[] 			= new long[var_size];
	long amt33[] 			= new long[var_size];
	long amt34[] 			= new long[var_size];
	long amt35[] 			= new long[var_size];
	long amt36[] 			= new long[var_size];
	long amt39[] 			= new long[var_size];
	long amt40[] 			= new long[var_size];
	long amt41[] 			= new long[var_size];
	long amt43[] 			= new long[var_size];
	long amt44[] 			= new long[var_size];
	
	//�ʱⰪ
	for(int i = (vt_size1*5) ; i < var_size ; i++){
		user_nm[i]			= "";
		dept_nm[i]			= "";
		enter_dt[i]			= "";
		title[i]			= "";
		rent_way_1_cnt[i]		= 0;
		rent_way_2_cnt[i]		= 0;
		rent_way_t_cnt[i]		= 0;
		amt1[i]				= 0;
		amt2[i]				= 0;
		amt3[i]				= 0;
		amt4[i]				= 0;
		amt5[i]				= 0;
		amt6[i]				= 0;
		amt7[i]				= 0;
		amt8[i]				= 0;
		amt9[i]				= 0;
		amt10[i] 			= 0;
		amt11[i] 			= 0;
		amt12[i] 			= 0;
		amt13[i] 			= 0;
		amt14[i] 			= 0;
		amt15[i] 			= 0;
		amt16[i] 			= 0;
		amt17[i] 			= 0;
		amt18[i] 			= 0;
		amt19[i] 			= 0;
		amt20[i] 			= 0;
		amt21[i] 			= 0;
		amt22[i] 			= 0;
		amt23[i] 			= 0;
		amt24[i] 			= 0;
		amt25[i] 			= 0;
		amt26[i] 			= 0;
		amt27[i] 			= 0;
		amt28[i] 			= 0;
		amt29[i] 			= 0;
		amt30[i] 			= 0;
		amt31[i] 			= 0;
		amt32[i] 			= 0;
		amt33[i] 			= 0;
		amt34[i] 			= 0;
		amt35[i] 			= 0;
		amt36[i] 			= 0;
		amt39[i] 			= 0;
		amt40[i] 			= 0;
		amt41[i] 			= 0;
		amt43[i] 			= 0;
		amt44[i] 			= 0;
		af_amt[i] 			= 0;
		bc_s_g[i] 			= 0;
		fee_s_amt[i] 			= 0;
		f_af_amt[i] 			= 0;
		f_fee_s_amt[i] 			= 0;
		f_amt8[i] 			= 0;
		ea_amt[i] 			= 0;
	}
	
	arg2 = 0;
	
	for(int i = 0 ; i < vt_size1 ; i++){
		Hashtable ht = (Hashtable)vts1.elementAt(i);
		
		for(int k = 0 ; k < 5 ; k++){
			if(k==0) title[arg2+k]			= "����";
			if(k==1) title[arg2+k]			= "�縮��";
			if(k==2) title[arg2+k]			= "����";
			if(k==3) title[arg2+k]			= "��Ÿ";
			if(k==4) title[arg2+k]			= "�Ұ�";
			
			if(k==4){
				user_nm[arg2+k]			= String.valueOf(ht.get("USER_NM"));
				dept_nm[arg2+k]			= String.valueOf(ht.get("DEPT_NM"));
				enter_dt[arg2+k]		= String.valueOf(ht.get("ENTER_DT"));
				rent_way_1_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT")));
				rent_way_2_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT")));
				rent_way_t_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("CON_MON")));
				amt1[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT1")));
				amt2[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT2")));
				amt3[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT3")));
				amt4[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT4")));
				amt5[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT5")));
				amt6[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT6")));
				amt7[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT7")));
				amt8[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT8")));
				amt9[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT9")));
				amt10[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT10")));
				amt11[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT11")));
				amt12[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT12")));
				amt13[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT13")));
				amt14[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT14")));
				amt15[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT15")));
				amt16[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT16")));
				amt17[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT17")));
				amt18[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT18")));
				amt19[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT19")));
				amt20[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT20")));
				amt21[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT21")));
				amt22[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT22")));
				amt23[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT23")));
				amt24[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT24")));
				amt25[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT25")));
				amt26[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT26")));
				amt27[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT27")));
				amt28[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT28")));
				amt29[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT29")));
				amt30[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT30")));
				amt31[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT31")));
				amt32[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT32")));
				amt33[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT33")));
				amt34[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT34")));
				amt35[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT35")));
				amt36[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT36")));
				amt39[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT39")));
				amt40[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT40")));
				amt41[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT41")));
				amt43[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT43")));
				amt44[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT44")));
				af_amt[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT")));
				bc_s_g[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G")));
				fee_s_amt[arg2+k] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT")));
				f_af_amt[arg2+k] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT")));
				f_fee_s_amt[arg2+k] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT")));
				f_amt8[arg2+k] 			= AddUtil.parseFloat(String.valueOf(ht.get("AMT8")));
				ea_amt[arg2+k] 			= amt8[arg2+k]-amt21[arg2+k]+amt30[arg2+k];
			}else{
				user_nm[arg2+k]			= String.valueOf(ht.get("USER_NM"));
				dept_nm[arg2+k]			= String.valueOf(ht.get("DEPT_NM"));
				enter_dt[arg2+k]		= String.valueOf(ht.get("ENTER_DT"));
				rent_way_1_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_1_CNT_"+(k+1))));
				rent_way_2_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("RENT_WAY_2_CNT_"+(k+1))));
				rent_way_t_cnt[arg2+k]		= AddUtil.parseLong(String.valueOf(ht.get("CON_MON_"+(k+1))));
				amt1[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT1_"+(k+1))));
				amt2[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT2_"+(k+1))));
				amt3[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT3_"+(k+1))));
				amt4[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT4_"+(k+1))));
				amt5[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT5_"+(k+1))));
				amt6[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT6_"+(k+1))));
				amt7[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT7_"+(k+1))));
				amt8[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT8_"+(k+1))));
				amt9[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT9_"+(k+1))));
				amt10[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT10_"+(k+1))));
				amt11[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT11_"+(k+1))));
				amt12[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT12_"+(k+1))));
				amt13[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT13_"+(k+1))));
				amt14[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT14_"+(k+1))));
				amt15[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT15_"+(k+1))));
				amt16[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT16_"+(k+1))));
				amt17[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT17_"+(k+1))));
				amt18[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT18_"+(k+1))));
				amt19[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT19_"+(k+1))));
				amt20[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT20_"+(k+1))));
				amt21[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT21_"+(k+1))));
				amt22[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT22_"+(k+1))));
				amt23[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT23_"+(k+1))));
				amt24[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT24_"+(k+1))));
				amt25[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT25_"+(k+1))));
				amt26[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT26_"+(k+1))));
				amt27[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT27_"+(k+1))));
				amt28[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT28_"+(k+1))));
				amt29[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT29_"+(k+1))));
				amt30[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT30_"+(k+1))));
				amt31[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT31_"+(k+1))));
				amt32[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT32_"+(k+1))));
				amt33[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT33_"+(k+1))));
				amt34[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT34_"+(k+1))));
				amt35[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT35_"+(k+1))));
				amt36[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT36_"+(k+1))));
				amt39[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT39_"+(k+1))));
				amt40[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT40_"+(k+1))));
				amt41[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT41_"+(k+1))));
				amt43[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT43_"+(k+1))));
				amt44[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AMT44_"+(k+1))));
				af_amt[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("AF_AMT_"+(k+1))));
				bc_s_g[arg2+k] 			= AddUtil.parseLong(String.valueOf(ht.get("BC_S_G_"+(k+1))));
				fee_s_amt[arg2+k] 		= AddUtil.parseLong(String.valueOf(ht.get("FEE_S_AMT_"+(k+1))));
				f_af_amt[arg2+k] 		= AddUtil.parseFloat(String.valueOf(ht.get("AF_AMT_"+(k+1))));
				f_fee_s_amt[arg2+k] 		= AddUtil.parseFloat(String.valueOf(ht.get("FEE_S_AMT_"+(k+1))));
				f_amt8[arg2+k] 			= AddUtil.parseFloat(String.valueOf(ht.get("AMT8_"+(k+1))));
				ea_amt[arg2+k] 			= amt8[arg2+k]-amt21[arg2+k]+amt30[arg2+k];
			}
		}
		
		
		//���� �հ�-----------------------------------------------------------------------------
		
		int add_arg_size = 0;
		for(int k = 0 ; k < brch_size ; k++){
			if(String.valueOf(ht.get("DEPT_NM")).equals(br_nm[k])){
				br_car_type_size[k] = br_car_type_size[k]+1;
				arg1 = (vt_size1*5)+add_arg_size;
			}
			add_arg_size = add_arg_size+5;		
		}
		
		arg3 = (vt_size1*5)+add_arg_size;
		

		//arg1 - �����Ұ�
		//arg2 - ���������Ʈ
		//arg3 - ���հ�
		
		
		for(int j = 0 ; j < 5 ; j++){
			user_nm[arg1+j]			= user_nm[arg2+j];
			dept_nm[arg1+j]			= dept_nm[arg2+j];
			enter_dt[arg1+j]		= enter_dt[arg2+j];
			rent_way_1_cnt[arg1+j]		+= rent_way_1_cnt[arg2+j];
			rent_way_2_cnt[arg1+j]		+= rent_way_2_cnt[arg2+j];
			rent_way_t_cnt[arg1+j]		+= rent_way_t_cnt[arg2+j];
			amt1[arg1+j]			+= amt1 [arg2+j];
			amt2[arg1+j]			+= amt2 [arg2+j];
			amt3[arg1+j]			+= amt3 [arg2+j];
			amt4[arg1+j]			+= amt4 [arg2+j];
			amt5[arg1+j]			+= amt5 [arg2+j];
			amt6[arg1+j]			+= amt6 [arg2+j];
			amt7[arg1+j]			+= amt7 [arg2+j];
			amt8[arg1+j]			+= amt8 [arg2+j];
			amt9[arg1+j]			+= amt9 [arg2+j];
			amt10[arg1+j] 			+= amt10[arg2+j];
			amt11[arg1+j] 			+= amt11[arg2+j];
			amt12[arg1+j] 			+= amt12[arg2+j];
			amt13[arg1+j] 			+= amt13[arg2+j];
			amt14[arg1+j] 			+= amt14[arg2+j];
			amt15[arg1+j] 			+= amt15[arg2+j];
			amt16[arg1+j] 			+= amt16[arg2+j];
			amt17[arg1+j] 			+= amt17[arg2+j];
			amt18[arg1+j] 			+= amt18[arg2+j];
			amt19[arg1+j] 			+= amt19[arg2+j];
			amt20[arg1+j] 			+= amt20[arg2+j];
			amt21[arg1+j] 			+= amt21[arg2+j];
			amt22[arg1+j] 			+= amt22[arg2+j];
			amt23[arg1+j] 			+= amt23[arg2+j];
			amt24[arg1+j] 			+= amt24[arg2+j];
			amt25[arg1+j] 			+= amt25[arg2+j];
			amt26[arg1+j] 			+= amt26[arg2+j];
			amt27[arg1+j] 			+= amt27[arg2+j];
			amt28[arg1+j] 			+= amt28[arg2+j];
			amt29[arg1+j] 			+= amt29[arg2+j];
			amt30[arg1+j] 			+= amt30[arg2+j];
			amt31[arg1+j] 			+= amt31[arg2+j];
			amt32[arg1+j] 			+= amt32[arg2+j];
			amt33[arg1+j] 			+= amt33[arg2+j];
			amt34[arg1+j] 			+= amt34[arg2+j];
			amt35[arg1+j] 			+= amt35[arg2+j];
			amt36[arg1+j] 			+= amt36[arg2+j];
			amt39[arg1+j] 			+= amt39[arg2+j];
			amt40[arg1+j] 			+= amt40[arg2+j];
			amt41[arg1+j] 			+= amt41[arg2+j];
			amt43[arg1+j] 			+= amt43[arg2+j];
			amt44[arg1+j] 			+= amt44[arg2+j];
			af_amt[arg1+j] 			+= af_amt[arg2+j];
			bc_s_g[arg1+j] 			+= bc_s_g[arg2+j];
			fee_s_amt[arg1+j] 		+= fee_s_amt[arg2+j];
			f_af_amt[arg1+j] 		+= f_af_amt [arg2+j];
			f_fee_s_amt[arg1+j] 		+= f_fee_s_amt[arg2+j];
			f_amt8[arg1+j] 			+= f_amt8[arg2+j];
			ea_amt[arg1+j] 			+= ea_amt[arg2+j];
			
			user_nm[arg3+j]			= user_nm[arg2+j];
			dept_nm[arg3+j]			= dept_nm[arg2+j];
			enter_dt[arg3+j]		= enter_dt[arg2+j];
			rent_way_1_cnt[arg3+j]		+= rent_way_1_cnt[arg2+j];
			rent_way_2_cnt[arg3+j]		+= rent_way_2_cnt[arg2+j];
			rent_way_t_cnt[arg3+j]		+= rent_way_t_cnt[arg2+j];
			amt1[arg3+j]			+= amt1 [arg2+j];
			amt2[arg3+j]			+= amt2 [arg2+j];
			amt3[arg3+j]			+= amt3 [arg2+j];
			amt4[arg3+j]			+= amt4 [arg2+j];
			amt5[arg3+j]			+= amt5 [arg2+j];
			amt6[arg3+j]			+= amt6 [arg2+j];
			amt7[arg3+j]			+= amt7 [arg2+j];
			amt8[arg3+j]			+= amt8 [arg2+j];
			amt9[arg3+j]			+= amt9 [arg2+j];
			amt10[arg3+j] 			+= amt10[arg2+j];
			amt11[arg3+j] 			+= amt11[arg2+j];
			amt12[arg3+j] 			+= amt12[arg2+j];
			amt13[arg3+j] 			+= amt13[arg2+j];
			amt14[arg3+j] 			+= amt14[arg2+j];
			amt15[arg3+j] 			+= amt15[arg2+j];
			amt16[arg3+j] 			+= amt16[arg2+j];
			amt17[arg3+j] 			+= amt17[arg2+j];
			amt18[arg3+j] 			+= amt18[arg2+j];
			amt19[arg3+j] 			+= amt19[arg2+j];
			amt20[arg3+j] 			+= amt20[arg2+j];
			amt21[arg3+j] 			+= amt21[arg2+j];
			amt22[arg3+j] 			+= amt22[arg2+j];
			amt23[arg3+j] 			+= amt23[arg2+j];
			amt24[arg3+j] 			+= amt24[arg2+j];
			amt25[arg3+j] 			+= amt25[arg2+j];
			amt26[arg3+j] 			+= amt26[arg2+j];
			amt27[arg3+j] 			+= amt27[arg2+j];
			amt28[arg3+j] 			+= amt28[arg2+j];
			amt29[arg3+j] 			+= amt29[arg2+j];
			amt30[arg3+j] 			+= amt30[arg2+j];
			amt31[arg3+j] 			+= amt31[arg2+j];
			amt32[arg3+j] 			+= amt32[arg2+j];
			amt33[arg3+j] 			+= amt33[arg2+j];
			amt34[arg3+j] 			+= amt34[arg2+j];
			amt35[arg3+j] 			+= amt35[arg2+j];
			amt36[arg3+j] 			+= amt36[arg2+j];
			amt39[arg3+j] 			+= amt39[arg2+j];
			amt40[arg3+j] 			+= amt40[arg2+j];
			amt41[arg3+j] 			+= amt41[arg2+j];
			amt43[arg3+j] 			+= amt43[arg2+j];
			amt44[arg3+j] 			+= amt44[arg2+j];
			af_amt[arg3+j] 			+= af_amt[arg2+j];
			bc_s_g[arg3+j] 			+= bc_s_g[arg2+j];
			fee_s_amt[arg3+j] 		+= fee_s_amt[arg2+j];
			f_af_amt[arg3+j] 		+= f_af_amt [arg2+j];
			f_fee_s_amt[arg3+j] 		+= f_fee_s_amt[arg2+j];
			f_amt8[arg3+j] 			+= f_amt8[arg2+j];
			ea_amt[arg3+j] 			+= ea_amt[arg2+j];
		}
		
		arg2 = arg2 + 5;
		
	}
	
	for(int k = 0 ; k < brch_size ; k++){
		br_car_type_size[k] = br_car_type_size[k]*5;
	}
	

	
	for(int i = 0 ; i < brch_size+1 ; i++){
		for(int j = (vt_size1*5)+(5*i) ; j < (vt_size1*5)+(5*(i+1)) ; j++){
			if(j == (vt_size1*5)+(5*i)+0) title[j]="����";
			if(j == (vt_size1*5)+(5*i)+1) title[j]="�縮��";
			if(j == (vt_size1*5)+(5*i)+2) title[j]="����";
			if(j == (vt_size1*5)+(5*i)+3) title[j]="��Ÿ";
			if(j == (vt_size1*5)+(5*i)+4) title[j]="�Ұ�";
		}
	}
	
	int start_i 	= 0;
	int end_i 	= 0;
	String d_nm 	= ""; 
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--
	/* Title ���� */
	function setupEvents()
	{
			window.onscroll = moveTitle ;
			window.onresize = moveTitle ; 
	}
	
	function moveTitle()
	{
	    var X ;
	    document.all.tr_title.style.pixelTop = document.body.scrollTop ;
	    document.all.td_title.style.pixelLeft = document.body.scrollLeft ; 
	    document.all.td_con.style.pixelLeft	= document.body.scrollLeft ;   	    
	    
	}
	function init() {
		
		setupEvents();
	}

	//�˾������� ����
	function MM_openBrWindow(theURL,winName,features) { //v2.0
		window.open(theURL,winName,features);
	}	
//-->
</script>
</head>
<body onLoad="javascript:init()">
<form action="" name="form1" method="POST">

<table border="0" cellspacing="0" cellpadding="0" width="5400">
    <tr>
    	<td colspan=2 class=line2></td>
    </tr>
    <tr id='tr_title' style='position:relative;z-index:1'>  
	<td class='line' width='450' id='td_title' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
                <tr> 
                    <td class='title' colspan=6 >����</td>
                </tr>
                <tr> 
                    <td width='30' class='title' rowspan=2>����</td>
                    <td width='270' class='title' rowspan=2>����</td>
                    <td class='title' colspan=3 >���</td>
                </tr>
                <tr> 
                    <td  width="50" class='title' style='font-size:8pt'>�������</td>
                    <td  width="50" class='title' style='font-size:8pt'>�߻��Ǽ�</td>
                    <td  width="50" class='title' style='font-size:8pt'>�Ѱ�����</td>
                </tr>        
            </table>
        </td>
	<td class='line' width='4950' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' height=90>
                <tr>
                    <td width='110' class='title' rowspan=3>���뿩��<br>���簡ġ</td>		  
                    <td width='110' class='title' rowspan=3>����ȿ��</td>
                    <td width='80' class='title' rowspan=3>����</td>		 
                    <td width='100' class='title' rowspan=3>���<br>����ȿ��</td>		 			
                    <td width='100' class='title' rowspan=3>������<br>����ȿ��</td>		 						
                    <td width='110' class='title' rowspan=3>����뿩��</td>
                    <td width='110' class='title' rowspan=3>���뿩��</td>		
                    <td width='80' class='title' rowspan=3>������</td>		 				
         	    <td class="title" colspan=15>����������+��븶��+��Ÿ����</td>
           	    <td class="title" colspan=14>����׸�</td>
                    <td class="title" colspan=9>��Ÿ����ȿ���ݿ���</td>
                </tr>          
                <tr>
         	    <td width=110 class="title" rowspan=2>�⺻��<br>������</td>
                    <td width=110 class="title" rowspan=2>�Ϲݽ�<br>������</td>
                    <td width=110 class="title" rowspan=2>��븶��</td>
		    <td width=110 class="title" rowspan=2>���Ǻ���<br>���Ժ�</td>
                    <td width=110 class="title" rowspan=2>�縮��<br>�ʱ⿵�����</td>
                    <td width=110 class="title" rowspan=2>�縮��<br>�߰���<br>������</td>
                    <td width=110 class="title" rowspan=2>ī�����<br>ĳ����</td>
                    <td width=110 class="title" rowspan=2>ī�����ĳ����<br>�����ݿ���</td>
                    <td width=110 class="title" rowspan=2>���������</td>
                    <td width=110 class="title" rowspan=2>���������<br>�����ݿ���</td>
                    <td width=110 class="title" rowspan=2>�����̰�<br>�������</td>            
                    <td width=110 class="title" rowspan=2>������Ʈ<br>�����������</td>            
                    <td width=110 class="title" rowspan=2>��Ÿ</td>   
                    <td width=110 class="title" rowspan=2>�Ұ�</td> 
                    <td width=80 class="title" rowspan=2>���<br>�뿩��<br>���</td>			            
                    <td width=110 class="title" rowspan=2>�⺻��<br>�ּ�<br>�������</td> 
                    <td width=110 class="title" rowspan=2>�Ϲݽ�<br>�ּ�<br>�������</td>  
                    <td width=110 class="title" rowspan=2>�縮������<br>������<br>(����)</td> 
                    <td width=110 class="title" rowspan=2>����<br>�縮������<br>������</td>  
                    <td width=110 class="title" rowspan=2>����Ŀ�߰�<br>Ź�ۺ��</td>
                    <td width=110 class="title" rowspan=2>���ú��</td> 
                    <td width=110 class="title" rowspan=2>���޿�ǰ</td>  
                    <td width=110 class="title" rowspan=2>�����̹ݿ�<br>����ǰ��</td> 
                    <td width=110 class="title" rowspan=2>�����ε�<br>Ź�ۺ��</td>  			
                    <td width=110 class="title" rowspan=2>�����ε�<br>������</td>  
                    <td width=110 class="title" rowspan=2>��Ʈ<br>����⵿<br>���谡�Ժ�</td>  			
                    <td width=110 class="title" rowspan=2>��Ÿ<br>���</td> 
                    <td class="title" colspan=2>���Ұ�</td>              
                    <td width=110 class="title" rowspan=2>����Ŀ<br>����D/C<br>(����)</td>  
                    <td width=110 class="title" rowspan=2>����Ŀ<br>�߰�D/C<br>(�ݿ���)</td> 
                    <td width=110 class="title" rowspan=2>�ܰ�����ũ<br>����ȿ��</td>  
                    <td width=110 class="title" rowspan=2>�������<br>����ݸ���<br>(����)</td>
                    <td width=110 class="title" rowspan=2>������<br>����ݸ���</td>  
                    <td width=110 class="title" rowspan=2>���°�<br>������</td>
                    <td width=110 class="title" rowspan=2>���������</td>
                    <td width=110 class="title" rowspan=2>��Ÿ</td>  
                    <td width=110 class="title" rowspan=2>�Ұ�</td>               
                </tr> 
                <tr>
                    <td width=110 class="title" >�Ǻ��</td>  
                    <td width=110 class="title" >��ġ</td>   
                </tr>
            </table>
	</td>
    </tr>	  
    <%if(vt_size1 > 0){%>
    <tr height=100>
	<td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
	    
	        <%for(int k = 0 ; k < brch_size ; k++){%>		
		
		<!-- ####### ������~����� ####### -->
                <%	car_type_cnt = 0;
			car_type_size = br_car_type_size[k];
			start_i = end_i;
			end_i = end_i+car_type_size;
			for(int i = start_i ; i < end_i ; i++){					
				d_nm = user_nm[i];
				s_kd = "4";
				t_wd = d_nm;
				gubun6 = "1";
		%>
		<!--�����-->
                <tr> 
		    <%		if(i%5==0){%>
          	    <td width='30' rowspan="5" align="center"><%= i+1%></td>
		    <%			if(car_type_cnt==0){%>
                    <td align="center" width='80' rowspan='<%=car_type_size%>'><%=dept_nm[i]%></td>
		    <%			}%>
                    <td width='60' rowspan="5" align="center"><a href="javascript:parent.list_move('<%=s_kd%>','<%=t_wd%>','<%=gubun6%>');"><%=d_nm%></a></td>
                    <td width='80' rowspan="5" align="center"><%=enter_dt[i]%></td>			 
		    <%		}else{%>			 
		    <%		}%>
                    <td align="center" width='50'><%=title[i]%></td>
                    <td width='50' align="right"><%=rent_way_1_cnt[i]%></td>
                    <td width='50' align="right"><%=rent_way_2_cnt[i]%></td>
                    <td width='50' align="right"><%=rent_way_t_cnt[i]%></td>
                </tr>
                <%		car_type_cnt++;
		  	}
		%>	
				
                <!--�����Ұ�-->
                <%	for(int i = (vt_size1*5)+(5*k) ; i < (vt_size1*5)+(5*(k+1)) ; i++){%>
                <%		if(i%5==0){%>
                <tr> 
                    <td colspan=4 rowspan="5" class=title style='text-align:center;'><%=br_nm[k]%> �Ұ�</td>			
		<%		}else{%>		  
                <tr>				
		<%		}%>
		    <td class=title style='text-align:center;'><%=title[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_1_cnt[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_2_cnt[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_t_cnt[i]%></td>
                </tr>
		<%	}%>	
		
		<%}%>			
				
											
		<!--���հ�-->
		<%	for(int i = (vt_size1*5)+(5*brch_size) ; i < (vt_size1*5)+(5*(brch_size+1)) ; i++){%>
		<%		if(i%5==0){%>
		<tr> 
                    <td colspan=4 rowspan="5" class=title style='text-align:center;'>���հ�</td>			
		<%		}else{%>		  
		<tr>				
		<%		}%>
		    <td class=title style='text-align:center;'><%=title[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_1_cnt[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_2_cnt[i]%></td>
                    <td class=title style='text-align:right;'><%=rent_way_t_cnt[i]%></td>
		</tr>
		<%	}%>			
	        
            </table>
        </td>
		
	<td class='line' width='4950'  >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%' >
		
		<%end_i=0;%>
		
		<%for(int k = 0 ; k < brch_size ; k++){%>	
				
		<!-- ####### ������~����� ####### -->
                <%	start_i = end_i;
			end_i = end_i+br_car_type_size[k];
			for(int i = start_i ; i < end_i ; i++){%>
                <tr> 
	  	    <td width="110" align="right"><%=Util.parseDecimal(af_amt[i])%></td><!--���뿩�����簡ġ -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(ea_amt[i])%></td><!--����ȿ�� -->
	  	    <td width="80"  align="right"><%if(af_amt[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[i]/f_af_amt[i]*100),2)%><%}%></td><!--���� -->
	  	    <td width="100" align="right"><%if(rent_way_1_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_1_cnt[i])%><%}%></td><!--��翵��ȿ�� -->
	  	    <td width="100" align="right"><%if(rent_way_t_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_t_cnt[i])%><%}%></td><!--�����翵��ȿ�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(bc_s_g[i])%></td><!--����뿩�� -->
	  	    <td width="110" align="right"><%=Util.parseDecimal(fee_s_amt[i])%></td><!--���뿩�� -->
	  	    <td width="80"  align="right"><%if(bc_s_g[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[i]-f_fee_s_amt[i])/(bc_s_g[i]-amt43[i]-amt44[i]) ) * 100),2)%><%}%></td><!--������ -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt1[i])%></td><!--�⺻�İ�����-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt2[i])%></td><!--�Ϲݽİ�����-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt3[i])%></td><!--��븶��-->
		    <td width="110" align="right"><%=Util.parseDecimal(amt34[i])%></td><!--���Ǻ��谡�Ժ�-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt4[i])%></td><!--�縮���ʱ⿵�����-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt5[i])%></td><!--�縮���߰���������-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt6[i])%></td><!-- ī�����ĳ����-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt40[i])%></td><!-- ī�����ĳ��������ݿ���-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt35[i])%></td><!-- ���������-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt41[i])%></td><!-- �������������ݿ���-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt36[i])%></td><!-- �����̰��������-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt39[i])%></td><!-- ������Ʈ�����������-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt7[i])%></td><!--��Ÿ-->
                    <td width="110" align="right"><%=Util.parseDecimal(amt8[i])%></td><!--�Ұ� -->
	  	    <td width="80"  align="right"><%if(f_af_amt[i]==0){%>0<%}else{ %><%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[i]/f_af_amt[i]*100),2)%><%}%></td><!--���뿩���� -->									            
                    <td width="110" align="right"><%=Util.parseDecimal(amt9[i])%></td><!--�⺻���ּҰ������ -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt10[i])%></td><!--�Ϲݽ��ּҰ������ --> 
                    <td width="110" align="right"><%=Util.parseDecimal(amt11[i])%></td><!--�縮������������ -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt12[i])%></td><!--�����縮�������� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt13[i])%></td><!--����Ŀ�߰�Ź�� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt15[i])%></td><!--���ú�� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt16[i])%></td><!--���޿�ǰ -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt17[i])%></td><!--�����̹ݿ�����ǰ�� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt14[i])%></td><!--�����ε�Ź�ۺ��  -->			
                    <td width="110" align="right"><%=Util.parseDecimal(amt18[i])%></td><!--�����ε������� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt33[i])%></td><!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->			
                    <td width="110" align="right"><%=Util.parseDecimal(amt19[i])%></td><!--��Ÿ��� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt20[i])%></td><!--�Ǻ�� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt21[i])%></td><!--��ġ -->        
                    <td width="110" align="right"><%=Util.parseDecimal(amt22[i])%></td><!--����D/C -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt23[i])%></td><!--�߰�D/C -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt24[i])%></td><!--�ܰ�����ũ����ȿ�� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt25[i])%></td><!--�����������ݸ���  -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt26[i])%></td><!--����������ݸ��� -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt27[i])%></td><!--�°������ -->
                    <td width="110" align="right"><%=Util.parseDecimal(amt28[i])%></td><!--�����    --> 	
                    <td width="110" align="right"><%=Util.parseDecimal(amt29[i])%></td><!--��Ÿ  -->                   
                    <td width="110" align="right"><%=Util.parseDecimal(amt30[i])%></td><!--�Ұ� -->
                </tr>
		<%	}%>

		<!--�����Ұ�-->
		<%	for(int i = (vt_size1*5)+(5*k) ; i < (vt_size1*5)+(5*(k+1)) ; i++){%>
                <tr> 
	  	    <td class=title style='text-align:right;'><%=Util.parseDecimal(af_amt[i])%></td><!--���뿩�����簡ġ -->
	  	    <td class=title style='text-align:right;'><%=Util.parseDecimal(ea_amt[i])%></td><!--����ȿ�� -->
	  	    <td class=title style='text-align:right;'><%if(af_amt[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[i]/f_af_amt[i]*100),2)%><%}%></td><!--���� -->
	  	    <td class=title style='text-align:right;'><%if(rent_way_1_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_1_cnt[i])%><%}%></td><!--��翵��ȿ�� -->
	  	    <td class=title style='text-align:right;'><%if(rent_way_t_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_t_cnt[i])%><%}%></td><!--�����翵��ȿ�� -->
	  	    <td class=title style='text-align:right;'><%=Util.parseDecimal(bc_s_g[i])%></td><!--����뿩�� -->
	  	    <td class=title style='text-align:right;'><%=Util.parseDecimal(fee_s_amt[i])%></td><!--���뿩�� -->
	    	    <td class=title style='text-align:right;'><%if(bc_s_g[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[i]-f_fee_s_amt[i])/(bc_s_g[i]-amt43[i]-amt44[i]) ) * 100),2)%><%}%></td><!--������ -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt1[i])%></td><!--�⺻�İ�����-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt2[i])%></td><!--�Ϲݽİ�����-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt3[i])%></td><!--��븶��-->
		    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt34[i])%></td><!--���Ǻ��谡�Ժ�-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt4[i])%></td><!--�縮���ʱ⿵�����-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt5[i])%></td><!--�縮���߰���������-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt6[i])%></td><!-- ī�����ĳ����-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt40[i])%></td><!-- ī�����ĳ��������ݿ���-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt35[i])%></td><!-- ���������-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt41[i])%></td><!-- �������������ݿ���-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt36[i])%></td><!-- �����̰��������-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt39[i])%></td><!-- ������Ʈ�����������-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt7[i])%></td><!--��Ÿ-->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt8[i])%></td><!--�Ұ� -->
	  	    <td class=title style='text-align:right;'><%if(f_af_amt[i]==0){%>0<%}else{ %><%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[i]/f_af_amt[i]*100),2)%><%}%></td><!--���뿩���� -->									            
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt9[i])%></td><!--�⺻���ּҰ������ -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt10[i])%></td><!--�Ϲݽ��ּҰ������ --> 
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt11[i])%></td><!--�縮������������ -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt12[i])%></td><!--�����縮�������� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt13[i])%></td><!--����Ŀ�߰�Ź�� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt15[i])%></td><!--���ú�� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt16[i])%></td><!--���޿�ǰ -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt17[i])%></td><!--�����̹ݿ�����ǰ�� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt14[i])%></td><!--�����ε�Ź�ۺ��  -->			
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt18[i])%></td><!--�����ε������� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt33[i])%></td><!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->			
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt19[i])%></td><!--��Ÿ��� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt20[i])%></td><!--�Ǻ�� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt21[i])%></td><!--��ġ -->        
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt22[i])%></td><!--����D/C -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt23[i])%></td><!--�߰�D/C -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt24[i])%></td><!--�ܰ�����ũ����ȿ�� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt25[i])%></td><!--�����������ݸ���  -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt26[i])%></td><!--����������ݸ��� -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt27[i])%></td><!--�°������ -->
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt28[i])%></td><!--�����    --> 	
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt29[i])%></td><!--��Ÿ  -->                   
            	    <td class=title style='text-align:right;'><%=Util.parseDecimal(amt30[i])%></td><!--�Ұ� -->
                </tr>
                <%	}%>

		<%}%>	
		
		
                <!--���հ�-->
                <%	for(int i = (vt_size1*5)+(5*brch_size) ; i < (vt_size1*5)+(5*(brch_size+1)) ; i++){%>
                <tr> 
	  		<td class=title style='text-align:right;'><%=Util.parseDecimal(af_amt[i])%></td><!--���뿩�����簡ġ -->
	  		<td class=title style='text-align:right;'><%=Util.parseDecimal(ea_amt[i])%></td><!--����ȿ�� -->
	  		<td class=title style='text-align:right;'><%if(af_amt[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal(ea_amt[i]/f_af_amt[i]*100),2)%><%}%></td><!--���� -->
	  		<td class=title style='text-align:right;'><%if(rent_way_1_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_1_cnt[i])%><%}%></td><!--��翵��ȿ�� -->
	  		<td class=title style='text-align:right;'><%if(rent_way_t_cnt[i]==0){%>0<%}else{%><%=Util.parseDecimal(ea_amt[i]/rent_way_t_cnt[i])%><%}%></td><!--�����翵��ȿ�� -->
	  		<td class=title style='text-align:right;'><%=Util.parseDecimal(bc_s_g[i])%></td><!--����뿩�� -->
	  		<td class=title style='text-align:right;'><%=Util.parseDecimal(fee_s_amt[i])%></td><!--���뿩�� -->
	  		<td class=title style='text-align:right;'><%if(bc_s_g[i]==0){%>0<%}else{%><%=AddUtil.parseFloatCipher(Util.parseDecimal( ((bc_s_g[i]-f_fee_s_amt[i])/(bc_s_g[i]-amt43[i]-amt44[i]) ) * 100),2)%><%}%></td><!--������ -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt1[i])%></td><!--�⺻�İ�����-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt2[i])%></td><!--�Ϲݽİ�����-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt3[i])%></td><!--��븶��-->
			<td class=title style='text-align:right;'><%=Util.parseDecimal(amt34[i])%></td><!--���Ǻ��谡�Ժ�-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt4[i])%></td><!--�縮���ʱ⿵�����-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt5[i])%></td><!--�縮���߰���������-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt6[i])%></td><!-- ī�����ĳ����-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt40[i])%></td><!-- ī�����ĳ��������ݿ���-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt35[i])%></td><!-- ���������-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt41[i])%></td><!-- �������������ݿ���-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt36[i])%></td><!-- �����̰��������-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt39[i])%></td><!-- ������Ʈ�����������-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt7[i])%></td><!--��Ÿ-->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt8[i])%></td><!--�Ұ� -->
	  		<td class=title style='text-align:right;'><%if(f_af_amt[i]==0){%>0<%}else{ %><%=AddUtil.parseFloatCipher(Util.parseDecimal(f_amt8[i]/f_af_amt[i]*100),2)%><%}%></td><!--���뿩���� -->									            
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt9[i])%></td><!--�⺻���ּҰ������ -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt10[i])%></td><!--�Ϲݽ��ּҰ������ --> 
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt11[i])%></td><!--�縮������������ -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt12[i])%></td><!--�����縮�������� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt13[i])%></td><!--����Ŀ�߰�Ź�� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt15[i])%></td><!--���ú�� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt16[i])%></td><!--���޿�ǰ -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt17[i])%></td><!--�����̹ݿ�����ǰ�� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt14[i])%></td><!--�����ε�Ź�ۺ��  -->			
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt18[i])%></td><!--�����ε������� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt33[i])%></td><!--��Ʈ����⵿���谡�Ժ�->�ӽÿ��ຸ���-->			
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt19[i])%></td><!--��Ÿ��� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt20[i])%></td><!--�Ǻ�� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt21[i])%></td><!--��ġ -->        
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt22[i])%></td><!--����D/C -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt23[i])%></td><!--�߰�D/C -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt24[i])%></td><!--�ܰ�����ũ����ȿ�� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt25[i])%></td><!--�����������ݸ���  -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt26[i])%></td><!--����������ݸ��� -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt27[i])%></td><!--�°������ -->
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt28[i])%></td><!--�����    --> 	
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt29[i])%></td><!--��Ÿ  -->                   
            <td class=title style='text-align:right;'><%=Util.parseDecimal(amt30[i])%></td><!--�Ұ� -->
                <%}%>				
                
                
                	        
	  </table>
	</td>
  </tr>
<%	}else{%>                     
  <tr>
	  <td class='line' width='450' id='td_con' style='position:relative;'> 
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr> 
            <td align='center'>&nbsp;</td>
          </tr>
        </table></td>
	<td class='line' width='4950' >
	    <table border="0" cellspacing="1" cellpadding="0" width='100%'>
          <tr>
		  <td>��ϵ� ����Ÿ�� �����ϴ�</td>
		</tr>
	  </table>
	</td>
  </tr>
<% 	}%>


</table>

</form>
</body>
</html>