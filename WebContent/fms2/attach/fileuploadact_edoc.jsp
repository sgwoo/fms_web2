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

 //20201211 CONTENT_CODE �ʼ� 
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");  //1:1�ΰ�� ���ʰ�༭ pdf��� 
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String urlfile = request.getParameter("urlfile")==null?"":request.getParameter("urlfile");  // pdf 
	String mrent = request.getParameter("mrent")==null?"":request.getParameter("mrent");  // ����Ʈ����
	    
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
			
    String zipfile = urlfile ;  //pdf ���� (pdf-gateway ) 
    File zf = new File(zipfile);	
	  		
	String fileName=zf.getName();
//	System.out.println("fileName="+ fileName);	
    
	String was_root = "d:/inetpub/wwwroot";   
	String path = "/data/pdfpw"; 
		
	//--���丮 ���� ��, ���丮 ����  
	File dir = new File(was_root+path);
			
    try {
		  if (!dir.isDirectory()) {
			  dir.mkdirs();
		  }
		 
	    if (!dir.canWrite())
			  throw new IllegalArgumentException("Not writable: Folder " );
		
		bi = new BufferedInputStream(new URL(urlfile).openStream());
		fo = new FileOutputStream(was_root+path + "/" + fileName); // ������ ����� ��ġ
		
		byte buffer[] = new byte[1024]; // �ִ� 1KB�� ����
		int len;
		int fileSize = 0;
		
		while((len = bi.read(buffer, 0, buffer.length)) != -1) { // ������ ������ buffer�� �ִ� buffer���̸�ŭ ����
			fo.write(buffer, 0, len); // buffer�� 0~len�� ��� ���� ������ ����
			fileSize = fileSize + len;
				
			if(fileSize > sizeLimit) { // �ִ� ������ �ʰ��� ��� ���� ���ε� ����
				break;
			}
		}
		
		fo.close();
		bi.close();
				
		//198������ pdfpw ������ ����� ��༭ pdf ���Ͽ� �ø���, image ���� ��  jpg ��� 	( ����� ��츸 )
		if (!mrent.equals("Y")) {
			if ( rent_st.equals("1") ) { //1���ΰ�츸 ���ʰ�༭ pdf�� ��� 
				mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "1" , path, fileName ); //���ʰ�༭ 
			}
		}	
		pdfto.conversionPdf2Img(path + "/" + fileName, m_id, l_cd, rent_st, reg_id ); //���ʰ�༭(pdf)���� ��༭��, ��  jpg�� ��ȯ 
      
		new File(was_root + path + "/" + fileName).delete(); //pdfgateway ���� ����
		
	    out.println("��ϵǾ����ϴ�.");
		 
		//if(fileSize <= sizeLimit) {
		//	System.out.println("���� ���ε� �Ϸ�!");
		//	System.out.println("���� ũ��: " + fileSize + "Byte");
		//} else {
		//	new File(was_root + path + "/" + fileName).delete();
		//	System.out.println("���� �ִ� ������ �ʰ��� ���� ���� ó��!");
		//}
		
  //  }catch (SecurityException e) {}
    
    } catch(IOException ioe){
	//	e.printStackTrace();
		out.println("An exception occurred: " + ioe.getMessage());
	}
     
%>  