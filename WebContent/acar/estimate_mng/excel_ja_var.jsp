<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, acar.estimate_mng.*"%>

<%
	String reg_dt = request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt");

	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	//ExcelUpload file = new ExcelUpload(path, request.getInputStream());
	EstiExcelUpload file = new EstiExcelUpload(path, request.getInputStream());
	String filename = file.getFilename();
	
	int pos = file.getRealName().lastIndexOf( "." );
	String ext = file.getRealName().substring( pos + 1 );
	
	int vt_size = 0;
	int colSize = 0;
	
	if (ext.equals("xls")) {
		vt = EstiVarExcelUpload.getXLSData(path, filename + ".xls", 3);
		vt_size = vt.size();
		colSize = EstiVarExcelUpload.getXLSDataColSize(path, filename + ".xls", 3);
	} else {
		vt = EstiVarExcelUpload.getXLSXData(path, filename + ".xlsx", 3);
		vt_size = vt.size();
		colSize = EstiVarExcelUpload.getXLSXDataColSize(path, filename + ".xlsx", 3);
	}
	
	String result[]  = new String[vt_size];
	
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
	int jg_g_38	= 0;
	int jg_g_39	= 0;
	int jg_g_40	= 0;
	int jg_g_41	= 0;
	int jg_g_42	= 0;
	int jg_g_43	= 0;
	int jg_g_44 = 0;
	float  jg_st22  = 0;
	float  jg_st23  = 0;
	float jg_g_45 = 0;
	int jg_g_46 = 0;

	int flag = 0;
	int temp_count = 0;
	
	String seq = "";
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	for (int j = 0; j < vt.size(); j++) {
		flag = 0;
		
		temp_count++;
		
		Hashtable content = (Hashtable)vt.elementAt(j);
		
		sh_code = String.valueOf(content.get("0"));
		com_nm = String.valueOf(content.get("1"));
		cars = String.valueOf(content.get("2"));
		new_yn = String.valueOf(content.get("3"));
		app_dt = AddUtil.replace(String.valueOf(content.get("4"))," ","");
		
		jg_1 = AddUtil.parseFloat(String.valueOf(content.get("5")));
		jg_2 = String.valueOf(content.get("6"));
		jg_3 = AddUtil.parseFloat(String.valueOf(content.get("7")));
		jg_3_1 = AddUtil.parseFloat(String.valueOf(content.get("8")));
		jg_4 = AddUtil.parseFloat(String.valueOf(content.get("9")));
		jg_5 = AddUtil.parseFloat(String.valueOf(content.get("10")));
		jg_5_1 = AddUtil.parseFloat(String.valueOf(content.get("11")));
		jg_6 = AddUtil.parseFloat(String.valueOf(content.get("12")));
		jg_7 = AddUtil.parseInt(String.valueOf(content.get("13")));
		jg_8 = AddUtil.parseFloat(String.valueOf(content.get("14")));
		jg_9 = AddUtil.parseFloat(String.valueOf(content.get("15")));
		jg_10 = AddUtil.parseFloat(String.valueOf(content.get("16")));
		jg_11 = AddUtil.parseFloat(String.valueOf(content.get("17")));
		jg_12 = AddUtil.parseFloat(String.valueOf(content.get("18")));
		jg_13 = String.valueOf(content.get("19"));
		jg_14 = AddUtil.parseFloat(String.valueOf(content.get("20")));
		jg_15 = AddUtil.parseFloat(String.valueOf(content.get("21")));
		
		jg_a = String.valueOf(content.get("22"));
		jg_b = String.valueOf(content.get("23"));
		jg_c = AddUtil.parseInt(String.valueOf(content.get("24")));
		jg_d1 = AddUtil.parseInt(String.valueOf(content.get("25")));
		jg_d2 = AddUtil.parseInt(String.valueOf(content.get("26")));
		jg_d3 = AddUtil.parseInt(String.valueOf(content.get("27")));
		jg_d4 = AddUtil.parseInt(String.valueOf(content.get("28")));
		jg_d5 = AddUtil.parseInt(String.valueOf(content.get("29")));
		jg_d6 = AddUtil.parseInt(String.valueOf(content.get("30")));
		jg_d7 = AddUtil.parseInt(String.valueOf(content.get("31")));
		jg_d8 = AddUtil.parseInt(String.valueOf(content.get("32")));
		jg_d9 = AddUtil.parseInt(String.valueOf(content.get("33")));
		jg_d10 = AddUtil.parseInt(String.valueOf(content.get("34")));	
		jg_e = String.valueOf(content.get("35"));
		jg_e1 = AddUtil.parseInt(String.valueOf(content.get("36")));
		jg_f = AddUtil.parseFloat(String.valueOf(content.get("37")));
		jg_g = AddUtil.parseFloat(String.valueOf(content.get("38")));
		jg_h = String.valueOf(content.get("39"));
		jg_i = String.valueOf(content.get("40"));
		jg_j1 = AddUtil.parseFloat(String.valueOf(content.get("41")));
		jg_j2 = AddUtil.parseFloat(String.valueOf(content.get("42")));
		jg_j3 = AddUtil.parseFloat(String.valueOf(content.get("43")));
		jg_k = String.valueOf(content.get("44"));
		jg_l = AddUtil.parseFloat(String.valueOf(content.get("45")));
		jg_e_d = AddUtil.parseFloat(String.valueOf(content.get("46")));
		jg_e_e = AddUtil.parseFloat(String.valueOf(content.get("47")));
		jg_e_g = AddUtil.parseInt(String.valueOf(content.get("48")));
		jg_q = String.valueOf(content.get("49"));
		jg_r = String.valueOf(content.get("50"));
		jg_s = String.valueOf(content.get("51"));
		jg_t = String.valueOf(content.get("52"));
		jg_u = AddUtil.parseFloat(String.valueOf(content.get("53")));	
		jg_v = String.valueOf(content.get("54"));
		jg_w = AddUtil.replace(String.valueOf(content.get("55"))," ","");
		jg_x = AddUtil.parseFloat(String.valueOf(content.get("56")));
		jg_y = AddUtil.parseFloat(String.valueOf(content.get("57")));
		jg_z = AddUtil.parseFloat(String.valueOf(content.get("58")));//20130501추가 자차보험승수(수입차)
		
		jg_g_1 = AddUtil.parseFloat(String.valueOf(content.get("59")));//20131105추가 (신차)단기마진율조정치
		jg_g_2 = AddUtil.parseFloat(String.valueOf(content.get("60")));//20140912추가 0개월잔가산정을 위한 신차DC율
		jg_g_3 = AddUtil.parseFloat(String.valueOf(content.get("61")));//20140912추가 자체영업비중				
		jg_g_4 = AddUtil.parseFloat(String.valueOf(content.get("62")));//20150512추가 사고수리비 반영관련 차종승수
		jg_g_5 = AddUtil.parseFloat(String.valueOf(content.get("63")));//20150512재리스잔존가 산출 승수			
		jg_g_6 = AddUtil.parseFloat(String.valueOf(content.get("64")));//20151211일반식관리비 조정승수
		jg_g_7 = String.valueOf(content.get("65"));//20160822 친환경차 구분
		jg_g_8 = String.valueOf(content.get("66"));//20160822 정부보조금 지급여부
		jg_g_9 = String.valueOf(content.get("67"));//20160822 0개월잔가 적용방식 구분
		jg_g_10 = AddUtil.parseFloat(String.valueOf(content.get("68")));//20160822 0개월 기준잔가 조정율
		jg_g_11 = AddUtil.parseFloat(String.valueOf(content.get("69")));//20170401 일반승용LPG 현시점 차령60개월 이상일 경우 잔가 조정율
		jg_g_12 = AddUtil.parseFloat(String.valueOf(content.get("70")));//20170401 일반승용LPG 종료시점 차령60개월 이상일 경우 잔가 조정율
		jg_g_13 = AddUtil.parseFloat(String.valueOf(content.get("71")));//20170529 1000km당 중고차가 조정율 반영승수(약정운행거리 계약시)
		jg_g_14 = AddUtil.parseFloat(String.valueOf(content.get("72")));//20180105 재리스 단기 마진율 조정치
		jg_g_15	= AddUtil.parseDigit(String.valueOf(content.get("73")));//20180128 전기차 정부보조금
		jg_g_16 = String.valueOf(content.get("74"));//20180420 저공해 스티커 발급대상(해당1)
		jg_g_17 = AddUtil.parseInt(String.valueOf(content.get("75")));//20180420 승차정원		
		jg_g_18 = String.valueOf(content.get("76"));//20180529 수출효과 대상 차종구분
		jg_g_19 = AddUtil.parseInt(String.valueOf(content.get("77")));//20180529 수출가능연도-신차등록연도
		jg_g_20 = AddUtil.parseInt(String.valueOf(content.get("78")));//20180529 수출효과 반감기간(년)X2
		jg_g_21 = String.valueOf(content.get("79"));//20180529 수출불가 사양
		jg_g_22 = AddUtil.parseInt(String.valueOf(content.get("80")));//20180529 신차수출가능견적 대여만료일
		jg_g_23 = AddUtil.parseInt(String.valueOf(content.get("81")));//20180529 신차출고 납기일수+7일
		jg_g_24 = AddUtil.parseInt(String.valueOf(content.get("82")));//20180529 신차수출효과 최대값
		jg_g_25 = AddUtil.parseFloat(String.valueOf(content.get("83")));//20180529 신차주행거리 상쇄효과 반영율
		jg_g_26 = String.valueOf(content.get("84"));//20180529 수출가능한 신차등록년도 시작일
		jg_g_27 = AddUtil.parseInt(String.valueOf(content.get("85")));//20180529 재리스 수출가능견적대여만료일(일수)
		jg_g_28 = AddUtil.parseInt(String.valueOf(content.get("86")));//20180529 수출효과최대값(현시점)
		jg_g_29 = AddUtil.parseInt(String.valueOf(content.get("87")));//20180529 수출효과최대값(재리스 종료시점)
		jg_g_30 = AddUtil.parseFloat(String.valueOf(content.get("88")));//20180529 재리스  주행거리 상쇄효과 반영율
		jg_g_31 = AddUtil.parseFloat(String.valueOf(content.get("89")));//20180529 수출불가사고금액 기준율
		jg_g_32 = AddUtil.parseFloat(String.valueOf(content.get("90")));//20180529 매입옵션있는 신차 연장견적시 수출효과적용율
		jg_g_33 = AddUtil.parseFloat(String.valueOf(content.get("91")));//20180529 매입옵션있는 재리스 연장견적시 수출효과적용율
		jg_g_34 = AddUtil.parseInt(String.valueOf(content.get("92")));//20190624 신차 장기렌트 홈페이지 인기차종(국산/수입) 인기1
		jg_g_35 = AddUtil.parseInt(String.valueOf(content.get("93")));//20190624 신차 리스 홈페이지 인기차종(국산/수입) 인기1
		jg_g_36 = String.valueOf(content.get("94"));//20190709 (대차료 청구용)
		jg_g_38 = AddUtil.parseInt(String.valueOf(content.get("95")));
		jg_g_39 = AddUtil.parseInt(String.valueOf(content.get("96")));
		jg_g_40 = AddUtil.parseInt(String.valueOf(content.get("97")));
		jg_g_41 = AddUtil.parseInt(String.valueOf(content.get("98")));
		jg_g_42 = AddUtil.parseInt(String.valueOf(content.get("99")));
		jg_g_43 = AddUtil.parseInt(String.valueOf(content.get("100")));
		jg_g_46 = AddUtil.parseInt(String.valueOf(content.get("101")));
		jg_g_44 = AddUtil.parseInt(String.valueOf(content.get("102")));
		jg_g_45 = AddUtil.parseFloat(String.valueOf(content.get("103")));
		
		//공백1 104
		//공백1 104 //20190624 // 20210215
						
		//공백2 170()
		//기간별 특소세율
		jg_st1 = AddUtil.parseFloat(String.valueOf(content.get("171")));
		jg_st2 = AddUtil.parseFloat(String.valueOf(content.get("172")));
		jg_st3 = AddUtil.parseFloat(String.valueOf(content.get("173")));
		jg_st4 = AddUtil.parseFloat(String.valueOf(content.get("174")));
		jg_st5 = AddUtil.parseFloat(String.valueOf(content.get("175")));
		jg_st6 = AddUtil.parseFloat(String.valueOf(content.get("176")));
		jg_st7 = AddUtil.parseFloat(String.valueOf(content.get("177")));
		jg_st8 = AddUtil.parseFloat(String.valueOf(content.get("178")));
		jg_st9 = AddUtil.parseFloat(String.valueOf(content.get("179")));
		jg_st10 = AddUtil.parseFloat(String.valueOf(content.get("180")));
		jg_st11 = AddUtil.parseFloat(String.valueOf(content.get("181")));
		jg_st15 = AddUtil.parseFloat(String.valueOf(content.get("182")));
		jg_st12 = AddUtil.parseFloat(String.valueOf(content.get("183")));
		jg_st13 = AddUtil.parseFloat(String.valueOf(content.get("184")));
		jg_st14 = AddUtil.parseFloat(String.valueOf(content.get("185")));
		jg_st16 = AddUtil.parseFloat(String.valueOf(content.get("186")));
		jg_st17 = AddUtil.parseFloat(String.valueOf(content.get("187")));
		jg_st18 = AddUtil.parseFloat(String.valueOf(content.get("188")));
		jg_st19 = AddUtil.parseFloat(String.valueOf(content.get("189")));
		jg_st20 = AddUtil.parseFloat(String.valueOf(content.get("190")));
		jg_st21 = AddUtil.parseFloat(String.valueOf(content.get("191")));
		jg_st22 = AddUtil.parseFloat(String.valueOf(content.get("192")));		
		jg_st23 = AddUtil.parseFloat(String.valueOf(content.get("193")));

		if (!sh_code.equals("")) {
			
			//10. 3. 23(->10.3.23) 날짜형식 -> 20100323로 변경
			if (!app_dt.equals("")) {
				if (app_dt.equals("2006.06출시")) {
					app_dt = "20060601";
				} else {
					if (app_dt.length() > 5) {
						StringTokenizer st = new StringTokenizer(app_dt, ".");
						int s = 0; 
						String app_value[] = new String[3];
						while (st.hasMoreTokens()) {
							app_value[s] = st.nextToken();
							s++;
						}
						if (s == 3) {
							String app_y = "20" + AddUtil.addZero(app_value[0]);
							String app_m = AddUtil.addZero(app_value[1]);
							String app_d = AddUtil.addZero(app_value[2]);
							app_dt = app_y + "" + app_m + "" + app_d;
						}
					}
				}
			}
			
			if (!jg_g_26.equals("")) {
				// jg_g_26 엑셀날짜형식(예 : 1/1/15 --> 20150101)변환.
				if (jg_g_26.contains("/")) {
					String jg_g_26_arr[] = new String[3];
					jg_g_26_arr = jg_g_26.split("/");
					//월
					if (Integer.parseInt(jg_g_26_arr[0])<10) {
						jg_g_26_arr[0] = "0" + jg_g_26_arr[0];
					}
					//일
					if (Integer.parseInt(jg_g_26_arr[1])<10) {
						jg_g_26_arr[1] = "0" + jg_g_26_arr[1];
					}
					//년
					jg_g_26_arr[2] = "20" + jg_g_26_arr[2];
					jg_g_26 = jg_g_26_arr[2] + jg_g_26_arr[0] + jg_g_26_arr[1];
				}
				
				//2015-01-01 --> 20150101
				if (jg_g_26.contains("-")) {
					jg_g_26 = jg_g_26.replaceAll("-", "");
				}
				
				//2015.01.01 --> 20150101
				if (jg_g_26.contains(".")) {
					jg_g_26 = jg_g_26.replaceAll(".", "");
				}
			}
		
			EstiJgVarBean bean = new EstiJgVarBean();
			
			bean.setReg_dt		(reg_dt);
			
			bean.setSh_code		(sh_code);
			bean.setCom_nm		(com_nm);
			bean.setCars 			(cars);
			bean.setNew_yn 		(new_yn);
			bean.setJg_1 			(jg_1);
			bean.setJg_2 			(jg_2);
			bean.setJg_3 			(jg_3);
			bean.setJg_4 			(jg_4);
			bean.setJg_5 			(jg_5);
			bean.setJg_6 			(jg_6);
			bean.setJg_7 			(jg_7);
			bean.setJg_8 			(jg_8);
			bean.setJg_9 			(jg_9);
			bean.setJg_10 		(jg_10);
			bean.setJg_11 		(jg_11);
			bean.setJg_12 		(jg_12);
			bean.setJg_13 		(jg_13);
			bean.setJg_14 		(jg_14);
			bean.setJg_15 		(jg_15);
			bean.setJg_a 			(jg_a);
			bean.setJg_b 			(jg_b);
			bean.setJg_c 			(jg_c);
			bean.setJg_d1 		(jg_d1);
			bean.setJg_d2 		(jg_d2);
			bean.setJg_d3 		(jg_d3);
			bean.setJg_d4 		(jg_d4);
			bean.setJg_d5 		(jg_d5);
			bean.setJg_e 			(jg_e);
			bean.setJg_e1 		(jg_e1);
			bean.setJg_f 			(jg_f);
			bean.setJg_g 			(jg_g);
			bean.setJg_h 			(jg_h);
			bean.setJg_i 			(jg_i);
			bean.setJg_j1 		(jg_j1);
			bean.setJg_j2 		(jg_j2);
			bean.setJg_j3 		(jg_j3);
			bean.setApp_dt 		(app_dt);
			bean.setJg_k		 	(jg_k);
			bean.setJg_l 			(jg_l);
			bean.setJg_st1 		(jg_st1);
			bean.setJg_st2 		(jg_st2);
			bean.setJg_st3 		(jg_st3);
			bean.setJg_st4 		(jg_st4);
			bean.setJg_st5 		(jg_st5);
			bean.setJg_st6 		(jg_st6);
			bean.setJg_st7 		(jg_st7);
			bean.setJg_st8 		(jg_st8);
			bean.setJg_st9 		(jg_st9);
			bean.setJg_st10		(jg_st10);
			bean.setJg_e_d 		(jg_e_d);
			bean.setJg_e_e 		(jg_e_e);
			bean.setJg_e_g 		(jg_e_g);
			bean.setJg_q 			(jg_q);
			bean.setJg_r 			(jg_r);
			bean.setJg_s 			(jg_s);
			bean.setJg_t 			(jg_t);
			bean.setJg_u 			(jg_u);
			bean.setJg_3_1 		(jg_3_1);
			bean.setJg_st11 		(jg_st11);
			bean.setJg_st12 		(jg_st12);
			bean.setJg_st13 		(jg_st13);
			bean.setJg_st14 		(jg_st14);
			bean.setJg_5_1 		(jg_5_1);
			bean.setJg_v 			(jg_v);
			bean.setJg_st15		(jg_st15);
			bean.setJg_w 			(jg_w);
			bean.setJg_x 			(jg_x);
			bean.setJg_y 			(jg_y);
			bean.setJg_z 			(jg_z);
			bean.setJg_g_1 		(jg_g_1);
			bean.setJg_g_2 		(jg_g_2);
			bean.setJg_g_3 		(jg_g_3);
			bean.setJg_g_4 		(jg_g_4);
			bean.setJg_g_5 		(jg_g_5);
			bean.setJg_st16 		(jg_st16);
			bean.setJg_g_6 		(jg_g_6);
			bean.setJg_st17 		(jg_st17);
			bean.setJg_st18 		(jg_st18);			
			bean.setJg_st19 		(jg_st19);
			bean.setJg_g_7		(jg_g_7);
			bean.setJg_g_8		(jg_g_8);
			bean.setJg_g_9		(jg_g_9);
			bean.setJg_g_10		(jg_g_10);
			bean.setJg_g_11		(jg_g_11);
			bean.setJg_g_12		(jg_g_12);
			bean.setJg_g_13		(jg_g_13);
			bean.setJg_d6 		(jg_d6);
			bean.setJg_d7 		(jg_d7);
			bean.setJg_d8 		(jg_d8);
			bean.setJg_d9 		(jg_d9);
			bean.setJg_d10 		(jg_d10);
			bean.setJg_g_14		(jg_g_14);
			bean.setJg_g_15		(jg_g_15);
			bean.setJg_g_16		(jg_g_16);
			bean.setJg_g_17		(jg_g_17);			
			bean.setJg_g_18		(jg_g_18);
			bean.setJg_g_19		(jg_g_19);
			bean.setJg_g_20		(jg_g_20);
			bean.setJg_g_21		(jg_g_21);
			bean.setJg_g_22		(jg_g_22);
			bean.setJg_g_23		(jg_g_23);
			bean.setJg_g_24		(jg_g_24);
			bean.setJg_g_25		(jg_g_25);
			bean.setJg_g_26		(jg_g_26);
			bean.setJg_g_27		(jg_g_27);
			bean.setJg_g_28		(jg_g_28);
			bean.setJg_g_29		(jg_g_29);
			bean.setJg_g_30		(jg_g_30);
			bean.setJg_g_31		(jg_g_31);
			bean.setJg_g_32		(jg_g_32);
			bean.setJg_g_33		(jg_g_33);
			bean.setJg_g_34		(jg_g_34);
			bean.setJg_g_35		(jg_g_35);
			bean.setJg_st20 		(jg_st20);
			bean.setJg_st21		(jg_st21);
			bean.setJg_g_36		(jg_g_36);
			bean.setJg_g_38		(jg_g_38);
			bean.setJg_g_39		(jg_g_39);
			bean.setJg_g_40		(jg_g_40);
			bean.setJg_g_41		(jg_g_41);
			bean.setJg_g_42		(jg_g_42);
			bean.setJg_g_43		(jg_g_43);
			bean.setJg_g_44		(jg_g_44);
			bean.setJg_g_45		(jg_g_45);
			bean.setJg_st22 		(jg_st22);
			bean.setJg_st23 		(jg_st23);
			bean.setJg_g_46		(jg_g_46);
		
			seq = e_db.insertEstiJgVar(bean);
		
			bean.setSeq(seq);
			
			//코드 (중복) 100(77)
			//비고설명문 참고값 101(78)
			
			//20220110
			//코드 (중복) 105
			//비고설명문 참고값 106
		
			//1번 색상 및 사양 관련 잔가 조정 변수 등록			
			jg_opt_1 = String.valueOf(content.get("107"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("108")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("109")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("110")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("111")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("112")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("113")));
			jg_opt_8 = String.valueOf(content.get("114"));
			jg_opt_9 = String.valueOf(content.get("115"));
			
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
			jg_opt_1 = String.valueOf(content.get("116"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("117")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("118")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("119")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("120")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("121")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("122")));
			jg_opt_8 = String.valueOf(content.get("123"));
			jg_opt_9 = String.valueOf(content.get("124"));
			
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
			jg_opt_1 = String.valueOf(content.get("125"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("126")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("127")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("128")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("129")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("130")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("131")));	
			jg_opt_8 = String.valueOf(content.get("132"));
			jg_opt_9 = String.valueOf(content.get("133"));
			
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
			jg_opt_1 = String.valueOf(content.get("134"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("135")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("136")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("137")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("138")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("139")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("140")));
			jg_opt_8 = String.valueOf(content.get("141"));
			jg_opt_9 = String.valueOf(content.get("142"));
			
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
			jg_opt_1 = String.valueOf(content.get("143"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("144")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("145")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("146")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("147")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("148")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("149")));	
			jg_opt_8 = String.valueOf(content.get("150"));
			jg_opt_9 = String.valueOf(content.get("151"));
			
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
			jg_opt_1 = String.valueOf(content.get("152"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("153")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("154")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("155")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("156")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("157")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("158")));	
			jg_opt_8 = String.valueOf(content.get("159"));
			jg_opt_9 = String.valueOf(content.get("160"));
			
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
			jg_opt_1 = String.valueOf(content.get("161"));
			jg_opt_2 = AddUtil.parseFloat(String.valueOf(content.get("162")));
			jg_opt_3 = AddUtil.parseFloat(String.valueOf(content.get("163")));
			jg_opt_4 = AddUtil.parseFloat(String.valueOf(content.get("164")));
			jg_opt_5 = AddUtil.parseFloat(String.valueOf(content.get("165")));
			jg_opt_6 = AddUtil.parseFloat(String.valueOf(content.get("166")));
			jg_opt_7 = AddUtil.parseFloat(String.valueOf(content.get("167")));
			jg_opt_8 = String.valueOf(content.get("168"));
			jg_opt_9 = String.valueOf(content.get("169"));
			
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
				result[j] = "등록했습니다.";
			} else {
				result[j] = "오류 발생";
			}
			
		}
		
	}
%>
<html>
<head>
<title>FMS</title>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<script language="JavaScript">
<!--	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</head>
<body>
<form action="excel_result.jsp" method='post' name="form1">
	<input type='hidden' name='start_row' value='0'>
	<input type='hidden' name='value_line' value='<%=vt.size()%>'>
	<%for (int i = 0; i < vt.size(); i++) {
		Hashtable content_temp = (Hashtable)vt.elementAt(i);
	%>
	<input type='hidden' name='sh_code' value='<%=String.valueOf(content_temp.get("0"))%>'>
	<input type='hidden' name='cars' value='<%=String.valueOf(content_temp.get("2"))%>'>
	<input type='hidden' name='result' value='<%=result[i]%>'>
	<%}%>
</form>
<script language="JavaScript">
<!--		
	document.form1.submit();
//-->
</script>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>