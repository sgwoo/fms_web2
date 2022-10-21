package common;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Calendar;
import java.util.Iterator;
import java.util.Locale;

import java.sql.*;
import java.io.*;

import acar.beans.AttachedFile;
import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

import oracle.sql.BLOB;
import oracle.jdbc.OracleResultSet;

import java.io.*;
import java.text.SimpleDateFormat;
import javax.activation.MimetypesFileTypeMap;

public class MoveAttachedFile{

    private static MoveAttachedFile instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
 
    public static synchronized MoveAttachedFile getInstance() throws DatabaseException {
        if (instance == null)
            instance = new MoveAttachedFile();
        return instance;
    }
    
    private MoveAttachedFile() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    private String WAS_ROOT = "D:/inetpub/wwwroot";
    private String DEFAULT_SAVE_ROOT = "attach";
           
/*
	public void insertAttachedFileForMove(String m_id, String l_cd , String rent_st, String reg_id, String gubun, String zfile, String zfilename) throws DatabaseException, DataSourceEmptyException {
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
	     
		int count = 0;
		   
	    Object obj = null;
	    Object obj1 = null;
	    int i = 0;
	    ArrayList lastRecord = null;
	  	         
       Statement stmt = null;
       ResultSet rs = null;
       String query = "";
       String seq = m_id+l_cd+rent_st+gubun;
       
       String savefolder="/ziptemp/"+zfile;
                 
       query  = "   SELECT 	SEQ    , CONTENTCODE    , CONTENTSEQ    , SAVE_FILE    , SAVE_FOLDER    , DECODE( REG_ID, NULL, '000000', REG_ID ) AS REG_ID 	FROM ( " +
      			"     SELECT  0 AS SEQ , 'LC_SCAN' AS CONTENTCODE , '"+seq+"' AS contentSeq , '" +  zfilename + "' as save_file , '"+ savefolder + "' AS save_folder, '"+reg_id + "' as REG_ID  FROM dual 	   )  ";
       
  //     System.out.println("query="+ query);
     
      try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);    
            
            ArrayList arraylist = new ArrayList();
            HashMap hashmap = new HashMap();

            hashmap.put("LC_SCAN", "lc_scan");
          
			String s2 = "";
			ArrayList arraylistLast = new ArrayList();

            do
            {
                if(!rs.next()) {
                    insertAttachedFile(s2, arraylist);
			 		break;
				}

                AttachedFile attachedfile = new AttachedFile();
                String s = rs.getString(4);   //파일
                s = s.trim().replaceAll("\\\\", "");
                String s1 = rs.getString(5);  //폴더 
                s1 = s1.trim().replaceAll("D:\\\\Inetpub\\\\wwwroot\\\\", "/");
                s1 = s1.trim().replaceAll("\\\\", "/");
                s2 = rs.getString(2); //contentcode 
                String s3 = (String)hashmap.get(s2.trim().replaceAll(" ", ""));
													
				File file = new File((new StringBuilder(String.valueOf(WAS_ROOT))).append(s1).append("/").append(s.toLowerCase()).toString());   //origin 
                if(file != null && file.isFile())
                {
                    String s4 = getFileCreateDate(file);
                    String s5 = s4.split("-")[0];
                    String s6 = s4.split("-")[1];
                    String s7 = (new MimetypesFileTypeMap()).getContentType(file);
                    String s8 = rs.getString(3);
                    s8 = s8.trim().replaceAll(" ", "");
                    String s9 = (new SimpleDateFormat("yyyyMMddHHmmssSSS", Locale.getDefault())).format(Calendar.getInstance().getTime());
                 //   System.out.println("s9="+s9);               
                    s3 = (new StringBuilder("/")).append(DEFAULT_SAVE_ROOT).append("/").append(s3).append("/").append(s5).append("/").append(s6).append("/").toString();

					File file1 = new File((new StringBuilder(String.valueOf(WAS_ROOT))).append(s3).toString());
                    try
                    {
                        if(!file1.isDirectory())
                            file1.mkdirs();
                    }
                    catch(SecurityException securityexception) { }
                    int l = s.lastIndexOf(".");
                    String s10 = s.substring(l, s.length());
                    if(s7.equals("application/octet-stream") && s10.indexOf("pdf") != -1)
                        s7 = "application/pdf";
                    else
                    if(s7.equals("application/octet-stream") && s10.indexOf("png") != -1)
                        s7 = "image/png";
                    s9 = (new StringBuilder(String.valueOf(s2))).append("_").append(s9).append("_").append(getRandomText()).append(s10).toString();
                //    System.out.println("s9="+s9);	
                    try
                    {
                        FileInputStream fileinputstream = new FileInputStream(file);
                        FileOutputStream fileoutputstream = new FileOutputStream((new StringBuilder(String.valueOf(WAS_ROOT))).append(s3).append("/").append(s9).toString());
                        BufferedInputStream bufferedinputstream = new BufferedInputStream(fileinputstream);
                        BufferedOutputStream bufferedoutputstream = new BufferedOutputStream(fileoutputstream);
                        int i1 = 0;
                        byte abyte0[] = new byte[1024];
                        while((i1 = bufferedinputstream.read(abyte0, 0, 1024)) != -1) 
                           
                        		bufferedoutputstream.write(abyte0, 0, i1);
		                        bufferedoutputstream.flush();
		                        bufferedoutputstream.close();
		                        bufferedinputstream.close();
		                        fileoutputstream.flush();
		                        fileoutputstream.close();
		                        fileinputstream.close();
		                 
		                        attachedfile.setContentCode(s2);
		                        attachedfile.setContentSeq(s8);
		                        attachedfile.setFileName(s);
		                        attachedfile.setFileSize(file.length());
		                        attachedfile.setFileType(s7);
		                        attachedfile.setSaveFile(s9);
		                        attachedfile.setSaveFolder(s3);
		                        attachedfile.setRegUser(rs.getString(6));
		                        attachedfile.setRegDate(s4);
		                        arraylist.add(attachedfile);
		                       
		                        if(i > 0 )
		                        {
		                            insertAttachedFile(s2, arraylist);
		                            arraylist.clear();
		                            arraylist = new ArrayList();
		                        }
		                        i++;
		                  }
                    catch(IOException ioexception)
                    {
                        System.out.println((new StringBuilder("파일복사 에러  : ")).append(ioexception.getMessage()).toString());
                    }
                }  // if
            } while(true);  //do 
            rs.close();
            stmt.close();
            arraylist.size();
        }
        catch(Exception exception)
        {
	           System.out.println((new StringBuilder("Exception : [er] ")).append(exception.getMessage()).toString());
				exception.printStackTrace();
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			con = null;
        }	            
   } 
           
   */
   
   // 
   public void insertAttachedFileForMove(String m_id, String l_cd , String rent_st, String reg_id, String gubun, String zfolder, String filename ) throws DatabaseException, DataSourceEmptyException {
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
	     
		int count = 0;
		   
	    Object obj = null;
	    Object obj1 = null;
	    int i = 0;
	    ArrayList lastRecord = null;
	  	         
       Statement stmt = null;
       PreparedStatement pstmt = null;
       ResultSet rs = null;
       ResultSet rs1 = null;
       BLOB blob;
       
        FileInputStream is;
    	 OutputStream os;
        
       String query = "";
       String seq = m_id+l_cd+rent_st+gubun;
                       
       query  = "   SELECT 	SEQ    , CONTENTCODE    , CONTENTSEQ    , SAVE_FILE    , SAVE_FOLDER    , DECODE( REG_ID, NULL, '000000', REG_ID ) AS REG_ID 	FROM ( " +
      			"     SELECT  0 AS SEQ , 'LC_SCAN' AS CONTENTCODE , '"+seq+"' AS contentSeq , '" +  filename + "' as save_file , '"+ zfolder + "' AS save_folder, '"+reg_id + "' as REG_ID  FROM dual 	   )  ";
       
    //   System.out.println("query="+ query);
     
      try {
            stmt = con.createStatement();
            rs = stmt.executeQuery(query);    
            
            ArrayList arraylist = new ArrayList();
            HashMap hashmap = new HashMap();

            hashmap.put("LC_SCAN", "lc_scan");
          
			  String s2 = "";
			
            do
            {
                if(!rs.next()) {    
                    insertAttachedFile(s2, arraylist);                 
			 		    break;
				}

                AttachedFile attachedfile = new AttachedFile();
                String s = rs.getString(4);   //파일
                s = s.trim().replaceAll("\\\\", "");
                String s1 = rs.getString(5);  //폴더 
                s1 = s1.trim().replaceAll("D:\\\\Inetpub\\\\wwwroot\\\\", "/");
                s1 = s1.trim().replaceAll("\\\\", "/");
                s2 = rs.getString(2); //contentcode 
                String s3 = (String)hashmap.get(s2.trim().replaceAll(" ", ""));
													
				   File ofile = new File((new StringBuilder(String.valueOf(WAS_ROOT))).append(s1).append("/").append(s.toLowerCase()).toString());   //origin
				 
				   				    
                if(ofile != null && ofile.isFile())
                {
                    String s4 = getFileCreateDate(ofile);
                    String s5 = s4.split("-")[0];
                    String s6 = s4.split("-")[1];
                    String s7 = (new MimetypesFileTypeMap()).getContentType(ofile);
                    String s8 = rs.getString(3);
                    s8 = s8.trim().replaceAll(" ", "");
                    String s9 = (new SimpleDateFormat("yyyyMMddHHmmssSSS", Locale.getDefault())).format(Calendar.getInstance().getTime());
                 //   System.out.println("s9="+s9);               
                    s3 = (new StringBuilder("/")).append(DEFAULT_SAVE_ROOT).append("/").append(s3).append("/").append(s5).append("/").append(s6).append("/").toString();

					    File file1 = new File((new StringBuilder(String.valueOf(WAS_ROOT))).append(s3).toString());  //directory까지만 
					    	
                    try
                    {
                        if(!file1.isDirectory())
                            file1.mkdirs();
                    }
                    catch(SecurityException securityexception) { }
                    int l = s.lastIndexOf(".");
                    String s10 = s.substring(l, s.length());
                    if(s7.equals("application/octet-stream") && s10.indexOf("pdf") != -1)
                        s7 = "application/pdf";
                    else
                    if(s7.equals("application/octet-stream") && s10.indexOf("png") != -1)
                        s7 = "image/png";
                    s9 = (new StringBuilder(String.valueOf(s2))).append("_").append(s9).append("_").append(getRandomText()).append(s10).toString();
                    
               //     System.out.println("s9="+s9);	
                    
                    try
                    {
                        FileInputStream fileinputstream = new FileInputStream(ofile);
                        FileOutputStream fileoutputstream = new FileOutputStream((new StringBuilder(String.valueOf(WAS_ROOT))).append(s3).append("/").append(s9).toString());
                        BufferedInputStream bufferedinputstream = new BufferedInputStream(fileinputstream);
                        BufferedOutputStream bufferedoutputstream = new BufferedOutputStream(fileoutputstream);
                        int i1 = 0;
                        byte abyte0[] = new byte[1024];
                        while((i1 = bufferedinputstream.read(abyte0, 0, 1024)) != -1) 
                           
                        		 bufferedoutputstream.write(abyte0, 0, i1);
		                        bufferedoutputstream.flush();
		                        bufferedoutputstream.close();
		                        bufferedinputstream.close();
		                        fileoutputstream.flush();
		                        fileoutputstream.close();
		                        fileinputstream.close();
		                 
		                        attachedfile.setContentCode(s2);
		                        attachedfile.setContentSeq(s8);
		                        attachedfile.setFileName(s);
		                        attachedfile.setFileSize(ofile.length());
		                        attachedfile.setFileType(s7);
		                        attachedfile.setSaveFile(s9);
		                        attachedfile.setSaveFolder(s3);
		                        attachedfile.setRegUser(rs.getString(6));
		                        attachedfile.setRegDate(s4);
		                        arraylist.add(attachedfile);	
		                        
		                        	                      
		                        System.out.println(" [ 전자계약서 ] attachedfile.getContentSeq()=" + attachedfile.getContentSeq() ); 		                			                
		                    		             
			                     	//cms동의서인 경우 blob 데이타처리		   if  ( workdDir.equals("LC_SCAN")  && seqs.get(itemsNumber).substring(20).equals("38")   && fileItem.getSize() > 307000 ) {				
								    if  ( attachedfile.getContentCode().equals("LC_SCAN")  && attachedfile.getContentSeq().substring(20).equals("38") &&   attachedfile.getFileSize()    < 307000  ) {
			                                System.out.println("  [ 전자계약서 ] attachedfile.getFileSize()  =" +  attachedfile.getFileSize() + ":" +attachedfile.getSaveFile()  + "|" + attachedfile.getSaveFolder()  ); 
			                              		                                                                                                                                                  									                                                               
			                               pstmt = con.prepareStatement("INSERT INTO IMG_BLOB_FILE (SAVE_FILE, SAVE_FOLDER, IMG_FILE ) VALUES ( ?,  ?, empty_blob())");
										
											      pstmt.setString(1,  attachedfile.getSaveFile());
											      pstmt.setString(2,  attachedfile.getSaveFolder());
											      pstmt.execute();
											      
											      pstmt = con.prepareStatement("select IMG_FILE from IMG_BLOB_FILE where SAVE_FILE = ? and  SAVE_FOLDER = ?  for update");
			   								      pstmt.setString(1,  attachedfile.getSaveFile());
											      pstmt.setString(2,  attachedfile.getSaveFolder());
			             	                rs1 = pstmt.executeQuery();
			  								      rs1.next();
			      							
			      								      //Use the OracleDriver resultset, we take the blob locator
											      blob = ((OracleResultSet)rs1).getBLOB("IMG_FILE");
												
											      is = new FileInputStream(ofile); //Create a stream from the file (압축해제폴더에 있는 파일)
												     // JDBC 2.0
											      os = blob.getBinaryOutputStream(); //get the output stream from the Blob to insert it
			     					
			     								   byte[] chunk = new byte[blob.getChunkSize()];
											      int ii=-1;
											      System.out.println("비대면  Inserting the Blob");
											      while((ii = is.read(chunk))!=-1)
											      {
											        os.write(chunk,0,ii); //Write the chunk
											        System.out.print('.'); // print progression
											      }
											
											      // When done close the streams
											      is.close();
											      os.close();
											
											      //Close the statement and commit
											      rs1.close();
											      pstmt.close();
			      								   con.commit();
			     							 //     con.close();			     															
			                    } 	
			                     
			                     if  ( attachedfile.getContentCode().equals("LC_SCAN")  && attachedfile.getContentSeq().substring(20).equals("38") &&   attachedfile.getFileSize()   > 307000  ) {
			                         	     System.out.println("첨부파일 저장 안됨 :  파일명("+attachedfile.getFileName()+") / 허용용량( 307000 )/ 파일용량( " + attachedfile.getFileSize() +" )" );
			                       	     arraylist.clear();
			                              arraylist = new ArrayList();
			                     }			                       
		                 }    
		                 
		                     
                    catch(IOException ioexception)
                    {
                        System.out.println((new StringBuilder("파일복사 에러  : ")).append(ioexception.getMessage()).toString());
                    }
                }  // if
            } while(true);  //do 
            rs.close();
            stmt.close();
            con.close();		
         //   arraylist.size();
        }
        catch(Exception exception)
        {
	           System.out.println((new StringBuilder("Exception : [er] ")).append(exception.getMessage()).toString());
			 	exception.printStackTrace();
        }finally{
            try{
                if(rs != null) rs.close();
                if(stmt != null) stmt.close();           
            }catch(SQLException _ignored){} 
            connMgr.freeConnection(DATA_SOURCE, con);
			  con = null;
        }	            
   }         
   
      
    public String getFileCreateDate(File file)
    {
        SimpleDateFormat simpledateformat = new SimpleDateFormat("yyyy-MM-dd HH:mm", Locale.KOREA);
        java.util.Date date = new java.util.Date(file.lastModified());
        String s = simpledateformat.format(date);
        return s;
    }
    
    public void insertAttachedFile(String s, List list)  throws DatabaseException, DataSourceEmptyException {
		
		Connection con = connMgr.getConnection(DATA_SOURCE);
		if(con == null)
			throw new DataSourceEmptyException("Can't get Connection !!");
	
        Object obj = null;
        String s1 = "";
        Statement stmt = null;
        int count = 0;
        
        s1 = " INSERT ALL ";
        for(Iterator iterator = list.iterator(); iterator.hasNext();)
        {
            AttachedFile attachedfile = (AttachedFile)iterator.next();
                         	
            s1 = (new StringBuilder(String.valueOf(s1))).append(" INTO  ACAR_ATTACH_FILE ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" VALUES ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" ( ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t0 ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getContentCode()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getContentSeq()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getFileName()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getFileSize()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getFileType()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getSaveFile()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getSaveFolder()).append("' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'").append(attachedfile.getRegUser()).append("' ").toString();
          //  s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,TO_DATE('").append(attachedfile.getRegDate().split(" ")[0]).append("') ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t, sysdate ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" \t\t,'N' ").toString();
            s1 = (new StringBuilder(String.valueOf(s1))).append(" ) ").toString();
        }

        s1 = (new StringBuilder(String.valueOf(s1))).append(" SELECT * FROM DUAL ").toString();
        
        System.out.println("=======MoveAttachedInfo====== : " +  s1 );
        
       try{
            con.setAutoCommit(false);
            stmt = con.createStatement();
            count = stmt.executeUpdate(s1);
            stmt.close();            
            con.close();
            
        }catch(SQLException se){
			 throw new DatabaseException();
        }finally{
            try{
                if(stmt != null) stmt.close();
            }catch(SQLException _ignored){}
            connMgr.freeConnection(DATA_SOURCE, con);
			  con = null;
        }
        
	}
   
   
   
    public  String getRandomText() throws IOException {  
    	String args1[] = {"0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"};

    	String result = "";

    	for (int i = 0; i < 10; i++) {
    		int a = (int) (Math.random() * 36);

    		result += args1[a];
    	}

    	return result;
    }

}
