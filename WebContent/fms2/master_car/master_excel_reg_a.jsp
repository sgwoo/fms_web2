<%@page import="com.sun.org.apache.bcel.internal.generic.NEW"%>
<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String dt1 = request.getParameter("dt1")==null?"":request.getParameter("dt1");			//공통-예정일자
	String dt2 = request.getParameter("dt2")==null?"":request.getParameter("dt2");			//공통-납부일자
	
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");
	String value1[]  = request.getParameterValues("value1");
	String value2[]  = request.getParameterValues("value2");
	String value3[]  = request.getParameterValues("value3");
	String value4[]  = request.getParameterValues("value4");
	String value5[]  = request.getParameterValues("value5");
	String value6[]  = request.getParameterValues("value6");
	String value7[]  = request.getParameterValues("value7");
	String value8[]  = request.getParameterValues("value8");
	String value9[]  = request.getParameterValues("value9");
	String value10[] = request.getParameterValues("value10");
	String value11[] = request.getParameterValues("value11");
	String value12[] = request.getParameterValues("value12");
	String value13[] = request.getParameterValues("value13");
	
	/*
	String value14[] = request.getParameterValues("value14");
	String value15[] = request.getParameterValues("value15");
	String value16[] = request.getParameterValues("value16");
	String value17[] = request.getParameterValues("value17");
	String value18[] = request.getParameterValues("value18");
	String value19[] = request.getParameterValues("value19");
	*/
	
	String car_mng_id 	= "";
	long    js_seq 		=  0;
	String js_dt 		= "";
	String js_tm 		= "";
	String rent_mng_id 	= "";
	String rent_l_cd 	= "";
	String rent_s_cd	= "";
	String bus_id		= "";
	String sbshm 		= "";
	String gmjm 		= "";
	String ggm 			= "";
	String car_no 		= "";
	String sigg 		= "";
	String m_tel 		= "";
	int sbgb_amt 		=  0;
	String ssssny 		= "";
	String jcssny 		= "";
	String jsbb 		= "";
	String gjyj_dt 		= "";
	String gj_dt 		= "";
	
	String s_js_seq = "";	
	
	boolean flag = true;
		
	for (int i = start_row ; i < value_line ; i++) {
		
		js_dt			= value0[i] ==null?"":value0[i];
		s_js_seq		= value1[i] ==null?"":value1[i];
		js_tm			= value2[i] ==null?"":value2[i];
		sbshm			= value3[i] ==null?"":value3[i];
		gmjm			= value4[i] ==null?"":value4[i];
		ggm				= value5[i] ==null?"":value5[i];
		car_no 			= value6[i] ==null?"":value6[i];
		sigg			= value7[i] ==null?"":value7[i];
		m_tel			= value8[i] ==null?"":value8[i];
		sbgb_amt		= value9[i] ==null?0: AddUtil.parseDigit(AddUtil.replace(value9[i],"_ ",""));
		ssssny			= value10[i] ==null?"":value10[i];
		jcssny			= value11[i] ==null?"":value11[i];
		jsbb			= value12[i] ==null?"":value12[i];
		gjyj_dt			= value13[i] ==null?"":value13[i];

		/*
		gj_dt			= value14[i] ==null?"":value14[i];
		car_mng_id		= value15[i] ==null?"":value15[i];
		rent_mng_id		= value16[i] ==null?"":value16[i];
		rent_l_cd		= value17[i] ==null?"":value17[i];
		rent_s_cd		= value18[i] ==null?"":value18[i];
		bus_id			= value19[i] ==null?"":value19[i];
		*/
		
		if (!dt1.equals("")) {
			gjyj_dt = dt1;
		}
		
		if (!dt2.equals("")) {
			gj_dt = dt2;
		}
		
		
		Master_CarBean exp = new Master_CarBean();

		
		
		Hashtable ht = new Hashtable();
		
		/* if (gubun1.equals("7")) {
			ht = mc_db.getMaster_Car(car_no, js_dt, gjyj_dt);
		} else {
			ht = mc_db.getMaster_Car(car_no, gjyj_dt, js_dt);
		} */
		
		ht = mc_db.getMaster_Car(car_no, gjyj_dt, js_dt);
	
		
			
		js_seq = AddUtil.parseLong(s_js_seq);			

		//등록
		exp.setJs_seq		(js_seq);
		exp.setJs_dt		(js_dt);
		exp.setJs_tm		(js_tm);
		exp.setSbshm		(sbshm);
		exp.setGmjm			(gmjm);
		exp.setGgm			(ggm);
		exp.setCar_no		(car_no);
		exp.setSigg			(sigg);
		exp.setM_tel		(m_tel);
		exp.setSbgb_amt		(sbgb_amt);
		exp.setSsssny		(ssssny);
		exp.setJcssny		(jcssny);
		exp.setJsbb			(jsbb);
		exp.setGjyj_dt		(gjyj_dt);
		exp.setGj_dt		(gj_dt);
		exp.setTot_dist		(0);
		exp.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		exp.setRent_mng_id	(String.valueOf(ht.get("RENT_MNG_ID")));
		exp.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));
		exp.setRent_s_cd	(String.valueOf(ht.get("RENT_S_CD"))==null?"":String.valueOf(ht.get("RENT_S_CD")));
		exp.setBus_id		(String.valueOf(ht.get("USER_ID")));
		exp.setGubun(gubun1);
		
		/*		
		System.out.println("<br>");
		System.out.println("js_seq="+value1[i] ==null?"":value1[i]);
		System.out.println(car_no+"<br>");
		System.out.println("car_mng_id="+String.valueOf(ht.get("CAR_MNG_ID")));
		System.out.println("rent_mng_id="+String.valueOf(ht.get("RENT_MNG_ID")));
		System.out.println("rent_l_cd="+String.valueOf(ht.get("RENT_L_CD")));
		*/
		
		/* System.out.println("car_mng_id >>> " + String.valueOf(ht.get("CAR_MNG_ID")));
		System.out.println("setCar_mng_id >>> " + String.valueOf(exp.getCar_mng_id())); */

		if (mc_db.insertMaster_car(exp)) {
			//등록정상
			result[i] = "정상처리되었습니다.";
		} else {
			//등록에러
			result[i] = "등록중 오류 발생";
		}
	}
	
	String ment = "";
	
	for (int i = start_row ; i < value_line ; i++) {
		if (!result[i].equals("")) {
			ment += result[i] + "";
		}
	}
	
	int result_cnt = 0;
	
	//System.out.println("마스타자동차 긴급출동 등록");
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
</HEAD>
<BODY>
<p>엑셀 파일 읽어 등록하기
</p>
<form action="http://fms1.amazoncar.co.kr/fms2/master_car/master_excel_result.jsp" method='post' name="form1">
<input type='hidden' name='start_row' value='<%=start_row%>'>
<input type='hidden' name='value_line' value='<%=value_line%>'>
<%	for(int i=start_row ; i < value_line ; i++){
		if(result[i].equals("정상처리되었습니다.")) continue;
		result_cnt++;%>

<input type='hidden' name='car_no'     value='<%=value6[i] ==null?"":value6[i]%>'>
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