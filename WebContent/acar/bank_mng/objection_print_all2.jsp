<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<%@ page import="java.util.*,java.awt.print.*"%>
<%@ page import="acar.insur.*, java.io.*, org.apache.pdfbox.pdmodel.PDDocument,org.apache.pdfbox.multipdf.PDFMergerUtility"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage, org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject, org.apache.pdfbox.pdmodel.PDPageContentStream"%>

<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<jsp:useBean id="FineGovBn" 	scope="page" class="acar.forfeit_mng.FineGovBean"/>
<jsp:useBean id="FineDocBn" 	scope="page" class="acar.forfeit_mng.FineDocBean"/>
	
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String st_dt = request.getParameter("st_dt")==null?"":request.getParameter("st_dt");
	String end_dt = request.getParameter("end_dt")==null?"":request.getParameter("end_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String sort = request.getParameter("sort")==null?"":request.getParameter("sort");
	String asc = request.getParameter("asc")==null?"":request.getParameter("asc");
	
	String doc_id = request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String gov_id = request.getParameter("gov_id")==null?"":request.getParameter("gov_id");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	FineDocBn = FineDocDb.getFineDoc(doc_id);
	FineGovBn = FineDocDb.getFineGov(FineDocBn.getGov_id());
	//과태료리스트
	Vector FineList = FineDocDb.getBankDocAllLists2(doc_id);
	
	if(FineDocBn.getH_mng_id().equals(""))		FineDocBn.setH_mng_id("000026");
	if(FineDocBn.getB_mng_id().equals(""))		FineDocBn.setB_mng_id("000144");
		
	String c_id[] = new String[FineList.size()];
	String l_cd[] = new String[FineList.size()];
	String m_id[] = new String[FineList.size()];
	String c_no[] = new String[FineList.size()];


	if(FineList.size()>0){
		for(int i=0; i<FineList.size(); i++){ 
			Hashtable ht = (Hashtable)FineList.elementAt(i);
			
			c_id[i] = String.valueOf(ht.get("CAR_MNG_ID"));
			l_cd[i] = String.valueOf(ht.get("RENT_L_CD"));	
			m_id[i] = String.valueOf(ht.get("RENT_MNG_ID"));	
			c_no[i] = String.valueOf(ht.get("CAR_NO"));	

	 	}
	} 

	String fileName ="";
	String saveFolder ="";
	String realFolder ="";
	String filePath = "";
	String fileType = "";

%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
</head>
<body leftmargin="15" topmargin="1"  >

<form action="" name="form1" method="POST" >
<div width='' border="0" cellpadding="0" cellspacing="0" align=center>
<%

for(int k=0; k<FineList.size(); k++){ 

	String car_mng_id = c_id[k];
	String rent_mng_id = m_id[k];
	String rent_l_cd = l_cd[k];
	String car_no = c_no[k];
	String rent_st = "1";

	int size = 0;

	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+rent_l_cd+rent_st;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();

	String mergeFilePath = "/httpd/www/attach/LC_SCAN/merge.pdf";
	
	for(int j=0; j< attach_vt.size(); j++){
		Hashtable aht = (Hashtable)attach_vt.elementAt(j);   
		
		fileName = String.valueOf(aht.get("SAVE_FILE"));		
		saveFolder = String.valueOf(aht.get("SAVE_FOLDER"));	
		
		realFolder = request.getRealPath("/");
		filePath = realFolder + "/" + saveFolder + fileName;	
		filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
		
		PDDocument doc = new PDDocument();   
		doc.save(mergeFilePath);
		PDPage blankPage = new PDPage();
		doc.addPage( blankPage );
		doc.save(mergeFilePath);
		
		File file = new File(mergeFilePath);
     	doc = PDDocument.load(file);
     	
     	PDPage page1 = doc.getPage(0);
     	PDPageContentStream contents = new PDPageContentStream(doc, page1);
     	PDImageXObject pdImage = PDImageXObject.createFromFile(filePath,doc);
     	contents.drawImage(pdImage, 70, 250);
     	contents.close();
     	doc.save(mergeFilePath);  
     	doc.close();
	}
		
	File mergeFile = new File(mergeFilePath);
	
	response.reset();
	
	response.setContentType("application/octet-stream;charset=EUC-KR");
	response.setHeader("Content-Transfer-Encoding", "binary;");
	response.setHeader("Pragma", "no-cache;");
	response.setHeader("Expires", "-1;");
	response.setHeader("Content-Type","application/pdf");
	//response.setHeader("Content-Disposition", "attachment;filename=find.jpg;");
	
	byte b[] = new byte[(int)mergeFile.length()];
	BufferedInputStream fin = new BufferedInputStream(new FileInputStream(mergeFile));
	BufferedOutputStream outs = new BufferedOutputStream(response.getOutputStream());
	int read = 0;
	while ((read = fin.read(b)) != -1){
		outs.write(b,0,read);
	}
	outs.close();					
	outs.flush();
	fin.close();
		
	
			
%>
<%}%>
</div>

</form>

</body>

</html>
