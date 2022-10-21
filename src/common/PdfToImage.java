package common;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.rendering.ImageType;
import org.apache.pdfbox.rendering.PDFRenderer;
import org.apache.pdfbox.tools.imageio.ImageIOUtil;

import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

import acar.database.DBConnectionManager;
import acar.exception.DataSourceEmptyException;
import acar.exception.DatabaseException;

public class PdfToImage{

    private static PdfToImage instance;
    private DBConnectionManager connMgr;   
    private final String DATA_SOURCE = "acar"; 
   
        
    public static synchronized PdfToImage getInstance() throws DatabaseException {
        if (instance == null)
            instance = new PdfToImage();
        return instance;
    }
    
    private PdfToImage() throws DatabaseException {
        connMgr = DBConnectionManager.getInstance();
    }

    private String WAS_ROOT = "D:/inetpub/wwwroot";       
    private String OUTPUT_DIR = "/pdfbox";

   // if (str.charAt(str.length()-1)=='1' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "17" , outpath , ze.getName() ); //��༭ �� 
    //     if (str.charAt(str.length()-1)=='2' )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "18" , outpath , ze.getName() ); //��༭ �� 
    
	public void conversionPdf2Img (String zipfilename, String m_id, String l_cd , String rent_st, String reg_id ) throws Exception{

        try {
        	
            String zipfile = WAS_ROOT +zipfilename ; //pdf  ���� 
        	   
            File file = new File(zipfile);	
       	    PDDocument document = PDDocument.load(file);
        	
        //	int pageCount = document.getNumberOfPages();
                 	
            PDFRenderer pdfRenderer = new PDFRenderer(document);
            
            String fileName=file.getName(); // pdf ���ϸ� 
                    
			int pos = fileName .lastIndexOf(".");
			String pdfName = fileName.substring(0, pos);
            
            String resultImgPath = WAS_ROOT+ OUTPUT_DIR; //�̹����� ����� ���
                        
            for (int i=0; i<2; i++) { //��༭��            	
             
                String imgFileName =  pdfName + "_"+ i + ".jpg";
                
          //      System.out.println("imgFileName="+ imgFileName);
                //DPI ����
                BufferedImage bim = pdfRenderer.renderImageWithDPI(i, 96, ImageType.RGB);     
               
                // �̹����� �����.
                ImageIOUtil.writeImage(bim, resultImgPath + "/"+imgFileName , 96);
                
                // ��༭ ��/�ڸ�  db ���               
                if ( i == 0 ) MoveAttachedFile.getInstance().insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "17" , OUTPUT_DIR , imgFileName ); //��༭ �� 
                if ( i == 1 ) MoveAttachedFile.getInstance().insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "18" , OUTPUT_DIR , imgFileName ); //��༭ �� 

            	new File(WAS_ROOT+ OUTPUT_DIR + "/" + imgFileName).delete(); //pdfgateway ���� ����	  
            }
            
            document.close(); //��� ����� PDF ������ �ݴ´�.  //������ �����߰��ؾ� ��        
                        	
         
        } catch (IOException e){
            System.err.println("Exception while trying to create jpg document - " + e);
        }
    }
	
	public void conversionPdf2Img (String zipfilename ) throws Exception{

        try {
        	
            String zipfile = WAS_ROOT +zipfilename ; //pdf  ���� 
        	   
            File file = new File(zipfile);	
       	    PDDocument document = PDDocument.load(file);
        	
        //	int pageCount = document.getNumberOfPages();
                 	
            PDFRenderer pdfRenderer = new PDFRenderer(document);
            
            String fileName=file.getName(); // pdf ���ϸ� 
                    
			int pos = fileName .lastIndexOf(".");
			String pdfName = fileName.substring(0, pos);
            
            String resultImgPath = WAS_ROOT+"/"+ OUTPUT_DIR; //�̹����� ����� ���
                        
            for (int i=0; i<2; i++) { //��༭��            	
                String imgFileName = resultImgPath + "/" + pdfName + "_"+ i + ".jpg";
                
                //DPI ����
                BufferedImage bim = pdfRenderer.renderImageWithDPI(i, 96, ImageType.RGB);     
               
                // �̹����� �����.
                ImageIOUtil.writeImage(bim, imgFileName , 96);

                // ��༭ ��/�ڸ�  db ��� 
         //        if ( i= 0 )   mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "17" , outpath , ze.getName() ); //��༭ �� 
                //  if (str.charAt
                //���� �Ϸ�� �̹����� list�� �߰��Ѵ�.
            //    savedImgList.add(makeDownloadUrl4Uuid(imgFileName));
            }
            document.close(); //��� ����� PDF ������ �ݴ´�.                       
         
        } catch (IOException e){
            System.err.println("Exception while trying to create pdf document - " + e);
        }
    }

}