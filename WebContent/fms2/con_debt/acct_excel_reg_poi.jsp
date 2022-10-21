<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.user_mng.*"%>
<jsp:useBean id="mc_db" scope="page" class="acar.master_car.Master_CarDatabase"/>


<%
	//excel ������ ���� ���
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
	
			
	//xlsx�� ���� 
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
		
	mc_db.deleteAcctTemp();  //���������� ����
	
	Hashtable ht = new Hashtable();
	for (int j = 0; j < vt.size(); j++) {
		flag = 0;
		
		temp_count++;
						    
	    //�ŷ�ó�ڵ�	�ŷ�ó��	����ڵ�Ϲ�ȣ	�����ܾ� ( �׿������� �ڵ� ��������  ������������ �� ����Ÿ ���� )
		
		Hashtable content = (Hashtable)vt.elementAt(j);
		
		c0 = String.valueOf(content.get("0"));  //�ŷ�ó�ڵ�	
		c1 = String.valueOf(content.get("1")); //�ŷ�ó��
		c2 = String.valueOf(content.get("2")); //����ڵ�Ϲ�ȣ
		c3 = String.valueOf(content.get("3")); //�����ܾ�
		l_c3 = AddUtil.parseLong(c3);
				
		if(mc_db.insertAcctTemp(c0, c1, c2, c3)){
			//�������
			result[j] = "����ó��";
		}else{
			//��Ͽ���
			result[j] = "���� �߻�";
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
		if(result[i].equals("����ó��")) continue;
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