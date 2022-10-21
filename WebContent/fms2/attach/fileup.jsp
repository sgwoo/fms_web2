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

 //20201211 CONTENT_CODE 필수 
	
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String rent_st = request.getParameter("rent_st")==null?"":request.getParameter("rent_st");
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String zipfilename = request.getParameter("ZIPFILENAME")==null?"result.zip":request.getParameter("ZIPFILENAME");  // pdf 
	    
   String cn = request.getParameter("contentCode");   //LC_SCAN
    
	String savePath = "";

	savePath = cn == null ? UploadInfoEnum.LC_SCAN.getText() : UploadInfoEnum.getEnumByText(cn).getText();
	
	cn = cn == null ? "0" : UploadInfoEnum.getEnumByText(cn).getLimit();
	
	int sizeLimit = ( Integer.parseInt(cn) );
	
	if( sizeLimit > 0 ){
		sizeLimit = sizeLimit * 1024 * 1024 ;
	}
	
	MoveAttachedFile mAttach = MoveAttachedFile.getInstance();
     
                
   String zipfile = "d:/inetpub/wwwroot" +zipfilename ;  //pdf  파일 
   
   File zf = new File(zipfile);	
		
	String path = zf.getParentFile().toString();
	
	//System.out.println("path="+ path); //path=d:\inetpub\wwwroot\data\rent_file\2021\05\26

	path = path.substring(path.length()-26, path.length());
		
	String filename=zf.getName();
		
			
	try {    
	    mAttach.insertAttachedFileForMove(m_id, l_cd, rent_st, reg_id,  "1" , path, filename ); //최초계약서 
	    out.println("등록되었습니다.");
	
	 } catch(IOException ioe){
	  out.println("An exception occurred: " + ioe.getMessage());
	 
	  }
   
    
%>  