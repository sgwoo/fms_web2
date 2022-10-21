<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.cus_reg.*, acar.customer.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	
	String dt1 		= request.getParameter("dt1")==null?"":request.getParameter("dt1");			//공통-예정일자
	String dt2 		= request.getParameter("dt2")==null?"":request.getParameter("dt2");			//공통-납부일자
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//접수일자
	String value1[]  = request.getParameterValues("value1");//차량번호
	String value2[]  = request.getParameterValues("value2");//차량명
	String value3[]  = request.getParameterValues("value3");//비고
	String value4[]  = request.getParameterValues("value4");//금액
	String value5[]  = request.getParameterValues("value5");//결재예정일

	
	String m1_no = "";  		//의뢰no
	String mng_id = ""; 		//관리자
	String car_mng_id  = ""; 
	String rent_l_cd 	= "";
	String m1_dt = "";  		//의뢰일
	String m1_chk = "4";  		//의뢰구분 //엑셀로 등록
	String che_nm = "" ;
	String  off_id = "";
	
	//3:성수자동차,  6: 미스터박대리(차비서),  2:담당자직접 
	if ( gubun1.equals("1")  ) {
		che_nm = 	 "정일현대"; //검사소
		m1_chk = "4";
		off_id = "000286";
	} else if (gubun1.equals("2") ) {
		che_nm = 	 "협신자동차"; //검사소
		m1_chk = "7";
		off_id = "010097";
	} else if (gubun1.equals("3") ) {
		che_nm = 	 "성서현대정비"; //검사소
		m1_chk = "8";
		off_id = "008462";
	} else {
		che_nm = 	 "영등포자동차검사소"; //검사소
		m1_chk = "9";
		off_id = "011827";
	}
	
	String reg_dt = ""; 		//등록일
	String che_dt = "";  		//검사일
	String che_type = ""; 		//검사종류
	int che_amt = 0;  		//검사금액
	String req_dt = "";   		//청구일
	String car_no = "";			//차량번호
	String c_no = "";
	String vid_num = "";
	
	boolean flag = true;
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		
		car_no 	= value1[i] ==null?"":value1[i];
		c_no 	= value1[i] ==null?"":value1[i];
	//	c_no		= car_no.substring(car_no.length()-4, car_no.length());
		
	//	m1_no = value0[i] ==null?"":value0[i] + c_no;
//	System.out.println("c_no= " +c_no);
//	System.out.println("m1_no= " +m1_no);
	

		che_dt			= value0[i] ==null?"":value0[i]; //일자
		che_type		= value3[i] ==null?"":value3[i];	//항목
		che_amt			= value4[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value4[i],"_ ","")); 	//금액
		req_dt			= value5[i] ==null?"":value5[i];	//결재예정일
		car_no			= value1[i] ==null?"":AddUtil.replace(value1[i]," ","");	//차량번호

		CarMaintReqBean cmrb = new CarMaintReqBean();
		
		
		Hashtable ht = mc_db.speed_Serach(car_no, che_dt);
		
		
		m1_dt 			= cr_db.getMaster_dt(String.valueOf(ht.get("CAR_MNG_ID")));
		

		//등록
		cmrb.setM1_no		(m1_no);
		cmrb.setM1_dt		(m1_dt);
		cmrb.setM1_chk		(m1_chk);
		cmrb.setChe_dt		(che_dt);
		cmrb.setChe_type	(che_type);
		cmrb.setChe_amt		(che_amt);
		cmrb.setChe_nm		(che_nm);
		cmrb.setReq_dt		(req_dt);
		cmrb.setM1_content(c_no);
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));
		cmrb.setMng_id		(String.valueOf(ht.get("MNG_ID")));
		cmrb.setOff_id		(off_id);
/*
		System.out.println("<br>");
		System.out.println(car_no+"<br>");
		System.out.println(car_mng_id);
		System.out.println(rent_mng_id);
		System.out.println(rent_l_cd);
*/
		if(mc_db.insertHj_car(cmrb)){
			//등록정상
			result[i] = "정상처리되었습니다.";
		}else{
			//등록에러
			result[i] = "등록중 오류 발생";
		}				

	}
	
	String ment = "";
	for(int i=start_row ; i < value_line ; i++){
		if(!result[i].equals("")) ment += result[i]+"";
	}
	int result_cnt = 0;
	
		
	System.out.println(che_nm);
	System.out.println(m1_chk);
	System.out.println(off_id);
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
<form action="master_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리되었습니다.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='car_no'     value='<%=value1[i] ==null?"":value1[i]%>'>
<input type='hidden' name='result'     value='<%=result[i]%>'>
<%	}%>
<input type='hidden' name='result_cnt' value='<%=result_cnt%>'>
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
		document.form1.submit();			
//-->
</SCRIPT>
</BODY>
</HTML>