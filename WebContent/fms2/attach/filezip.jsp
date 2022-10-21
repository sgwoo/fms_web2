<%@page import="acar.beans.AttachedFile"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@page import="acar.util.*" %>
<%@page import="java.util.zip.ZipEntry" %>
<%@page import="java.util.zip.ZipOutputStream" %>

<%@page trimDirectiveWhitespaces="true"%>
<%@page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<% 

 //20201211 CONTENT_CODE �ʼ� 
	String content_code = request.getParameter("CONTENT_CODE");	  //APPRSL
	String attachedSeq = request.getParameter("SEQ");  //car_mng_id + 
	String downFileName = request.getParameter("DOWNFILENAME")==null?"result":request.getParameter("DOWNFILENAME");

	downFileName =URLDecoder.decode(downFileName, "UTF-8");  
    String filename = new String(downFileName.getBytes("UTF-8"), "8859_1");
  
    List<AttachedFile> files = null;

	MultipartFileUpload uploadComponent = new MultipartFileUpload();
	
	String req_code  = Long.toString(System.currentTimeMillis());
		
	String zipFile = "d:/inetpub/wwwroot/ziptemp/"+content_code+req_code+".zip";  //zip���� ����� �ߺ��ȵǰ� 
	
	System.out.println("file zipFile=" + zipFile);
 

	if( attachedSeq != null && attachedSeq.matches("^[0-9]+$") ){
		
	   files = uploadComponent.getAttachedInfoList( request, content_code, attachedSeq ) ;
	   
	    // ZipOutputStream�� FileOutputStream ���� ����
       FileOutputStream fout = new FileOutputStream(zipFile);
       ZipOutputStream zout = new ZipOutputStream(fout);
             
       try {            
	  
		    for( AttachedFile file : files ){
		   
			     	ServletContext context = getServletContext();
					String fileName = file.getSaveFile();
					String saveFolder = file.getSaveFolder();
					String realFolder = request.getRealPath("/");
					String filePath = "";
					String fileType = "";
			
					filePath = realFolder + "/" + saveFolder + fileName;		
					fileType = file.getFileType();
							
					filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
								
			        //���� ���ϸ� ����, ������� ���Ͼ����� ���� new File�� 
			        ZipEntry zipEntry = new ZipEntry(new File(filePath).getName());
			        zout.putNextEntry(zipEntry);
			
			        //������� ����
			        //zout.putNextEntry(new ZipEntry(sourceFiles.get(i)));
			
			        FileInputStream fin = new FileInputStream(filePath);
			        byte[] buffer = new byte[1024];
			        int length;
			
			        // input file�� 1024����Ʈ�� ����, zip stream�� ���� ����Ʈ�� ��
			        while((length = fin.read(buffer)) > 0){
			            zout.write(buffer, 0, length);
			        }
			
			        zout.closeEntry();
			        fin.close();
		 	 }
   	       
		    zout.close();
			    
		    response.setContentType("application/zip");
		    response.addHeader("Content-Disposition", "attachment; filename=" + filename + ".zip");
		
		    FileInputStream fis=new FileInputStream(zipFile);
		    BufferedInputStream bis=new BufferedInputStream(fis);
		    ServletOutputStream so=response.getOutputStream();
		    BufferedOutputStream bos=new BufferedOutputStream(so);
		
		    byte[] data=new byte[2048];
		    int input=0;
		
		    while((input=bis.read(data))!=-1){
		        bos.write(data,0,input);
		        bos.flush();
		    }
					    
		    if(bos!=null) bos.close();
		    if(bis!=null) bis.close();
		    if(so!=null) so.close();
		    if(fis!=null) fis.close();
		
			//zip���� ������ ���� �������� ���� 
			 File inputFile = new File(zipFile);
			 inputFile.delete();  //zip ���� ���� 			 
		 
	    } catch(IOException ioe){ }
  } //if 
      
%>