<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, java.text.*, acar.util.*, jxl.*, acar.insur.*"%>

<%@ include file="/acar/cookies.jsp" %>

<%
//excel ������ ���� ���
	int flag = 0;
	Vector vt = new Vector();
	
	try{
		InsComDatabase ic_db = InsComDatabase.getInstance();
		
		String path = request.getRealPath("/file/insur/");
		ExcelUpload file = new ExcelUpload(path , request.getInputStream());
		String filename = file.getFilename(); 
		
	 	FileInputStream fi = new FileInputStream(new File(path+""+filename+".xls"));

		Workbook workbook = Workbook.getWorkbook(fi);
		
		//������ ù��° sheet ������ �´�. 
		Sheet sheet = workbook.getSheet(0);

		
		for(int i = 5; i < sheet.getRows(); i++){
		
			Hashtable ht = new Hashtable();
			
			for(int j = 0; j < sheet.getColumns(); j++){
				
				Cell cell = sheet.getCell(j,i);
				
				ht.put(Integer.toString(j), cell.getContents());
				
			}
			vt.add(ht);
		}  
		
		for (int i=0; i < vt.size(); i++){
			Hashtable ht = (Hashtable)vt.elementAt(i);
			String ht22 = String.valueOf(ht.get("22"));
			String reHt22 = ht22.replace("[����]", "");
			reHt22 = ht22.replace("(��)","");
			
			int seq = ic_db.getFileSeq(reHt22.trim());
			if(ic_db.updateInsExcelComSort(seq , Integer.valueOf((String) ht.get("0")) )){
				flag += 1;
			} 
		}
	}catch(Exception e){
		flag = -1;
	}
	
	
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<script language='javascript'>
	if(<%=flag%>==<%=vt.size()%>){
		alert("����� �Ϸ�Ǿ����ϴ�");
	}else if(<%=flag%> <0){
		alert("���� ������ ������ �ٸ��ϴ�.");
	}else{
		alert("������ȣ Ȯ���� �ʿ��մϴ�.");
	}
	opener.location.reload();
	self.close();
	
</script>
</head>
<body>
</body>
</html>