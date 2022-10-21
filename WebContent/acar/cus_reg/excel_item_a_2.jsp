<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.cus_reg.*"%>

<%
	int row_size = request.getParameter("row_size")==null?0:AddUtil.parseInt(request.getParameter("row_size"));//행수
	int col_size = request.getParameter("col_size")==null?0:AddUtil.parseInt(request.getParameter("col_size"));//열수
	int start_row = request.getParameter("start_row")==null?0:AddUtil.parseInt(request.getParameter("start_row"));//시작행
	int value_line = request.getParameter("value_line")==null?0:AddUtil.parseInt(request.getParameter("value_line"));//실제데이타있는행수
	
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String serv_id 		= request.getParameter("serv_id")==null?"":request.getParameter("serv_id");
	
	String result[]  = new String[value_line];
	String value0[]  = request.getParameterValues("value0");//번호
	String value1[]  = request.getParameterValues("value1");//구분
	String value2[]  = request.getParameterValues("value2");//작업항목 및 교환부품
	String value3[]  = request.getParameterValues("value3");//작업
	String value4[]  = request.getParameterValues("value4");//H,Q,%
	String value5[]  = request.getParameterValues("value5");//단가
	String value6[]  = request.getParameterValues("value6");//부품가격
	String value7[]  = request.getParameterValues("value7");//공임
	String value8[]  = request.getParameterValues("value8");//비고
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
	
	int flag = 0;
	int error = 0;
	
	
	CusReg_Database cr_db = CusReg_Database.getInstance();
	
	for(int i=start_row ; i < value_line ; i++){
	
		Serv_ItemBean siBn = new Serv_ItemBean();
		siBn.setCar_mng_id	(car_mng_id);
		siBn.setServ_id		(serv_id);
		siBn.setItem_st		(value1[i] ==null?"":AddUtil.replace(value1[i],"?",""));
		if(siBn.getItem_st().equals("")) siBn.setItem_st("주작업");
		siBn.setItem_id		("");
		siBn.setItem		(value2[i] ==null?"":AddUtil.replace(value2[i],"?",""));
		siBn.setWk_st		(value3[i] ==null?"":AddUtil.replace(value3[i],"?",""));
		siBn.setCount		(value4[i] ==null?0:AddUtil.parseDigit(value4[i]));
		siBn.setPrice		(value5[i] ==null?0:AddUtil.parseDigit(value5[i]));
		siBn.setAmt			(value6[i] ==null?0:AddUtil.parseDigit(value6[i]));
		siBn.setLabor		(value7[i] ==null?0:AddUtil.parseDigit(value7[i]));
		siBn.setBpm			("2");
		
		//중복체크
		//if(cr_db.getServ_itemCheck(siBn.getCar_mng_id(), siBn.getServ_id(), siBn.getItem(), siBn.getLabor(), siBn.getAmt()) == 0){
			if(cr_db.insertServItem(siBn) == 0) error++;
		//}
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>엑셀 파일 읽어 견적(청구)내역서 등록하기
</p>
<SCRIPT LANGUAGE="JavaScript">
<!--		
<%	if(error > 0){//에러발생시 초기화
		flag = cr_db.delServ_item_all(car_mng_id, serv_id);%>
		document.write("오류발생");
<%	}else{%>
	parent.opener.item_serv_in.location.reload();
	parent.window.close();
<%	}%>
//-->
</SCRIPT>
</BODY>
</HTML>