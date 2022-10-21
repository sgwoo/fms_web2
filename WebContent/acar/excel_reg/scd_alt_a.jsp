<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.debt.*, acar.cont.*"%>
<jsp:useBean id="a_db" scope="page" class="acar.cont.AddContDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.debt.DebtDatabase"/>
<jsp:useBean id="ex_db" scope="page" class="acar.mng_exp.GenExpDatabase"/>
<jsp:useBean id="af_db" scope="page" class="acar.fee.AddFeeDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//차량번호
	String value1[]  = request.getParameterValues("value1");//대출번호
	String value2[]  = request.getParameterValues("value2");//회차
	String value3[]  = request.getParameterValues("value3");//지출일자
	String value4[]  = request.getParameterValues("value4");//원금
	String value5[]  = request.getParameterValues("value5");//이자
	String value6[]  = request.getParameterValues("value6");//잔액
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
	
	String car_mng_id	= "";
	String rent_mng_id	= "";
	String rent_l_cd	= "";
	String car_no 		= "";
	String lend_no 		= "";
	String alt_tm 		= "";
	String alt_est_dt 	= "";
	int alt_prn 		= 0;
	int alt_int 		= 0;
	int rest_amt		= 0;
	
	int tot_alt_tm = 0;
	int alt_amt = 0;
	
	
	boolean flag = true;
	
	
	
	for(int i=start_row ; i < value_line ; i++){
	
		car_no 			= value0[i] ==null?"":AddUtil.replace(value0[i]," ","");
		lend_no 		= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");
		alt_tm 			= value2[i] ==null?"":String.valueOf(AddUtil.parseInt(AddUtil.replace(value2[i]," ","")));
		alt_est_dt		= value3[i] ==null?"":AddUtil.replace(AddUtil.replace(AddUtil.replace(value3[i],"-","")," ",""),"/","");
		alt_prn			= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value4[i],"_","")," ",""));
		alt_int			= value5[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value5[i],"_","")," ",""));
		rest_amt		= value6[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(AddUtil.replace(value6[i],"_","")," ",""));
		
		//차량번호로 차량관리번호 가져오기------------------------------------------
		
		Hashtable ht = ex_db.getCarMngID(car_no, lend_no);
		
		car_mng_id 	= String.valueOf(ht.get("CAR_MNG_ID"))==null?"":String.valueOf(ht.get("CAR_MNG_ID"));
		rent_mng_id 	= String.valueOf(ht.get("RENT_MNG_ID"));
		rent_l_cd 	= String.valueOf(ht.get("RENT_L_CD"));
		
		if(!car_mng_id.equals("") && !String.valueOf(ht.get("CAR_MNG_ID")).equals("null")){
			
			//1. 1회차납입일,1회차납입금액 셋팅
			if(alt_tm.equals("1")){
				ContDebtBean c_debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
				c_debt.setCar_mng_id	(car_mng_id);
				c_debt.setFst_pay_dt	(alt_est_dt);
				c_debt.setFst_pay_amt	(alt_prn+alt_int);
				flag = a_db.updateContDebt(c_debt);
			}				
			
			//2. 스케줄등록
			if(flag){
								
				//상환스케줄정보
				DebtScdBean pay_scd = new DebtScdBean();
				pay_scd = d_db.getADebtScd(car_mng_id, alt_tm);
				
				if(pay_scd.getCar_mng_id().equals("")){
					
					pay_scd.setCar_mng_id		(car_mng_id);
					pay_scd.setAlt_tm		(alt_tm);
					pay_scd.setAlt_est_dt		(alt_est_dt);
					pay_scd.setR_alt_est_dt (af_db.getValidDt(pay_scd.getAlt_est_dt()));
					if(alt_tm.equals("0")){
						pay_scd.setAlt_prn	(0);
						pay_scd.setAlt_int	(0);
						pay_scd.setPay_yn	("1");
						pay_scd.setPay_dt	(pay_scd.getR_alt_est_dt());
					}else{
						pay_scd.setAlt_prn	(alt_prn);
						pay_scd.setAlt_int	(alt_int);
						pay_scd.setPay_yn	("0");
						pay_scd.setPay_dt	("");
					}
					pay_scd.setAlt_rest		(rest_amt);
					
					
					if ( !alt_tm.equals("99") ) {
						flag = d_db.insertDebtScd(pay_scd);
					} 
										
					if(flag){
						result[i] = "정상처리되었습니다.";
					}else{
						result[i] = "스케줄 등록시 오류";
					}
					
				}else{
//					result[i] = "이미 등록된 스케줄입니다.";
					
					pay_scd.setCar_mng_id	(car_mng_id);
					pay_scd.setAlt_tm		(alt_tm);
					pay_scd.setAlt_est_dt	(alt_est_dt);
					pay_scd.setR_alt_est_dt (af_db.getValidDt(pay_scd.getAlt_est_dt()));
					if(alt_tm.equals("0")){
						pay_scd.setAlt_prn	(0);
						pay_scd.setAlt_int	(0);
						pay_scd.setPay_yn	("1");
						pay_scd.setPay_dt	(pay_scd.getR_alt_est_dt());
					}else{
						pay_scd.setAlt_prn	(alt_prn);
						pay_scd.setAlt_int	(alt_int);
						pay_scd.setPay_yn	("0");
						pay_scd.setPay_dt	("");
					}
					pay_scd.setAlt_rest		(rest_amt);
					
					
					if ( !alt_tm.equals("99") ) {
						flag = d_db.updateDebtScd(pay_scd);
					}
					
					if(flag){
						result[i] = "정상처리되었습니다.";
					}else{
						result[i] = "스케줄 등록시 오류";
					}
				}				
				
			}else{
				result[i] = "1회차납입정보 등록시 오류";
			}
			
		   	//3. 이자총금액  셋팅
			if(alt_tm.equals("99")){
				ContDebtBean c_debt = a_db.getContDebt(rent_mng_id, rent_l_cd);
				
				tot_alt_tm = AddUtil.parseInt(c_debt.getTot_alt_tm());				
				alt_amt = (alt_prn+alt_int) / tot_alt_tm ;
				
			//	System.out.println("tot_alt_tm="+tot_alt_tm);
			//	System.out.println("alt_amt="+alt_amt);
				c_debt.setCar_mng_id	(car_mng_id);
				c_debt.setLend_prn	(alt_prn);
				c_debt.setLend_int_amt	(alt_int);
				c_debt.setRtn_tot_amt	(alt_prn+alt_int);
			//	c_debt.setLend_no	(lend_no);		
				c_debt.setAlt_amt (alt_amt);
				
				flag = a_db.updateContDebt(c_debt);
			}
						
		}else{
			result[i] = "자동차관리번호를 조회할 수 없습니다.";
		}
		
		flag = true;
		
		/*
		out.println("0");out.println(car_mng_id);out.println("<br>");
		out.println("1");out.println(car_no);out.println("<br>");
		out.println("2");out.println(alt_tm);out.println("<br>");
		out.println("3");out.println(alt_est_dt);out.println("<br>");
		out.println("4");out.println(alt_prn);out.println("<br>");
		out.println("5");out.println(alt_int);out.println("<br>");
		out.println("6");out.println(rest_amt);out.println("<br>");
		out.println("=============================================");out.println("<br>");
		*/
	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	
	int ment_cnt=0;
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
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리되었습니다.")) continue;
		ment_cnt++;%>
<input type='hidden' name='value0' value='<%=value0[i] ==null?"":value0[i]%>'>
<input type='hidden' name='value1' value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='value2' value='<%=value2[i] ==null?"":value2[i]%>'>
<input type='hidden' name='result' value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='ment_cnt' value='<%=ment_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>