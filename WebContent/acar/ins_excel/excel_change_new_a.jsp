<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	String result[]   = new String[value_line];
	String value0[]  	= request.getParameterValues("value6");	//1 차량번호
	String value1[]  	= request.getParameterValues("value7");	//2 차명
	String value2[]  	= request.getParameterValues("value51");//3 상호명
	String value3[]  	= request.getParameterValues("value1");	//4 사업자번호
	String value4[]  	= request.getParameterValues("value1");	//5 대여개시일
	String value5[]  	= request.getParameterValues("value1");	//6 대여만료일
	String value6[]  	= request.getParameterValues("value1");	//7 변경전보험
	String value7[]  	= request.getParameterValues("value1");	//8 보험회사
	String value8[]  	= request.getParameterValues("value9");	//9 보험시작일
	String value9[]  	= request.getParameterValues("value9");	//10 보험만료일
	String value10[] 	= request.getParameterValues("value1");//11 변경후보험
	String value11[] 	= request.getParameterValues("value1");//12 영업자		
	String value12[] 	= request.getParameterValues("value29");//13 장기여부
	String value13[] 	= request.getParameterValues("value13");//14 변경항목
	String value14[] 	= request.getParameterValues("value14");//15 변경전
	String value15[] 	= request.getParameterValues("value15");//16 변경후
	String value16[] 	= request.getParameterValues("value33");//17 배서기준일20170123요청으로 수납일로 변경
	String value17[] 	= request.getParameterValues("value32");//18 추징보험료
	String value18[] 	= request.getParameterValues("value0"); //19 증권번호
	String value19[] 	= request.getParameterValues("value39");//20 대인배상Ⅰ
	String value20[] 	= request.getParameterValues("value40");//21 대인배상Ⅱ
	String value21[] 	= request.getParameterValues("value41");//22 대물배상
	String value22[] 	= request.getParameterValues("value42");//23 자기신체사고
	String value23[] 	= request.getParameterValues("value43");//24 무보험차상해
	String value24[] 	= request.getParameterValues("value49");//25 분담금할증한정
	String value25[] 	= request.getParameterValues("value44");//26 자기차량손해
	String value26[] 	= request.getParameterValues("value1");//27 애니카
	String value27[] 	= request.getParameterValues("value1");//28 총보험료
			
	
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
	String v24 ="";
	String v25 ="";
	String v26 ="";
	String v27 ="";
	String v28 ="";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();
	String chk_ins_no =" ";
	String chk_before_dt = AddUtil.getDate();
	String chk_after_dt = AddUtil.getDate();	
	int chk_current_dt = 0;
	
	chk_before_dt = c_db.addMonth(chk_before_dt, -1);
	chk_after_dt =  c_db.addMonth(chk_after_dt, 1); 
	
	chk_before_dt = AddUtil.ChangeString(chk_before_dt);
	chk_after_dt =  AddUtil.ChangeString(chk_after_dt); 
	
	for(int i=start_row ; i < value_line ; i++){
		
		
		
		flag = 0;
		count++;
		
		v1 		= value0[i]  ==null?"":value0[i];  //1 차량번호
		v2		= value1[i]  ==null?"":value1[i];  //2 차명
		v3		= value2[i]  ==null?"":AddUtil.replace(value2[i],"주식회사 아마존카","(주)아마존카");  //3 상호명
		v4		= value3[i]  ==null?"":AddUtil.replace(value3[i],"?","");  //4 사업자번호
		v5		= value4[i]  ==null?"":AddUtil.replace(value4[i],"?","");	 //5 대여개시일
		v6		= value5[i]  ==null?"":AddUtil.replace(value5[i],"?","");  //6 대여만료일
		v7		= value6[i]  ==null?"":AddUtil.replace(value6[i],"?","");  //7 변경전보험
		v8		= value7[i]  ==null?"":AddUtil.replace(value7[i],"?","");  //8 보험회사
		v9		= value8[i]  ==null?"":value8[i];  //9 보험시작일
		v9    = v9.substring(0,10);
		v9    = AddUtil.replace(v9,"/","");
		v10		= value9[i]  ==null?"":value9[i];  //10 보험만료일
		v10   = v10.substring(11,21);
		v10   = AddUtil.replace(v10,"/","");
		v11		= value10[i] ==null?"":value10[i];  //11 변경후보험
		v12		= value11[i] ==null?"":value11[i];  //12 영업자
		v13		= value12[i] ==null?"":value12[i];  //13 장기여부
		v14		= value13[i] ==null?"":value13[i];  //14 변경항목
		v15		= value14[i] ==null?"":value14[i];  //15 변경전
		v16		= value15[i] ==null?"":value15[i];  //16 변경후
		v17		= value16[i] ==null?"":AddUtil.replace(value16[i],"-","");  //17 배서기준일
		//v17   = v17.substring(0,10);
		v17   = AddUtil.replace(v17,"/","");
		v18		= value17[i] ==null?"":AddUtil.replace(value17[i],",","");  //18 추징보험료
		v19		= value18[i] ==null?"":value18[i];  //19 증권번호
		v20		= value19[i] ==null?"":AddUtil.replace(value19[i],",","");  //20 대인배상Ⅰ
		v21		= value20[i] ==null?"":AddUtil.replace(value20[i],",","");  //21 대인배상Ⅱ
		v22		= value21[i] ==null?"":AddUtil.replace(value21[i],",","");  //22 대물배상
		v23		= value22[i] ==null?"":AddUtil.replace(value22[i],",","");  //23 자기신체사고
		v24		= value23[i] ==null?"":AddUtil.replace(value23[i],",","");  //24 무보험차상해
		v25		= value24[i] ==null?"":AddUtil.replace(value24[i],",","");  //25 분담금할증한정
		v26		= value25[i] ==null?"":value25[i];  //26 자기차량손해
		v27		= value26[i] ==null?"":value26[i];  //27 애니카
		v28		= value27[i] ==null?"":AddUtil.replace(value27[i],",","");  //28 총보험료
		
		
		
		
		if( v14.equals("연령한정특약") ||  v14.equals("임직원운전자") ||  v14.equals("블랙박스") ||  v14.equals("대물배상") || v14.equals("임차인")){
		
					//중복입력 체크-----------------------------------------------------
					int over_cnt = ai_db.getCheckOverIns(v19, v18, v17, v14);
					int over_cnt2 = 0;
					chk_current_dt = AddUtil.getDate2(0) ;
					int  v17_m  = AddUtil.parseInt(v17.substring(0,6));
					
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
						out.println("<중복입력확인필요>차량번호: "+v1+", 증권번호: "+v19+ ", 변경항목: " +v14 +" <br>");
					}
					if(over_cnt2 != 0){
						out.println("<배서기준일 확인필요>차량번호: "+v1+", 증권번호: "+v19+ ", 변경항목: " +v14+", 배서기준일: "+v17+" <br>");
					}
					System.out.println(v1);		
					System.out.println(v9);		
					System.out.println(v10);		
					System.out.println(over_cnt);		
					System.out.println(over_cnt2);		
					if(!v1.equals("") && !v9.equals("") && !v10.equals("")  && over_cnt == 0  && over_cnt2 == 0){
						
						
						
						System.out.println(reg_code);
						
						InsurExcelBean ins = new InsurExcelBean();
									
						ins.setReg_code	(reg_code);
						ins.setSeq	(count);
						ins.setReg_id	(ck_acar_id);
						ins.setGubun	("9");
						
						ins.setValue01	(v1);//1 차량번호
						String ch_est_dt = c_db.addMonth(v17, 1);
							ch_est_dt = ch_est_dt.substring(0,8)+"10";
						ins.setValue02	(ai_db.getValidDt(ch_est_dt));//2 차명
						ins.setValue03	(v3);//3 상호명
						ins.setValue04	(v4);//4 사업자번호	
						ins.setValue05	(v5);//5 대여개시일	
						
						ins.setValue06	(v6);//6 대여만료일
						ins.setValue07	(v7);//7 변경전보험
						ins.setValue08	(v8);//8 보험회사	
						ins.setValue09	(v9);//9 보험시작일	
						ins.setValue10	(v10);//10 보험만료일	
						
						ins.setValue11	(v11);//11 변경후보험	
						ins.setValue12	(v12);//12 영업자	
						ins.setValue13	(v13);//13 미가입승인	
						ins.setValue14	(v14);//14 변경항목	
						ins.setValue15	(v15);//15 변경전	
						
						ins.setValue16	(v16);//16 변경후
						ins.setValue17	(v17);//17 배서기준일
						ins.setValue18	(v18);//18 추징보험료
						ins.setValue19	(v19);//19 증권번호
						ins.setValue20	(v20);//20 대인배상Ⅰ
						
						ins.setValue21	(v21);//21 대인배상Ⅱ
						ins.setValue22	(v22);//22 대물배상
						ins.setValue23	(v23);//23 자기신체사고
						ins.setValue24	(v24);//24 무보험차상해
						ins.setValue25	(v25);//25 분담금할증한정
						
						ins.setValue26	(v26);//26 자기차량손해
						ins.setValue27	(v27);//27 애니카	
						ins.setValue28	(v28);//28 총보험료
						
						System.out.println("v3:"+v3);
						System.out.println("v4:"+v4);
						System.out.println("v5:"+v5);
						System.out.println("v6:"+v6);
						System.out.println("v7:"+v7);
						System.out.println("v8:"+v8);
						System.out.println("v9:"+v9);
						System.out.println("v10:"+v10);
						System.out.println("v11:"+v11);
						System.out.println("v12:"+v12);
						System.out.println("v13:"+v13);
						System.out.println("v14:"+v14);
						System.out.println("v15:"+v15);
						System.out.println("v16:"+v16);
						System.out.println("v17:"+v17);
						System.out.println("v18:"+v18);
						System.out.println("v19:"+v19);
						System.out.println("v20:"+v20);
						System.out.println("v21:"+v21);
						System.out.println("v22:"+v22);
						System.out.println("v23:"+v23);
						System.out.println("v24:"+v24);
						System.out.println("v25:"+v25);
						System.out.println("v26:"+v26);
						System.out.println("v27:"+v27);
						System.out.println("v28:"+v28); 
					
						
						
						
						if(chk_ins_no.equals(v19)){
							ins.setValue04	("re");//4 사업자번호	
							//out.println("<체크> "+chk_ins_no+"vs"+v19+"="+chk_ins_no.equals(v19) );
						}else{
							//out.println("<체크> "+chk_ins_no+"vs"+v19+"="+chk_ins_no.equals(v19) );
							chk_ins_no = v19;
						}
						
						if(!ai_db.insertInsExcel2(ins))	flag += 1;
						
						//if(1==1)return;
								
					}
		}
	}
	
	if(count >0){
		String  d_flag1 =  ai_db.call_sp_ins_excel_change_new(reg_code);
	}

	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 보험 등록하기
</p>

<SCRIPT LANGUAGE="JavaScript">
<!--		
		alert('등록합니다. 잠시후 보험변경조회에서 등록 확인하세요.');
		window.close(); 
//-->
</SCRIPT>
</BODY>
</HTML>