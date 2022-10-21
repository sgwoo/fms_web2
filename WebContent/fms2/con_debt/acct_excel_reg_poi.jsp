<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
//	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
	FileUpload file = new FileUpload(path , request.getInputStream());
	String filename = file.getFilename();
		
	int pos = file.getRealName().lastIndexOf( "." );
	String ext = file.getRealName().substring( pos + 1 );
	
	int vt_size = 0;
	int colSize = 0;
		
	if (ext.equals("xls")) {
		vt = EstiVarExcelUpload.getXLSData(path, filename + ".xls", 1);
		vt_size = vt.size();
		colSize = EstiVarExcelUpload.getXLSDataColSize(path, filename + ".xls", 1);
	} else {
		vt = EstiVarExcelUpload.getXLSXData(path, filename + ".xlsx", 1);
		vt_size = vt.size();
		colSize = EstiVarExcelUpload.getXLSXDataColSize(path, filename + ".xlsx", 1);
	}
	
			
	//xlsx만 가능 
//	vt = EstiVarExcelUpload.getXLSXData(path, filename + ".xlsx", 1);
//	vt_size = vt.size();
//	colSize = EstiVarExcelUpload.getXLSXDataColSize(path, filename + ".xlsx", 1);

	String result[]  = new String[vt_size];
	
	String c0 = "";			//	
	String c1 = "";
	String c2 = "";
	String c3 = "";
	String c4 = "";
	
	long l_c3 = 0;
		
	int flag = 0;
	int temp_count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
		
	String seq = "";
		
	mc_db.deleteAcctTemp();  //기존데이터 삭제
	
	Hashtable ht = new Hashtable();
	for (int j = 0; j < vt.size(); j++) {
		flag = 0;
		
		temp_count++;
						    
	    //거래처코드	거래처명	사업자등록번호	당일잔액 ( 네오엠에서 코드 포함으로  엑셀내려받은 후 데이타 정리 )
		
		Hashtable content = (Hashtable)vt.elementAt(j);
		
		c0 = String.valueOf(content.get("0"));  //거래처코드	
		c1 = String.valueOf(content.get("1")); //거래처명
		c2 = String.valueOf(content.get("2")); //사업자등록번호
		c3 = String.valueOf(content.get("3")); //당일잔액
		l_c3 = AddUtil.parseLong(c3);
				
		if(mc_db.insertAcctTemp(c0, c1, c2, c3)){
			//등록정상
			result[j] = "정상처리";
		}else{
			//등록에러
			result[j] = "오류 발생";
		}					
	}
	
	int result_cnt = 0;
	
%>
<html>
<head>
<title>FMS</title>
<meta HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
<script language="JavaScript" src="/include/info.js"></script>
<script language="JavaScript">
<!--	
//-->
</script>
<style type="text/css">
<!--
.style1 {color: #999999}
-->
</style>
</head>
<body>
<form action="acct_excel_result.jsp" method='post' name="form1">
	<input type='hidden' name='start_row' value='0'>
	<input type='hidden' name='value_line' value='<%=vt.size()%>'>
	<%for (int i = 0; i < vt.size(); i++) {
		if(result[i].equals("정상처리")) continue;
		Hashtable content_temp = (Hashtable)vt.elementAt(i);
		result_cnt++;%>
	<input type='hidden' name='c0' value='<%=String.valueOf(content_temp.get("0"))%>'>	
	<input type='hidden' name='result' value='<%=result[i]%>'>	
	<%}%>
	<input type='hidden' name='result_cnt' value='<%=result_cnt%>'>
  	
</form>
<script language="JavaScript">
<!--		
	document.form1.submit();
//-->
</script>

<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</BODY>
</HTML>