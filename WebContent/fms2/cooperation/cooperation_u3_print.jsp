<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,java.awt.print.*,com.qoppa.pdf.*,com.qoppa.pdfPrint.*,acar.client.*"%>
<%@ page import="acar.cooperation.*, java.io.*, org.apache.pdfbox.pdmodel.PDDocument,acar.user_mng.*, acar.accid.*"%>
<%@ page import="org.apache.pdfbox.multipdf.PDFMergerUtility,org.apache.pdfbox.pdmodel.*, acar.util.*"%>
<%@ page import="org.apache.pdfbox.pdmodel.PDPage, org.apache.pdfbox.pdmodel.graphics.image.PDImageXObject, org.apache.pdfbox.pdmodel.PDPageContentStream"%>
<%@ page import="java.awt.*,java.nio.*, javax.imageio.*,com.sun.pdfview.*,java.awt.image.*, java.nio.channels.*"%>
<jsp:useBean id="cp_db" scope="page" class="acar.cooperation.CooperationDatabase"/>
<jsp:useBean id="al_db" scope="page" 	class="acar.client.AddClientDatabase"/>
<%@ include file="/acar/cookies.jsp"%>
<%
	
	AccidDatabase as_db = AccidDatabase.getInstance();
	
	String ch_cd[] 	= request.getParameterValues("ch_cd");
	//content_code �޾ƿ���
	String content_code = request.getParameter(Webconst.Common.contentCodeName);
	int seq = request.getParameter("seq")==null?0:Util.parseInt(request.getParameter("seq"));
	
	String rent_l_cd = request.getParameter("rent_l_cd");
	String rent_mng_id = request.getParameter("rent_mng_id");
	String rent_st = request.getParameter("rent_st");
	
	//�����ȸ
	Hashtable cont = as_db.getRentCase(rent_mng_id, rent_l_cd);
	
	//������
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
    font-family: "����", dotum, arial, helvetica, sans-serif;
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
				<br>
				<div style="text-align:left;font-size:8pt;margin-bottom:10px;">&nbsp; �� �ֹε�Ϲ� �����Ģ [ ���� ��7ȣ���� ]<span style="color:blue;font-size:7pt;"> <���� 2014. 12. 31.></span></div>
				<div style="text-align:center;font-size:15pt;font-weight:bold;font-family:HYGothic-Extra;">�ֹε��ǥ ���� �Ǵ� ����ʺ� ���� ��û��</div>
				<div style="text-align:left;font-size:8pt;font-weight:normal;;margin-bottom:3px;">&nbsp; �� ������ ���� ������ �а� �ۼ��Ͽ� �ֽñ� �ٶ��, [ &nbsp; ]���� �ش��ϴ� ���� ��ǥ�� �մϴ�.<span style="margin-left:180px;">( ���� )</span></div>
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content1">
						<tr>
							<td width="80" rowspan="4" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;border-bottom:1px solid #444444;">��û��<div style="margin-top:5px;">(����)</div></td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;����
								<div style="margin-left:300px;font-size:9px;">( ���� �Ǵ� �� )</div>
								<div style="width:0px; height:0px;position:relative;z-index:1;top:-25;margin-left:320px;"><img src="/acar/images/stamp.png" width="39" height="38"></div> 
							</td>
							<td width="220" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;�ֹε�Ϲ�ȣ</td>
						</tr>
						<tr>
							<td colspan="3" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;�ּ�</td>
						</tr>
						<tr>
							<td colspan="2" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;����ڿ��� ����</td>
							<td style="border-bottom:0.5px dotted rgba(0,0,0,0.25);border-left:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;��ȭ��ȣ</td>
						</tr>
						<tr style="height:21px;">
							<td width="110" style="border-bottom:1px solid #444444;border-right:0.5px solid rgba(0,0,0,0.25);">&nbsp;������ ���� ���</td>
							<td colspan="2" style="border-bottom:1px solid #444444;font-size:11px;">&nbsp;[ &nbsp;&nbsp; ]���α��ʻ�Ȱ������ &nbsp;&nbsp; [ &nbsp;&nbsp; ]�������ƴ���� &nbsp;&nbsp; [ &nbsp;&nbsp; ]�� ���� �����(<span style="margin-left:50px;"></span>)</td>
						</tr>
					</table>
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content2" style="margin-top:3px;">
						<tr>
							<td width="80" rowspan="4" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;border-bottom:1px solid #444444;">��û��<div style="margin-top:5px;">(����)</div></td>
							<td colspan="2" width="" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;����� (��) �Ƹ���ī</td>
							<td colspan="2" width="220" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;����ڵ�Ϲ�ȣ
								<div style="font-size:9pt">&nbsp;128-81-47957</div></td>
						</tr>
						<tr>
							<td colspan="2" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;��ǥ�� ������
							<div style="margin-left:300px;font-size:9px;">( ���� �Ǵ� �� )</div>
							<div style="width:0px; height:0px;position:relative;z-index:1;top:-25;margin-left:320px;"><img src="/acar/images/stamp.png" width="39" height="38"></div>
							</td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-left:0.5px dotted rgba(0,0,0,0.25);">&nbsp;��ǥ��ȭ��ȣ
								<div style="font-size:9pt">&nbsp;02-392-4243</div></td>
						</tr>
						<tr>
							<td colspan="4" style="border-bottom:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;������
								<div style="font-size:9pt">&nbsp;���� �������� �ǻ����  8, 802 ( ���ǵ���, ������� )</div>
							</td>
						</tr>
						<tr>
							<td  width="220" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;�湮�� ����
							</td>
							<td width="150" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;�ֹε�Ϲ�ȣ
							</td>
							<td width="90" style="border-bottom:1px solid #444444;border-right:0.5px dotted rgba(0,0,0,0.25);vertical-align:top;">&nbsp;����
							</td>
							<td width="130" style="border-bottom:1px solid #444444;vertical-align:top;">&nbsp;��ȭ��ȣ
							</td>
						</tr>
					</table>
					
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content3" style="margin-top:3px;">
						<tr style="height:33px;">
							<td width="80" rowspan="2" class='title' style="border-right:0.5px solid rgba(0,0,0,0.35);border-top:1px solid #444444;">���� �Ǵ�<br>����ʺ�<br>���� �����</td>
							<td colspan="2" width="" style="vertical-align:top;border-bottom:0.5px dotted rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;<%=client.getClient_nm()%> <%=cont.get("CAR_NO") %></td>
							<td  width="225" style="vertical-align:top;border-top:1px solid #444444;border-left:0.5px dotted rgba(0,0,0,0.25);border-bottom:0.5px dotted rgba(0,0,0,0.25);font-size:10pt;">&nbsp;�ֹε�Ϲ�ȣ
								<div style="font-size:9pt">&nbsp;<%=client.getSsn1()%>-<%=client.getSsn2() %></div></td>
						</tr>
						<tr style="height:33px;">
							<td colspan="4" style="vertical-align:top;">&nbsp;<%if(!client.getHo_addr().equals("")){%><%=client.getHo_addr()%><%}else{%><%=client.getO_addr()%><%}%>
								<div style="margin-left:350px;text-align:right;font-size:9pt">[ ��������� : <span style="margin-left:130px;"></span>]</div>
							</td>
						</tr>
						<tr>
							<td width="60" rowspan="16" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-top:0.5px solid rgba(0,0,0,0.25);border-bottom:1px solid #444444;">��û ����</td>
							<td colspan="1" width="100" style="text-align:center;border-bottom:0.5px solid rgba(0,0,0,0.35);border-top:0.5px solid rgba(0,0,0,0.35);border-right:0.5px solid rgba(0,0,0,0.35);">�� &nbsp; ��</td>
							<td colspan="2" width="" style="border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:0.5px solid rgba(0,0,0,0.25);font-size:9pt;">
								&nbsp;[ &nbsp; ] �����	<span style="margin-left:130px;"></span>&nbsp;[ v ] �ʺ�����
							</td>
						</tr>
						<tr style="height:px;">
							<td colspan="4" style="vertical-align:top;font-size:8pt;border-bottom:0.5px solid rgba(0,0,0,0.35);border-top:0.5px solid rgba(0,0,0,0.35);background-color:#cabdbd;">&nbsp;
								�� �������� ��ȣ�� ���Ͽ� �Ʒ��� ����ʺ� ���� �� �ʿ��� ���׸� �����Ͽ� ��û�� �� �ֽ��ϴ�.<br>
								<span style="margin-left:20px;"></span>���û����� ǥ������ �ʴ� ��쿡�� "����"���� ���� ǥ�õ� ���׸� �����Ͽ� ������ �帳�ϴ�.
							</td>
						</tr>
						<tr>
							<td rowspan="8" width="100" style="text-align:center;border-bottom:0.5px solid rgba(0,0,0,0.35);border-right:0.5px solid rgba(0,0,0,0.35);">� ����<br>[ &nbsp; ] ��</td>
							<td colspan="2" class="checklist">
								&nbsp;1. ������ �ּҺ��� ����	<div class="checkpoint">[ &nbsp; ]��ü ���� &nbsp; [  &nbsp;v&nbsp; ]�ֱ� 5�� ����  &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;2. ���� ���� ���� <div class="checkpoint">[ &nbsp; ]<b>����</b> &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;3. ������� �����ֿ��� ����<div class="checkpoint">[ &nbsp; ]<b>����</b> &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;4. ������� ������ / ������, ���� ���� <div class="checkpoint">[ &nbsp; ]<b>����</b> &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;5. ���� ����� �� �ٸ� ������� �̸� <div class="checkpoint">[ &nbsp; ]<b>����</b> &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;6. ���� ����� �� �ٸ� ������� �ֹε�Ϲ�ȣ ���ڸ� <div class="checkpoint">[ &nbsp; ]<b>����</b> &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;7. ������ <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" style="border-bottom:0.5px solid rgba(0,0,0,0.25);">
								&nbsp;8. �ܱ��� ����� / �ܱ��� �θ� <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td rowspan="6" width="100" style="text-align:center;border-bottom:1px solid #444444;border-right:0.5px solid rgba(0,0,0,0.35);">�ʺ� ����<br>[ 1 ] ��</td>
							<td colspan="2" width="" class="checklist" >
								&nbsp;1. ���� ���� ���� ���� ����     	<div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;2. ������ �ּ� ���� ���� <div class="checkpoint">[ &nbsp; ]��ü ���� &nbsp; [  &nbsp;v&nbsp; ]�ֱ� 5�� ����  &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;3. ������ �ּ� ���� ���� �� �������� ����� �����ֿ��� ���� <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;4. �������� <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist">
								&nbsp;5. ��ܱ��� �����żҽŰ��ȣ <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" width="" class="checklist" style="vertical-align:top;border-bottom:1px solid #444444;">
								&nbsp;6. �ܱ��ε�Ϲ�ȣ <div class="checkpoint">[ &nbsp; ]���� &nbsp; [ &nbsp; ]������</div>
							</td>
						</tr>
					</table>
					
					<table border="0" cellspacing="0" cellpadding='0' width='100%' class="content1" style="margin-top:3px;">
						<tr>
							<td width="100" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;border-bottom:0.5px solid rgba(0,0,0,0.25);">�뵵 �� ����</td>
							<td colspan="2" style="vertical-align:top;border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;">&nbsp;ä���� �ּ� ��ȸ	</td>
							<td width="220" style="vertical-align:top;border-bottom:0.5px solid rgba(0,0,0,0.25);border-top:1px solid #444444;border-left:0.5px solid rgba(0,0,0,0.25);">&nbsp;����ó</td>
						</tr>
						<tr style="height:30px;">
							<td width="80" class='title' style="border-right:0.5px solid rgba(0,0,0,0.25);border-bottom:1px solid #444444;">�����ڷ�</td>
							<td colspan="3" style="border-bottom:1px solid #444444;"></td>
						</tr>
					</table>
					<div style="margin-top:5px;">
						<div style="font-size:11.3pt;text-align:right;margin:0px 10px;">&nbsp;���ֹε�Ϲ� ����ɡ�&nbsp;��47���� ��48���� ���� �ֹε��ǥ�� ���� �Ǵ� ����ʺ� ���θ� ��û<div style="text-align:left;">�մϴ�.</div></div>
						<div style="font-size:8pt;text-align:right;margin-top:10px;">  &nbsp;&nbsp; ��     &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; ��   &nbsp;&nbsp; &nbsp;&nbsp; &nbsp;&nbsp; ��</div>
						<div style="text-align:center;font-weight:bold;font-size:13pt;margin-top:10px;"> �������������û�� �Ǵ� ����������� �� �������  <span style="font-weight:normal;font-size:9pt;">����</span></div>
						<div><hr style="height:3px;background-color:gray;"></div>
					</div>
			</div>
			</div>
			</div>
			
			<!-- �ι�° ������  -->
		  	<div class="paper">
		    <div class="content">
			<div class="wrap" style="width:100%;">
				<div style="text-align:right;font-size:8pt;font-weight:normal;margin-bottom:1px;margin-top:30px;">( ���� )</div>
				<div><hr style="height:3px;background-color:gray;margin-bottom:60px;"></div>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' class="notice">
					<tr>
						<td width="120" style="text-align:center;border-bottom:1px dotted rgba(0,0,0,0.35);border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.25);">
							&nbsp;÷�μ���<div style="margin:5px 0px;">(Ȯ�� �� ����</div><div>�帳�ϴ�.)</div>
						</td>
						<td style="border-bottom:1px solid rgba(0,0,0,0.35);border-top:1px solid rgba(0,0,0,0.35);border-left:1px dotted rgba(0,0,0,0.25);">
							<div style="margin-top:5px">&nbsp;1. �ֹε���� �� �ź�����</div>
							<div style="margin-top:5px">&nbsp;2. ���� �湮���� ���� �湮���� ����� �Ǵ� ��������</div>
							<div style="margin-top:5px">&nbsp;3. ������ ���� ������� ���� �ʿ��� �����ڷ�</div>
							<div style="margin:5px 0px">&nbsp;4. �ܱ��ε����(�ܱ��ι������ ���)</div>
						</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:4px;">
					<tr style="height:25px;">
						<td style="text-align:center;border-top:3px solid gray;border-bottom:1px solid rgba(0,0,0,0.25);font-size:10pt;background-color:#cabdbd;">���ǻ���		</td>
					</tr>
					<tr style="text-align:left;border-bottom:1px solid #444444;font-size:9pt;word-spacing:3;">
						<td>
							<div class="noticeList">
								<div class="noticeListFirst">1. ���Τ�������� ���Τ�������� �ֹε��ǥ ���� �Ǵ� ����ʺ� ���θ� �ֹε���� �� �ź����� ���ø�����</div> 
								<div class="noticeListMiddle">��û�ϴ� ��쿡�� �������̹��������Է±⡹�� ���� �ѱ� �������� �����Ͽ��� ���� �Ǵ� ���ι��� �� �ֽ���</div>
								<div class="noticeListLast" class="noticeListLast">��.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">2. ��û���� "��û����"���� �� �׸� ���Ͽ� "����", "������"�� �����Ͽ� ��û�� �� ������, �������� ���� ��</div>
								<div class="noticeListLast">�쿡�� <b>"����"</b> ���� ���� ǥ�õ� ���׸� ó���˴ϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">3. ��� ��� ������û�� ���Ͽ� ä������ �ֹε���ʺ� ���θ� ��û�ϴ� ��쿡�� ������ �ּҺ��������� ������</div>
								<div class="noticeListLast">�� �����ϰ� �ϰų� �߱��� �� �ֽ��ϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">4. � ���θ� ��û�� �� �ֹε���� ���� ���� �ܱ��� ������� ��� 8. �ܱ��� ����� �� �θ��׸��� �����̳�</div>
								<div class="noticeListLast">�����(�� ������ ���� �� ����)�� "����"�� ������ �� �ֽ��ϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">5. �ʺ� ���θ� ��û�� ��  3. ������ �ּ� ���� ���� �� �������� ����� �����ֿ��� ���� �׸��� �����̳� �����</div> 
								<div class="noticeListMiddle">(�� ������ ������ ����), ������ ������ġ��ü�� ������ �ʿ�� �� ��쿡��  "����"�� ������ �� �ְ�, 4. ����</div>
								<div class="noticeListMiddle">���� �׸��� �����̳� �����(�� ������ ���� ��� ����),���ֹε�Ϲ�����29����2����5ȣ�� ���� ����, ����</div>
								<div class="noticeListLast">�� ������ġ��ü�� ������ �ʿ�� �� ��쿡�� "����"�� ������ �� �ֽ��ϴ�.</div>
							</div>
							<div class="noticeList">
								<div>6. ��� �������� ������ ���� ��������� Ȯ���ϱ� ���Ͽ� �ʿ��� �����ڷḦ �䱸�� ��쿡�� �����ؾ� �մϴ�.</div>
							</div>
							<div class="noticeList">
								<div>7. ���ι湮�ڴ� �����(�Ǵ� ��������)�� �ֹε���� ���� �ź������� �Բ� �����ؾ� �մϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">8. �����̳� ������� �ƴ� �ڰ� ���ι޴� ����ʺ����� �����Ͻ� �뵵 �� ������ ǥ�õǴ� �ݵ�� "�뵵 �� ����"</div>
								<div class="noticeListLast">�� �����Ͽ��� �ϸ�, ��� ��û�ϴ� ��쿡�� ������ �����ڷḦ �����Ͽ��� �մϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">9. ���ֹε�Ϲ��� ��37����5ȣ�� ���� �����̳� �� ���� ������ ������� �ٸ� ����� �ֹε��ǥ�� �����ϰų� </div>
								<div class="noticeListLast">����ʺ��� ���ι��� ��쿡�� 3�� ������ ¡�����̳� 1õ�� �� ������ �������� ó���� �� �ֽ��ϴ�.</div>
							</div>
							<div class="noticeList">
								<div class="noticeListFirst">10. ���� ��û�ڰ� ���� �����ڷῡ ���� ���� �������� ���� ����� �ֹε��ǥ�� �����ϰų� ����ʺ� ���θ� �� </div>
								<div style="margin-left:25px;margin-bottom:4px;">û�ϴ� ��쿡�� ���� ��7ȣ���İ� ���� ��8ȣ������ �Բ� ����Ͽ� �ϰ� ��û�� �� ������, �̰� ���� ��7</div>
								<div style="margin-left:25px;">ȣ���İ� ���� ��8ȣ���� ���̿��� ��û���� Ȯ��(����)�� �־�� �մϴ�.</div>
							</div>
							<div class="noticeList">
								<div>11. �ܱ��� ����ڴ� �ֹε�Ϲ�ȣ ���� �ܱ��ε�Ϲ�ȣ�� �����Ͻñ� �ٶ��ϴ�.</div>
							</div>
						</td>
					</tr>
					<tr>
						<td style="border-bottom:1px solid rgba(0,0,0,0.25);">
							<br>
						</td>
					</tr>
				</table>
				
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:15px;">
					<tr style="height:35px;">
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">���� ��ȣ</td>
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">���� ����</td>
						<td style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);font-size:10pt;background-color:#cabdbd;">���������� �Ͻ�</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%' style="margin-top:20px;">
					<tr height="50">
						<td style="text-align:center;border-top:3px dashed gray;font-weight:1000;font-size:19px;font-family:HYGothic-Extra;">�ֹε��ǥ ���� �Ǵ� ����ʺ� ���� ��û ������</td>
					</tr>
				</table>
				<table border="0" cellspacing="0" cellpadding='0' width='100%'>
					<tr style="height:35px;">
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">���� ��ȣ</td>
						<td width="220" style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);border-right:1px solid rgba(0,0,0,0.25);font-size:9pt;background-color:#cabdbd;">���� ����</td>
						<td style="vertical-align:top;border-top:1px solid rgba(0,0,0,0.35);border-bottom:1px solid rgba(0,0,0,0.35);font-size:10pt;background-color:#cabdbd;">��û�� ����</td>
					</tr>
				</table>
				<div style="margin-left:100px;">
				<table border="0" cellspacing="0" cellpadding='0' width='80%' style="margin-top:15px;">
					<tr style="height:60px;font-size:12pt;font-weight:1000;">
						<td style="border:0px;text-align:right;padding-right:20px;">�������������û�� �Ǵ� ������������������</td>
						<td width="65" style="text-align:center;border:3px solid grey;font-size:12pt;color:grey;">����</td>
					</tr>
				</table>
				</div>
				<div style="text-align:left;font-size:9pt;margin-top:15px;">
					* �������� �¶������ ������ ���Ͽ� ��� ó���� �� �Ǵ� ��쿡�� �����Ͽ� �帳�ϴ�.			
				</div>
			</div>
			</div>
			</div>
		<%
		}else{
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
	<%} %>
</body>
</html>
