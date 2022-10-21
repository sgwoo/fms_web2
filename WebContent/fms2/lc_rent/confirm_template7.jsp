<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>

<% 
	String rent_mng_id 	= request.getParameter("rent_mng_id")		==null? "":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")			==null? "":request.getParameter("rent_l_cd");
	String rent_st 		= request.getParameter("rent_st")			==null? "":request.getParameter("rent_st");
	
	String var1 = request.getParameter("var1")==null?"":request.getParameter("var1");
	String var2 = request.getParameter("var2")==null?"":request.getParameter("var2");	
	String var3 = request.getParameter("var3")==null?"":request.getParameter("var3");
	String var4 = request.getParameter("var4")==null?"":request.getParameter("var4");	
	String var5 = request.getParameter("var5")==null?"":request.getParameter("var5");
	String var6 = request.getParameter("var6")==null?"":request.getParameter("var6");
	
	String mail_yn = request.getParameter("mail_yn")	==null? "":request.getParameter("mail_yn");
	
	//if(rent_l_cd.equals("") && !var2.equals("")){
		
		rent_l_cd = var2;		
		rent_mng_id = var4;
		rent_st = var6;
	//}	
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	double img_width 	= 690;
	double img_height 	= 980;		
	
if(!rent_l_cd.equals("")){
	
	//20150526 ACAR_ATTACH_FILE LIST---------------------------------------------------------
	String content_code = "LC_SCAN";
	String content_seq  = rent_mng_id+""+rent_l_cd+""+rent_st;

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
<%} %>	