<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import = "java.util.*, acar.util.*, acar.offls_cmplt.*"%>
<%@ page import="org.json.simple.JSONObject, org.json.simple.JSONArray" %>
<jsp:useBean id="olcD" class="acar.offls_cmplt.Offls_cmpltDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")	==null?"":request.getParameter("auth_rw");
	String br_id 	= request.getParameter("br_id")		==null?"":request.getParameter("br_id");
	String user_id 	= request.getParameter("user_id")	==null?"":request.getParameter("user_id");
	
	String gubun 	= request.getParameter("gubun")		==null?"":request.getParameter("gubun");
	String gubun1 	= request.getParameter("gubun1")	==null?"":request.getParameter("gubun1");
	String gubun2 	= request.getParameter("gubun2")	==null?"":request.getParameter("gubun2");
	String gubun3 	= request.getParameter("gubun3")	==null?"":request.getParameter("gubun3");
	String gubun_nm = request.getParameter("gubun_nm")	==null?"":request.getParameter("gubun_nm");	
	
	String dt		= request.getParameter("dt")		==null?"":request.getParameter("dt");
	String ref_dt1 	= request.getParameter("ref_dt1")	==null?"":request.getParameter("ref_dt1");
	String ref_dt2 	= request.getParameter("ref_dt2")	==null?"":request.getParameter("ref_dt2");
	String s_au 	= request.getParameter("s_au")		==null?"":request.getParameter("s_au");
	String deep_yn 	= request.getParameter("deep_yn")		==null?"":request.getParameter("deep_yn");

	
	Vector jarr = olcD.getCmplt_stat_lst(dt, ref_dt1, ref_dt2, gubun, gubun1, gubun2, gubun3, gubun_nm, br_id, s_au, deep_yn);
	
	int jarr_size = 0;
	
	jarr_size = jarr.size();
	
	String jobjString = "";
	
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
	
	//평균재리스잔존가대비율 구하기
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
	
	int k =  0;
		
	if(jarr_size >= 0 ) {
		
		jobjString = "data={ rows:[ ";

		for(int i = 0 ; i < jarr_size ; i++) {
			
			Hashtable ht = (Hashtable)jarr.elementAt(i);
			
						
			if(AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT"))) == 60500){
				comm2_tot 	= AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
				total_amt7	= total_amt7 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
			}else{
				out_amt = AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
				total_amt10	= total_amt10 + AddUtil.parseLong(String.valueOf(ht.get("COMM2_TOT")));
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
			avg_per1 = avg_per1 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_PER")),2));
			avg_per2 = avg_per2 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_F_PER")),2));
			avg_per3 = avg_per3 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_PER")),2));
			avg_per4 = avg_per4 + AddUtil.parseFloat(AddUtil.parseFloatCipher(String.valueOf(ht.get("ABS_HP_S_CHA_PER")),2));
			
			Vector amts = olcD.getServiceAmt2(String.valueOf(ht.get("CAR_MNG_ID")));	//수리금액 1~2위 구하기
	 		int amt_size = amts.size();
	 		int amt_1nd = 0;
	 		int amt_2nd =  0;
	 		int total_amt =  0;
	 		if(amt_size > 0){
	 			for(int j = 0 ; j < amt_size ; j++){
	 				Hashtable ht2 = (Hashtable)amts.elementAt(j);
 	 				if(j==0){
 	 					amt_1nd = Integer.parseInt(String.valueOf(ht2.get("TOT_AMT")));
 	 					total_amt = amt_1nd;
 	 				}else if(j==1){
 	 					amt_2nd = Integer.parseInt(String.valueOf(ht2.get("TOT_AMT")));
 	 					total_amt += amt_2nd;
 	 				}else{
 	 					total_amt+=Integer.parseInt(String.valueOf(ht2.get("TOT_AMT")));
 	 				}
	 			}
	 		}			
						
			if(i != 0 ){
				jobjString += ",";				
			}	
			k =  i+1;
			

	 	 	jobjString += " { id:" + k + ",";
	 	 	
	 	 	/*0*/jobjString += "data:[\""  +  k + "\",";//연번
	 	 	/*1*/jobjString += "\"" +ht.get("CAR_NO") + " " + ht.get("SSS")+"^javascript:view_detail(&#39;"+ht.get("CAR_MNG_ID")+"&#39;, &#39;"+ht.get("SEQ")+"&#39;);^_self\",";//차량번호
	 	 	/*2*/jobjString += "\"" +ht.get("JG_CODE") + "\",";//차종코드  // <- 차종코드 위치변경 (추가, 이하 주석의 번호 바뀜)
	 	 	/*3*/jobjString += "\"" +String.valueOf(ht.get("CAR_NM")) + "\",";//차명
	 	 	/*4*/jobjString += "\""+String.valueOf(ht.get("FIRM_NM"))+ht.get("ACTN_WH") + "\",";//경매장
	 	 	/*5*/jobjString += "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("ACTN_DT"))) + "\",";//경매일자
	 	 	/*6*/jobjString += "\""+AddUtil.ChangeDate2(String.valueOf(ht.get("INIT_REG_DT")))  + "\",";//최초등록일
	 	 	/*7*/jobjString += "\""+String.valueOf(ht.get("CAR_C_AMT")) + "\",";//소비자가격
	 	 	/*8*/jobjString += "\""+String.valueOf(ht.get("CAR_F_AMT")) + "\",";//구입가격
	 	 	/*9*/jobjString += "\""+ String.valueOf(ht.get("HP_PR")) + "\",";//희망가
	 	 	/*10*/jobjString += "\""+ String.valueOf(ht.get("CAR_S_AMT")) + "\",";//예상낙찰가
	 	 	
	 	 	/*11*/jobjString += "\""+ String.valueOf(ht.get("NAK_PR")) + "\",";//낙찰가
	 	 	/*12*/jobjString += "\""+String.valueOf(ht.get("HP_C_PER")) + "\",";//소비자가 대비
	 	 	/*13*/jobjString += "\""+String.valueOf(ht.get("HP_F_PER")) + "\",";//구입가 대비
	 	 	/*14*/jobjString += "\""+String.valueOf(ht.get("HP_S_PER")) + "\",";//예상낙찰가 대비
	 	 	/*15*/jobjString += "\""+String.valueOf(ht.get("HP_S_CHA_AMT")) + "\",";//편차금액
	 	 	/*16*/jobjString += "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER")),2) + "\",";//편차%(예상낙찰가 기준)
	 	 	/*17*/jobjString += "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER")),2) + "\",";//편차%(소비자가 기준)
	 	 	/*18*/jobjString += "\""+ht.get("CAR_OLD_MONS") + "\",";//차령
	 	 	/*19*/jobjString += "\""+String.valueOf(ht.get("KM")) + "\",";//주행거리
	 	 	/*20*/jobjString += "\""+ String.valueOf(ht.get("DEEP_CAR_AMT1")) + "\",";//딥러닝예상낙찰가1
	 	 	
	 	 	/*21*/jobjString += "\""+ String.valueOf(ht.get("NAK_PR")) + "\",";//낙찰가
	 	 	/*22*/jobjString += "\""+String.valueOf(ht.get("HP_C_PER")) + "\",";//소비자가 대비
	 	 	/*23*/jobjString += "\""+String.valueOf(ht.get("HP_F_PER")) + "\",";//구입가 대비
	 	 	/*24*/jobjString += "\""+String.valueOf(ht.get("HP_S_PER2")) + "\",";//예상낙찰가 대비
	 	 	/*25*/jobjString += "\""+String.valueOf(ht.get("HP_S_CHA_AMT2")) + "\",";//편차금액
	 	 	/*26*/jobjString += "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_S_CHA_PER2")),2) + "\",";//편차%(예상낙찰가 기준)
	 		/*27*/jobjString += "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("HP_C_CHA_PER2")),2) + "\",";//편차%(소비자가 기준)
	 		/*28*/jobjString += "\""+ String.valueOf(ht.get("DEEP_CAR_AMT2")) + "\",";//딥러닝예상낙찰가2  
	 		/*29*/jobjString += "\""+ String.valueOf(ht.get("DEEP_CAR_AMT8")) + "\",";//딥러닝예상낙찰가2 	추가(20220727) 
	 		/*30*/jobjString += "\""+ht.get("ACTN_JUM") + "\",";//경매장 평점
	 		
	 		/*31*/jobjString += "\""+ht.get("MIGR_STAT") + "\",";//명의이전 구분
	 		/*32*/jobjString += "\""+ht.get("PARK_NM") + "\",";//마지막 위치
	 		/*33*/jobjString += "\""+ht.get("ACCID_YN") + "\",";//사고유무
	 		/*34*/jobjString += "\""+amt_1nd + "\",";//사고수리비 - 수리금액(1위)	추가(20181207)
	 		/*35*/jobjString += "\""+amt_2nd + "\",";//사고수리비 - 수리금액(2위)	추가(20181207)
	 		/*36*/jobjString += "\""+total_amt + "\",";//사고수리비 - 수리금액(전체-합계)
	 		/*37*/jobjString += "\""+AddUtil.parseFloatCipher(String.valueOf(ht.get("SE_PER")),2)+"\",";//사고수리비 - 소비자가 대비
	 		/*38*/jobjString += "\""+String.valueOf(ht.get("COMM1_TOT")) + "\",";//매각수수료 - 낙찰수수료
	 		/*39*/jobjString += "\""+comm2_tot + "\",";//매각수수료 - 출품수수료
	 		/*40*/jobjString += "\""+String.valueOf(out_amt) + "\",";//매각수수료 - 재출품수수료
	 		
	 		/*41*/jobjString += "\""+String.valueOf(ht.get("COMM3_TOT")) + "\",";//매각수수료 - 반입탁송대금	 		
	 		/*42*/jobjString += "\""+String.valueOf(ht.get("COMM_TOT")) + "\",";//매각수수료 - 합계
	 		/*43*/jobjString += "\""+String.valueOf(ht.get("SUI_NM")) + "\",";//낙찰자
	 		/*44*/jobjString += "\""+String.valueOf(ht.get("OPT")) + "\",";//선택사양
	 		/*45*/jobjString += "\""+ht.get("OPT_AMT") + "\",";//선택사양가
	 		/*46*/jobjString += "\""+ ht.get("DPM") + "\",";//배기량
	 		/*47*/jobjString += "\""+ ht.get("FUEL_KD") + "\",";//연료
	 		/*48*/jobjString += "\""+ String.valueOf(ht.get("COLO")) + "\",";//색상
	 		/*49*/jobjString += "\""+ String.valueOf(ht.get("IN_COL")) + "\",";//내장색상
	 		/*50*/jobjString += "\""+String.valueOf(ht.get("CAR_Y_FORM")) + "\",";//모델년도
	 		
	 		/*51*/jobjString += "\""+String.valueOf(ht.get("ACTN_RSN")) + "\",";//평가요인
	 		/*52*/jobjString += "\""+String.valueOf(ht.get("A_CNT_YN")) + "\",";//침수차여부
	 		/*53*/jobjString += "\""+String.valueOf(ht.get("DIST_CNG_YN")) + "\",";//계기판 교체여부
	 		/*54*/jobjString += "\""+String.valueOf(ht.get("CAR_PRE_NO")) + "\",";//변경전 차량번호
	 		/*55*/jobjString += "\""+String.valueOf(ht.get("OFFER_CNT")) + "\",";//유찰회수
	 		/*56*/jobjString += "\""+String.valueOf(ht.get("DEEP_CAR_AMT3")) + "\",";//
	 		/*57*/jobjString += "\""+String.valueOf(ht.get("DEEP_CAR_AMT4")) + "\",";//
	 		/*58*/jobjString += "\""+String.valueOf(ht.get("DEEP_CAR_AMT5")) + "\",";//
	 		/*59*/jobjString += "\""+String.valueOf(ht.get("DEEP_CAR_AMT6")) + "\",";//	 			 		
	 		/*60*/jobjString += "\""+String.valueOf(ht.get("DEEP_CAR_AMT7")) + "\"]";//
	 		
	 	 	jobjString += "}";
		}	
		jobjString += "]};";
	} 
	
	String [][] grid_arr = {
			
			/*	0	*/{ "40",	"int",	"s",	"ro",	"center",	"false",	"연번	",			"#rspan"			,"편차 부호 반영",	"편차 부호 반영",                	"편차 부호 반영",       	"편차 절대값 반영",   	"편차 절대값 반영",                   	"편차 절대값 반영"},
			/*	1	*/{ "70",	"str",	"s",	"link",	"center",	"false",	"차량번호",		"#text_filter"		,"#cspan",      	"#cspan",                       	"#cspan",              	"#cspan",           	"#cspan",                           	"#cspan"                   },
			/*	2	*/{ "70",	"int",	"s",	"ron",	"center",	"false",	"차종코드",		"#select_filter"	,"#cspan",      	"#cspan",                       	"#cspan",              	"#cspan",           	"#cspan",                           	"#cspan"           },
			/*	3	*/{ "150",	"str",	"s",	"ro",	"center",	"true",		"차명	",			"#text_filter"		,"#cspan",      	"#cspan",                       	"#cspan",              	"#cspan",           	"#cspan",                           	"#cspan"           },
			/*	4	*/{ "90",	"str",	"s",	"ro",	"center",	"true",		"경매장",			"#select_filter"	,"합계",         	"평균(평균금액 대 평균금액으로 계산)",   	"평균(대비율의 평균)",      	"합계",              	"평균(평균금액 대 평균금액으로 계산)",       	"평균(대비율의 평균)"           },
			/*	5	*/{ "80",	"str",	"s",	"ro",	"center",	"false",	"경매일자",		"#text_filter"		,"#cspan",      	"#cspan",                       	"#cspan",              	"#cspan",           	"#cspan",                           	"#cspan"           },
			/*	6	*/{ "80",	"str",	"s",	"ro",	"center",	"false",	"최초등록일",		"#select_filter"	,"#cspan",      	"#cspan",                       	"#cspan",              	"#cspan",           	"#cspan",                           	"#cspan"           },
			/*	7	*/{ "110",	"int",	"i",	"ron",	"right",	"false",	"소비자가격",		"#rspan"			,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	8	*/{ "110",	"int",	"i",	"ron",	"right",	"false",	"구입가격",		"#rspan"			,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	9	*/{ "100",	"int",	"i",	"ron",	"right",	"false",	"희망가",			"#rspan"			,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	10	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"예상낙찰가",		"#rspan"			,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	11	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"매각(낙찰)",		"낙찰가"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	12	*/{ "100",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"소비자가<br>대비"		,"",            	"{#stat_multi_total_avg}7:11",  	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	13	*/{ "70",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"구입가<br>대비"		,"",            	"{#stat_multi_total_avg}8:11",  	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	14	*/{ "70",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"예상<br>낙찰가<br>대비","",            	"{#stat_multi_total_avg}10:11", 	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	15	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"편차금액"				,"#stat_total", 	"#stat_average",                	"",                    	"#stat_cha_total",  	"#stat_cha_average",                	""                 },
			/*	16	*/{ "90",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"<span style='font-size:12px;'>편차%<br>(예상낙찰가<br>기준)</span>"	,"",            	"{#stat_multi_total_avg}10:15", 	"#stat_average",       	"",                 	"{#stat_multi_total_avg_cha}10:15", 	"#stat_cha_average"},
			/*	17	*/{ "80",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"<span style='font-size:12px;'>편차%<br>(소비자가<br>기준)</span>"	,"",            	"{#stat_multi_total_avg}7:15",  	"#stat_average",       	"",                 	"{#stat_multi_total_avg_cha}7:15",  	"#stat_cha_average"},

			/*	18 (27이동)	*/{ "60",	"int",	"s",	"ron",	"center",	"false",	"차령	",			"#rspan"			,"",            	"",                             	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	19 (28이동)	*/{ "70",	"int",	"i",	"ron",	"right",	"false",	"주행<br>거리",	"#rspan"			,"",            	"",                             	"#stat_average",       	"",                 	"",                                 	""                 },
			
			/*	20	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가",  "#rspan"		,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	21	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"매각(낙찰)",		"낙찰가"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	22	*/{ "100",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"소비자가<br>대비"		,"",            	"{#stat_multi_total_avg}7:21",  	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	23	*/{ "70",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"구입가<br>대비"		,"",            	"{#stat_multi_total_avg}8:21",  	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	24	*/{ "70",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"예측<br>낙찰가<br>대비","",            	"{#stat_multi_total_avg}10:21", 	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	25	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"편차금액"				,"#stat_total", 	"#stat_average",                	"",                    	"#stat_cha_total",  	"#stat_cha_average",                	""                 },
			/*	26	*/{ "90",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"<span style='font-size:12px;'>편차%<br>(예측낙찰가<br>기준)</span>"	,"",            	"{#stat_multi_total_avg}20:25", 	"#stat_average",       	"",                 	"{#stat_multi_total_avg_cha}20:25", 	"#stat_cha_average"},
			/*	27	*/{ "80",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"<span style='font-size:12px;'>편차%<br>(소비자가<br>기준)</span>"	,"",            	"{#stat_multi_total_avg}7:25",  	"#stat_average",       	"",                 	"{#stat_multi_total_avg_cha}7:25",  	"#stat_cha_average"},
			/*	28	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(해당연월 반영 - 해당차량 미반영)",  "#rspan"   ,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			
			/*	29 (추가)	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(해당연월 반영 - 해당차량 반영)",  "#rspan"   ,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			
			/*	30	*/{ "60",	"str",	"s",	"ro",	"center",	"false",	"경매장<br>평점",  "#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	31	*/{ "80",	"str",	"s",	"ro",	"center",	"false",	"명의이전<br>구분", "#select_filter"	,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	32	*/{ "80",	"str",	"s",	"ro",	"center",	"false",	"마지막위치",		"#select_filter"	,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	33	*/{ "50",	"str",	"s",	"ro",	"center",	"false",	"사고<br>유무",	"#select_filter"	,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	34	*/{ "100",	"int",	"i",	"ron",	"right",	"false",	"사고수리비",		"1위"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	35	*/{ "100",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"2위"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	36	*/{ "100",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"전체"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	37	*/{ "70",	"int",	"f",	"ron",	"right",	"false",	"#cspan",		"소비자가<br>대비"		,"",            	"{#stat_multi_total_avg}7:25",  	"#stat_average",       	"",                 	"",                                 	""                 },
			/*	38	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"매각수수료",		"낙찰<br>수수료"		,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	39	*/{ "60",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"출품<br>수수료"		,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	40	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"재출품<br>수수료"		,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	41	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"반입<br>탁송대금"		,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	42	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"#cspan",		"합계"				,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	43	*/{ "100",	"str",	"s",	"ro",	"center",	"true",		"낙찰자",			"#text_filter"		,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	44	*/{ "170",	"str",	"s",	"ro",	"center",	"true",		"선택사양",		"#text_filter"		,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	45	*/{ "90",	"int",	"i",	"ron",	"right",	"false",	"선택사양가",		"#rspan"			,"#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                 },
			/*	46	*/{ "70",	"int",	"s",	"ron",	"center",	"false",	"배기량",			"#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	47	*/{ "50",	"str",	"s",	"ro",	"center",	"false",	"연료	",			"#select_filter"	,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	48	*/{ "90",	"str",	"s",	"ro",	"center",	"true",		"색상	",			"#text_filter"		,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	49	*/{ "80",	"str",	"s",	"ro",	"center",	"false",	"내장색상",		"#select_filter"	,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	50	*/{ "50",	"str",	"s",	"ro",	"center",	"false",	"모델<br>년도",	"#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	51	*/{ "200",	"str",	"s",	"ro",	"left",		"true",		"평가요인",		"#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	52	*/{ "70",	"str",	"s",	"ro",	"center",	"false",	"침수차<br>여부",  "#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	53	*/{ "70",	"str",	"s",	"ro",	"center",	"false",	"계기판<br>교체여부", "#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	54	*/{ "70",	"str",	"s",	"ro",	"center",	"false",	"변경전<br>차량번호", "#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	55	*/{ "50",	"int",	"s",	"ron",	"center",	"false",	"유찰<br>횟수",	"#rspan"			,"",            	"",                             	"",                    	"",                 	"",                                 	""                 },
			/*	56	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(분당)",  "#rspan","#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                    },
			/*	57	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(시화)",  "#rspan","#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                    },
			/*	58	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(양산)",  "#rspan","#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                    },
			/*	59	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(롯데)",  "#rspan","#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                    },
			/*	60	*/{ "80",	"int",	"i",	"ron",	"right",	"false",	"딥러닝<br>예측낙찰가<br>(AJ)",   "#rspan","#stat_total", 	"#stat_average",                	"",                    	"",                 	"",                                 	""                    }

	};
	
	String setInitWidths  = "";
	String setColSorting  = "";
	String setNumberFormat = "";
	String setColTypes  = "";
	String setColAlign  = "";
	String enableTooltips  = "";
	String setHeader  = "";
	String attachHeader  = "";
	String attachFooter1  = "";
	String attachFooter2  = "";
	String attachFooter3  = "";
	String attachFooter4  = "";
	String attachFooter5  = "";
	String attachFooter6  = "";

	for(int i=0;i<grid_arr.length;i++){
		
		for(int j=0;j<grid_arr[i].length;j++){
			
			if(j==0) setInitWidths += grid_arr[i][j]; 
			if(j==1) setColSorting += grid_arr[i][j];
			if(j==2) setNumberFormat += grid_arr[i][j];
			if(j==3) setColTypes += grid_arr[i][j];
			if(j==4) setColAlign += grid_arr[i][j];
			if(j==5) enableTooltips += grid_arr[i][j];
			if(j==6) setHeader += grid_arr[i][j].trim();
			if(j==7) attachHeader += grid_arr[i][j];
			if(j==8)  attachFooter1 += grid_arr[i][j];
			if(j==9)  attachFooter2 += grid_arr[i][j];
			if(j==10) attachFooter3 += grid_arr[i][j];
			if(j==11) attachFooter4 += grid_arr[i][j];
			if(j==12) attachFooter5 += grid_arr[i][j];
			if(j==13) attachFooter6 += grid_arr[i][j];
			
			if((i+1) < grid_arr.length){
				if(j==0) setInitWidths += ","; 
				if(j==1) setColSorting += ",";
				if(j==2) setNumberFormat += ",";
				if(j==3) setColTypes += ",";
				if(j==4) setColAlign += ",";
				if(j==5) enableTooltips += ",";
				if(j==6) setHeader += ",";
				if(j==7) attachHeader += ",";				
				if(j==8)  attachFooter1 += ",";
				if(j==9)  attachFooter2 += ",";
				if(j==10) attachFooter3 += ",";
				if(j==11) attachFooter4 += ",";
				if(j==12) attachFooter5 += ",";
				if(j==13) attachFooter6 += ",";				
			}
			
		}
	}

%>

<!DOCTYPE html>
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<meta http-equiv="X-UA-Compatible" content="IE=EmulateIE8">
<!--link rel=stylesheet type="text/css" href="/include/table.css"-->

<!--Grid-->
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<!-- <link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/dhtmlxgrid.css" /> -->
<link rel="stylesheet" type="text/css" href="/fms2/lib/dhtmlx/skins/web/dhtmlxgrid_rendering.css"/>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_deprecated.js"></script>
<script src="/fms2/lib/dhtmlx/dhtmlxgrid_export.js"></script>
<style type="text/css">
	html, body {height: 93%;	}
	input.whitenum {text-align: right;  border-width: 0; }
	table.hdr td {	height: 30px !important;	}
</style>
<!--Grid-->

<script>

function view_detail(car_mng_id, seq)
{
	var fm = document.form1;
	fm.car_mng_id.value = car_mng_id;
	fm.seq.value = seq;
	fm.target = "d_content";
	fm.action = "/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp";
	fm.submit();
}

function excel_reg(){
	var fm = document.form1;
	fm.target = "_blank";
	fm.action = "in_excel.jsp";
	fm.submit();
}

<%=jobjString%>

</script>
</head>
<body leftmargin="15">
<form name='form1' method='post' target='d_content' action='/acar/off_ls_cmplt/off_ls_cmplt_sc_in_detail_frame.jsp'>
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='br_id' value='<%=br_id%>'> 
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='gubun1' value='<%=gubun1%>'>
<input type='hidden' name='gubun2' value='<%=gubun2%>'>
<input type='hidden' name='gubun3' value='<%=gubun3%>'>
<input type='hidden' name='deep_yn' value='<%=deep_yn%>'>
<input type='hidden' name='gubun_nm' value='<%=gubun_nm%>'>
<input type='hidden' name='dt' value='<%=dt%>'>
<input type='hidden' name='ref_dt1' value='<%=ref_dt1%>'>
<input type='hidden' name='ref_dt2' value='<%=ref_dt2%>'>
<input type='hidden' name='s_au' value='<%=s_au%>'>
<input type='hidden' name='from_page' value='/acar/off_ls_cmplt/off_ls_stat_grid_sc.jsp'>  
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='seq' value=''>

<table border="0" cellspacing="0" cellpadding="0" width=100% height="35px">
	<tr>
		<td align=''>
		   <a href="javascript:myGrid.toExcel('/grid-excel/generate');"><img src=/acar/images/center/button_excel.gif align=absmiddle border=0></a>&nbsp;&nbsp;
		   <a href="javascript:excel_reg();"><img src=/acar/images/center/button_excel_dr.gif align=absmiddle border=0></a>&nbsp;&nbsp;&nbsp;&nbsp;		
		</td>
        <td align="right" style="margin-right:5px; font-size: 9pt;">
            * 평균 예상낙찰가대비율:
              [현대글로비스-시화]	<input type='text' name='avg_per1' size='4' class='whitenum'>%&nbsp;
              [현대글로비스-분당]	<input type='text' name='avg_per2' size='4' class='whitenum'>%&nbsp;
	      	  [에이제이셀카 주식회사]	<input type='text' name='avg_per4' size='4' class='whitenum'>%&nbsp;		
              [롯데렌탈]			<input type='text' name='avg_per3' size='4' class='whitenum'>%&nbsp;          
        </td>
    </tr>
</table>
</form>
<div id="gridbox" style="width:100%;height:100%; margin: 5px 0 5px 0;"></div>
<table border="0" cellspacing="0" cellpadding="0" width=100% height="25px">
    <tr> 
        <td width="*" align="left" style="font-size: 9pt;">
            * 총 건수 : <span id="gridRowCount">0</span>건 
        </td>
        <td width="10%">
			<div id="a_1" style="color:red;">Loading</div>
        </td>
        <td width="80%" align="right" style="font-size: 9pt;">
        	<span>* 예상낙찰가 : 20150512 이전에는 재리스잔존가, 20150512 부터는 예상낙찰가 계산값</span>
        </td>
    </tr>    
</table>
<script language='javascript'>
<!--
	document.form1.avg_per1.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per1/use_cnt1), 2)%>';
	document.form1.avg_per2.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per2/use_cnt2), 2)%>';
	document.form1.avg_per3.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per3/use_cnt3), 2)%>';
	document.form1.avg_per4.value = '<%=AddUtil.parseFloatCipher(String.valueOf(use_per4/use_cnt4), 2)%>';
//-->
</script>
</body>

<script>

var myGrid;

	myGrid = new dhtmlXGridObject('gridbox');
	myGrid.setImagePath("");//총0-45열(46개)
	//myGrid.setHeader("연번,차량번호,차종코드,차명,경매장,경매일자,최초등록일,소비자가격,구입가격,희망가,예상낙찰가,매각(낙찰),#cspan,#cspan,#cspan,#cspan,#cspan,#cspan,차령,주행<br>거리,경매장<br>평점,명의이전<br>구분,마지막위치,사고<br>유무,사고수리비,#cspan,#cspan,#cspan,매각수수료,#cspan,#cspan,#cspan,#cspan,낙찰자,선택사양,선택사양가,배기량,연료,색상,내장색상,모델<br>년도,평가요인,침수차<br>여부,계기판<br>교체여부,변경전<br>차량번호,유찰<br>횟수,딥러닝<br>예측낙찰가<br>(분당),딥러닝<br>예측낙찰가<br>(시화),딥러닝<br>예측낙찰가<br>(양산),딥러닝<br>예측낙찰가<br>(롯데),딥러닝<br>예측낙찰가<br>(AJ)");
	//myGrid.setInitWidths("35,70,70,150,90,80,80,105,105,95,90,90,100,70,70,90,85,75,55,65,60,80,80,50,95,95,95,70,85,55,85,80,85,100,170,90,70,50,90,80,50,200,70,70,70,50,80,80,80,80,80");
	//myGrid.setColSorting("int,str,int,str,str,str,str,int,int,int,int,int,int,int,int,int,int,int,int,int,str,str,str,str,int,int,int,int,int,int,int,int,int,str,str,int,int,str,str,str,str,str,str,str,str,int,int,int,int,int,int");
	//myGrid.setColTypes("ro,link,ron,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron,ron,ron,ron,ro,ro,ron,ron,ro,ro,ro,ro,ro,ro,ro,ro,ron,ron,ron,ron,ron,ron");
	//myGrid.attachHeader("#rspan,#text_filter,#select_filter,#text_filter,#select_filter,#text_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,낙찰가,소비자가<br>대비,구입가<br>대비,예상<br>낙찰가<br>대비,편차금액,<span style='font-size:12px;'>편차%<br>(예상낙찰가<br>기준)</span>,<span style='font-size:12px;'>편차%<br>(소비자가<br>기준)</span>,#rspan,#rspan,#rspan,#select_filter,#select_filter,#select_filter,1위,2위,전체,소비자가<br>대비,낙찰<br>수수료,출품<br>수수료,재출품<br>수수료,반입<br>탁송대금,합계,#text_filter,#text_filter,#rspan,#rspan,#select_filter,#text_filter,#select_filter,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan,#rspan");
	//myGrid.setColAlign("center,center,center,center,center,center,center,right,right,right,right,right,right,right,right,right,right,right,center,right,center,center,center,center,right,right,right,right,right,right,right,right,right,center,center,right,center,center,center,center,center,left,center,center,center,center,right,right,right,right,right");
	//myGrid.enableTooltips("false,false,false,true,true,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,false,true,true,false,false,false,true,false,false,true,false,false,false,false,false,false,false,false,false");
	myGrid.setHeader("<%=setHeader%>");
	myGrid.setInitWidths("<%=setInitWidths%>");
	myGrid.setColSorting("<%=setColSorting%>");
	myGrid.setColTypes("<%=setColTypes%>");
	myGrid.attachHeader("<%=attachHeader%>");
	myGrid.setColAlign("<%=setColAlign%>");
	myGrid.enableTooltips("<%=enableTooltips%>");
	<%for(int i=0;i<grid_arr.length;i++){
		for(int j=0;j<grid_arr[i].length;j++){
			if(j==2 && grid_arr[i][j].equals("i")){%>
				myGrid.setNumberFormat("0,000",<%=i%>);
	<%			
			}else if(j==2 && grid_arr[i][j].equals("f")){%>
				myGrid.setNumberFormat("0,000.00%",<%=i%>);
	<%
			}
		}
	}
	%>	
	
	
	myGrid.attachEvent("onXLS",function(){ document.getElementById("a_1").style.display="block"; });
	myGrid.attachEvent("onXLE",function(){  
		if (!myGrid.getRowsNum())	{
			document.getElementById("a_1").style.display="none"; 
			alert('해당 차량이 없습니다');
		} else {
			document.getElementById("a_1").style.display="none"; 
		}
	});	
	
	myGrid.init();
	eXcell_link.prototype.getTitle = eXcell_link.prototype.getContent;
	
	//myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,#cspan,합계,#cspan,#cspan,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,,#stat_total,,,#stat_total,#stat_total,,,,#stat_total,,,#stat_total,,,,,,,#stat_total,#stat_total,#stat_total,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total,,,#stat_total,,,,,,,,,,,#stat_total,#stat_total,#stat_total,#stat_total,#stat_total",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,#cspan,평균(평균금액 대 평균금액으로 계산),#cspan,#cspan,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}7:11,{#stat_multi_total_avg}8:11,{#stat_multi_total_avg}10:11,#stat_average,{#stat_multi_total_avg}10:15,{#stat_multi_total_avg}7:15,#stat_average,#stat_average,{#stat_multi_total_avg}7:19,{#stat_multi_total_avg}8:19,{#stat_multi_total_avg}10:19,#stat_average,{#stat_multi_total_avg}18:23,{#stat_multi_total_avg}7:23,#stat_average,,,,,,,#stat_average,#stat_average,#stat_average,{#stat_multi_total_avg}7:23,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average,,,#stat_average,,,,,,,,,,,#stat_average,#stat_average,#stat_average,#stat_average,#stat_average",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);  
	//myGrid.attachFooter("편차 부호 반영,#cspan,#cspan,#cspan,평균(대비율의 평균),#cspan,#cspan,,,,,,#stat_average,#stat_average,#stat_average,,#stat_average,#stat_average,,,#stat_average,#stat_average,#stat_average,,#stat_average,#stat_average,,#stat_average,#stat_average,,,,,,,,#stat_average,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,#cspan,합계,#cspan,#cspan,,,,,,,,,#stat_cha_total,,,,,,,,#stat_cha_total,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,#cspan,평균(평균금액 대 평균금액으로 계산),#cspan,#cspan,,,,,,,,,#stat_cha_average,{#stat_multi_total_avg_cha}10:15,{#stat_multi_total_avg_cha}7:15,,,,,,#stat_cha_average,{#stat_multi_total_avg_cha}18:23,{#stat_multi_total_avg_cha}7:23,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	//myGrid.attachFooter("편차 절대값 반영,#cspan,#cspan,#cspan,평균(대비율의 평균),#cspan,#cspan,,,,,,,,,,#stat_cha_average,#stat_cha_average,,,,,,,#stat_cha_average,#stat_cha_average,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter1%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter2%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter3%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter4%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter5%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	myGrid.attachFooter("<%=attachFooter6%>",["text-align:center;",,,,"text-align:center;",,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,,]);
	
	
	myGrid.splitAt(7);
	
	//myGrid.enableBlockSelection();
    myGrid.enableMathEditing(true);
    myGrid.enableColumnMove(true);      
    myGrid.enableSmartRendering(true);
    myGrid.enableBlockSelection();
    myGrid.forceLabelSelection(true);
    myGrid.attachEvent("onKeyPress",onKeyPressed);
    myGrid.parse(data,"json");	   


function onKeyPressed(code,ctrl,shift){
	if(code==67&&ctrl){
		if (!myGrid._selectionArea) return alert("You need to select a block area in grid first");
			myGrid.setCSVDelimiter("\t");
			
			myGrid.copyBlockToClipboard()
		}
		if(code==86&&ctrl){
			myGrid.setCSVDelimiter("\t");
			myGrid.pasteBlockFromClipboard()
		}
	return true;
}

</script>
</html>