<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	CommonDataBase c_db = CommonDataBase.getInstance();
	InsDatabase ai_db = InsDatabase.getInstance();


	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line);
	out.println("<br>");
	
	String ins_est_dt = request.getParameter("ins_est_dt")==null?"":request.getParameter("ins_est_dt");//공통-환급예정일
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//차량번호
	String value1[]  = request.getParameterValues("value1");//증권번호
	String value2[]  = request.getParameterValues("value2");//차종
	String value3[]  = request.getParameterValues("value3");//사유발생일자
	String value4[]  = request.getParameterValues("value4");//내용
	String value5[]  = request.getParameterValues("value5");//목적
	String value6[]  = request.getParameterValues("value6");//청구승계일자
	String value7[]  = request.getParameterValues("value7");//환급금액
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
	
	String reg_code  = Long.toString(System.currentTimeMillis());
	
	int count = 0;
	String v1 ="";
	String v2 ="";
	String v3 ="";
	String v4 ="";
	String v5 ="";
	String v6 ="";
	String v7 ="";
	String v8 ="";	
	
	int flag = 0;
	
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
		
		v1 		= value0[i]  ==null?"":value0[i]; //차량번호
		v2		= value1[i]  ==null?"":value1[i]; //증권번호
		v3		= value2[i]  ==null?"":value2[i]; //차종
		v4		= value3[i]  ==null?"":AddUtil.replace(value3[i],"-",""); //사유발생일자
		v5		= value4[i]  ==null?"":value4[i]; //내용
		v6		= value5[i]  ==null?"":value5[i]; //목적
		v7		= value6[i]  ==null?"":AddUtil.replace(value6[i],"-",""); //청구승계일자
		v8		= value7[i]  ==null?"":value7[i]; //환급금액
		
		
		//중복입력 체크-----------------------------------------------------
		int over_cnt = ai_db.getCheckOverIns(v2);
		int over_cnt2 = 0;
		chk_current_dt = AddUtil.getDate2(0) ;
		int  v17_m  = AddUtil.parseInt(v7.substring(0,6));
		
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
			out.println("<중복입력확인필요>차량번호: "+v1+", 증권번호: "+v2+" <br>");
		}
		if(over_cnt2 != 0){
			out.println("<청구승계일 확인필요>차량번호: "+v1+", 증권번호: "+v2+", 청구승계일자: "+v7+" <br>");
		}
						
		
						
		if(!v2.equals("") && !v7.equals("") && !v8.equals("")  && over_cnt == 0  && over_cnt2 == 0){
					
			InsurExcelBean ins = new InsurExcelBean();
						
			ins.setReg_code	(reg_code);
			ins.setSeq	(count);
			ins.setReg_id	(ck_acar_id);
			ins.setGubun	("8");
			
			ins.setValue01	(v1);//1 차량번호
			ins.setValue02	(v2);//2  증권번호
			ins.setValue03	(v3);//3 차종
			ins.setValue04	(v4);//4 사유발생일자	
			ins.setValue05	(v5);//5 내용	
			
			ins.setValue06	(v6);//6 목적
			ins.setValue07	(v7);//7 청구승계일자
			ins.setValue08	(v8);//8 환급금액	
			ins.setValue09	(ai_db.getValidDt(v7));//9 날짜1	
			ins.setValue10	(ai_db.getValidDt((c_db.addMonth(v7, 1)).substring(0,8)+"10"));//9 날짜2	
			
			if(!ai_db.insertInsExcel2(ins))	flag += 1;
			
			//if(1==1)return;
					
		}
	}
	
	if(count >0){
		String  d_flag1 =  ai_db.call_sp_ins_excel_cls(reg_code);
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
		alert('등록합니다. 잠시후 보험해지조회에서 등록 확인하세요.');
		window.close(); 
//-->
</SCRIPT>
</BODY>
</HTML>