<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%
	String savePath="D:\\Inetpub\\wwwroot\\data\\year_jungsan"; // 저장할 디렉토리 (절대경로)
	
	int sizeLimit = 5 * 1024 * 1024 ; // 5메가까지 제한 넘어서면 예외발생
	
	/* multipart/form-data 로 FileUpload객체 생성 */ 
	MultipartRequest multi = new MultipartRequest(request, savePath, sizeLimit);

	String ck_acar_id = multi.getParameter("ck_acar_id")==null?"":multi.getParameter("ck_acar_id");
	String s_width = multi.getParameter("s_width")==null?"":multi.getParameter("s_width");
	String s_height = multi.getParameter("s_height")==null?"":multi.getParameter("s_height");
	String user_id 	= multi.getParameter("user_id")==null?"":multi.getParameter("user_id"); //연차대상자
	String auth_rw 	= multi.getParameter("auth_rw")==null?"":multi.getParameter("auth_rw");
	String st_year 	= multi.getParameter("st_year")==null?"":multi.getParameter("st_year");
	String dept_id 	= multi.getParameter("dept_id")==null?"":multi.getParameter("dept_id");
	String sa_no 	= multi.getParameter("sa_no")==null?"":multi.getParameter("sa_no");
	
	String file_name1 	= multi.getParameter("file_name1")==null?"":multi.getParameter("file_name1");
	String file_name2 	= multi.getParameter("file_name2")==null?"":multi.getParameter("file_name2");
	String file_name3 	= multi.getParameter("file_name3")==null?"":multi.getParameter("file_name3");
	String file_name4 	= multi.getParameter("file_name4")==null?"":multi.getParameter("file_name4");
	String file_name5 	= multi.getParameter("file_name5")==null?"":multi.getParameter("file_name5");
	String file_name6 	= multi.getParameter("file_name6")==null?"":multi.getParameter("file_name6");
	String file_name7 	= multi.getParameter("file_name7")==null?"":multi.getParameter("file_name7");
	String file_name8 	= multi.getParameter("file_name8")==null?"":multi.getParameter("file_name8");
	
	String file1 = multi.getParameter("file1")==null?"":multi.getParameter("file1");
	String file2 = multi.getParameter("file2")==null?"":multi.getParameter("file2");
	String file3 = multi.getParameter("file3")==null?"":multi.getParameter("file3");
	String file4 = multi.getParameter("file4")==null?"":multi.getParameter("file4");
	String file5 = multi.getParameter("file5")==null?"":multi.getParameter("file5");
	String file6 = multi.getParameter("file6")==null?"":multi.getParameter("file6");
	String file7 = multi.getParameter("file7")==null?"":multi.getParameter("file7");
	String file8 = multi.getParameter("file8")==null?"":multi.getParameter("file8");

	String file3_yn = multi.getParameter("file3_yn")==null?"":multi.getParameter("file3_yn");
	String file4_yn = multi.getParameter("file4_yn")==null?"":multi.getParameter("file4_yn");
	String file5_yn = multi.getParameter("file5_yn")==null?"":multi.getParameter("file5_yn");
	String file6_yn = multi.getParameter("file6_yn")==null?"":multi.getParameter("file6_yn");
	String file7_yn = multi.getParameter("file7_yn")==null?"":multi.getParameter("file7_yn");
	String file8_yn = multi.getParameter("file8_yn")==null?"":multi.getParameter("file8_yn");
	
	String change_his = multi.getParameter("change_his")==null?"":multi.getParameter("change_his");
	
	String filename[] = new String[8];
	int i = 7;
	
	//한글이 깨지는 문제 -multipartrequest

 	file1=new String(file1.getBytes("8859_1"),"euc-kr");  
	file2=new String(file2.getBytes("8859_1"),"euc-kr");  
	file3=new String(file3.getBytes("8859_1"),"euc-kr");  
	file4=new String(file4.getBytes("8859_1"),"euc-kr");  
	file5=new String(file5.getBytes("8859_1"),"euc-kr");  
	file6=new String(file6.getBytes("8859_1"),"euc-kr");  
	file7=new String(file7.getBytes("8859_1"),"euc-kr");  
	file8=new String(file8.getBytes("8859_1"),"euc-kr");  
	
	String formName ="";
	
	Enumeration formNames=multi.getFileNames();  // 폼의 이름 반환
			
		
		while( formNames.hasMoreElements() ) {
			  formName = (String)formNames.nextElement();   // 폼에서 type이 file인것의 이름(name)을 반환(예 : upload1)
			  filename[i] = multi.getFilesystemName(formName); // 파일의 이름 얻기
			  i--;
		 } 
	
System.out.println("file_name1="+file_name1);
System.out.println("file_name2="+file_name2);
System.out.println("file_name3="+file_name3);
System.out.println("file_name4="+file_name4);
System.out.println("file_name5="+file_name5);
System.out.println("file_name6="+file_name6);
System.out.println("file_name7="+file_name7);
System.out.println("file_name8="+file_name8);	
	
System.out.println("filename1="+filename[0]);
System.out.println("filename2="+filename[1]);
System.out.println("filename3="+filename[2]);
System.out.println("filename4="+filename[3]);
System.out.println("filename5="+filename[4]);
System.out.println("filename6="+filename[5]);
System.out.println("filename7="+filename[6]);
System.out.println("filename8="+filename[7]);		

	int count = 0;
	
	
	if(filename[0] != null){
		file_name1=filename[0];
	}else{
		file_name1 = file1;
	}
	
	if(filename[1] != null){
		file_name2=filename[1];
	}else{
		file_name2 = file2;
	}
	
	if(filename[2] != null){
		file_name3=filename[2];
	}else{
		file_name3 = file3;
	}
	
	if(filename[3] != null){
		file_name4=filename[3];
	}else{
		file_name4 = file4;
	}
	
	if(filename[4] != null){
		file_name5=filename[4];
	}else{
		file_name5 = file5;
	}
	
	if(filename[5] != null){
		file_name6=filename[5];
	}else{
		file_name6 = file6;
	}
	
	if(filename[6] != null){
		file_name7=filename[6];
	}else{
		file_name7 = file7;
	}
	
	if(filename[7] != null){
		file_name8=filename[7];
	}else{
		file_name8 = file8;
	}
	

	
	
	count = ac_db.InsertYear_jungsan_Scan(st_year, dept_id, sa_no, ck_acar_id, file_name1, file_name2, file_name3, file3_yn, file_name4, file4_yn, file_name5, file5_yn, file_name6, file6_yn, file_name7, file7_yn, file_name8, file8_yn, change_his );
			
%>
<html>
<head>
<title>FMS</title>

</head>
<script language="JavaScript">
<!--

	function go_parent_list(){
		var fm = document.form1;
		fm.action = "./year_jungsan_frame_<%=st_year%>.jsp";
		fm.target='d_content';
		fm.submit();
	}

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<%if(count==1){	%>
		alert("정상적으로 등록되었습니다.");
		go_parent_list();
		parent.close();	
<%}else{ %>
	alert("오류입니다!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>
