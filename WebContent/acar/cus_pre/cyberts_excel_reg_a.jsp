<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	//순번	자동차등록번호	차대번호	성명/상호	차명	유효기간만료일	검사종류명
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//자동차등록번호번
	String value1[]  = request.getParameterValues("value1");//차대번호
	String value2[]  = request.getParameterValues("value2");//성명/상호
	String value3[]  = request.getParameterValues("value3");//차명
	String value4[]  = request.getParameterValues("value4");//유효기간만료일
	String value5[]  = request.getParameterValues("value5");//검사종류명
	String value6[]  = request.getParameterValues("value6");//차령만료일
	String value7[]  = request.getParameterValues("value7");//년식
	String value8[]  = request.getParameterValues("value8");//최초등록일

	String car_no = "";			//차량번호
	
	String vid_num = "";
	String che_1 = "";
	String che_2 = "";
	String che_3 = "";
	String che_4 = "";
	String che_5 = "";
	String che_6 = "";
	String che_7 = "";
	String che_8 = "";
			
	boolean flag = true;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	mc_db.deleteCyberts();
	
	for(int i=start_row ; i < value_line ; i++){
			
		car_no 	= value0[i] ==null?"":value0[i];  //차량번호
	
		che_1		= value1[i] ==null?"":value1[i]; 	//차대번호
		che_2		= value2[i] ==null?"":value2[i]; 	//성명/상호
		che_3		= value3[i] ==null?"":value3[i];	//차명
		che_4		= value4[i] ==null?"":value4[i];	//유효기간만료일
		che_5		= value5[i] ==null?"":value5[i];	//검사종류명
		che_6		= value6[i] ==null?"":value6[i];	//차령만료일
		che_7		= value7[i] ==null?"":value7[i];	//년식
		che_8		= value8[i] ==null?"":value8[i];	//최초등록일
	
		CarMaintReqBean cmrb = new CarMaintReqBean();
			
		Hashtable ht = mc_db.getCarMngID(car_no);  //계약번호
		
		//등록
		cmrb.setM1_no		(car_no);  //차량번호		
		cmrb.setChe_type	(che_5);	//검사종류명	 
		cmrb.setChe_nm		(che_3);  //차명
		cmrb.setReq_dt		(che_4); //유효기간만료일
		cmrb.setM1_content(che_1); //차대번호
		cmrb.setM1_dt(che_8);  //최초등록일
		cmrb.setJung_dt(che_6);  // 차령만료일
		cmrb.setGubun(che_7);  // 년식
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));	
/*
		System.out.println("<br>");
		System.out.println(car_no+"<br>");
		System.out.println(car_mng_id);	
		System.out.println(rent_l_cd);
*/
		if(mc_db.insertCyberts(cmrb)){
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
<form action="cyberts_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리되었습니다.")) continue;
		result_cnt++;%>
<input type='hidden' name='car_mng_id' value=''>
<input type='hidden' name='car_no'     value='<%=value0[i] ==null?"":value0[i]%>'>
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