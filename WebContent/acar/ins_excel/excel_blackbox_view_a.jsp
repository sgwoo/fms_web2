<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*"%>
<jsp:useBean id="t_db" scope="page" class="acar.tint.TintDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	out.println("start_row="+start_row);
	out.println("value_line="+value_line+"<br><br>");
	
	String result[]  = new String[value_line];
	String value0[]  	= request.getParameterValues("value0");	//1 no
	String value1[]  	= request.getParameterValues("value1");	//2 공제시기
	String value2[]  	= request.getParameterValues("value2");	//3 차량번호
	String value3[]  	= request.getParameterValues("value3");	//4 차명
	String value4[]  	= request.getParameterValues("value4");
	String value5[]  	= request.getParameterValues("value5");
	String value6[]  	= request.getParameterValues("value6");
	String value7[]  	= request.getParameterValues("value7");
	String value8[]  	= request.getParameterValues("value8");
	String value9[]  	= request.getParameterValues("value9");
	String value10[] 	= request.getParameterValues("value10");
	String value11[] 	= request.getParameterValues("value11");
	String value12[] 	= request.getParameterValues("value12");
	String value13[] 	= request.getParameterValues("value13");
	String value14[] 	= request.getParameterValues("value14");
	String value15[] 	= request.getParameterValues("value15");
	String value16[] 	= request.getParameterValues("value16");
	String value17[] 	= request.getParameterValues("value17");
	String value18[] 	= request.getParameterValues("value18");
	String value19[] 	= request.getParameterValues("value19");
			
	
	
	
	
	
	for(int i=start_row ; i < value_line ; i++){
		
		int flag = 0;
				
		String car_no 			= value2[i] ==null?"":AddUtil.replace(value2[i]," ","");
		Hashtable ht = t_db.getCarTintInsBlackFileList(car_no);
		int ht_size = ht.size();
		
		
			
		if(ht_size>0){		
			out.println("차량번호: "+car_no+" 제조사: "+ht.get("COM_NM")+" 모델명: "+ht.get("MODEL_NM")+" 일련번호: "+ht.get("SERIAL_NO")+"<br>");
		}else{
			out.println("차량번호: "+car_no+" 해당하는 차량의 검색결과가 없습니다.<br>");
		}						
		
	}
	
	out.println("조회 완료");
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