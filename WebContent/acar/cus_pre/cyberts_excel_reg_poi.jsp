<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.master_car.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
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
	
	String car_no = "";			//������ȣ
	
	String che_1 = "";
	String che_2 = "";
	String che_3 = "";
	String che_4 = "";
	String che_5 = "";
	String che_6 = "";
	String che_7 = "";
	String che_8 = "";
	
	int flag = 0;
	int temp_count = 0;
	
	UserMngDatabase umd = UserMngDatabase.getInstance();	
	AlimTalkDatabase at_db = AlimTalkDatabase.getInstance();
	
	String seq = "";
	String sms_msg = "";
	
	mc_db.deleteCyberts();  //���������� ����
	
	Hashtable ht = new Hashtable();
	for (int j = 0; j < vt.size(); j++) {
		flag = 0;
		
		temp_count++;
						    
	    //������ȣ	�����ȣ	����/��ȣ	����	��ȿ�Ⱓ������	���ɱⰣ������	���	���ʵ����	���Ⱑ�� ���
		
		Hashtable content = (Hashtable)vt.elementAt(j);
		
		car_no = String.valueOf(content.get("0"));  //������ȣ
	//	System.out.println("car_no="+ car_no);
		che_1 = String.valueOf(content.get("1")); //�����ȣ
		che_2 = String.valueOf(content.get("2")); //����/��ȣ
		che_3 = String.valueOf(content.get("3")); //����
		che_4 = String.valueOf(content.get("4")); //��ȿ�Ⱓ������
		che_5 = String.valueOf(content.get("5")); //���ɸ�����
		che_6 = String.valueOf(content.get("6")); //���
		che_7 = String.valueOf(content.get("7"));//���ʵ����	
		che_8 = String.valueOf(content.get("8"));//���Ⱑ�� ���	
	
		CarMaintReqBean cmrb = new CarMaintReqBean();
		
		ht = mc_db.getCarMngID(car_no);  //����ȣ
		
		if ( String.valueOf(ht.get("CAR_MNG_ID")).equals("null")) {
			ht = mc_db.getReCarMngID(car_no);  //����ȣ
		}
		
		//���
		cmrb.setM1_no		(car_no);  //������ȣ		
		cmrb.setChe_type	(che_8);	//���Ⱑ�� ���
		cmrb.setChe_nm		(che_3);  //����
		cmrb.setReq_dt		(che_4); //��ȿ�Ⱓ������
		cmrb.setM1_content(che_1); //�����ȣ
		cmrb.setM1_dt(che_7);  //���ʵ����
		cmrb.setJung_dt(che_5);  // ���ɸ�����
		cmrb.setGubun(che_6);  // ���
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));	
			
		if(mc_db.insertCyberts(cmrb)){
			//�������
			result[j] = "����ó��";
		}else{
			//��Ͽ���
			result[j] = "���� �߻�";
		}	
		
		//�˸������� 
		//��������� 
	
	    sms_msg ="�ѱ������������ �˻絵�� 7���� �ڷῡ  ������ȣ " + car_no+  " �� ���ԵǾ����� �˻���� ��������� Ȯ���غ�����!!!.";
	    UsersBean user_bean = umd.getUsersBean(String.valueOf(ht.get("MNG_ID")));
	    
		at_db.sendMessage(1009, "0", sms_msg, user_bean.getUser_m_tel(), "02-392-4242", null, String.valueOf(ht.get("RENT_L_CD")), "999999");		
		
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
<form action="cyberts_excel_result.jsp" method='post' name="form1">
	<input type='hidden' name='start_row' value='0'>
	<input type='hidden' name='value_line' value='<%=vt.size()%>'>
	<%for (int i = 0; i < vt.size(); i++) {
		if(result[i].equals("����ó��")) continue;
		Hashtable content_temp = (Hashtable)vt.elementAt(i);
		result_cnt++;%>
	<input type='hidden' name='car_no' value='<%=String.valueOf(content_temp.get("0"))%>'>	
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