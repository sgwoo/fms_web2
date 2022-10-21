<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.awt.print.*,com.qoppa.pdf.*,com.qoppa.pdfPrint.*,acar.client.*"%>
<%@ page import="acar.cooperation.*, java.io.*, org.apache.pdfbox.pdmodel.PDDocument,acar.user_mng.*, acar.accid.*"%>
<%@ page import="org.apache.pdfbox.multipdf.PDFMergerUtility,org.apache.pdfbox.pdmodel.*, acar.util.*"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage, org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject, org.apache.pdfbox.pdmodel.PDPageContentStream"%>
<%@ page import="java.awt.*,java.nio.*, javax.imageio.*,com.sun.pdfview.*,java.awt.image.*, java.nio.channels.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
<jsp:useBean id="ic_db" scope="page" class="acar.insa_card.InsaCardDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] 	= request.getParameterValues("ch_cd");
	//content_code 받아오기
	String content_code = request.getParameter(Webconst.Common.contentCodeName);
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	String rent_l_cd = request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id");
	String rent_st = request.getParameter("rent_st");
	
	//계약조회
	Hashtable cont = as_db.getRentCase(rent_mng_id, rent_l_cd);
	
	//고객정보
	ClientBean client = al_db.getNewClient(String.valueOf(cont.get("CLIENT_ID")));
	
	ServletContext context = getServletContext();
	String fileName ="";
	String saveFolder ="";
	String realFolder ="";
	String filePath = "";
	String fileType = "";
	Vector vt = new Vector();
	
	int count = 0;
	
	int img_width 	= 680;
	int img_height 	= 1009;
	
	
	//재직자 조회
	Vector doc_vt = ic_db.InsaCardUserList(ck_acar_id);
	int doc_vt_size = doc_vt.size();
	int doc_seq =  ic_db.getSeq("1", Integer.toString(AddUtil.getDate2(1))); //재직증명서 순번

%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script src='/include/common.js'></script>
<script>
window.onload = function(){
    window.document.body.scroll = "auto";
}

</script>
<style>
body {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
    background-color: #ddd;
    font-family: "돋움", dotum, arial, helvetica, sans-serif;
}
* {
    box-sizing: border-box;
    -moz-box-sizing: border-box;
}
.paper {
    width: 210mm;
    min-height: 297mm;
    padding: 10mm; /* set contents area */
    margin: 10mm auto;
    border-radius: 5px;
    background: #fff;
    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
}
.content {
    padding: 20px;
   /*  border: 1px #888 solid ; */
    height: 273mm;
}
@page {
    size: A4;
    margin: 0;
}
@media print {
    html, body {
        width: 210mm;
        height: 297mm;
        background: #fff;
    }
    .paper {
        margin: 0;
        border: initial;
        border-radius: initial;
        width: initial;
        min-height: initial;
        box-shadow: initial;
        background: initial;
        page-break-after: always;
    }
   
}

</style>
<style>

.title{text-align:center;font-size:11pt;}  
.content1 {font-size:10pt;}
.content1 tr{ height:30px;}
  
.content2 {font-size:10pt;}
.content2 tr{ height:31px;}
  
.content3 {font-size:10pt;}
.content3 tr{ height:25px;}

.checklist{border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;font-size:9pt;}
.checkpoint{font-size:11px;text-align:right;}

.notice{font-size:9pt;}
.noticeList{margin-left:10px;margin-top:10px;}
.noticeListFirst{margin-bottom:4px;}
.noticeListMiddle{margin-left:18px;margin-bottom:4px;}
.noticeListLast{margin-left:18px;}

/*재직증명서  */
.doc1{line-height:130%; font-size:10.0pt; font-family:돋움;}
.style1 {font-size:10.5pt; border-right:solid #000000 1px;border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style2 {font-size:10.5pt; border-top:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style3 {font-size:10.5pt; border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style4 {font-size:10.5pt; border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style5 {font-size:10.5pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style6 {font-size:10pt; border-left:solid #000000 1px;border-right:solid #000000 1px;border-bottom:solid #000000 1px;padding:1.4pt 1.4pt 1.4pt 1.4pt}
.style7 {font-size:10pt; padding:1.4pt 1.4pt 1.4pt 1.4pt}

.f1{font-size:20pt; font-weight:bold; line-height:150%;}
.f2{font-size:10.5pt; line-height:150%;}
/* //  */

</style>
<script>


</script>
</head>
<body>
<%-- 	<%	for(int i=0; i< ch_cd.length; i++){
		
		if(ch_cd[i].equals("doc1")){
	%>		
	<%	}else{
			String url = "https://fms3.amazoncar.co.kr/fms2/attach/imgview_print.jsp?SEQ="+ch_cd[i].replaceAll(" ","");
		%>
			<div class="paper2">
		    <div class="content2">
				<iframe  src="<%=url%>" id="frame<%=i%>" class="frame" scrolling="no" frameborder="0" style="width:100%;height:100%;">
				</iframe>
			</div>
			</div>
		<%	}%>
	<%	}%> --%>
	<%
	
	for(int i=0; i< ch_cd.length; i++){
		if(ch_cd[i].equals("doc1")){
		%>
		    <div class="paper">
		    <div class="content">
			<div class="wrap" style="width:100%;">
			<%--  	<iframe src="/fms2/insa_card/doc_cert.jsp?user_id=<%=ck_acar_id%>" name="inner" width="100%" height="100%" 
			  		cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling="no" marginwidth="0" marginheight="0" >
			  	</iframe> --%>
				<table width="680" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000" class="doc1">
					<tr>
						<td bgcolor="#FFFFFF">
							<table width="680" border="0" cellspacing="0" cellpadding="0">
			    			<tr>
			        			<td>
			        				<table width="680" border="0" cellspacing="0" cellpadding="0" height=90>
							            <tr>
							                <td valign=top>
							                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
								                    <TR>
								                        <TD width="60" height="33" class=style3 style="font-size:10pt;" align=center>관리번호</TD>
								                        <TD width="90" class=style6 align=center><%=AddUtil.getDate2(1)%>-<%=seq%></TD>
								                    </TR>
							                	</TABLE>
							                </td>
							            </tr>
							            <tr>
							                <td align=center valign=top><span class=f1>재 직 증 명 서</td>
							           	</tr>	
							           	<tr>
							           		<td height=30></td>
							           	</tr>			            
						        	</table>
			        			</td>
			    			</tr>
						<% for(int j = 0 ; j < doc_vt_size ; j++){
							Hashtable ht = (Hashtable)doc_vt.elementAt(j);	 %>		    
						    <tr>
						        <td>
						        	<table width="680" border="0" cellspacing="0" cellpadding="0">
							            <TR>
											<TD width="100" height="54" class=style1 align=center>성 명(한글)</TD>
											<TD width="250" class=style1>&nbsp;&nbsp;<%=ht.get("USER_NM")%></TD>
											<TD width="100" class=style1 align=center>생년월일</TD>
											<TD class=style2>&nbsp;&nbsp<%=ht.get("SSN1")%><!---<%//=ht.get("SSN3")%>--></TD>
							            </TR>
										<TR>
											<TD height="54" class=style3 align=center>부 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</TD>
											<TD class=style3>&nbsp;&nbsp;<%=ht.get("DEPT_NM")%></TD>
											<TD class=style3 align=center>직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 위</TD>
										    <TD class=style4>&nbsp;&nbsp;<%=ht.get("USER_POS")%></TD>
									    </TR>
										<TR>
											<TD height="54" class=style3 align=center>재&nbsp;직&nbsp;기&nbsp;간</TD>
											<TD class=style3>&nbsp;&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> 부터 현재까지</TD>
											<TD class=style3 align=center>직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 무</TD>
											<TD class=style4>&nbsp;&nbsp;</TD>
									    </TR>
										<TR>
											<TD height="54" class=style3 align=center>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 소</TD>
										    <TD colspan="3" class=style4>&nbsp;&nbsp;<%=ht.get("ADDR")%> </TD>
									    </TR>
									</table>
								</td>
							</tr> 
						<% }%>				
						    <tr>
						        <td align=center>
						        	<table width="680" border="0" cellspacing="0" cellpadding="0" align="center">
						            	<tr>
											<td height="180" align="center" class=style5 colspan="2">상기와 같이 재직하고 있음을 증명함.</td>
							    		</tr>
										<tr>
											<td height="20" align="" class=style5 colspan="2">(&nbsp; 용 &nbsp;&nbsp; 도 &nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<input type='text' name="r_name"   size='25'  style=' text-align:left; font-size : 12pt; background-color:#ffffff; border-color:#000000; border-width:1;' >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											제출용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</td>
										</tr>
										<tr>
											<td height="120" colspan="2"></td>
										</tr>
										<tr>
											<td height="22" align=center class=style5 colspan="2"><%=AddUtil.getDate2(1)%> 년 &nbsp;&nbsp;<%=AddUtil.getDate2(2)%> 월 &nbsp;&nbsp;<%=AddUtil.getDate2(8)%> 일</td>
										</tr>
										<tr>
											<td height="120" colspan="2"></td>
										</tr>
										<tr>
											<td width=230 align="right" style="font-size:14.0pt;line-height:160%;">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</td>
											<td width=400 height="22" style="font-size:14.0pt;line-height:160%;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (주)아마존카</td>
										</tr>
										<tr>
											<td height="20"></td>
										</tr>
										<tr>
											<td align=right style="font-size:14.0pt;line-height:160%;">대 &nbsp;표 &nbsp;자</td>
											<td height="22" style="font-size:14.0pt;line-height:160%;font-weight:bold;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											조성희 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;인</td>
											<div style="width:0px; height:0px;position:relative;z-index:1;top:450;margin-left:150px;"><img src="/acar/images/stamp.png" width="109" height="108"></div> 
										</tr>
									</table>
								</td>
						    </tr>
						    <tr>
						        <td height=60></td>
						    </tr>
						</table>
					</td>
					</tr>
				</table>  
				
			</div>
			</div>
			</div>
		
		<%
		}
		if(ch_cd[i].equals("doc2")){
			%>
			    <div class="paper">
			    <div class="content">
			    
				<div class="wrap" style="width:100%;">
				<!-- <div id="Layer1" style="position:absolute; left:475px; top:870px; width:109px; height:108px; z-index:1"><img src="/images/square.png" width="109" height="108"></div> -->
				<table width="680" border="0" cellspacing="2" cellpadding="0" bgcolor="#000000" class="doc1">
					<tr>
						<td bgcolor="#FFFFFF">
							<table width="680" border="0" cellspacing="0" cellpadding="0">
			    			<tr>
			        			<td>
			        				<table width="680" border="0" cellspacing="0" cellpadding="0" height=90>
							            <tr>
							                <td valign=top>
							                	<TABLE border="0" cellspacing="0" cellpadding="0" style='border-collapse:collapse;border:none;'>
								                    <TR>
								                        <TD width="60" height="33" class=style3 style="font-size:10pt;" align=center>관리번호</TD>
								                        <TD width="90" class=style6 align=center><%=AddUtil.getDate2(1)%>-<%=seq%></TD>
								                    </TR>
							                	</TABLE>
							                </td>
							            </tr>
							            <tr>
							                <td align=center valign=top><span class=f1>위 임 장</td>
							           	</tr>	
							           	<tr>
							           		<td height=30></td>
							           	</tr>			            
						        	</table>
			        			</td>
			    			</tr>
						<% for(int j = 0 ; j < doc_vt_size ; j++){
							Hashtable ht = (Hashtable)doc_vt.elementAt(j);	 %>		    
						    <tr>
						        <td>
						        	<table width="680" border="0" cellspacing="0" cellpadding="0">
							            <TR>
											<TD width="100" height="54" class=style1 align=center>성 명(한글)</TD>
											<TD width="250" class=style1>&nbsp;&nbsp;<%=ht.get("USER_NM")%></TD>
											<TD width="100" class=style1 align=center>생년월일</TD>
											<TD class=style2>&nbsp;&nbsp<%=ht.get("SSN1")%><!---<%//=ht.get("SSN3")%>--></TD>
							            </TR>
										<TR>
											<TD height="54" class=style3 align=center>부 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;서</TD>
											<TD class=style3>&nbsp;&nbsp;<%=ht.get("DEPT_NM")%></TD>
											<TD class=style3 align=center>직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 위</TD>
										    <TD class=style4>&nbsp;&nbsp;<%=ht.get("USER_POS")%></TD>
									    </TR>
										<TR>
											<TD height="54" class=style3 align=center>재&nbsp;직&nbsp;기&nbsp;간</TD>
											<TD class=style3>&nbsp;&nbsp;<%=AddUtil.ChangeDate2(String.valueOf(ht.get("ENTER_DT")))%> 부터 현재까지</TD>
											<TD class=style3 align=center>직&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 무</TD>
											<TD class=style4>&nbsp;&nbsp;</TD>
									    </TR>
										<TR>
											<TD height="54" class=style3 align=center>주&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 소</TD>
										    <TD colspan="3" class=style4>&nbsp;&nbsp;<%=ht.get("ADDR")%> </TD>
									    </TR>
									</table>
								</td>
							</tr> 
						<% }%>				
						    <tr>
						        <td align=center>
						        	<table width="680" border="0" cellspacing="0" cellpadding="0" align="center">
						            	<tr>
											<td height="180" align="center" class=style5 colspan="2"></td>
							    		</tr>
										<tr>
											<td height="20" align="" class=style5 colspan="2">(&nbsp; 용 &nbsp;&nbsp; 도 &nbsp;&nbsp;&nbsp;&nbsp;:&nbsp;&nbsp;&nbsp;<input type='text' name="r_name"   size='25'  style=' text-align:left; font-size : 12pt; background-color:#ffffff; border-color:#000000; border-width:1;' value="운행정지 신청" >&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											제출용 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;)</td>
										</tr>
										<tr>
											<td height="120" colspan="2"></td>
										</tr>
										<tr>
											<td height="22" align=center class=style5 colspan="2"><%=AddUtil.getDate2(1)%> 년 &nbsp;&nbsp;<%=AddUtil.getDate2(2)%> 월 &nbsp;&nbsp;<%=AddUtil.getDate2(8)%> 일</td>
										</tr>
										<tr>
											<td height="120" colspan="2"></td>
										</tr>
										<tr>
											<td width=230 align="right" style="font-size:14.0pt;line-height:160%;">상&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;호</td>
											<td width=400 height="22" style="font-size:14.0pt;line-height:160%;font-weight:bold;">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (주)아마존카</td>
										</tr>
										<tr>
											<td height="20"></td>
										</tr>
										<tr>
											<td align=right style="font-size:14.0pt;line-height:160%;">대 &nbsp;표 &nbsp;자</td>
											<td height="22" style="font-size:14.0pt;line-height:160%;font-weight:bold;"> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
											조성희 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;인</td>
											<div style="width:0px; height:0px;position:relative;z-index:1;top:450;margin-left:150px;"><img src="/acar/images/stamp.png" width="109" height="108"></div> 
										</tr>
									</table>
								</td>
						    </tr>
						    <tr>
						        <td height=60></td>
						    </tr>
						</table>
					</td>
					</tr>
				</table>
			</div>
			</div>
			</div>					
				</div>
				</div>
				</div>
			
			<%
		}
		
		if(ch_cd[i].equals("doc3")){
			%>
			    <div class="paper">
			    <div class="content">
				<div class="wrap" style="width:100%;">
					 	<iframe src="/fms2/con_fee/fee_scd_print_ext.jsp?m_id=<%=rent_mng_id%>&l_cd=<%=rent_l_cd%>" name="inner" width="100%" height="100%" 
			  			cellpadding="0" cellspacing="0" border="0" frameborder="0" noresize scrolling="no" marginwidth="0" marginheight="0" >
			  			</iframe>
				</div>
				</div>
				</div>
			
			<%
		}
		
		 vt = cp_db.getAcarAttachFile(ch_cd[i]);
			 for(int j=0; j< vt.size(); j++){
					Hashtable ht = (Hashtable)vt.elementAt(j);
					fileName = String.valueOf(ht.get("SAVE_FILE"));		
					saveFolder = String.valueOf(ht.get("SAVE_FOLDER"));
					realFolder = "https://fms3.amazoncar.co.kr";
					//realFolder = request.getRealPath("/");
					filePath = realFolder + saveFolder + fileName;	
					filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
			
				if(!String.valueOf(ht.get("FILE_TYPE")).equals("application/pdf")){
			%>
				<div class="paper">
				    <div class="content">
						<%-- <img src="<%=filePath%>" width=<%=img_width%> height=<%=img_height%>> --%>
						<img src="https://fms3.amazoncar.co.kr/fms2/attach/view_normal.jsp?SEQ=<%=ht.get("SEQ")%>" width=<%=img_width%> height=<%=img_height%> /> 
					</div>
					</div>
				<%}else{ %>
					 <%-- <embed src="<%=filePath%>"  width=<%=img_width%> height=100%/> --%>
					 <%
					    File file = new File(filePath);
				        RandomAccessFile raf = new RandomAccessFile(file, "r");
				        FileChannel channel = raf.getChannel();
				        ByteBuffer buf = channel.map(FileChannel.MapMode.READ_ONLY, 0, channel.size());
				        PDFFile pdffile = new PDFFile(buf);

				        // draw the first page to an image
				        PDFPage pdfPage = pdffile.getPage(pdffile.getNumPages());
				        
				        //get the width and height for the doc at the default zoom 
				        Rectangle rect = new Rectangle(0,0,
				                (int)pdfPage.getBBox().getWidth(),
				                (int)pdfPage.getBBox().getHeight());
				        
				        //generate the image
				        
				        Image image = pdfPage.getImage(
				                rect.width, rect.height, //width & height
				                rect, // clip rect
				                null, // null for the ImageObserver
				                true, // fill background with white
				                true  // block until drawing is done
				                );
				        
				        int w = image.getWidth(null);
				        int h = image.getHeight(null);
				        BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
				        Graphics2D g2 = bi.createGraphics();
				        g2.drawImage(image, 0, 0, null);
				        g2.dispose();
				        try
				        {
				        	int Idx = fileName.lastIndexOf(".");
				        	fileName = fileName.substring(0, Idx )+".jpg";
		        			filePath = realFolder + saveFolder + fileName;					        
		        			filePath = filePath.replaceAll("///", "/").replaceAll("/////", "/");
				            ImageIO.write(bi, "jpg", new File(filePath));
				        }
				        catch(IOException ioe)
				        {
				            System.out.println("write: " + ioe.getMessage());
				        } 
					 
					 %>
				<%} %>
	 		<%} %>
		<%} %>
</body>
</html>
