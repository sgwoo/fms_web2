<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String l_cd 		= request.getParameter("l_cd")		==null?"":request.getParameter("l_cd");
	String m_id 		= request.getParameter("m_id")		==null?"":request.getParameter("m_id");
	String rent_st 	= request.getParameter("rent_st")	==null?"":request.getParameter("rent_st");
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	double img_width 	= 690;
	double img_height 	= 980;		
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	String content_code = "LC_SCAN";
	String content_seq  = m_id+""+l_cd+""+rent_st;

	Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
	int attach_vt_size = attach_vt.size();
	//코드리스트 : 계약스캔파일구분
	CodeBean[] scan_codes = c_db.getCodeAll3("0028");
	int scan_code_size = scan_codes.length;
	
	if(attach_vt_size > 0){
		for (int j = 0 ; j < attach_vt_size ; j++){
				Hashtable aht = (Hashtable)attach_vt.elementAt(j); 	 					
				if(!String.valueOf(aht.get("CONTENT_SEQ")).equals("") && String.valueOf(aht.get("CONTENT_SEQ")).length() > 20){
					String rent_st2 = String.valueOf(aht.get("CONTENT_SEQ")).substring(19,20);
					String file_st = String.valueOf(aht.get("CONTENT_SEQ")).substring(20); 	
					
					if(rent_st.equals(rent_st2) && (file_st.equals("17")||file_st.equals("18"))){
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<style>

@page a4sheet { size: 21.0cm 29.7cm }

.a4 { page: a4sheet; page-break-after: always }

</style>
</head>
<body leftmargin="15" topmargin="1">
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object>
	<div align="center" style="vertical-align: middle; margin-top: 50px;">
		<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
			<tr valign="middle">
				<td align="center">
					<img src="https://fms3.amazoncar.co.kr<%=aht.get("SAVE_FOLDER")%><%=aht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				</td>
			</tr>
		</table>
	</div>
</body>
</html>
<%				}
			}
		}
	}%>