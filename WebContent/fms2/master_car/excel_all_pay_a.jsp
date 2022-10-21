<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, acar.common.*, acar.insur.*"%>
<%@ page import="acar.master_car.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	String path = request.getRealPath("/file/");
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path, request.getInputStream());	
	
	String gjyj_dt 	= file.getParameter("gjyj_dt")==null?"":file.getParameter("gjyj_dt");
	String gj_dt 		= file.getParameter("gj_dt")==null?"":file.getParameter("gj_dt");
	
	boolean flag = true;
	String result = "";
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(mc_db.updateAllMaster_CarPay(gjyj_dt, gj_dt)){
		//정상
		result = "정상처리되었습니다.";
	}else{
		//에러
		result = "오류 발생";
	}
%>
<HTML>
<HEAD>
<TITLE>FMS</TITLE>
<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<script language="JavaScript" src="/include/info.js"></script>
</HEAD>
<BODY>
<p>긴급출동 일괄 지출처리
</p>
<form action="excel_result.jsp" method='post' name="form1">
</form>
<SCRIPT LANGUAGE="JavaScript">
<!--		
	alert('<%=result%>');
//-->
</SCRIPT>
</BODY>
</HTML>