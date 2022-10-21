package acar.util;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.HashMap;

import acar.database.*;
import java.sql.*;
import java.io.*;
 import java.sql.*;
 import java.util.*;

import oracle.jdbc.*;
import oracle.sql.BLOB;

import java.awt.Graphics; 
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import javax.imageio.ImageIO;
import java.awt.Graphics2D;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import acar.beans.AttachedFile;

import common.AttachedDatabase;

//import moveAttachedInfo.Thumbnail;

public class MultipartFileUpload {

	private static  MultipartFileUpload instance = null;
	
	
	public MultipartFileUpload()
	{
		
	}
	static synchronized public MultipartFileUpload getInstance() 
	{
		if (instance == null) 
		{
			instance = new MultipartFileUpload();
		}
		return instance;
	}

	private DBConnectionManager connMgr = null;
	private Connection conn = null;
	
	private String WAS_ROOT = "";
	/**
	 * ���� ���� ������ �����ܰ� �� ������ �ܰ�
	 * @author Dev.ywkim
	 * @since 2015.04.16
	 * @param request : HttpServletRequest ��ü
	 * @param workdDir : ������ ���丮
	 * @param contentSeq : �ش� ������ �ڵ� ( ������ �ڵ尡 ������ 0 )
	 * @param maxPostSize : �ִ������
	 * @param isInsertDb : DB���� ����
	 * @throws Exception
	 * @throws IOException
	 */
	public List<AttachedFile> MultipartRequestFileSave(HttpServletRequest request
			  , int maxPostSize
			  , String savePath
			  , boolean isInsertDb
			) throws Exception, IOException {
			
		  // Sanity check values
			if (request == null)
				throw new IllegalArgumentException("request cannot be null");
			if (maxPostSize <= 0) {
				//throw new IllegalArgumentException("maxPostSize must be positive");
			}
			WAS_ROOT = request.getRealPath("/");
			
			  Calendar cal = Calendar.getInstance( );
				
			  String year = Integer.toString( cal.get(Calendar.YEAR) );
			  int monthCnt = cal.get(Calendar.MONTH) + 1;
			  String month =  ( monthCnt < 10 ? "0" : "" )  + Integer.toString( monthCnt );
			
			
			  String path = "/"+Webconst.UploadPath.DEFAULT_SAVE_ROOT+"/" + savePath + "/" + year + "/" + month + "/";
			
			  File dir = new File(WAS_ROOT + path);
			  
			  System.out.println(WAS_ROOT + path);
			
			  try {
				  if (!dir.isDirectory()) {
					  dir.mkdirs();
				  }
			  }catch (SecurityException e) {}

			  if (!dir.canWrite())
				  throw new IllegalArgumentException("Not writable: Folder " );
			  
			List<AttachedFile> files = save(request, maxPostSize, path);
		 
			 if( files != null && files.size() > 0 ){
				 
				 if(isInsertDb){
					 AttachedDatabase atd = AttachedDatabase.getInstance();
					 
					 if(!atd.insertAttachedFileForMulti(files)){
						 files.clear();
					 }
				 }
			 }
		 
		 return files;
	  }
	  
	/**
	 * ���� ������ �������� ����ҿ� ����Ǵ� ����
	 * @author Dev.ywkim
	 * @since 2015.04.16
	 * @param request : HttpServletRequest ��ü
	 * @param contentCode : ������ ������ �ڵ�
	 * @param path : ���� ����������� ���
	 * @param maxSize : �ִ������
	 * @return
	 * @throws Exception
	 */
	  public List<AttachedFile> save( HttpServletRequest request
			  , int maxSize
			  , String savePath
			  ) throws Exception{
		  boolean isMultipart = ServletFileUpload.isMultipartContent(request);
		  List<AttachedFile> files = new ArrayList<AttachedFile>();
		  LoginBean login 	= LoginBean.getInstance();
		  		  
		//  DBConnectionManager connMgr = null;
		//   Connection conn = null;
		  connMgr = DBConnectionManager.getInstance();
		  conn = connMgr.getConnection("acar");
		  	
		 Statement stmt = null; 
		 PreparedStatement pstmt = null;
		 ResultSet rs = null;
		 String query = null;
		 String i_sql = null;
		 String u_sql = null;
		 int re = -1;

		 BLOB blob;
	//	 File file ;
    	 FileInputStream is;
    	 OutputStream os;
  //     BufferedImage inputImage = null;
	    String re_file = "";
	    
	    
		  if (isMultipart) { 
			  File temporaryDir = new File(WAS_ROOT + savePath);
			  int cnt = 0;
			  
			  DiskFileItemFactory factory = new DiskFileItemFactory();
			  factory.setSizeThreshold(1 * 1024 * 1024);
			  factory.setRepository(temporaryDir);
		
			  ServletFileUpload upload = new ServletFileUpload(factory);
			  upload.setSizeMax(-1);
			  
			  List<FileItem> items = upload.parseRequest(request);
			  Iterator<FileItem> iter=items.iterator();
			  
			  List<String> codes = new ArrayList<String>();
			  List<String> seqs = new ArrayList<String>();
			  
			  while(iter.hasNext()){  
				  
				  FileItem fileItem = (FileItem) iter.next();
				  if(fileItem.isFormField()){
					  
					  if( fileItem.getFieldName().equals(Webconst.Common.contentCodeName) ){
						  codes.add(fileItem.getString("euc-kr"));
					  }else if( fileItem.getFieldName().equals(Webconst.Common.contentSeqName) ){
						  seqs.add(fileItem.getString("euc-kr"));
					  }
				  }
			  }
			  
			  iter=items.iterator();
			  
			  int itemsNumber = 0;

			  while(iter.hasNext()){  
				  
				  FileItem fileItem = (FileItem) iter.next();
				  if(!fileItem.isFormField()){
					  if(fileItem.getSize()>0){
						
						  String workdDir = codes.get(cnt);

						  if( maxSize > 0 && maxSize < fileItem.getSize() ){
							  System.out.println("÷������ ���� �ȵ� : ["+workdDir+"] ���ϸ�("+fileItem.getName()+") / ���뷮(" + maxSize + ")/ ���Ͽ뷮(" + fileItem.getSize() +")" );
							  fileItem.delete();
							  continue;
						  }						 										  						  
							
						  AttachedFile file = new AttachedFile();
						  
						  String resize_name = "";

						  String fieldName		=	fileItem.getFieldName();
						  String oriName		=	fileItem.getName();
						  String contentType	=	fileItem.getContentType();
						  String saveName		=	new SimpleDateFormat("yyyyMMddHHmmssSSS" , Locale.getDefault()).format(Calendar.getInstance().getTime());
						  String ori_saveName = "";
						  
						  boolean isInMemory	=	fileItem.isInMemory();
						  
						  long sizeInBytes		=	fileItem.getSize();
												
								  //cms - 300k���ϸ� ����												  						
						   if  ( workdDir.equals("LC_SCAN")  && seqs.get(itemsNumber).substring(20).equals("38")   && fileItem.getSize() > 307000 ) {
						  	  System.out.println("÷������ ���� �ȵ�  TIF : ���ϸ�("+fileItem.getName()+") / ���뷮( 307000 )/ ���Ͽ뷮(" + fileItem.getSize() +")" );
							  fileItem.delete();
							  continue;
						  }
							
																								  
						  //���ϸ� ����  LC_SCAN_20150610164337276_0.jpg  getRandomText()						  
						  oriName = oriName.replaceAll("\\\\", "��");
						  
						  if( oriName.lastIndexOf("��") >= 0 ){
							  int ind = oriName.lastIndexOf("��");
							  oriName = oriName.substring( ind+1  );
						  }
						  
						  int lastDotIndex = oriName.lastIndexOf(".");						  
						  if(lastDotIndex == -1){
							  throw new IllegalArgumentException("���� Ȯ���ڰ� �����ϴ�.");
						  }
							
						  String prefix = oriName.substring(0,lastDotIndex);
						  String surfix = oriName.substring(lastDotIndex,oriName.length());			
						
						  saveName = workdDir + "_" + saveName + "_" + cnt + surfix;
						  ori_saveName = "ORI_" + saveName;  //apprsl ���ø� ���� 
						  
						  SecurityUtil securityUtil = new SecurityUtil();
						  
						  String session_user = login.getCookieValue(request, "fmsCookie");
						  String session_user_id = "000000";
						  
						  if (!workdDir.equals("ESTI_SPE")   ) { 
								  session_user = securityUtil.decodeAES(session_user);
								  session_user = session_user.replaceAll(Webconst.Common.FMS3_COOKIE_VALUE, "").trim();
		
								  if( session_user != null && session_user.length() > 0 ){
									  String[] userInfo = session_user.split("\\|");
									  if( userInfo.length == 2 ){
										  session_user_id = userInfo[1];
									  }
								  }else{
									  throw new IllegalArgumentException("Is not login");  
								  }
						  }
						  
						  file.setContentCode(workdDir);
						  file.setContentSeq(seqs.get(itemsNumber));
						  file.setFileName(oriName);
						  file.setFileSize(sizeInBytes);
						  file.setFileType(contentType);
						  file.setSaveFile(saveName);
						  file.setSaveFolder(savePath);
						  file.setRegUser(session_user_id);
			  							
						  files.add(file);		  
										  								  
						  try{
						  				
						  	  if  ( file.getContentCode().equals("APPRSL") ) {
							  	
							   	   File oriuploadedFile	= new File(WAS_ROOT + savePath,ori_saveName);
							  	   fileItem.write(oriuploadedFile);
						  							  	   
							  	   BufferedImage inputImage = ImageIO.read(oriuploadedFile);
        
								   int width = 800;
								   int height = 600;
								       								  								        
								    BufferedImage outputImage = new BufferedImage( width, height, BufferedImage.TYPE_INT_RGB);
								    Graphics2D g = outputImage.createGraphics();
					
								    g.drawImage(inputImage, 0, 0, width, height, null);
								     								 
								//	    File uploadedFile	= new File(WAS_ROOT + savePath,saveName);    
															
									    ImageIO.write(outputImage, "jpg", new File(WAS_ROOT + savePath,saveName));
							
										 oriuploadedFile.delete();
										
								    //   fileItem.delete();
							            
							  } 			  
						  	 														   
								  File uploadedFile	= new File(WAS_ROOT + savePath,saveName);										  
							                                                               					
								  	fileItem.write(uploadedFile);
								  	
							 
						//	}
							 					  
						//cms���Ǽ��� ��� blob ����Ÿó��						
							   if  ( file.getContentCode().equals("LC_SCAN")  && file.getContentSeq().substring(20).equals("38")    ) {
                                                                                                                                                									                                                               
                               pstmt = conn.prepareStatement("INSERT INTO IMG_BLOB_FILE (SAVE_FILE, SAVE_FOLDER, IMG_FILE ) VALUES ( ?,  ?, empty_blob())");
							
								      pstmt.setString(1,  file.getSaveFile());
								      pstmt.setString(2,  file.getSaveFolder());
								      pstmt.execute();
								      
								      pstmt = conn.prepareStatement("select IMG_FILE from IMG_BLOB_FILE where SAVE_FILE = ? and  SAVE_FOLDER = ?  for update");
   								      pstmt.setString(1,  file.getSaveFile());
								      pstmt.setString(2,  file.getSaveFolder());
             	                                                    	     rs = pstmt.executeQuery();
  								     rs.next();
      							
      								      //Use the OracleDriver resultset, we take the blob locator
								      blob = ((OracleResultSet)rs).getBLOB("IMG_FILE");
									
								      is = new FileInputStream(uploadedFile); //Create a stream from the file
									     // JDBC 2.0
								      os = blob.getBinaryOutputStream(); //get the output stream from the Blob to insert it
     					
     								      byte[] chunk = new byte[blob.getChunkSize()];
								      int i=-1;
								      System.out.println("Inserting the Blob");
								      while((i = is.read(chunk))!=-1)
								      {
								        os.write(chunk,0,i); //Write the chunk
								        System.out.print('.'); // print progression
								      }
								
								      // When done close the streams
								      is.close();
								      os.close();
								
								      //Close the statement and commit
								      rs.close();
								      pstmt.close();
      								   conn.commit();
     							      conn.close();	
     															
                           } 	
                           
                      //�ű�Ȩ������������ ����� ������ - 20170419
                           //if(file.getContentCode().toLowerCase().trim().equals("apprsl") && file.getContentSeq().substring(seqs.get(itemsNumber).length() - 1).equals("1"))
	                 		// {
								//					System.out.println("===========apprl======= ����� ������");
	                            	//			Thumbnail.createThumb((new StringBuilder(String.valueOf(WAS_ROOT))).append(file.getSaveFolder()).append(file.getSaveFile()).toString(), (new StringBuilder(String.valueOf(WAS_ROOT))).append(file.getSaveFolder()).append("thum/").append(file.getSaveFile()).toString(), 71, 53);
	                            		//		System.out.println("==========thumbnail========== ����� ���� �Ϸ�");
	                      //  }					 
                                                     					  
							  fileItem.delete();
							  
							  
						  }catch(IOException ex) {  }	
						  finally{
							 try
							{
							//	if(rs != null) rs.close();
							//	if(pstmt != null) pstmt.close();
								if(conn != null) connMgr.freeConnection("acar", conn);
								conn = null;								
							}
								catch(Exception se)
							{
							}
							
						}
							
						  cnt++;
					  }

					  itemsNumber++;
				  }
			  }
		  }else{
			  System.out.println("���ڵ� Ÿ���� multipart/form-data �� �ƴ�.");
		  }	  
		  
		  
		  return files;
	  }
	  
	  /**
	   * ÷������ ���� ��ȸ ( ����. Seq ���� )
	   * @author Dev.ywkim
	   * @since 2015. 04. 16
	   * @param request
	   * @param attachedSeq : ÷������ ������
	   * @return
	   * @throws Exception
	   */
	  public AttachedFile getAttachedInfoForSeq( HttpServletRequest request , int attachedSeq ) throws Exception{
			 
		  AttachedDatabase atd = AttachedDatabase.getInstance();
		  AttachedFile file = new AttachedFile();
		  
		  List<AttachedFile> files = atd.getAttachedFileInfoList("", "", attachedSeq);
		  
		  if( files != null && files.size() > 0 ){
			  file = files.get(0);
		  }
		 	 
		  return file;
	  }
	  
	    public AttachedFile getAttachedInfoForSeq( HttpServletRequest request , int attachedSeq ,  int attachedSize ) throws Exception{
			 
		  AttachedDatabase atd = AttachedDatabase.getInstance();
		  AttachedFile file = new AttachedFile();
		  
		  List<AttachedFile> files = atd.getAttachedFileInfoList("", "", attachedSeq, attachedSize);
		  
		  if( files != null && files.size() > 0 ){
			  file = files.get(0);
		  }
		 	 
		  return file;
	  }
	  
	  
	  /**
	   * ÷������ ���� ��ȸ( ����. ����Ʈ ���� )
	   * @author Dev.ywkim
	   * @since 2015. 04. 16
	   * @param request : HttpServletRequest ��ü
	   * @param contentCode : ������ �ڵ�
	   * @param contentSeq : ������ ������
	   * @return
	   * @throws Exception
	   */
	  public List<AttachedFile> getAttachedInfoList( HttpServletRequest request , String contentCode, String contentSeq ) throws Exception{
		  
			 AttachedDatabase atd = AttachedDatabase.getInstance();
			 List<AttachedFile> files = null;
			 
			 files = atd.getAttachedFileInfoList(contentCode, contentSeq);
			 
		  return files;
	  }
	  
	  /**
	   * ���ϻ���ó��( ����, ������ ��� )
	   * @author Dev.ywkim
	   * @since 2015. 04. 17
	   * @param Seq : ÷������ ������
	   * @param filePath : ���� ���� ���� ���
	   * @throws Exception 
	   */
	  public void deleteFileForAllInfo(int Seq, String filePath ) throws Exception{
		  deleteFileForPhysical(filePath);
		  deleteFileForLogical(Seq);
	  }
		
	  /**
	   * ���� ���� ó��( ������ )
	   * @author Dev.ywkim
	   * @since 2015. 04. 17
	   * @param filePath : ���� ���� ���� ���
	   */
	  public void deleteFileForPhysical( String filePath ){
		  try{
			  File file = new File(filePath);
			  if (file.exists()){			
				  file.delete();
				  System.out.println("���� ���� ���� ���� �Ϸ�");
			  }else{
				  System.out.println("���� ������ �������� ����.");
			  }
		  }catch(Exception e){}
	  }
	  
	  /**
	   * ���� ���� ó�� ( ���� )
	   * @author Dev.ywkim
	   * @since 2015. 04. 17
	   * @param Seq
	   */
	  public void deleteFileForLogical( int seq )  throws Exception {
		  if( seq > 0 ){
			  AttachedDatabase atd = AttachedDatabase.getInstance();
			  atd.deleteFileForLogical(seq);
		  }else{
			  System.out.println("�߸��� ��û");
		  }
	  }	
	  
	  
	 public String getRandomText()
    	{
	    	String args1[] = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};
	
	    	String result = "";
	
	    	for (int i = 0; i < 10; i++) {
	    		int a = (int) (Math.random() * 36);
	
	    		result += args1[a];
	    	}
	
	    	return result;
    	}
   
}
