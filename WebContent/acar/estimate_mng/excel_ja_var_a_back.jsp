<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.estimate_mng.*"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line);
	
	//System.out.println("start_row="+start_row);
	//System.out.println("value_line="+value_line);
	
	int temp_count = 0;
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	String value20[] = request.getParameterValues("value20");
	String value21[] = request.getParameterValues("value21");
	String value22[] = request.getParameterValues("value22");
	String value23[] = request.getParameterValues("value23");
	String value24[] = request.getParameterValues("value24");
	String value25[] = request.getParameterValues("value25");
	String value26[] = request.getParameterValues("value26");
	String value27[] = request.getParameterValues("value27");
	String value28[] = request.getParameterValues("value28");
	String value29[] = request.getParameterValues("value29");
	String value30[] = request.getParameterValues("value30");
	String value31[] = request.getParameterValues("value31");
	String value32[] = request.getParameterValues("value32");
	String value33[] = request.getParameterValues("value33");
	String value34[] = request.getParameterValues("value34");
	String value35[] = request.getParameterValues("value35");
	String value36[] = request.getParameterValues("value36");
	String value37[] = request.getParameterValues("value37");
	String value38[] = request.getParameterValues("value38");
	String value39[] = request.getParameterValues("value39");
	String value40[] = request.getParameterValues("value40");
	String value41[] = request.getParameterValues("value41");
	String value42[] = request.getParameterValues("value42");
	String value43[] = request.getParameterValues("value43");
	String value44[] = request.getParameterValues("value44");
	String value45[] = request.getParameterValues("value45");
	String value46[] = request.getParameterValues("value46");
	String value47[] = request.getParameterValues("value47");
	String value48[] = request.getParameterValues("value48");
	String value49[] = request.getParameterValues("value49");
	String value50[] = request.getParameterValues("value50");
	String value51[] = request.getParameterValues("value51");
	String value52[] = request.getParameterValues("value52");
	String value53[] = request.getParameterValues("value53");
	String value54[] = request.getParameterValues("value54");
	String value55[] = request.getParameterValues("value55");
	String value56[] = request.getParameterValues("value56");
	String value57[] = request.getParameterValues("value57");
	String value58[] = request.getParameterValues("value58");
	String value59[] = request.getParameterValues("value59");
	String value60[] = request.getParameterValues("value60");
	String value61[] = request.getParameterValues("value61");
	String value62[] = request.getParameterValues("value62");
	String value63[] = request.getParameterValues("value63");
	String value64[] = request.getParameterValues("value64");
	String value65[] = request.getParameterValues("value65");
	String value66[] = request.getParameterValues("value66");
	String value67[] = request.getParameterValues("value67");
	String value68[] = request.getParameterValues("value68");
	String value69[] = request.getParameterValues("value69");
	String value70[] = request.getParameterValues("value70");
	String value71[] = request.getParameterValues("value71");
	String value72[] = request.getParameterValues("value72");
	String value73[] = request.getParameterValues("value73");
	String value74[] = request.getParameterValues("value74");
	String value75[] = request.getParameterValues("value75");
	String value76[] = request.getParameterValues("value76");
	String value77[] = request.getParameterValues("value77");
	String value78[] = request.getParameterValues("value78");
	String value79[] = request.getParameterValues("value79");
	String value80[] = request.getParameterValues("value80");
	//20151001 추가
	String value81[] = request.getParameterValues("value81");
	String value82[] = request.getParameterValues("value82");
	String value83[] = request.getParameterValues("value83");
	String value84[] = request.getParameterValues("value84");
	String value85[] = request.getParameterValues("value85");
	String value86[] = request.getParameterValues("value86");
	String value87[] = request.getParameterValues("value87");
	String value88[] = request.getParameterValues("value88");
	String value89[] = request.getParameterValues("value89");
	String value90[] = request.getParameterValues("value90");
	String value91[] = request.getParameterValues("value91");
	String value92[] = request.getParameterValues("value92");
	String value93[] = request.getParameterValues("value93");
	String value94[] = request.getParameterValues("value94");
	String value95[] = request.getParameterValues("value95");
	String value96[] = request.getParameterValues("value96");
	String value97[] = request.getParameterValues("value97");
	String value98[] = request.getParameterValues("value98");
	String value99[] = request.getParameterValues("value99");
	String value100[] = request.getParameterValues("value100");
	String value101[] = request.getParameterValues("value101");
	String value102[] = request.getParameterValues("value102");
	String value103[] = request.getParameterValues("value103");
	String value104[] = request.getParameterValues("value104");
	String value105[] = request.getParameterValues("value105");
	String value106[] = request.getParameterValues("value106");
	String value107[] = request.getParameterValues("value107");
	String value108[] = request.getParameterValues("value108");
	String value109[] = request.getParameterValues("value109");
	String value110[] = request.getParameterValues("value110");
	String value111[] = request.getParameterValues("value111");
	String value112[] = request.getParameterValues("value112");
	String value113[] = request.getParameterValues("value113");
	String value114[] = request.getParameterValues("value114");
	String value115[] = request.getParameterValues("value115");
	String value116[] = request.getParameterValues("value116");
	String value117[] = request.getParameterValues("value117");
	String value118[] = request.getParameterValues("value118");
	String value119[] = request.getParameterValues("value119");
	String value120[] = request.getParameterValues("value120");
	String value121[] = request.getParameterValues("value121");
	String value122[] = request.getParameterValues("value122");
	String value123[] = request.getParameterValues("value123");
	String value124[] = request.getParameterValues("value124");
	String value125[] = request.getParameterValues("value125");
	String value126[] = request.getParameterValues("value126");
	String value127[] = request.getParameterValues("value127");
	String value128[] = request.getParameterValues("value128");
	String value129[] = request.getParameterValues("value129");
	String value130[] = request.getParameterValues("value130");
	String value131[] = request.getParameterValues("value131");
	String value132[] = request.getParameterValues("value132");
	String value133[] = request.getParameterValues("value133");
	String value134[] = request.getParameterValues("value134");
	String value135[] = request.getParameterValues("value135");
	String value136[] = request.getParameterValues("value136");
	String value137[] = request.getParameterValues("value137");
	String value138[] = request.getParameterValues("value138");
	String value139[] = request.getParameterValues("value139");
	String value140[] = request.getParameterValues("value140");
	String value141[] = request.getParameterValues("value141");
	String value142[] = request.getParameterValues("value142");
	String value143[] = request.getParameterValues("value143");
	String value144[] = request.getParameterValues("value144");
	String value145[] = request.getParameterValues("value145");
	String value146[] = request.getParameterValues("value146");
	String value147[] = request.getParameterValues("value147");
	String value148[] = request.getParameterValues("value148");
	String value149[] = request.getParameterValues("value149");
	String value150[] = request.getParameterValues("value150");	
	String value151[] = request.getParameterValues("value151");
	String value152[] = request.getParameterValues("value152");
	String value153[] = request.getParameterValues("value153");
	String value154[] = request.getParameterValues("value154");
	String value155[] = request.getParameterValues("value155");
	String value156[] = request.getParameterValues("value156");
	String value157[] = request.getParameterValues("value157");
	String value158[] = request.getParameterValues("value158");
	String value159[] = request.getParameterValues("value159");
	String value160[] = request.getParameterValues("value160");
	String value161[] = request.getParameterValues("value161");
	String value162[] = request.getParameterValues("value162");
	//20180529 추가
	String value163[] = request.getParameterValues("value163");
	String value164[] = request.getParameterValues("value164");
	String value165[] = request.getParameterValues("value165");
	String value166[] = request.getParameterValues("value166");
	String value167[] = request.getParameterValues("value167");
	String value168[] = request.getParameterValues("value168");
	String value169[] = request.getParameterValues("value169");
	String value170[] = request.getParameterValues("value170");
	String value171[] = request.getParameterValues("value171");
	String value172[] = request.getParameterValues("value172");
	String value173[] = request.getParameterValues("value173");
	String value174[] = request.getParameterValues("value174");
	String value175[] = request.getParameterValues("value175");
	String value176[] = request.getParameterValues("value176");
	String value177[] = request.getParameterValues("value177");
	String value178[] = request.getParameterValues("value178");
	String value179[] = request.getParameterValues("value179");
	String value180[] = request.getParameterValues("value180");
	String value181[] = request.getParameterValues("value181");
	String value182[] = request.getParameterValues("value182");
	String value183[] = request.getParameterValues("value183");
	String value184[] = request.getParameterValues("value184");
	String value185[] = request.getParameterValues("value185");
	String value186[] = request.getParameterValues("value186");
	String value187[] = request.getParameterValues("value187");
	String value188[] = request.getParameterValues("value188");
	String value189[] = request.getParameterValues("value189");
	String value190[] = request.getParameterValues("value190");
	String value191[] = request.getParameterValues("value191");
	
	//System.out.println("gg >> " + value1.length);

	String sh_code 	= "";	
	String com_nm 	= "";
	String cars 	= "";
	float  jg_1 	= 0;
	String jg_2 	= "";
	float  jg_3 	= 0;
	float  jg_3_1 	= 0;
	float  jg_4 	= 0;
	float  jg_5 	= 0;
	float  jg_6 	= 0;
	int    jg_7 	= 0;
	float  jg_8 	= 0;
	float  jg_9 	= 0;
	float  jg_10 	= 0;
	float  jg_11 	= 0;
	float  jg_12 	= 0;
	String jg_13 	= "";
	String jg_a 	= "";
	String jg_b 	= "";
	int    jg_c 	= 0;
	int    jg_d1 	= 0;
	int    jg_d2 	= 0;
	String jg_e 	= "";
	int    jg_e1 	= 0;
	float  jg_f 	= 0;
	float  jg_g 	= 0;
	String jg_h 	= "";
	String jg_i 	= "";
	float  jg_j1 	= 0;
	float  jg_j2 	= 0;
	float  jg_j3 	= 0;
	String new_yn 	= "";
	int    jg_d3 	= 0;
	String app_dt 	= "";
	String jg_k 	= "";
	float  jg_l 	= 0;
	float  jg_e_d 	= 0;
	float  jg_e_e 	= 0;
	int    jg_e_g 	= 0;
	float  jg_st1 	= 0;
	float  jg_st2 	= 0;
	float  jg_st3 	= 0;
	float  jg_st4 	= 0;
	float  jg_st5 	= 0;
	float  jg_st6 	= 0;
	float  jg_st7 	= 0;
	float  jg_st8 	= 0;
	float  jg_st9 	= 0;
	float  jg_st10 	= 0;
	String jg_q 	= "";
	String jg_r 	= "";
	String jg_s 	= "";
	String jg_t 	= "";
	float  jg_u 	= 0;
	float  jg_14 	= 0;
	float  jg_st11 	= 0;
	float  jg_st12 	= 0;
	float  jg_st13 	= 0;
	float  jg_st14 	= 0;
	float  jg_5_1 	= 0;
	String jg_v	= "";
	float  jg_st15 	= 0;
	String jg_w 	= "";
	float  jg_x 	= 0;
	float  jg_y 	= 0;
	float  jg_z 	= 0;
	int    jg_d4 	= 0;
	int    jg_d5 	= 0;
	float  jg_g_1 	= 0;
	float  jg_g_2 	= 0;
	float  jg_g_3 	= 0;
	float  jg_15 	= 0;
	float  jg_g_4 	= 0;
	float  jg_g_5 	= 0;
	float  jg_st16 	= 0;
	String jg_opt_st= "";
	String jg_opt_1 = "";
	float  jg_opt_2 = 0;
	float  jg_opt_3 = 0;
	float  jg_opt_4 = 0;
	float  jg_opt_5 = 0;
	float  jg_opt_6 = 0;
	float  jg_opt_7 = 0;
	String jg_opt_8 = "";
	float  jg_g_6 	= 0;
	float  jg_st17 	= 0;
	float  jg_st18 	= 0;
	String jg_opt_9 = "";
	float  jg_st19 	= 0;
	String jg_g_7 = "";
	String jg_g_8 = "";
	String jg_g_9 = "";
	float  jg_g_10 	= 0;
	float  jg_g_11 	= 0;
	float  jg_g_12 	= 0;
	float  jg_g_13 	= 0;
	int    jg_d6 	= 0;
	int    jg_d7 	= 0;
	int    jg_d8 	= 0;
	int    jg_d9 	= 0;	
	int    jg_d10	= 0;	
	float  jg_g_14 	= 0;
	int    jg_g_15	= 0;
	String jg_g_16 	= "";
	int    jg_g_17	= 0;
	
	String jg_g_18	= "";
	int    jg_g_19	= 0; 
	int    jg_g_20	= 0; 
	String jg_g_21	= ""; 
	int    jg_g_22	= 0; 
	int    jg_g_23	= 0; 
	int    jg_g_24	= 0; 
	float  jg_g_25	= 0;
	String jg_g_26	= ""; 
	int    jg_g_27	= 0; 
	int    jg_g_28	= 0; 
	int    jg_g_29	= 0; 
	float  jg_g_30	= 0; 
	float  jg_g_31	= 0; 
	float  jg_g_32	= 0; 
	float  jg_g_33	= 0; 
	float  jg_st20  = 0;
	float  jg_st21  = 0;
	int    jg_g_34	= 0; 
	int    jg_g_35	= 0; 
	String jg_g_36	= "";
	float  jg_st22  = 0;
	float  jg_st23  = 0;
	
	int flag = 0;	
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	for (int i = start_row; i < value_line; i++) {
		
		flag = 0;
		
		temp_count++;
		
		sh_code 	= value0[i]  ==null?"":value0[i];
		com_nm 		= value1[i]  ==null?"":value1[i];
		cars 		= value2[i]  ==null?"":value2[i];
		new_yn 		= value3[i]  ==null?"":value3[i];
		app_dt 		= value4[i]  ==null?"":AddUtil.replace(value4[i]," ","");
		jg_1 		= value5[i]  ==null?0: AddUtil.parseFloat(value5[i]);
		jg_2 		= value6[i]  ==null?"":value6[i];
		jg_3 		= value7[i]  ==null?0: AddUtil.parseFloat(value7[i]);
		jg_3_1 		= value8[i]  ==null?0: AddUtil.parseFloat(value8[i]);
		jg_4 		= value9[i]  ==null?0: AddUtil.parseFloat(value9[i]);
		jg_5 		= value10[i] ==null?0: AddUtil.parseFloat(value10[i]);
		jg_5_1 		= value11[i] ==null?0: AddUtil.parseFloat(value11[i]);
		jg_6 		= value12[i] ==null?0: AddUtil.parseFloat(value12[i]);
		jg_7 		= value13[i] ==null?0: AddUtil.parseInt  (value13[i]);
		jg_8 		= value14[i] ==null?0: AddUtil.parseFloat(value14[i]);
		jg_9 		= value15[i] ==null?0: AddUtil.parseFloat(value15[i]);
		jg_10 		= value16[i] ==null?0: AddUtil.parseFloat(value16[i]);
		jg_11 		= value17[i] ==null?0: AddUtil.parseFloat(value17[i]);
		jg_12 		= value18[i] ==null?0: AddUtil.parseFloat(value18[i]);
		jg_13 		= value19[i] ==null?"":value19[i];
		jg_14 		= value20[i] ==null?0: AddUtil.parseFloat(value20[i]);
		jg_15 		= value21[i] ==null?0: AddUtil.parseFloat(value21[i]);//20141222추가
		jg_a 		= value22[i] ==null?"":value22[i];
		jg_b 		= value23[i] ==null?"":value23[i];
		jg_c 		= value24[i] ==null?0: AddUtil.parseInt  (value24[i]);
		jg_d1 		= value25[i] ==null?0: AddUtil.parseInt  (value25[i]);
		jg_d2 		= value26[i] ==null?0: AddUtil.parseInt  (value26[i]);
		jg_d3 		= value27[i] ==null?0: AddUtil.parseInt  (value27[i]);
		jg_d4 		= value28[i] ==null?0: AddUtil.parseInt  (value28[i]);//20130906추가
		jg_d5 		= value29[i] ==null?0: AddUtil.parseInt  (value29[i]);//20130906추가
		jg_d6 		= value30[i] ==null?0: AddUtil.parseInt  (value30[i]);//20170705추가
		jg_d7 		= value31[i] ==null?0: AddUtil.parseInt  (value31[i]);//20170705추가
		jg_d8 		= value32[i] ==null?0: AddUtil.parseInt  (value32[i]);//20170705추가
		jg_d9 		= value33[i] ==null?0: AddUtil.parseInt  (value33[i]);//20170705추가
		jg_d10 		= value34[i] ==null?0: AddUtil.parseInt  (value34[i]);//20170705추가	
		jg_e 		= value35[i] ==null?"":value35[i];
		jg_e1 		= value36[i] ==null?0: AddUtil.parseInt  (value36[i]);
		jg_f 		= value37[i] ==null?0: AddUtil.parseFloat(value37[i]);
		jg_g 		= value38[i] ==null?0: AddUtil.parseFloat(value38[i]);
		jg_h 		= value39[i] ==null?"":value39[i];
		jg_i 		= value40[i] ==null?"":value40[i];
		jg_j1 		= value41[i] ==null?0: AddUtil.parseFloat(value41[i]);
		jg_j2 		= value42[i] ==null?0: AddUtil.parseFloat(value42[i]);
		jg_j3 		= value43[i] ==null?0: AddUtil.parseFloat(value43[i]);
		jg_k 		= value44[i] ==null?"":value44[i];
		jg_l 		= value45[i] ==null?0: AddUtil.parseFloat(value45[i]);
		jg_e_d 		= value46[i] ==null?0: AddUtil.parseFloat(value46[i]);
		jg_e_e 		= value47[i] ==null?0: AddUtil.parseFloat(value47[i]);
		jg_e_g 		= value48[i] ==null?0: AddUtil.parseInt  (value48[i]);
		jg_q 		= value49[i] ==null?"":value49[i];
		jg_r 		= value50[i] ==null?"":value50[i];
		jg_s 		= value51[i] ==null?"":value51[i];
		jg_t 		= value52[i] ==null?"":value52[i];
		jg_u		= value53[i] ==null?0: AddUtil.parseFloat(value53[i]);
		jg_v 		= value54[i] ==null?"":value54[i];
		jg_w 		= value55[i] ==null?"":AddUtil.replace(value55[i]," ","");
		jg_x		= value56[i] ==null?0: AddUtil.parseFloat(value56[i]);//20130102추가
		jg_y		= value57[i] ==null?0: AddUtil.parseFloat(value57[i]);//20130109추가
		jg_z 		= value58[i] ==null?0: AddUtil.parseFloat(value58[i]);//20130501추가 자차보험승수(수입차)				
		jg_g_1	= value59[i] ==null?0: AddUtil.parseFloat(value59[i]);//20131105추가 (신차)단기마진율조정치
		jg_g_2	= value60[i] ==null?0: AddUtil.parseFloat(value60[i]);//20140912추가 0개월잔가산정을 위한 신차DC율
		jg_g_3	= value61[i] ==null?0: AddUtil.parseFloat(value61[i]);//20140912추가 자체영업비중				
		jg_g_4	= value62[i] ==null?0: AddUtil.parseFloat(value62[i]);//20150512추가 사고수리비 반영관련 차종승수
		jg_g_5	= value63[i] ==null?0: AddUtil.parseFloat(value63[i]);//20150512재리스잔존가 산출 승수			
		jg_g_6	= value64[i] ==null?0: AddUtil.parseFloat(value64[i]);//20151211일반식관리비 조정승수
		jg_g_7	= value65[i] ==null?"":value65[i];//20160822 친환경차 구분
		jg_g_8	= value66[i] ==null?"":value66[i];//20160822 정부보조금 지급여부
		jg_g_9	= value67[i] ==null?"":value67[i];//20160822 0개월잔가 적용방식 구분
		jg_g_10 = value68[i] ==null?0: AddUtil.parseFloat(value68[i]);//20160822 0개월 기준잔가 조정율
		jg_g_11 = value69[i] ==null?0: AddUtil.parseFloat(value69[i]);//20170401 일반승용LPG 현시점 차령60개월 이상일 경우 잔가 조정율
		jg_g_12 = value70[i] ==null?0: AddUtil.parseFloat(value70[i]);//20170401 일반승용LPG 종료시점 차령60개월 이상일 경우 잔가 조정율
		jg_g_13 = value71[i] ==null?0: AddUtil.parseFloat(value71[i]);//20170529 1000km당 중고차가 조정율 반영승수(약정운행거리 계약시)
		jg_g_14 = value72[i] ==null?0: AddUtil.parseFloat(value72[i]);//20180105 재리스 단기 마진율 조정치
		jg_g_15	= value73[i] ==null?0: AddUtil.parseDigit(value73[i]);//20180128 전기차 정부보조금
		jg_g_16	= value74[i] ==null?"":value74[i];//20180420 저공해 스티커 발급대상(해당1)
		jg_g_17	= value75[i] ==null?0: AddUtil.parseInt	 (value75[i]);//20180420 승차정원
		
		jg_g_18	= value76[i] ==null?"":value76[i];//20180529 수출효과 대상 차종구분
		jg_g_19	= value77[i] ==null?0: AddUtil.parseInt	 (value77[i]);//20180529 수출가능연도-신차등록연도
		jg_g_20	= value78[i] ==null?0: AddUtil.parseInt	 (value78[i]);//20180529 수출효과 반감기간(년)X2
		jg_g_21	= value79[i] ==null?"":value79[i];//20180529 수출불가 사양
		jg_g_22	= value80[i] ==null?0: AddUtil.parseInt	 (value80[i]);//20180529 신차수출가능견적 대여만료일
		jg_g_23	= value81[i] ==null?0: AddUtil.parseInt	 (value81[i]);//20180529 신차출고 납기일수+7일
		jg_g_24	= value82[i] ==null?0: AddUtil.parseInt	 (value82[i]);//20180529 신차수출효과 최대값
		jg_g_25 = value83[i] ==null?0: AddUtil.parseFloat(value83[i]);//20180529 신차주행거리 상쇄효과 반영율
		jg_g_26	= value84[i] ==null?"":value84[i];//20180529 수출가능한 신차등록년도 시작일
		jg_g_27	= value85[i] ==null?0: AddUtil.parseInt	 (value85[i]);//20180529 재리스 수출가능견적대여만료일(일수)
		jg_g_28	= value86[i] ==null?0: AddUtil.parseInt	 (value86[i]);//20180529 수출효과최대값(현시점)
		jg_g_29	= value87[i] ==null?0: AddUtil.parseInt	 (value87[i]);//20180529 수출효과최대값(재리스 종료시점)
		jg_g_30 = value88[i] ==null?0: AddUtil.parseFloat(value88[i]);//20180529 재리스  주행거리 상쇄효과 반영율
		jg_g_31 = value89[i] ==null?0: AddUtil.parseFloat(value89[i]);//20180529 수출불가사고금액 기준율
		jg_g_32 = value90[i] ==null?0: AddUtil.parseFloat(value90[i]);//20180529 매입옵션있는 신차 연장견적시 수출효과적용율
		jg_g_33 = value91[i] ==null?0: AddUtil.parseFloat(value91[i]);//20180529 매입옵션있는 재리스 연장견적시 수출효과적용율
		jg_g_34 = value92[i] ==null?0: AddUtil.parseInt	 (value92[i]);//20190624 신차 장기렌트 홈페이지 인기차종(국산/수입) 인기1
		jg_g_35 = value93[i] ==null?0: AddUtil.parseInt  (value93[i]);//20190624 신차 리스 홈페이지 인기차종(국산/수입) 인기1
		jg_g_36	= value94[i] ==null?"":value94[i];//20190709 (대차료 청구용)
		
		//공백1 95
		//공백1 96 //20190624
						
		//공백2 161()
		//기간별 특소세율
		jg_st1 		= value162[i] ==null?0: AddUtil.parseFloat(value162[i]);
		jg_st2 		= value163[i] ==null?0: AddUtil.parseFloat(value163[i]);
		jg_st3 		= value164[i] ==null?0: AddUtil.parseFloat(value164[i]);
		jg_st4 		= value165[i] ==null?0: AddUtil.parseFloat(value165[i]);
		jg_st5 		= value166[i] ==null?0: AddUtil.parseFloat(value166[i]);
		jg_st6 		= value167[i] ==null?0: AddUtil.parseFloat(value167[i]);
		jg_st7 		= value168[i] ==null?0: AddUtil.parseFloat(value168[i]);
		jg_st8 		= value169[i] ==null?0: AddUtil.parseFloat(value169[i]);
		jg_st9 		= value170[i] ==null?0: AddUtil.parseFloat(value170[i]);
		jg_st10		= value171[i] ==null?0: AddUtil.parseFloat(value171[i]);
		jg_st11		= value172[i] ==null?0: AddUtil.parseFloat(value172[i]);
		jg_st15		= value173[i] ==null?0: AddUtil.parseFloat(value173[i]);//20120911 추가
		jg_st12		= value174[i] ==null?0: AddUtil.parseFloat(value174[i]);
		jg_st13		= value175[i] ==null?0: AddUtil.parseFloat(value175[i]);
		jg_st14		= value176[i] ==null?0: AddUtil.parseFloat(value176[i]);
		jg_st16		= value177[i] ==null?0: AddUtil.parseFloat(value177[i]);
		jg_st17		= value178[i] ==null?0: AddUtil.parseFloat(value178[i]);
		jg_st18		= value179[i] ==null?0: AddUtil.parseFloat(value179[i]);
		jg_st19		= value180[i] ==null?0: AddUtil.parseFloat(value180[i]);
		jg_st20		= value181[i] ==null?0: AddUtil.parseFloat(value181[i]);//20180719
		jg_st21		= value182[i] ==null?0: AddUtil.parseFloat(value182[i]);//20190416
		jg_st22		= value183[i] ==null?0: AddUtil.parseFloat(value183[i]);//20191230		
		jg_st23		= value184[i] ==null?0: AddUtil.parseFloat(value184[i]);//20200225
		
		if (!sh_code.equals("")) {

			//10. 3. 23(->10.3.23) 날짜형식 -> 20100323로 변경
			if (!app_dt.equals("")) {
				if (app_dt.equals("2006.06출시")) {
					app_dt = "20060601";
				} else {
					if (app_dt.length() > 5) {
						StringTokenizer st = new StringTokenizer(app_dt,".");
						int s=0; 
						String app_value[] = new String[3];
						while (st.hasMoreTokens()) {
							app_value[s] = st.nextToken();
							s++;
						}
						if (s == 3) {
							String app_y = "20"+AddUtil.addZero(app_value[0]);
							String app_m = AddUtil.addZero(app_value[1]);
							String app_d = AddUtil.addZero(app_value[2]);
							app_dt = app_y+""+app_m+""+app_d;
						}
					}
				}
			}
			
			if (!jg_g_26.equals("")) {
				// jg_g_26 엑셀날짜형식(예 : 1/1/15 --> 20150101)변환.
				if (jg_g_26.contains("/")) {
					String jg_g_26_arr[] = new String[3];
					jg_g_26_arr = jg_g_26.split("/");
					if (Integer.parseInt(jg_g_26_arr[0])<10) {	jg_g_26_arr[0] = "0"+jg_g_26_arr[0];	}	//월
					if (Integer.parseInt(jg_g_26_arr[1])<10) {	jg_g_26_arr[1] = "0"+jg_g_26_arr[1];	}	//일
					jg_g_26_arr[2] = "20"+jg_g_26_arr[2];													//년
					jg_g_26 = jg_g_26_arr[2] + jg_g_26_arr[0] + jg_g_26_arr[1];
				}
				if (jg_g_26.contains("-")) {		jg_g_26 = jg_g_26.replaceAll("-","");		}	//2015-01-01 --> 20150101
				if (jg_g_26.contains(".")) {		jg_g_26 = jg_g_26.replaceAll(".","");		}   //2015.01.01 --> 20150101
			}
		
			EstiJgVarBean bean = new EstiJgVarBean();
		
			bean.setSh_code	(sh_code	);
			bean.setCom_nm	(com_nm		);
			bean.setCars 	(cars 		);
			bean.setNew_yn 	(new_yn		);
			bean.setJg_1 	(jg_1 		);
			bean.setJg_2 	(jg_2 		);
			bean.setJg_3 	(jg_3 		);
			bean.setJg_4 	(jg_4 		);
			bean.setJg_5 	(jg_5 		);
			bean.setJg_6 	(jg_6 		);
			bean.setJg_7 	(jg_7 		);
			bean.setJg_8 	(jg_8 		);
			bean.setJg_9 	(jg_9 		);
			bean.setJg_10 	(jg_10 		);
			bean.setJg_11 	(jg_11 		);
			bean.setJg_12 	(jg_12 		);
			bean.setJg_13 	(jg_13 		);
			bean.setJg_14 	(jg_14 		);
			bean.setJg_15 	(jg_15 		);
			bean.setJg_a 	(jg_a 		);
			bean.setJg_b 	(jg_b 		);
			bean.setJg_c 	(jg_c 		);
			bean.setJg_d1 	(jg_d1 		);
			bean.setJg_d2 	(jg_d2 		);
			bean.setJg_d3 	(jg_d3 		);
			bean.setJg_d4 	(jg_d4 		);
			bean.setJg_d5 	(jg_d5 		);
			bean.setJg_e 	(jg_e 		);
			bean.setJg_e1 	(jg_e1 		);
			bean.setJg_f 	(jg_f 		);
			bean.setJg_g 	(jg_g 		);
			bean.setJg_h 	(jg_h 		);
			bean.setJg_i 	(jg_i 		);
			bean.setJg_j1 	(jg_j1 		);
			bean.setJg_j2 	(jg_j2 		);
			bean.setJg_j3 	(jg_j3 		);
			bean.setApp_dt 	(app_dt		);
			bean.setJg_k 	(jg_k 		);
			bean.setJg_l 	(jg_l 		);
			bean.setJg_st1 	(jg_st1		);
			bean.setJg_st2 	(jg_st2		);
			bean.setJg_st3 	(jg_st3		);
			bean.setJg_st4 	(jg_st4		);
			bean.setJg_st5 	(jg_st5		);
			bean.setJg_st6 	(jg_st6		);
			bean.setJg_st7 	(jg_st7		);
			bean.setJg_st8 	(jg_st8		);
			bean.setJg_st9 	(jg_st9		);
			bean.setJg_st10	(jg_st10	);
			bean.setJg_e_d 	(jg_e_d		);
			bean.setJg_e_e 	(jg_e_e		);
			bean.setJg_e_g 	(jg_e_g		);
			bean.setJg_q 	(jg_q		);
			bean.setJg_r 	(jg_r		);
			bean.setJg_s 	(jg_s		);
			bean.setJg_t 	(jg_t		);
			bean.setJg_u 	(jg_u		);
			bean.setJg_3_1 	(jg_3_1		);
			bean.setJg_st11 (jg_st11	);
			bean.setJg_st12 (jg_st12	);
			bean.setJg_st13 (jg_st13	);
			bean.setJg_st14 (jg_st14	);
			bean.setJg_5_1 	(jg_5_1		);
			bean.setJg_v 	(jg_v		);
			bean.setJg_st15 (jg_st15	);
			bean.setJg_w 	(jg_w		);
			bean.setJg_x 	(jg_x		);
			bean.setJg_y 	(jg_y		);
			bean.setJg_z 	(jg_z		);
			bean.setJg_g_1 	(jg_g_1		);
			bean.setJg_g_2 	(jg_g_2		);
			bean.setJg_g_3 	(jg_g_3		);
			bean.setJg_g_4 	(jg_g_4		);
			bean.setJg_g_5 	(jg_g_5		);
			bean.setJg_st16 (jg_st16	);
			bean.setJg_g_6 	(jg_g_6		);
			bean.setJg_st17 (jg_st17	);
			bean.setJg_st18 (jg_st18	);
			bean.setReg_dt	(reg_dt		);
			bean.setJg_st19 (jg_st19	);
			bean.setJg_g_7	(jg_g_7		);
			bean.setJg_g_8	(jg_g_8		);
			bean.setJg_g_9	(jg_g_9		);
			bean.setJg_g_10	(jg_g_10	);
			bean.setJg_g_11	(jg_g_11	);
			bean.setJg_g_12	(jg_g_12	);
			bean.setJg_g_13	(jg_g_13	);
			bean.setJg_d6 	(jg_d6 		);
			bean.setJg_d7 	(jg_d7 		);
			bean.setJg_d8 	(jg_d8 		);
			bean.setJg_d9 	(jg_d9 		);
			bean.setJg_d10 	(jg_d10		);
			bean.setJg_g_14	(jg_g_14	);
			bean.setJg_g_15	(jg_g_15	);
			bean.setJg_g_16	(jg_g_16	);
			bean.setJg_g_17	(jg_g_17	);			
			bean.setJg_g_18	(jg_g_18	);
			bean.setJg_g_19	(jg_g_19	);
			bean.setJg_g_20	(jg_g_20	);
			bean.setJg_g_21	(jg_g_21	);
			bean.setJg_g_22	(jg_g_22	);
			bean.setJg_g_23	(jg_g_23	);
			bean.setJg_g_24	(jg_g_24	);
			bean.setJg_g_25	(jg_g_25	);
			bean.setJg_g_26	(jg_g_26	);
			bean.setJg_g_27	(jg_g_27	);
			bean.setJg_g_28	(jg_g_28	);
			bean.setJg_g_29	(jg_g_29	);
			bean.setJg_g_30	(jg_g_30	);
			bean.setJg_g_31	(jg_g_31	);
			bean.setJg_g_32	(jg_g_32	);
			bean.setJg_g_33	(jg_g_33	);
			bean.setJg_g_34	(jg_g_34	);
			bean.setJg_g_35	(jg_g_35	);
			bean.setJg_st20 (jg_st20	);
			bean.setJg_st21 (jg_st21	);
			bean.setJg_g_36	(jg_g_36	);
			bean.setJg_st22 (jg_st22	);
			bean.setJg_st23 (jg_st23	);
		
			seq = e_db.insertEstiJgVar(bean);
		
			bean.setSeq	(seq);
		
			//코드 (중복) 93(77)
			//비고설명문 참고값 94(78)
			
			//20190624
			//코드 (중복) 95
			//비고설명문 참고값 96
		
			//1번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value98[i]  ==null?"":value98[i];
			jg_opt_2	= value99[i] ==null?0:  AddUtil.parseFloat(value99[i]);
			jg_opt_3	= value100[i] ==null?0: AddUtil.parseFloat(value100[i]);
			jg_opt_4	= value101[i] ==null?0: AddUtil.parseFloat(value101[i]);
			jg_opt_5	= value102[i] ==null?0: AddUtil.parseFloat(value102[i]);
			jg_opt_6	= value103[i] ==null?0: AddUtil.parseFloat(value103[i]);
			jg_opt_7	= value104[i] ==null?0: AddUtil.parseFloat(value104[i]);
			jg_opt_8 	= value105[i]  ==null?"":value105[i];
			jg_opt_9 	= value106[i]  ==null?"":value106[i];
			
			if (!jg_opt_1.equals("")) {
				bean.setJg_opt_st	("1");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
			
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}
		
			//1번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value107[i]  ==null?"":value107[i];
			jg_opt_2	= value108[i] ==null?0: AddUtil.parseFloat(value108[i]);
			jg_opt_3	= value109[i] ==null?0: AddUtil.parseFloat(value109[i]);
			jg_opt_4	= value110[i] ==null?0: AddUtil.parseFloat(value110[i]);
			jg_opt_5	= value111[i] ==null?0: AddUtil.parseFloat(value111[i]);
			jg_opt_6	= value112[i] ==null?0: AddUtil.parseFloat(value112[i]);
			jg_opt_7	= value113[i] ==null?0: AddUtil.parseFloat(value113[i]);
			jg_opt_8 	= value114[i]  ==null?"":value114[i];
			jg_opt_9 	= value115[i]  ==null?"":value115[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("2");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
				
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}		
		
			//3번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value116[i] ==null?"":value116[i];
			jg_opt_2	= value117[i] ==null?0: AddUtil.parseFloat(value117[i]);
			jg_opt_3	= value118[i] ==null?0: AddUtil.parseFloat(value118[i]);
			jg_opt_4	= value119[i] ==null?0: AddUtil.parseFloat(value119[i]);
			jg_opt_5	= value120[i] ==null?0: AddUtil.parseFloat(value120[i]);
			jg_opt_6	= value121[i] ==null?0:AddUtil.parseFloat(value121[i]);
			jg_opt_7	= value122[i] ==null?0:AddUtil.parseFloat(value122[i]);	
			jg_opt_8 	= value123[i]  ==null?"":value123[i];
			jg_opt_9 	= value124[i]  ==null?"":value124[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("3");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
			
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}				
		
			//4번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value125[i]  ==null?"":value125[i];
			jg_opt_2	= value126[i] ==null?0: AddUtil.parseFloat(value126[i]);
			jg_opt_3	= value127[i] ==null?0: AddUtil.parseFloat(value127[i]);
			jg_opt_4	= value128[i] ==null?0: AddUtil.parseFloat(value128[i]);
			jg_opt_5	= value129[i] ==null?0: AddUtil.parseFloat(value129[i]);
			jg_opt_6	= value130[i] ==null?0: AddUtil.parseFloat(value130[i]);
			jg_opt_7	= value131[i] ==null?0: AddUtil.parseFloat(value131[i]);
			jg_opt_8 	= value132[i]  ==null?"":value132[i];
			jg_opt_9 	= value133[i]  ==null?"":value133[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("4");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
				
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}				
		
			//5번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value134[i]  ==null?"":value134[i];
			jg_opt_2	= value135[i] ==null?0: AddUtil.parseFloat(value135[i]);
			jg_opt_3	= value136[i] ==null?0: AddUtil.parseFloat(value136[i]);
			jg_opt_4	= value137[i] ==null?0: AddUtil.parseFloat(value137[i]);
			jg_opt_5	= value138[i] ==null?0: AddUtil.parseFloat(value138[i]);
			jg_opt_6	= value139[i] ==null?0: AddUtil.parseFloat(value139[i]);
			jg_opt_7	= value140[i] ==null?0: AddUtil.parseFloat(value140[i]);	
			jg_opt_8 	= value141[i] ==null?"":value141[i];
			jg_opt_9 	= value142[i] ==null?"":value142[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("5");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
			
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}	
		
			//6번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value143[i]  ==null?"":value143[i];
			jg_opt_2	= value144[i] ==null?0: AddUtil.parseFloat(value144[i]);
			jg_opt_3	= value145[i] ==null?0: AddUtil.parseFloat(value145[i]);
			jg_opt_4	= value146[i] ==null?0: AddUtil.parseFloat(value146[i]);
			jg_opt_5	= value147[i] ==null?0: AddUtil.parseFloat(value147[i]);
			jg_opt_6	= value148[i] ==null?0: AddUtil.parseFloat(value148[i]);
			jg_opt_7	= value149[i] ==null?0: AddUtil.parseFloat(value149[i]);	
			jg_opt_8 	= value150[i] ==null?"":value150[i];
			jg_opt_9 	= value151[i] ==null?"":value151[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("6");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
			
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}					
		
			//7번 색상 및 사양 관련 잔가 조정 변수 등록		
			jg_opt_1 	= value152[i]  ==null?"":value152[i];
			jg_opt_2	= value153[i] ==null?0: AddUtil.parseFloat(value153[i]);
			jg_opt_3	= value154[i] ==null?0: AddUtil.parseFloat(value154[i]);
			jg_opt_4	= value155[i] ==null?0: AddUtil.parseFloat(value155[i]);
			jg_opt_5	= value156[i] ==null?0: AddUtil.parseFloat(value156[i]);
			jg_opt_6	= value157[i] ==null?0: AddUtil.parseFloat(value157[i]);
			jg_opt_7	= value158[i] ==null?0: AddUtil.parseFloat(value158[i]);
			jg_opt_8 	= value159[i]  ==null?"":value159[i];
			jg_opt_9 	= value160[i]  ==null?"":value160[i];
			
			if (!jg_opt_1.equals("")) {			
				bean.setJg_opt_st	("7");
				bean.setJg_opt_1	(jg_opt_1);
				bean.setJg_opt_2	(jg_opt_2);
				bean.setJg_opt_3	(jg_opt_3);
				bean.setJg_opt_4	(jg_opt_4);
				bean.setJg_opt_5	(jg_opt_5);
				bean.setJg_opt_6	(jg_opt_6);
				bean.setJg_opt_7	(jg_opt_7);
				bean.setJg_opt_8	(jg_opt_8);
				bean.setJg_opt_9	(jg_opt_9);
			
				int opt_seq = e_db.insertEstiJgOptVar(bean);
			}			
		
			if (!seq.equals("")) {
				result[i] = "등록했습니다.";
			} else {
				result[i] = "오류 발생";
			}
			
		}	
	}	

	//System.out.println("temp_count >>>> " + temp_count);
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 등록하기
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%for (int i = start_row; i < value_line; i++) {%>
<input type='hidden' name='sh_code' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='cars'    value='<%=value2[i] ==null?"":value2[i]%>'>
<input type='hidden' name='result'  value='<%=result[i]%>'>
<%}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>