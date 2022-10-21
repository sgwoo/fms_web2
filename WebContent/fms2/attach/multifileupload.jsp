<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="com.oreilly.servlet.MultipartRequest, com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.*,java.io.*, acar.util.* ,acar.common.*, java.text.*"%>
<%@ page import="acar.beans.*, common.AttachedDatabase"%>
<%@ page import="java.net.*,java.net.URLEncoder"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	System.out.println("파일업로드 시작");
	//content_code 받아오기
	String content_code = request.getParameter(Webconst.Common.contentCodeName);
		
	
	//System.out.println("content_code :"+content_code);
	//용량제한 설정
	int sizeLimit = Integer.parseInt(content_code == null ? "0" : UploadInfoEnum.getEnumByText(content_code).getLimit());
	if( sizeLimit > 0 ){
		sizeLimit = sizeLimit * 1024 * 1024 ;
	} 
	//System.out.println("sizeLimit :"+sizeLimit);

	//저장 경로 설정
	String savePath = "";
	savePath = content_code == null ? UploadInfoEnum.FREE_TIME.getText() : UploadInfoEnum.getEnumByText(content_code).getText();
//	System.out.println("savePath :"+savePath);
	
	Calendar cal = Calendar.getInstance( );
	String year = Integer.toString( cal.get(Calendar.YEAR) );
	int monthCnt = cal.get(Calendar.MONTH) + 1;
	String month =  ( monthCnt < 10 ? "0" : "" )  + Integer.toString( monthCnt );

	String was_root = request.getRealPath("/");
	String path = "/"+Webconst.UploadPath.DEFAULT_SAVE_ROOT+"/" + savePath + "/" + year + "/" + month + "/";
	
	
	//--디렉토리 없을 시, 디렉토리 생성  
	File dir = new File(was_root+path);
	try {
		if (!dir.isDirectory()) {
		dir.mkdirs();
		}
	
	}catch (SecurityException e) {}
	
	if (!dir.canWrite())
		throw new IllegalArgumentException("Not writable: Folder " );
	
	sizeLimit = 10 * 1024 * 1024 ;
	System.out.println("was_root+path : "+ was_root+path);
	// 파일 저장
	MultipartRequest multi = null;
	try{
		multi = new MultipartRequest(request, was_root+path, sizeLimit, "euc-kr", new DefaultFileRenamePolicy());
	}catch(Exception e){
		e.printStackTrace();
	}
	
	if(multi == null){
		response.getWriter().write("<script>alert('업로드실패'); location.herf='/';</script>");
		return;
	} 
	
	/*
		CONTENT_CODE : INSUR 
		CONTENT_SEQ : P11601013034 (파일이름) 
		FILE_NAME : P11601013034.pdf (파일이름.pdf)
		FILE_SIZE : 145032  
		FILE_TYPE : application/pdf 
		SAVE_FILE : INSUR_20170714153053459_0.pdf
		SAVE_FOLDER : /attach/INSUR/2017/07/  
		REG_USERSEQ : 000290 
		REG_DATE : 2017-07-14 오후 3:30:09 (sysdate)
		ISELETED : N
	*/
	
	String[] content_seq = multi.getParameterValues("content_seq");
	String[] file_name = multi.getParameterValues("file_name");
	String[] file_size = multi.getParameterValues("file_size");
	String[] file_type = multi.getParameterValues("file_type");
	String save_file	= "";
	String save_name	= new SimpleDateFormat("yyyyMMddHHmmssSSS" , Locale.getDefault()).format(Calendar.getInstance().getTime());
	String save_forlder = path;
	String reg_userseq = ck_acar_id;
	//String[] pevFileNames = multi.getParameterValues("pevFileNames");

	
	//105번 파일서버 적용시 주석 풀어야함*********************
/* 	 
	LoginBean login 	= LoginBean.getInstance();
	SecurityUtil security = new SecurityUtil();
 	
	String user = login.getCookieValue(request, "fmsCookie");
	String user_id = "000000";
	
	if(user != " "){
		user = security.decodeAES(user);
		user = user.replaceAll(Webconst.Common.FMS3_COOKIE_VALUE, "").trim();
	}
	
	if( user != null && user.length() > 0 ){
		String[] userInfo = user.split("\\|");
		if( userInfo.length == 2 ){
			user_id = userInfo[1];
			reg_userseq = user_id; 
		}
		
	}else{
		throw new IllegalArgumentException("Is not login");  
	}   */
	
	//*********************   
	
	AttachedDatabase atd = AttachedDatabase.getInstance();
	AttachedFile file = new AttachedFile();
	
	String surfix="";//확장자
	
	String result_value="";
	boolean result = true;
	
	%>
	<html>
	<head>
	<title>Insert title here</title>
	</head>
	<body>
		<div>
			<table>
	
	<%
	
	if(content_seq != null){
		//System.out.println("content_seq.length:" +content_seq.length);
		for( int i = 0 ; i < content_seq.length ; i++){
			surfix = file_name[i].substring(file_name[i].lastIndexOf("."),file_name[i].length());
			save_file = savePath + "_" + save_name + "_" + i + surfix;
			file.setContentCode(content_code);
			file.setContentSeq(content_seq[i]);
			file.setFileName(file_name[i]);
			file.setFileSize(Integer.parseInt(file_size[i]));
			file.setFileType(file_type[i]);
			file.setSaveFile(save_file);
			file.setSaveFolder(save_forlder);
			file.setRegUser(reg_userseq);
			
			
		 	/* System.out.println(content_code);
			System.out.println(content_seq[i]); 
			System.out.println(file_name[i]);
			System.out.println(new String(file_name[i].getBytes("UTF-8"), "euc-kr"));
			System.out.println(Integer.parseInt(file_size[i]));
			System.out.println(file_type[i]);
			System.out.println(save_file);
			System.out.println(reg_userseq);  */
			 
			 
			result = true; 
	
			File oldFile = new File(was_root+path+ file.getFileName());
			File newFile = new File(was_root+path+ file.getSaveFile());
		
			 //기존에 이미 저장된 파일이면 삭제
		/* 
			  if(pevFileNames != null){
				 for( int j = 0 ; j < pevFileNames.length ; j++){
					 
					//System.out.println(pevFileNames[j] );
					//System.out.println(file.getFileName() );
					 
					if(pevFileNames[j].replaceAll(" ", "").equals(file.getFileName().replaceAll(" ", ""))){
						oldFile.delete();
						result_value = "파일은 이미 등록되어 저장되지 않습니다.";
						result = false;
						
					}
				} 
			 } 
			 */
			//기존에 이미 저장된 파일이면 삭제
		/* 
			 if(atd.getAttachedCheckOverFile(content_code,file.getContentSeq()) > 0){
				oldFile.delete();
				result_value = "파일은 이미 등록되어 저장되지 않습니다.";
				result = false;
			}
			   */
			 
			//파일 이름 변경하기
		//	oldFile.renameTo(newFile); // 파일명 변경
			
			if(file.getContentCode() == null){
				result_value = "파일이 제대로 등록되지 않았습니다. \n새로고침 후 다시 시도해주시기바랍니다.";
				result = false;
			}
			 
	/* 
			if(!file.getFileType().contains("pdf")){
				result_value = "pdf 파일이 아닙니다. \n확인 후 다시 요청 바랍니다.";
				result = false;
				
			} */
			 
			if(result){
				if(!atd.insertAttachedFileJustOne(file)){
					result_value = "등록 중 오류가 발생했습니다. 관리자에게 문의 바랍니다.";
					result = false;
				}else{
					result_value = "등록이 완료 되었습니다. \n 새로고침 후 확인해보시기 바랍니다.";
				}
			}  
			 
			//System.out.println(result_value);
			
			%>
				
				<tr>					
					<td style="width: 200px;"><%=file.getFileName()%></td>
					<td><%=result_value%></td>
				</tr>
			<%
			 
		}
	}
	 
%>
		</table>				
	</div>
</body>
</html>