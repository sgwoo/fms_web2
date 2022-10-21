<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*"%>
<%@ page import="acar.insur.*"%>
<%@ include file="/acar/cookies.jsp" %>



<%
	//excel ������ ���� ���
	String path = request.getRealPath("/file/insur/");
	Vector vt = new Vector();
	
	//ExcelUpload file = new ExcelUpload("C:\\Inetpub\\wwwroot\\file\\", request.getInputStream());
	ExcelUpload file = new ExcelUpload(path , request.getInputStream());
	String filename = file.getFilename();
	
	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

	Workbook workbook = Workbook.getWorkbook(fi);
	
	//������ ù��° sheet ������ �´�. 
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
	
	
	//DB�� �ִ� Client ���� ��������
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
			 	<td width="130" height="30" class="title" >��ȣ</td>
			  	<td width="130" height="30" class="title" >����ڹ�ȣ</td>
			  	<td width="130" height="30" class="title" >������ȣ</td>
			  	<td width="130" height="30" class="title" >�����ȣ</td>
			  	<td width="100" height="30" class="title" >���������</td>
			  	<td width="100" height="30" class="title" >���踸����</td>
			 	<td width="100" height="30" class="title" >����</td>
			  	<td width="100" height="30" class="title" >������</td>
			</tr>
	
	<%
	for (int a = 0 ; a < vt_size ; a++){
		// ������ ���ǹ�ȣ�� DB�� �ִ� Client�� ã�� ����
		Hashtable content1 = (Hashtable)vt.elementAt(a);
		String ins_con_no = ((String)content1.get("0")).replaceAll(" ","");  	//���ǹ�ȣ
		String car_no = ((String)content1.get("1")).replaceAll(" ",""); 		//������ȣ
		String car_num = ((String)content1.get("2")).replaceAll(" ","");  		//�����ȣ
		String firm_emp_nm = ((String)content1.get("3")).replaceAll(" ","");  	//����
		String enp_no = ((String)content1.get("4")).replaceAll(" ","");  		//����ڹ�ȣ
		String ins_start_dt = ((String)content1.get("5")).replaceAll(" ","");  	//���������
		String ins_exp_dt = ((String)content1.get("6")).replaceAll(" ",""); 	//���踸����
		String age_scp = "";													//����Ư��
		String com_emp_yn = ((String)content1.get("8")).replaceAll(" ","");  	//����������
	
		if(enp_no.contains("*")){
			enp_no =  enp_no.replaceAll("\\*","");
			if(enp_no.length() == 7 ){ //���λ������ ��� ������� ��
				enp_no=  enp_no.substring(0,6); 
			}
			
		}
		ins_start_dt = ins_start_dt.replaceAll("-","");
		ins_exp_dt = ins_exp_dt.replaceAll("-","");
		
		//1:21�� �̻� 2:26�� �̻� 
		//3:��� ������ 4 : 24���̻�
		String age= (String)content1.get("7");
		
		if(((String)content1.get("7")).contains("21")){
			age_scp = "1";
		}else if(((String)content1.get("7")).contains("26")){
			age_scp = "2";
		}else if(((String)content1.get("7")).contains("24")){
			age_scp = "4";
		}else if(((String)content1.get("7")).contains("���")){
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
				result_value = "��ϿϷ�";
				
			}else{
				result_value = "������������ ������ �߻��߽��ϴ�.";
				
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
	
	if(!result_value.equals("��ϿϷ�")){
	%>
	</table>
		<div>��ϵ��� ���� �ǵ��Դϴ�. ������ �����͸� Ȯ���ϼ���</div>
	<% 		
		}
	%>
	<script>
		if('<%=result_value%>' == "��ϿϷ�"){
			alert('��� ���ó���� �Ϸ� �Ǿ����ϴ�');
			window.history.back();
		}
		
	</script>
	
</BODY>
</HTML>