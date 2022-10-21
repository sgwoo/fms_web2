<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.forfeit_mng.*, acar.cont.*,java.net.URLEncoder"%>
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 		= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	String client_id 		= request.getParameter("client_id")==null?"":request.getParameter("client_id");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String doc_id 			= request.getParameter("doc_id")==null?"":request.getParameter("doc_id");
	String vio_dt 			= request.getParameter("vio_dt")==null?"":request.getParameter("vio_dt");
	String seq_no 			= request.getParameter("seq_no")==null?"":request.getParameter("seq_no");
	String file_name 			= request.getParameter("file_name")==null?"":request.getParameter("file_name");
	String note 			= request.getParameter("note")==null?"":request.getParameter("note");
	String yyyy = "";
	String fileName = "";
	String imgUrl = "";
	
	if(note.equals("과태료 OCR 등록")) {
		if(!file_name.equals("") && file_name != null) {
			String[] fileNames =  file_name.split("/");
			yyyy = fileNames[0];
			fileName = fileNames[1];
			
			imgUrl = "https://ocr.amazoncar.co.kr:8443/fine_mng/"+yyyy+"/"+ URLEncoder.encode(fileName, "EUC-KR");
		}
	}
	
	CommonDataBase c_db = CommonDataBase.getInstance();	
	
	double img_width 	= 690;
	double img_height 	= 1009;		
	
	String contentCode = "FINE";
	String contentSeq  = rent_mng_id+rent_l_cd+car_mng_id+seq_no+"1";
	
	Vector attach_vt = c_db.getAcarAttachFileList(contentCode, contentSeq, 0);
	int  attach_vt_size = attach_vt.size();
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<%if(mode.equals("b-lazy")){%>
<script type="text/javascript" src="https://cdn.jsdelivr.net/npm/blazy@1.8.2/blazy.min.js"></script>
<%}%>
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
</head>
<body leftmargin="15" topmargin="1"  >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>  
<% if(note.equals("과태료 OCR 등록") && !file_name.equals("") && file_name != null){ %>
	<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr valign="top">
		<td>
			<img src="<%=imgUrl%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
		</td>
	</tr>
</table>
<%} else {%>
	<%
		if(attach_vt_size >0){
			for(int y=(attach_vt.size()-1); y< attach_vt.size(); y++){
				Hashtable aht = (Hashtable)attach_vt.elementAt(y);   
	%>
	<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
		<tr valign="top">
			<td>
					<%if(mode.equals("b-lazy")){%>
						<img class="b-lazy" data-src="https://fms3.amazoncar.co.kr<%=aht.get("SAVE_FOLDER")%><%=aht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
					<%}else{%>
						<img src="https://fms3.amazoncar.co.kr<%=aht.get("SAVE_FOLDER")%><%=aht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
					<%}%>
			</td>
		</tr>
	</table>
	<%	}
		}
	}
%>

<%if(mode.equals("b-lazy")){%>
<script>
    var bLazy = new Blazy({ });
</script>
<%}%>

</body>
</html>
