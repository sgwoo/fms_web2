<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*, acar.bill_mng.*, acar.user_mng.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 증권번호
	String value1[]  	= request.getParameterValues("value1");	//2 차량번호
	String value2[]  	= request.getParameterValues("value2");	//3 대인배상Ⅰ
	String value3[]  	= request.getParameterValues("value3");	//4 대인배상Ⅱ
	String value4[]  	= request.getParameterValues("value4");	//5 대물배상
	String value5[]  	= request.getParameterValues("value5");	//6 자기신체사고
	String value6[]  	= request.getParameterValues("value6");	//7 무보험차상해
	String value7[]  	= request.getParameterValues("value7");	//8 분담금할증한정
	String value8[]  	= request.getParameterValues("value8");	//9 총보험료
	String value9[]  	= request.getParameterValues("value9");	//10 수납일자
	String value10[] 	= request.getParameterValues("value10");//11 
	String value11[] 	= request.getParameterValues("value11");//12 
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	
	String ins_con_no 	= "";
	String car_no 		= "";
	int    ins_amt1 	= 0;
	int    ins_amt2 	= 0;
	int    ins_amt3 	= 0;
	int    ins_amt4 	= 0;
	int    ins_amt5 	= 0;
	int    ins_amt6 	= 0;
	int    ins_amt7 	= 0;
	int    ins_amt8 	= 0;
	int    tot_amt 		= 0;
	int    pay_tm 		= 1;
	int    f_amt 		= 0;
	String ins_rent_dt	= "";
	
	int flag = 0;
	
	InsDatabase ai_db = InsDatabase.getInstance();	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	UserMngDatabase umd = UserMngDatabase.getInstance();
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		
		ins_con_no 		= value0[i] ==null?"":AddUtil.replace(AddUtil.replace(value0[i]," ",""),"_ ","");
		car_no 			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		ins_amt1 		= value2[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value2[i],"_ ",""));
		ins_amt2 		= value3[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value3[i],"_ ",""));
		ins_amt3 		= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ",""));
		ins_amt4 		= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value5[i],"_ ",""));
		ins_amt5 		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value6[i],"_ ",""));
		ins_amt8 		= value7[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value7[i],"_ ",""));
		tot_amt 		= value8[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value8[i],"_ ",""));
		ins_rent_dt		= value9[i] ==null?"":AddUtil.replace(value9[i]," ","");
		

		
		//최근보험 조회-------------------------------------------------
		InsurBean now_ins = ai_db.getInsConNoExcelCase(ins_con_no, car_no);

		InsurBean ins = ai_db.getInsCase(now_ins.getCar_mng_id(), now_ins.getIns_st());
								
		out.println("car_no="+car_no);
		out.println("ins_con_no="+ins_con_no);
		out.println("ins.getCar_mng_id()="+ins.getCar_mng_id());
		out.println("ins.getIns_rent_dt()="+ins.getIns_rent_dt());
		
		//if(1==1)return;
		
		
			

		if(!ins.getCar_mng_id().equals("") && ins.getIns_rent_dt().equals(ins_rent_dt)){
			
			//보험갱신 수정-------------------------------------------------
			ins.setRins_pcp_amt		(ins_amt1);//대인배상1 rins_pcp_amt+vins_pcp_amt+vins_gcp_amt+vins_bacdt_amt+vins_canoisr_amt+vins_cacdt_cm_amt+vins_spe_amt
			ins.setVins_pcp_amt		(ins_amt2);//대인배상2
			ins.setVins_gcp_amt		(ins_amt3);//대물배상
			ins.setVins_bacdt_amt		(ins_amt4);//자기신체사고
			ins.setVins_canoisr_amt		(ins_amt5);//무보험차상해
			ins.setVins_share_extra_amt	(ins_amt8);//분담금할증한정
				
			if(!ai_db.updateIns(ins))	flag += 1;
				

			//보험갱신 스케줄 등록------------------------------------------
			InsurScdBean scd = ai_db.getInsScd(ins.getCar_mng_id(), ins.getIns_st(), "1");
			scd.setPay_amt		(tot_amt);
				
			if(!ai_db.updateInsScd(scd)) flag += 1;
			
			//기간비용 기등록분 삭제
			PrecostBean cost = ai_db.getInsurPrecostCase("2", ins.getCar_mng_id(), ins.getIns_st(), ins.getIns_rent_dt());
			if(!ai_db.deleteNextPrecostCase(cost)) flag += 1;
			
					
							
						//자동전표처리용
						Vector vt = new Vector();
						int line = 0;
						int count =0;
						String acct_cont = "";
						String acct_code = "";
			
						UsersBean user_bean 	= umd.getUsersBean(ck_acar_id);
						Hashtable per = neoe_db.getPerinfoDept(user_bean.getUser_nm());
						String insert_id = String.valueOf(per.get("SA_CODE"));
						String dept_code = String.valueOf(per.get("DEPT_CODE"));
	
					
						//보험사
						Hashtable ins_com = ai_db.getInsCom(ins.getIns_com_id());
			
						//대여차량선급보험료
						if(ins.getCar_use().equals("1")){
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 영업용";
							acct_code = "13300";
						//리스차량선급보험료
						}else{
							acct_cont = String.valueOf(ins_com.get("INS_COM_NM"))+ " 업무용";
							acct_code = "13200";
						}
			
						if(ins.getIns_st().equals("0")) 			acct_cont = acct_cont+ " 신규 가입 ("+car_no+")";
						else  							acct_cont = acct_cont+ " 갱신 가입 ("+car_no+")";
			
						line++;
			
						//선급보험료
						Hashtable ht1 = new Hashtable();
						ht1.put("DATA_GUBUN", 	"53");
						ht1.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht1.put("DATA_NO",    	"");
						ht1.put("DATA_LINE",  	String.valueOf(line));
						ht1.put("DATA_SLIP",  	"1");
						ht1.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht1.put("NODE_CODE",  	"S101");
						ht1.put("C_CODE",     	"1000");
						ht1.put("DATA_CODE",  	"");
						ht1.put("DOCU_STAT",  	"0");
						ht1.put("DOCU_TYPE",  	"11");
						ht1.put("DOCU_GUBUN", 	"3");
						ht1.put("AMT_GUBUN",  	"3");//차변
						ht1.put("DR_AMT",    	tot_amt);
						ht1.put("CR_AMT",     	"0");
						ht1.put("ACCT_CODE",  	acct_code);
						ht1.put("CHECK_CODE1",	"A19");//전표번호
						ht1.put("CHECK_CODE2",	"A07");//거래처
						ht1.put("CHECK_CODE3",	"A05");//표준적요
						ht1.put("CHECK_CODE4",	"");
						ht1.put("CHECK_CODE5",	"");
						ht1.put("CHECK_CODE6",	"");
						ht1.put("CHECK_CODE7",	"");
						ht1.put("CHECK_CODE8",	"");
						ht1.put("CHECK_CODE9",	"");
						ht1.put("CHECK_CODE10",	"");
						ht1.put("CHECKD_CODE1",	"");//전표번호
						ht1.put("CHECKD_CODE2",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
						ht1.put("CHECKD_CODE3",	"");//표준적요
						ht1.put("CHECKD_CODE4",	"");
						ht1.put("CHECKD_CODE5",	"");
						ht1.put("CHECKD_CODE6",	"");
						ht1.put("CHECKD_CODE7",	"");
						ht1.put("CHECKD_CODE8",	"");
						ht1.put("CHECKD_CODE9",	"");
						ht1.put("CHECKD_CODE10","");
						ht1.put("CHECKD_NAME1",	"");//전표번호
						ht1.put("CHECKD_NAME2",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
						ht1.put("CHECKD_NAME3",	acct_cont);//표준적요
						ht1.put("CHECKD_NAME4",	"");
						ht1.put("CHECKD_NAME5",	"");
						ht1.put("CHECKD_NAME6",	"");
						ht1.put("CHECKD_NAME7",	"");
						ht1.put("CHECKD_NAME8",	"");
						ht1.put("CHECKD_NAME9",	"");
						ht1.put("CHECKD_NAME10","");
						ht1.put("INSERT_ID",	insert_id);
			
						line++;
			
						//미지급금
						Hashtable ht2 = new Hashtable();
						ht2.put("DATA_GUBUN", 	"53");
						ht2.put("WRITE_DATE", 	ins.getIns_rent_dt());
						ht2.put("DATA_NO",    	"");
						ht2.put("DATA_LINE",  	String.valueOf(line));
						ht2.put("DATA_SLIP",  	"1");
						ht2.put("DEPT_CODE",  	String.valueOf(per.get("DEPT_CODE")));
						ht2.put("NODE_CODE",  	"S101");
						ht2.put("C_CODE",     	"1000");
						ht2.put("DATA_CODE",  	"");
						ht2.put("DOCU_STAT",  	"0");
						ht2.put("DOCU_TYPE",  	"11");
						ht2.put("DOCU_GUBUN", 	"3");
						ht2.put("AMT_GUBUN",  	"4");//대변
						ht2.put("DR_AMT",    	"0");
						ht2.put("CR_AMT",     	tot_amt);
						ht2.put("ACCT_CODE",  	"25300");
						ht2.put("CHECK_CODE1",	"A07");//거래처
						ht2.put("CHECK_CODE2",	"A19");//전표번호
						ht2.put("CHECK_CODE3",	"F47");//신용카드번호
						ht2.put("CHECK_CODE4",	"A13");//project
						ht2.put("CHECK_CODE5",	"A05");//표준적요
						ht2.put("CHECK_CODE6",	"");
						ht2.put("CHECK_CODE7",	"");
						ht2.put("CHECK_CODE8",	"");
						ht2.put("CHECK_CODE9",	"");
						ht2.put("CHECK_CODE10",	"");
						ht2.put("CHECKD_CODE1",	String.valueOf(ins_com.get("VEN_CODE")));//거래처
						ht2.put("CHECKD_CODE2",	"");//전표번호
						ht2.put("CHECKD_CODE3",	"");//신용카드번호
						ht2.put("CHECKD_CODE4",	"");//project
						ht2.put("CHECKD_CODE5",	"0");//표준적요
						ht2.put("CHECKD_CODE6",	"");
						ht2.put("CHECKD_CODE7",	"");
						ht2.put("CHECKD_CODE8",	"");
						ht2.put("CHECKD_CODE9",	"");
						ht2.put("CHECKD_CODE10","");
						ht2.put("CHECKD_NAME1",	String.valueOf(ins_com.get("VEN_NAME")));//거래처
						ht2.put("CHECKD_NAME2",	"");//전표번호
						ht2.put("CHECKD_NAME3",	"");//신용카드번호
						ht2.put("CHECKD_NAME4",	"");//project
						ht2.put("CHECKD_NAME5",	acct_cont);//표준적요
						ht2.put("CHECKD_NAME6",	"");
						ht2.put("CHECKD_NAME7",	"");
						ht2.put("CHECKD_NAME8",	"");
						ht2.put("CHECKD_NAME9",	"");
						ht2.put("CHECKD_NAME10","");
						ht2.put("INSERT_ID",	insert_id);
			
						vt.add(ht1);
						vt.add(ht2);
			
						if(line > 0 && vt.size() > 0){

				
							String row_id = neoe_db.insertDebtSettleAutoDocu(ins.getIns_rent_dt(), vt);	//-> neoe_db 변환
				
							if(row_id.equals("")){
								count = 1;
							}
						}
			result[i] = "보험 수정했습니다.";			

		}else{
			result[i] = "증권번호,차량번호,수납일자로 보험을 찾지 못했습니다.";			
		}					

		
		out.println("result="+result[i]);
		out.println("<br>");

	}
	
	if(1==1)return;	
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

<form action="excel_result.jsp" method='post' name="form1">
</form>

<SCRIPT LANGUAGE="JavaScript">
<!--		

//-->
</SCRIPT>
</BODY>
</HTML>