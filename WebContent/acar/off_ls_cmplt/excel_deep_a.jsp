<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.offls_sui.*, acar.user_mng.*"%>
<jsp:useBean id="olsD" class="acar.offls_sui.Offls_suiDatabase" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	
	
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String result[]  = new String[value_line];
	
	String value0[]  = request.getParameterValues("value0");//A  	// 차량번호 
	String value1[]  = request.getParameterValues("value1");//B  	// 경매일자
	String value2[]  = request.getParameterValues("value2");//C		// 예측낙찰가 DEEP_CAR_AMT1
	String value3[]  = request.getParameterValues("value3");//D  	// 예측낙찰가(해당연월 반영,해당차량 미반영) DEEP_CAR_AMT2
	String value4[]  = request.getParameterValues("value4");//I		// 예측낙찰가(해당연월 반영,해당차량 반영) DEEP_CAR_AMT8
	String value5[]  = request.getParameterValues("value5");//E  	// 예측낙찰가(분당) DEEP_CAR_AMT3
	String value6[]  = request.getParameterValues("value6");//F  	// 예측낙찰가(시화) DEEP_CAR_AMT4
	String value7[]  = request.getParameterValues("value7");//G		// 예측낙찰가(양산) DEEP_CAR_AMT5
	String value8[]  = request.getParameterValues("value8");//H		// 예측낙찰가(롯데) DEEP_CAR_AMT6
	String value9[]  = request.getParameterValues("value9");//I		// 예측낙찰가(AJ)  DEEP_CAR_AMT7
	

	int count = 0;
	
	String car_no = "";
	String actn_dt = "";
	String car_mng_id = "";
	String seq = "";
	
	for(int i=start_row ; i < value_line ; i++){
	
		car_no 		= value0[i] ==null?"":value0[i].trim();
		actn_dt		= value1[i] ==null?"":value1[i].trim(); 
		
		//out.println(car_no+" "+actn_dt+" - ");
		
		Hashtable ht = olsD.getAuctionDeepCar(car_no, actn_dt);
		
		car_mng_id = ht.get("CAR_MNG_ID")+"";
		seq = ht.get("SEQ")+"";
		
		//update [auction] 
				
		int a_amt1 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT1")+"");
		int a_amt2 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT2")+"");
		int a_amt3 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT3")+"");
		int a_amt4 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT4")+"");
		int a_amt5 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT5")+"");
		int a_amt6 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT6")+"");
		int a_amt7 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT7")+"");
		int a_amt8 = AddUtil.parseDigit(ht.get("DEEP_CAR_AMT8")+"");
		
		int b_amt1 = value2[i]==null?0:AddUtil.parseDigit(value2[i]);				
		int b_amt2 = value3[i]==null?0:AddUtil.parseDigit(value3[i]);
		int b_amt8 = value9[i]==null?0:AddUtil.parseDigit(value4[i]);//추가
		int b_amt3 = value4[i]==null?0:AddUtil.parseDigit(value5[i]);
		int b_amt4 = value5[i]==null?0:AddUtil.parseDigit(value6[i]);
		int b_amt5 = value6[i]==null?0:AddUtil.parseDigit(value7[i]);
		int b_amt6 = value7[i]==null?0:AddUtil.parseDigit(value8[i]);
		int b_amt7 = value8[i]==null?0:AddUtil.parseDigit(value9[i]);
		
		
		if(!car_mng_id.equals("")){
			if(a_amt1 != b_amt1 || a_amt2 != b_amt2 || a_amt3 != b_amt3 || a_amt4 != b_amt4 || a_amt5 != b_amt5 || a_amt6 != b_amt6 || a_amt7 != b_amt7 || a_amt8 != b_amt8){
				int f_result = olsD.updateDeepCarAmt(car_mng_id, seq, b_amt1, b_amt2, b_amt3, b_amt4, b_amt5, b_amt6, b_amt7, b_amt8);
				count++;
				result[i] = "금액 변동 정상 처리";
			}else{
				result[i] = "금액 변동 없음.";
			}
		}else{
			result[i] = "해당차량 찾을수 없음";
		}
		
		//out.println(car_mng_id+" "+seq+" "+a_amt1+" "+b_amt1+" "+a_amt2+" "+a_amt2+"<br>");
		
	}
	
	
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 내역서 등록하기
</p>
<form action="excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){%>
<input type='hidden' name='car_no'     value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
	document.form1.submit();
//-->
</SCRIPT>
</BODY>
</HTML>