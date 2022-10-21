<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*,acar.car_register.*"%>
<jsp:useBean id="ec_db" scope="page" class="acar.cont.EtcContDatabase"/>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String ins_com_id = request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//사용자 관리번호
	
	String result[]   = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");		//1 증권번호
	String value1[]  	= request.getParameterValues("value6");		//2 차량번호
	String value2[]  	= request.getParameterValues("value8");		//3 연령
	String value3[]  	= request.getParameterValues("value9");		//4 공제기간
	String value4[]  	= request.getParameterValues("value10");	//5 납입방법
	String value5[]  	= request.getParameterValues("value18");	//6 대인투
	String value6[]  	= request.getParameterValues("value19");	//7 대물배상
	String value7[]  	= request.getParameterValues("value20");	//8 자손
	String value8[]  	= request.getParameterValues("value29");	//9 장기여부
	String value9[]  	= request.getParameterValues("value32");	//10 결제예정금
	String value10[] 	= request.getParameterValues("value33");	//11 배서기준일
	String value11[] 	= request.getParameterValues("value39");	//12 대인원		
	String value12[] 	= request.getParameterValues("value40");	//13 대인투
	String value13[] 	= request.getParameterValues("value41");	//14 대물배상
	String value14[] 	= request.getParameterValues("value42");	//15 자손
	String value15[] 	= request.getParameterValues("value43");	//16 무보험
	String value16[] 	= request.getParameterValues("value49");	//17 분담금할증
	String value17[] 	= request.getParameterValues("value51");	//18 운전자이름
	String value18[] 	= request.getParameterValues("value35");	//19 신규체크
	String value19[] 	= request.getParameterValues("value3");	//20 계약자명
	String value20[] 	= request.getParameterValues("value2");	//21 피공제자명
	String value21[] 	= request.getParameterValues("value44");	//22 자차
	String value22[] 	= request.getParameterValues("value47");	//23 긴출

			
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int flag = 0;
	int count = 0;
	String v1 ="";
	String v2 ="";
	String v3 ="";
	String v4 ="";
	String v5 ="";
	String v6 ="";
	String v7 ="";
	String v8 ="";
	String v9 ="";
	String v10 ="";
	String v11 ="";
	String v12 ="";
	String v13 ="";
	String v14 ="";
	String v15 ="";
	String v16 ="";
	String v17 ="";
	String v18 ="";
	String v19 ="";
	String v20 ="";
	String v21 ="";
	String v22 ="";
	String v23 ="";
	String ins_start_dt = "";
	String ins_end_dt = "";

	
	String result_value = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsComDatabase ic_db = InsComDatabase.getInstance();
	CarRegDatabase crd = CarRegDatabase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	String chk_before_dt = AddUtil.getDate();
	String chk_after_dt = AddUtil.getDate();	
	int chk_current_dt = 0;
	
	chk_before_dt = c_db.addMonth(chk_before_dt, -1);
	chk_after_dt =  c_db.addMonth(chk_after_dt, 1); 
	
	chk_before_dt = AddUtil.ChangeString(chk_before_dt);
	chk_after_dt =  AddUtil.ChangeString(chk_after_dt); 
	ck_acar_id ="000048"; //000277
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		
		v1 		= value0[i]  ==null?"":value0[i];  //1 증권번호
		v2		= value1[i]  ==null?"":value1[i];  //2 차량번호
		v3		= value2[i]  ==null?"":value2[i];  //3 연령
		v4		= value3[i]  ==null?"":value3[i];  //4 공제기간
		v5		= value4[i]  ==null?"":value4[i];	 //5 납입방법
		v6		= value5[i]  ==null?"":value5[i];  //6 대인투
		v7		= value6[i]  ==null?"":value6[i];  //7 대물배상
		v8		= value7[i]  ==null?"":value7[i];  //8 자손
		v9		= value8[i]  ==null?"":value8[i];  //9 장기여부
		v10		= value9[i]  ==null?"":value9[i];  //10 결제예정금
		v11		= value10[i] ==null?"":value10[i];  //11 배서기준일
		v12		= value11[i] ==null?"":value11[i];  //12 대인원		
		v13		= value12[i] ==null?"":value12[i];  //13 대인투
		v14		= value13[i] ==null?"":value13[i];  //14 대물배상
		v15		= value14[i] ==null?"":value14[i];  //15 자손
		v16		= value15[i] ==null?"":value15[i];  //16 무보험
		v17		= value16[i] ==null?"":value16[i];  //17 분담금할증
		v18		= value17[i] ==null?"":value17[i];  //18 운전자이름
		v19		= value18[i] ==null?"":value18[i];  //19 신규체크
		v20		= value19[i] ==null?"":value19[i];  //20 계약자명
		v21		= value20[i] ==null?"":value20[i];  //21 피공제자명
		v22		= value21[i] ==null?"":value21[i];  //22 자차         
		v23		= value22[i] ==null?"":value22[i];  //23 긴출         
		
		
		
		//중복입력 체크-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(v2,v1);
		int over_cnt2 = 0;
		int over_cnt3 = ai_db.getCheckOverIns2(v2);
		
		chk_current_dt = AddUtil.getDate2(0) ;
		int  v17_m  = AddUtil.parseInt(v11.substring(0,6));
		
		if(chk_current_dt <= 9 ){ //결산 전
			if(      (  AddUtil.parseInt(chk_before_dt.substring(0,6))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )       ){
				
			}else{
				over_cnt2++;
			}					
		}else{ //결산 후
			if(   (  AddUtil.parseInt(AddUtil.getDate(5))  <=   v17_m  )    &&     (  AddUtil.parseInt(chk_after_dt.substring(0,6))  >=   v17_m  )      ){
			
			}else{
				over_cnt2++;
			}	
		}
		
		if(over_cnt != 0){
			out.println("<중복입력확인필요>차량번호: "+v2+", 증권번호: "+v1+ " <br>");
		}
		if(over_cnt2 != 0){
			out.println("<배서기준일 확인필요>차량번호: "+v2+", 증권번호: "+v1+", 배서기준일: "+v11+" <br>");
		}
		if(over_cnt3 == 0){
			out.println("<차량등록 확인필요>차량번호: "+v2+", 증권번호: "+v1+"<br>");
		}
						
	 	/* System.out.println(v1);
		System.out.println(v9);
		System.out.println(v10);
		System.out.println(over_cnt);
		System.out.println(over_cnt2);
		System.out.println(over_cnt3); 
		 */
		 if(!v1.equals("") && !v9.equals("") && !v10.equals("")  && over_cnt == 0  &&  over_cnt2 == 0  &&  over_cnt3 != 0 ){
					
			InsurExcelBean ins = new InsurExcelBean();
						
			ins.setReg_code	(reg_code);
			ins.setSeq	(count);
			ins.setReg_id	(ck_acar_id);
			ins.setGubun	("7");
			
			ins.setValue01	(v1);//1 증권번호
			ins.setValue02	(v2);//2 차량번호
			ins.setValue03	(v3);//3 연령
			//ins.setValue04	(v4);//4 공제기간	
			ins.setValue05	(v5);//5 납입방법	
			
			ins.setValue06	(v6);//6 대인투
			ins.setValue07	(v7);//7 대물배상
			ins.setValue08	(v8);//8 자손	
			ins.setValue09	(v9);//9 장기여부	
			ins.setValue10	(AddUtil.replace(v10,",",""));//10 결제예정금	
			
			ins.setValue11	(v11);//11 배서기준일	
			ins.setValue12	(AddUtil.replace(v12,",",""));//12 대인원			
			ins.setValue13	(AddUtil.replace(v13,",",""));//13 대인투	
			ins.setValue14	(AddUtil.replace(v14,",",""));//14 대물배상	
			ins.setValue15	(AddUtil.replace(v15,",",""));//15 자손	
			
			ins.setValue16	(AddUtil.replace(v16,",",""));//16 무보험
			ins.setValue17	(AddUtil.replace(v17,",",""));//17 분담금할증
			ins.setValue18	(v18);//18 운전자이름
			
			ins_start_dt    = v4.substring(0,10);
			ins_start_dt    = AddUtil.replace(ins_start_dt,"/","");
			ins.setValue19	(ins_start_dt);//19 보험시작일
			
			ins_end_dt   = v4.substring(11,21);
			ins_end_dt   = AddUtil.replace(ins_end_dt,"/","");
			ins.setValue20	(ins_end_dt);//20 보험만료일
			ins.setValue21	(v19);//21 신규체크
			ins.setValue22	(v20);//22 계약자명
			ins.setValue23	(v21);//23 피공제자명
			String r_ins_est_dt = c_db.addMonth(ins_start_dt, 1);
			r_ins_est_dt = r_ins_est_dt.substring(0,8)+"10";
			r_ins_est_dt = ai_db.getValidDt(r_ins_est_dt);
			ins.setValue24	(AddUtil.replace(r_ins_est_dt,"-",""));//24 실제 입금일

			
			
			if(!ai_db.insertInsExcel2(ins))	flag += 1;
			
			//System.out.println("flag:"+ flag);
			//if(1==1)return;
		
			}
		
		if(flag == 0){ //ins table에 insert 성공 시

				
				String car_no = v2;
			 	String firm_nm = v18;
				
				Hashtable cont_ht = a_db.getContInfo(car_no, firm_nm);
			
				String rent_l_cd = (String)cont_ht.get("RENT_L_CD");
				
			
				String gubun = "가입";
				//String gubun = "확인";
				String car_num = "";
				
				
				Hashtable ht = a_db.getRentBoardSubCase(rent_l_cd);
				
				
				String rent_mng_id = String.valueOf(cont_ht.get("RENT_MNG_ID"));
				
			/* 	System.out.println("rent_l_cd:"+rent_l_cd);
				System.out.println("rent_mng_id:"+rent_mng_id);
			 */	
				CarRegBean cr_bean = new CarRegBean();
				
				if(String.valueOf(cont_ht.get("CAR_MNG_ID")).equals("")){
					car_no  = String.valueOf(ht.get("EST_CAR_NO"));
					car_num = String.valueOf(ht.get("CAR_NUM"));
				}else{
					cr_bean = crd.getCarRegBean(String.valueOf(cont_ht.get("CAR_MNG_ID")));
					car_no  = cr_bean.getCar_no();
					car_num = cr_bean.getCar_num();
				}
				car_no  = AddUtil.replace(car_no," ","");
				car_num = AddUtil.replace(car_num," ","");
				
				
				//차대번호나 차량번호 있는거 확인
				if(car_no.equals("") && car_num.equals("")){
					result_value = "차대번호와 차량번호가 없습니다.";
				}
				
				//차대번호나 차량번호 있는거 확인
				if(car_no.length() < 7 && car_num.length() < 17){
					result_value = "차대번호와 차량번호가 잘못 입력되었습니다. car_no="+car_no+"/len="+car_no.length()+"/car_num="+car_num+"/len="+car_num.length()+" ";
				}
				
				//영업용 확인
				if(result_value.equals("") && ins_com_id.equals("0038") && String.valueOf(cont_ht.get("CAR_ST")).equals("3")){
					result_value = "리스계약입니다.";
				}
				
				//중복체크
				if(result_value.equals("")){
					over_cnt = ic_db.getCheckOverInsExcelCom(gubun, "", rent_mng_id, rent_l_cd, "", "");
					if(over_cnt > 0){
						result_value = "이미 등록되어 있습니다.";
					}
				}
				if(result_value.equals("")){ //validation 성공 후
					
					Hashtable ht2 = ec_db.getRentBoardInsAc(rent_mng_id, rent_l_cd);
					if(ht2.isEmpty()){
						 ht2 = ec_db.getRentBoardIns(rent_mng_id, rent_l_cd);
					}
				
					
					InsurExcelBean ins = new InsurExcelBean();
					
					ins.setReg_code		(reg_code);
					ins.setSeq				(count);
					ins.setReg_id			(ck_acar_id);
					ins.setGubun			(gubun);
					ins.setRent_mng_id(rent_mng_id);
					ins.setRent_l_cd	(rent_l_cd);
					
					ins.setValue01		(String.valueOf(ht2.get("FIRM_NM")));
					
					if(String.valueOf(ht2.get("CAR_ST")).equals("업무대여")){
						ins.setValue01	("(주)아마존카/"+String.valueOf(ht2.get("FIRM_NM")));
					}
					
					ins.setValue02		(AddUtil.ChangeEnpH(String.valueOf(ht2.get("SSN"))));
					ins.setValue03		(String.valueOf(ht2.get("CAR_NM"))+" "+String.valueOf(ht2.get("CAR_NAME")));
					ins.setValue04		(String.valueOf(ht2.get("CAR_NO")));
					ins.setValue05		(String.valueOf(ht2.get("CAR_NUM")));
					
					ins.setValue06		(String.valueOf(ht2.get("TOT_AMT")));
					
					String driving_age = String.valueOf(ht2.get("DRIVING_AGE"));
					String driving_age_nm = "";
					if(driving_age.equals("0")){      driving_age_nm = "26세이상";
					}else if(driving_age.equals("3")){driving_age_nm = "24세이상";
					}else if(driving_age.equals("1")){driving_age_nm = "21세이상";
					}else if(driving_age.equals("5")){driving_age_nm = "30세이상";
					}else if(driving_age.equals("6")){driving_age_nm = "35세이상";
					}else if(driving_age.equals("7")){driving_age_nm = "43세이상";
					}else if(driving_age.equals("8")){driving_age_nm = "48세이상";
					}else if(driving_age.equals("2")){driving_age_nm = "모든운전자";
					}
					ins.setValue07		(driving_age_nm);
					
					String gcp_kd = String.valueOf(ht2.get("GCP_KD"));
					String gcp_kd_nm = "";
					if(gcp_kd.equals("1")){      gcp_kd_nm = "5천만원";
					}else if(gcp_kd.equals("2")){gcp_kd_nm = "1억원";
					}else if(gcp_kd.equals("3")){gcp_kd_nm = "5억원";
					}else if(gcp_kd.equals("4")){gcp_kd_nm = "2억원";
					}else if(gcp_kd.equals("8")){gcp_kd_nm = "3억원";
					}
					ins.setValue08		(gcp_kd_nm);
					
					String bacdt_kd = String.valueOf(ht2.get("BACDT_KD"));
					String bacdt_kd_nm = "";
					if(bacdt_kd.equals("1")){      bacdt_kd_nm = "5천만원";
					}else if(bacdt_kd.equals("2")){bacdt_kd_nm = "1억원";
					}
					ins.setValue09		(bacdt_kd_nm);
					
					ins.setValue10		(String.valueOf(ht2.get("COM_EMP_YN")));
					
					ins.setValue11		(String.valueOf(ht2.get("B_COM_NM"))+"-"+String.valueOf(ht2.get("B_MODEL_NM")));
					
					if(!String.valueOf(ht2.get("B_MODEL_NM")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
						ins.setValue12	("92727");
					}else{
						ins.setValue12	(String.valueOf(ht2.get("B_AMT")));
					}
					ins.setValue13		(String.valueOf(ht2.get("B_SERIAL_NO")));
					ins.setValue14		("0038");
					
					if(!ins_com_id.equals("")){
						ins.setValue14		(ins_com_id);
					}
					
					if(String.valueOf(ht2.get("B_SERIAL_NO")).equals("") && AddUtil.parseDecimal(String.valueOf(ht2.get("B_AMT"))).equals("0")){
						ins.setValue11	("");
					}		
					
					ins.setValue15	(v1);  //1 증권번호
					ins.setValue16 	(v2);  //2 차량번호
					
					
					ins.setValue17 	(AddUtil.replace(v12,",","")); //12 대인원	
					ins.setValue18 	(AddUtil.replace(v13,",","")); //13 대인투  
					ins.setValue19 	(AddUtil.replace(v14,",","")); //14 대물배상 
					ins.setValue20 	(AddUtil.replace(v15,",","")); //15 자손  (자기신체사고) 
					ins.setValue21 	(AddUtil.replace(v16,",","")); //16 무보험  
					ins.setValue22 	(AddUtil.replace(v17,",","")); //17 분담금할증
					
					
					ins.setValue23 	(v22); //22 자차       
					ins.setValue24 	(v23); //23 긴출       

					//총금액을 위한
					String val17  = ins.getValue17() == null ? "0" : ins.getValue17(); //대인원
					String val18  = ins.getValue18() == null ? "0" : ins.getValue18(); //대인투
					String val19  = ins.getValue19() == null ? "0" : ins.getValue19(); //대물배상
					String val20  = ins.getValue20() == null ? "0" : ins.getValue20(); //자손
					String val21  = ins.getValue21() == null ? "0" : ins.getValue21(); //무보험
					String val22  = ins.getValue22() == null ? "0" : ins.getValue22(); //분담금할정
					
					
					int sum =  Integer.parseInt(val17) + Integer.parseInt(val18) + Integer.parseInt(val19) + 
							Integer.parseInt(val20) + Integer.parseInt(val21) + Integer.parseInt(val22);
					
					
					ins.setValue25	(String.valueOf(sum)); // 총금액    
					
					//임직원을 위한
					String com_emp_yn = "";
					if(String.valueOf(ht2.get("COM_EMP_YN")).equals("가입")){
						com_emp_yn = "Y";
					}else{
						com_emp_yn = "N";
					}
					ins.setValue26	(com_emp_yn); // 임직원     
					
					if(ins.getValue01().equals("null") && ins.getValue02().equals("null") && ins.getValue03().equals("null null") && ins.getValue04().equals("null") && ins.getValue05().equals("null")){
						result_value = "계약내용을 정상적으로 가져오지 못했습니다.";
					}else{
					
						if(!ic_db.insertInsExcelCom(ins)){
							flag += 1;
							result_value = "등록에러입니다.";
						}else{
							result_value = "등록완료";//ins_excel_com insert 성공
							
						}
					}
					
				
				
					if(result_value.equals("등록완료")){
						InsurExcelBean ins_e = ic_db.getInsExcelCom(reg_code, String.valueOf(count));
						
						//System.out.println("ins_e.getUse_st():"+ins_e.getUse_st());
						
						if(ins_e.getUse_st().equals("등록")){
							
							ins_e.setUse_st("요청");
							ins_e.setReq_id(ck_acar_id);
							if(!ic_db.updateInsExcelComUseSt(ins_e)){
								flag += 1;
								result_value = "요청에러입니다.";
							}else{
								result_value = "요청완료";
							}
						}
					}
					
					//System.out.println("result_value :"+result_value);
					
					if(result_value.equals("요청완료")){
						InsurExcelBean ins_r = ic_db.getInsExcelCom(reg_code, String.valueOf(count));
						
						if(ins_r.getUse_st().equals("요청")){
							
							ins_r.setUse_st("확인");
							ins_r.setReq_id(ck_acar_id);
							if(!ic_db.updateInsExcelComUseSt(ins_r)){
								flag += 1;
								result_value = "확인에러입니다.";
							}else{
								result_value = "확인완료";
							}
						}
					}
				
				} 
			}
		}
		
	if(count >0 && result_value.equals("확인완료")){
		//프로시저 호출
		String  d_flag1 =  ai_db.call_sp_ins_excel_new(reg_code);
		
		//System.out.println("d_flag1 : "+ d_flag1);
		
		if(d_flag1.equals("")){ //ins_excel insert 성공 후
			String act_code  = Long.toString(System.currentTimeMillis());
			
			if(!ic_db.updateInsExcelComActCode(reg_code, count, act_code)){
				flag += 1;
				result_value ="REG_CODE 수정시 에러가 발생했습니다";
			}else{
				
				//프로시저 호출
				 result_value  =  ic_db.call_sp_ins_excel_com_new(act_code, user_id);
				if(result_value.equals("")){
					result_value = "정상등록";
				}
				
			}
			
		}else{//ins_excel insert 실패 후
			result_value = "ins_excel insert 실패";
		}
		
	}
				//System.out.println("result_value :"+result_value);
	
	
	
	
			
				 
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>


<SCRIPT LANGUAGE="JavaScript">
		 if('<%=result_value%>'!= "정상등록"){
			<%-- alert('<%=result_value%>');  --%>
			// window.history.back();
		}else{
			/* alert('등록합니다. 잠시후 보험변경조회에서 등록 확인하세요.'); */
		//	window.close(); 
			
		}
</SCRIPT>
</BODY>
</HTML>