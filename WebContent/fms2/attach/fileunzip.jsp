<%@page import="acar.beans.AttachedFile"%>
<%@page import="java.io.*"%>
<%@page import="java.util.*"%>
<%@page import="java.net.*"%>
<%@ page import="acar.util.*" %>
<%@ page import="common.MoveAttachedFile" %>
<%@ page import="java.io.OutputStream" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.FileOutputStream" %>
<%@ page import="java.util.zip.ZipEntry" %>
<%@ page import="java.util.zip.ZipInputStream" %>

<%@ page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="text/html; charset=EUC-KR" pageEncoding="EUC-KR"%>

<% 

 //20201211 CONTENT_CODE �ʼ� 	
	
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");  //����Ʈ�� M
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String zipfilename = request.getParameter("ZIPFILENAME")==null?"result.zip":request.getParameter("ZIPFILENAME");
	    
   String cn = request.getParameter("contentCode");   //LC_SCAN
    
	String savePath = "";

	savePath = cn == null ? UploadInfoEnum.LC_SCAN.getText() : UploadInfoEnum.getEnumByText(cn).getText();
	
	cn = cn == null ? "0" : UploadInfoEnum.getEnumByText(cn).getLimit();
	
	int sizeLimit = ( Integer.parseInt(cn) );
	
	if( sizeLimit > 0 ){
		sizeLimit = sizeLimit * 1024 * 1024 ;
	}
	
	MoveAttachedFile mAttach = MoveAttachedFile.getInstance();
	MultipartFileUpload uploadComponent = new MultipartFileUpload();         
                
   String zipfile = "d:/inetpub/wwwroot" +zipfilename ;  //�������� 
       
  /* 
   File zf = new File(zipfile);	
      
	File root  =  zf.getParentFile();
		
	String path1 = zf.getAbsolutePath();
			
	path1 = path1.substring(root.getAbsolutePath().length()).replace(File.separatorChar, '/');
		   
	if ( path1.startsWith("/")) path1 = path1.substring(1);
	
	if ( zf.isDirectory() && !path1.endsWith("/")) path1 += "/" ;
		 	
	//	 	file.length() // file size
	
	*/
	
	
	File zf = new File(zipfile);	
		
	String filename=zf.getName();
		
	String zfile = "";
   	int pos = filename.lastIndexOf(".");
	if ( pos >  0){
				zfile = filename.substring(0, pos);   //zip ���ϸ� 
	}
	
   String outputFolder = "d:/inetpub/wwwroot/ziptemp/"+zfile;   //������ Ǯ ����  
   String outpath = "/ziptemp/"+zfile;  
    
   int BUFFER_SIZE = 1024;
   int size;
   byte[] buffer = new byte[BUFFER_SIZE];

   try {
            File f = new File(outputFolder);
            if(!f.isDirectory()) {
                f.mkdirs();
            }
            ZipInputStream zin = new ZipInputStream(new BufferedInputStream(new FileInputStream(zipfile), BUFFER_SIZE));
            try {
                ZipEntry ze = null;
                while ((ze = zin.getNextEntry()) != null) {
                    String path = outputFolder  +"/"+  ze.getName();
                    String str= ze.getName().substring(0, ze.getName().lastIndexOf("."));
                          
					    if (str.length() > 0 && (  str.substring(str.length()-2, str.length()).equals("10")  || str.charAt(str.length()-1)=='4' || str.charAt(str.length()-1)=='9'  ||  str.charAt(str.length()-1)=='1' ||  str.charAt(str.length()-1)=='2' ) ) {  //�������� ���Ǽ�	, ��༭ �� ��	 , cms-rtype=1�ΰ�� 		
					 //    if (str.length() > 0 && (  str.charAt(str.length()-1)=='4' || str.charAt(str.length()-1)=='9'  ||  str.charAt(str.length()-1)=='1' ||  str.charAt(str.length()-1)=='2' ) ) {  //�������� ���Ǽ�	, ��༭ �� ��	 , cms-rtype=1�ΰ�� 		 				 				
				
		                    if (ze.isDirectory()) {
		                        File unzipFile = new File(path);
		                        if(!unzipFile.isDirectory()) {
		                            unzipFile.mkdirs();
		                        }
		                    }
		                    else {
		                        FileOutputStream fout = new FileOutputStream(path, false);
		                        BufferedOutputStream bout = new BufferedOutputStream(fout, BUFFER_SIZE);
		                        try {
		                            while ( (size = zin.read(buffer, 0, BUFFER_SIZE)) != -1 ) {
		                                bout.write(buffer, 0, size);
		                            }
							
		                            zin.closeEntry();
		                            
		                        }catch (Exception e) {
		                            
		                        }
		                        finally {
		                            bout.flush();
		                            bout.close();
		                        }
		                    }		                   
		          
		               
		                   if (str.charAt(str.length()-1)=='1' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "17" , outpath , ze.getName() ); //��༭ �� 
		                   if (str.charAt(str.length()-1)=='2' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "18" , outpath , ze.getName() ); //��༭ ��  
		         		   
		         		   if (str.substring(str.length()-2, str.length()).equals("10")  )    mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "38" , outpath , ze.getName() ); // cms (rtype=1�ΰ�쿡�� �ش� ) - file size 	
		                 
			               if ( 	gubun.equals("M") ) { //����Ʈ�� 		
			                 	  if (str.charAt(str.length()-1)=='4' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "37" , outpath , ze.getName() ); //�������� ���Ǽ�  
			               }
			       
			               if ( 	!gubun.equals("M") ) { //����Ʈ �ƴϸ� 		
			                 	  if (str.charAt(str.length()-1)=='9' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "37" , outpath , ze.getName() ); //�������� ���Ǽ�  
			               }
		                 
		                   
                    }  //��༭, ���Ǽ��� 
                     
                }  //while
                //�������� ���� 
                uploadComponent.deleteFolder(outputFolder);
                out.println("��ϵǾ����ϴ�.");
            }catch (Exception e) {
                  out.println("An exception occurred: " + e.getMessage()); 
            }
            finally {
                zin.close();
            }
          
        }
        catch (Exception e) {
        
         out.println("An exception occurred: " + e.getMessage());
           
   }  //��������   
    
%>  