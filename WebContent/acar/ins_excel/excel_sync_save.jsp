<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>



<%
	//excel 파일의 절대 경로
	String path = request.getRealPath("/file/insur/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//엑셀의 첫번째 sheet 가지고 온다. 
	Sheet sheet = workbook.getSheet(0);
	
	for(int i = 3; i < sheet.getRows(); i++){
	
		Hashtable ht = new Hashtable();
		
		for(int j = 0; j < sheet.getColumns(); j++){
			
			Cell cell = sheet.getCell(j,i);
			
			ht.put(Integer.toString(j), cell.getContents());
			
		}
		vt.add(ht);
	}
	
	
	String result_value="";
	boolean result=false;
	
	int value_line = 0;
	int vt_size = vt.size();
	
	
	//DB에 있는 Client 정보 가져오기
	InsDatabase ai_db = InsDatabase.getInstance();
	Vector vt2 = new Vector();
	
	%>
	<HTML>
	<HEAD>
	<TITLE>FMS</TITLE>
	<META HTTP-EQUIV="Content-Type" CONTENT="text/html; charset=euc-kr">
	<script src="http://code.jquery.com/jquery-1.10.2.js"></script>
	<script src="//code.jquery.com/ui/1.11.4/jquery-ui.js"></script>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/2.1.4/jquery.min.js"></script>
	<script language="JavaScript" src="/include/info.js"></script>
	<!-- <script language='JavaScript' src='/include/common.js'></script> -->
	<style>
		table{
			font-size:9pt;
			border-collapse:collapse;
		}
	</style>
	</HEAD>
	<body>
		<table border="1">  
			<tr align="center">	
			 	<td width="130" height="30" class="title" >상호</td>
			  	<td width="130" height="30" class="title" >사업자번호</td>
			  	<td width="130" height="30" class="title" >차량번호</td>
			  	<td width="130" height="30" class="title" >차대번호</td>
			  	<td width="100" height="30" class="title" >보험시작일</td>
			  	<td width="100" height="30" class="title" >보험만료일</td>
			 	<td width="100" height="30" class="title" >연령</td>
			  	<td width="100" height="30" class="title" >임직원</td>
			</tr>
	
	<%
	for (int a = 0 ; a < vt_size ; a++){
		// 엑셀의 증권번호로 DB에 있는 Client값 찾기 위함
		Hashtable content1 = (Hashtable)vt.elementAt(a);
		String ins_con_no = ((String)content1.get("0")).replaceAll(" ","");  	//증권번호
		String car_no = ((String)content1.get("1")).replaceAll(" ",""); 		//차량번호
		String car_num = ((String)content1.get("2")).replaceAll(" ","");  		//차대번호
		String firm_emp_nm = ((String)content1.get("3")).replaceAll(" ","");  	//고객명
		String enp_no = ((String)content1.get("4")).replaceAll(" ","");  		//사업자번호
		String ins_start_dt = ((String)content1.get("5")).replaceAll(" ","");  	//보험시작일
		String ins_exp_dt = ((String)content1.get("6")).replaceAll(" ",""); 	//보험만기일
		String age_scp = "";													//연령특약
		String com_emp_yn = ((String)content1.get("8")).replaceAll(" ","");  	//임직원한정
	
		if(enp_no.contains("*")){
			enp_no =  enp_no.replaceAll("\\*","");
			if(enp_no.length() == 7 ){ //개인사업자일 경우 생년월일 만
				enp_no=  enp_no.substring(0,6); 
			}
			
		}
		ins_start_dt = ins_start_dt.replaceAll("-","");
		ins_exp_dt = ins_exp_dt.replaceAll("-","");
		
		//1:21세 이상 2:26세 이상 
		//3:모든 운전자 4 : 24세이상
		String age= (String)content1.get("7");
		
		if(((String)content1.get("7")).contains("21")){
			age_scp = "1";
		}else if(((String)content1.get("7")).contains("26")){
			age_scp = "2";
		}else if(((String)content1.get("7")).contains("24")){
			age_scp = "4";
		}else if(((String)content1.get("7")).contains("모든")){
			age_scp = "3";
		}else{
			
		}
				
		age = age.replaceAll(" ","");
		
		
		if(com_emp_yn.equals("O")){
			com_emp_yn = "Y";	
		}else if(com_emp_yn.equals("X")){
			com_emp_yn = "N";	
		}else{
			com_emp_yn = " ";				
		}
		
		if(!ins_con_no.equals("") && !firm_emp_nm.equals("") && !enp_no.equals("") && !ins_start_dt.equals("") && !age_scp.equals("") && !com_emp_yn.equals("")){
			result = ai_db.updateClientInfo(ins_con_no,firm_emp_nm,enp_no,ins_start_dt,ins_exp_dt,age_scp,com_emp_yn);
/* 			 	System.out.println("ins_con_no:"+ins_con_no +"/ firm_emp_nm:"+firm_emp_nm +"/ enp_no:"+enp_no +"/ ins_start_dt:"+ins_start_dt + "/ ins_exp_dt:"+ins_exp_dt +"/ age_scp:"+age_scp +"/ com_emp_yn:"+com_emp_yn);  */
			if(result){
				result_value = "등록완료";
				
			}else{
				result_value = "데이터저장중 오류가 발생했습니다.";
				
			}
			
			
		}else{
		%>
			<tr height="30">
				<td width="130" align="center" height="30"><p><%=ins_con_no%></p></td>
				<td width="130" align="center" height="30"><p><%=firm_emp_nm%></p></td>
				<td width="100" align="center" height="30"><p><%=enp_no%></p></td>
				<td width="150" align="center" height="30"><p><%=ins_start_dt%></p></td>
				<td width="100" align="center" height="30"><p><%=ins_exp_dt%></p></td>
				<td width="100" align="center" height="30"><p><%=age_scp%></p></td>
				<td width="50"  align="center" height="30"><p><%=com_emp_yn%></p></td>
			</tr>
		<%
		}
		
	//	System.out.println(result_value);
	 }
	
	if(!result_value.equals("등록완료")){
	%>
	</table>
		<div>등록되지 않은 건들입니다. 엑셀의 데이터를 확인하세요</div>
	<% 		
		}
	%>
	<script>
		if('<%=result_value%>' == "등록완료"){
			alert('모든 등록처리가 완료 되었습니다');
			window.history.back();
		}
		
	</script>
	
</BODY>
</HTML>