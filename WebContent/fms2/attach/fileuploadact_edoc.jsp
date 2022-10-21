<%@page import="acar.beans.AttachedFile"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@ page import="acar.util.*" %>
<%@ page import="common.MoveAttachedFile" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.io.BufferedInputStream" %>
<%@ page import="java.io.File" %>
<%@ page import="common.PdfToImage" %>

<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<% 

 //20201211 CONTENT_CODE 필수 
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");  //1:1인경우 최초계약서 pdf등록 
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String urlfile = request.getParameter("urlfile")==null?"":request.getParameter("urlfile");  // pdf 
	String mrent = request.getParameter("mrent")==null?"":request.getParameter("mrent");  // 월렌트여부
	    
   // String cn = request.getParameter("contentCode");   //LC_SCAN
    String cn = "LC_SCAN";
   
    MoveAttachedFile mAttach = MoveAttachedFile.getInstance();
    PdfToImage pdfto = PdfToImage.getInstance();
    
	String savePath = "";
	savePath = cn == null ? UploadInfoEnum.LC_SCAN.getText() : UploadInfoEnum.getEnumByText(cn).getText();	
	cn = cn == null ? "0" : UploadInfoEnum.getEnumByText(cn).getLimit();
	
	int sizeLimit = ( Integer.parseInt(cn) );
	
	if( sizeLimit > 0 ){
		sizeLimit = sizeLimit * 1024 * 1024 ;
	}
	
	BufferedInputStream bi = null;
	FileOutputStream fo = null;
			
    String zipfile = urlfile ;  //pdf 파일 (pdf-gateway ) 
    File zf = new File(zipfile);	
	  		
	String fileName=zf.getName();
//	System.out.println("fileName="+ fileName);	
    
	String was_root = "d:/inetpub/wwwroot";   
	String path = "/data/pdfpw"; 
		
	//--디렉토리 없을 시, 디렉토리 생성  
	File dir = new File(was_root+path);
			
    try {
		  if (!dir.isDirectory()) {
			  dir.mkdirs();
		  }
		 
	    if (!dir.canWrite())
			  throw new IllegalArgumentException("Not writable: Folder " );
		
		bi = new BufferedInputStream(new URL(urlfile).openStream());
		fo = new FileOutputStream(was_root+path + "/" + fileName); // 파일이 저장될 위치
		
		byte buffer[] = new byte[1024]; // 최대 1KB씩 저장
		int len;
		int fileSize = 0;
		
		while((len = bi.read(buffer, 0, buffer.length)) != -1) { // 파일을 읽으며 buffer에 최대 buffer길이만큼 저장
			fo.write(buffer, 0, len); // buffer의 0~len에 담긴 파일 내용을 저장
			fileSize = fileSize + len;
				
			if(fileSize > sizeLimit) { // 최대 범위를 초과할 경우 파일 업로드 종료
				break;
			}
		}
		
		fo.close();
		bi.close();
				
		//198서버에 pdfpw 폴더에 등록후 계약서 pdf 파일에 올리고, image 추출 후  jpg 등록 	( 장기인 경우만 )
		if (!mrent.equals("Y")) {
			if ( rent_st.equals("1") ) { //1차인경우만 최초계약서 pdf로 등록 
				mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "1" , path, fileName ); //최초계약서 
			}
		}	
		pdfto.conversionPdf2Img(path + "/" + fileName, m_id, l_cd, rent_st, reg_id ); //최초계약서(pdf)에서 계약서앞, 뒤  jpg로 변환 
      
		new File(was_root + path + "/" + fileName).delete(); //pdfgateway 파일 삭제
		
	    out.println("등록되었습니다.");
		 
		//if(fileSize <= sizeLimit) {
		//	System.out.println("파일 업로드 완료!");
		//	System.out.println("파일 크기: " + fileSize + "Byte");
		//} else {
		//	new File(was_root + path + "/" + fileName).delete();
		//	System.out.println("파일 최대 사이즈 초과로 파일 삭제 처리!");
		//}
		
  //  }catch (SecurityException e) {}
    
    } catch(IOException ioe){
	//	e.printStackTrace();
		out.println("An exception occurred: " + ioe.getMessage());
	}
     
%>  