<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String ins_rent_dt 	= request.getParameter("ins_rent_dt")==null?"":request.getParameter("ins_rent_dt");	//공통-보험가입일
	String ins_start_dt 	= request.getParameter("ins_start_dt")==null?"":request.getParameter("ins_start_dt");	//공통-보험시작일
	String ins_end_dt 	= request.getParameter("ins_end_dt")==null?"":request.getParameter("ins_end_dt");	//공통-보험만료일
	String t_pay_est_dt 	= request.getParameter("t_pay_est_dt")==null?"":request.getParameter("t_pay_est_dt");	//공통-보험납일일
	String ins_com_id 	= request.getParameter("ins_com_id")==null?"":request.getParameter("ins_com_id");	//공통-보험사코드
	String gubun1 		= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 증권번호
	String value1[]  	= request.getParameterValues("value1");	//2 차량번호
	String value2[]  	= request.getParameterValues("value2");	//3 대인배상Ⅰ
	String value3[]  	= request.getParameterValues("value3");	//4 대인배상Ⅱ
	String value4[]  	= request.getParameterValues("value4");	//5 대물배상
	String value5[]  	= request.getParameterValues("value5");	//6 자기신체사고
	String value6[]  	= request.getParameterValues("value6");	//7 무보험차상해
	String value7[]  	= request.getParameterValues("value7");	//8 분담금할증한정
	String value8[]  	= request.getParameterValues("value8");	//9 자기차량손해
	String value9[]  	= request.getParameterValues("value9");	//10 애니카
	String value10[] 	= request.getParameterValues("value10");//11 총보험료
	String value11[] 	= request.getParameterValues("value11");//12 ⑫임직원전용자동차보험가입여부		
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	String ins_con_no 	= "";
	String car_no 		= "";
	String    ins_amt1 	= "";
	String    ins_amt2 	= "";
	String    ins_amt3 	= "";
	String    ins_amt4 	= "";
	String    ins_amt5 	= "";
	String    ins_amt6 	= "";
	String    ins_amt7 	= "";
	String    ins_amt8 	= "";	
	String    tot_amt 	= "";
	String com_emp_yn	= "";
	int flag = 0;
	int count = 0;
	
	
	InsDatabase ai_db = InsDatabase.getInstance();
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		flag = 0;
		count++;
		
		ins_con_no 		= value0[i] ==null?"": AddUtil.replace(AddUtil.replace(AddUtil.replace(value0[i],"_","")," ",""),"_ ","");
		car_no 			= value1[i] ==null?"": AddUtil.replace(value1[i]," ","");
		ins_amt1 		= value2[i] ==null?"0":AddUtil.replace(value2[i],"_ ","");
		ins_amt2 		= value3[i] ==null?"0":AddUtil.replace(value3[i],"_ ","");
		ins_amt3 		= value4[i] ==null?"0":AddUtil.replace(value4[i],"_ ","");
		ins_amt4 		= value5[i] ==null?"0":AddUtil.replace(value5[i],"_ ","");
		ins_amt5 		= value6[i] ==null?"0":AddUtil.replace(value6[i],"_ ","");
		ins_amt6 		= value7[i] ==null?"0":AddUtil.replace(value7[i],"_ ","");
		ins_amt7 		= value8[i] ==null?"0":AddUtil.replace(value8[i],"_ ","");
		ins_amt8 		= value9[i] ==null?"0":AddUtil.replace(value9[i],"_ ","");
		tot_amt 		= value10[i] ==null?"0":AddUtil.replace(value10[i],"_ ","");
		com_emp_yn		= value11[i] ==null?"":AddUtil.replace(value11[i]," ","");
						
		if(!ins_con_no.equals("") && !car_no.equals("") && !tot_amt.equals("0")  ){
					
			InsurExcelBean ins = new InsurExcelBean();
						
			ins.setReg_code	(reg_code);
			ins.setSeq	(count);
			ins.setReg_id	(ck_acar_id);
			ins.setGubun	(gubun1);
			
			ins.setValue01	(ins_rent_dt);
			ins.setValue02	(ins_start_dt);
			ins.setValue03	(ins_end_dt);	
			ins.setValue04	(t_pay_est_dt);	
			ins.setValue05	(ins_com_id);	
			
			ins.setValue06	(ins_con_no);
			ins.setValue07	(car_no);
			ins.setValue08	(ins_amt1);	//대인배상1
			ins.setValue09	(ins_amt2);	//대인배상2
			ins.setValue10	(ins_amt3);	//대물배상
			
			ins.setValue11	(ins_amt4);	//자기신체사고
			ins.setValue12	(ins_amt5);	//무보험차상해
			ins.setValue13	(ins_amt6);	//분담금할증한정
			ins.setValue14	(ins_amt7);	//자기차량손해
			ins.setValue15	(ins_amt8);	//애니카
			
			ins.setValue16	(tot_amt);
			ins.setValue17	(com_emp_yn);
				
			if(!ai_db.insertInsExcel(ins))	flag += 1;
			
			
			
			out.println("6="+ins.getValue06());
			out.println("7="+ins.getValue07());
			out.println("8="+ins.getValue08());
			out.println("9="+ins.getValue09());
			out.println("10="+ins.getValue10());
			out.println("11="+ins.getValue11());
			out.println("12="+ins.getValue12());
			out.println("13="+ins.getValue13());
			out.println("14="+ins.getValue14());
			out.println("15="+ins.getValue15());
			out.println("16="+ins.getValue16());
			
			//if(1==1)return;
					
		}
	}
	
	if(count >0){
		String  d_flag1 =  ai_db.call_sp_ins_excel(reg_code);
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
		alert('등록합니다. 잠시후 보험가입조회에서 등록 확인하세요.');
		window.close(); 
//-->
</SCRIPT>
</BODY>
</HTML>