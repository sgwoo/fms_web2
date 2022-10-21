<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.master_car.*, acar.user_mng.*"%>
<%@ page import="acar.kakao.*" %>
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
	
	String car_no = "";			//차량번호
	
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
	
	mc_db.deleteCyberts();  //기존데이터 삭제
	
	Hashtable ht = new Hashtable();
	for (int j = 0; j < vt.size(); j++) {
		flag = 0;
		
		temp_count++;
						    
	    //차량번호	차대번호	성명/상호	차명	유효기간만료일	차령기간만료일	년식	최초등록일	배출가스 등급
		
		Hashtable content = (Hashtable)vt.elementAt(j);
		
		car_no = String.valueOf(content.get("0"));  //차량번호
	//	System.out.println("car_no="+ car_no);
		che_1 = String.valueOf(content.get("1")); //차대번호
		che_2 = String.valueOf(content.get("2")); //성명/상호
		che_3 = String.valueOf(content.get("3")); //차명
		che_4 = String.valueOf(content.get("4")); //유효기간만료일
		che_5 = String.valueOf(content.get("5")); //차령만료일
		che_6 = String.valueOf(content.get("6")); //년식
		che_7 = String.valueOf(content.get("7"));//최초등록일	
		che_8 = String.valueOf(content.get("8"));//배출가스 등급	
	
		CarMaintReqBean cmrb = new CarMaintReqBean();
		
		ht = mc_db.getCarMngID(car_no);  //계약번호
		
		if ( String.valueOf(ht.get("CAR_MNG_ID")).equals("null")) {
			ht = mc_db.getReCarMngID(car_no);  //계약번호
		}
		
		//등록
		cmrb.setM1_no		(car_no);  //차량번호		
		cmrb.setChe_type	(che_8);	//배출가스 등급
		cmrb.setChe_nm		(che_3);  //차명
		cmrb.setReq_dt		(che_4); //유효기간만료일
		cmrb.setM1_content(che_1); //차대번호
		cmrb.setM1_dt(che_7);  //최초등록일
		cmrb.setJung_dt(che_5);  // 차령만료일
		cmrb.setGubun(che_6);  // 년식
		cmrb.setCar_mng_id	(String.valueOf(ht.get("CAR_MNG_ID")));
		cmrb.setRent_l_cd	(String.valueOf(ht.get("RENT_L_CD")));	
			
		if(mc_db.insertCyberts(cmrb)){
			//등록정상
			result[j] = "정상처리";
		}else{
			//등록에러
			result[j] = "오류 발생";
		}	
		
		//알림톡전송 
		//담당자정보 
	
	    sms_msg ="한국교통안전공단 검사도래 7일전 자료에  차량번호 " + car_no+  " 가 포함되었으니 검사업무 진행사항을 확인해보세요!!!.";
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
		if(result[i].equals("정상처리")) continue;
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