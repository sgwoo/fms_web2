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
	
	String mail_yn = "";
	
	if(rent_l_cd.equals("") && !var2.equals("")){
		mail_yn = "Y";
		rent_l_cd = var2;		
		rent_mng_id = var4;
		rent_st = var6;
	}	
	
	String content_code = "LC_SCAN";
	String content_seq  = ""; 
	
	Vector attach_vt = new Vector();
	int attach_vt_size = 0;       	
	

	CommonDataBase c_db = CommonDataBase.getInstance();
	
	double img_width 	= 690;
	double img_height 	= 980;		
	

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
<%
	//계약서(앞)-jpg파일---------------------------------------------------------
	content_seq  = rent_mng_id+""+rent_l_cd+""+rent_st+""+"17";

	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
	attach_vt_size = attach_vt.size();

	if(attach_vt_size > 0){
		for (int j = 0 ; j < 1 ; j++){
        	Hashtable ht = (Hashtable)attach_vt.elementAt(j); 					
%>
	<div align="center" style="vertical-align: middle; margin-top: 50px;">
		<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
			<tr valign="middle">
				<td align="center">
					<img src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				</td>
			</tr>
		</table>
	</div>
<%		}
	}
%>	
<%
	//계약서(뒤)-jpg파일---------------------------------------------------------
	content_seq  = rent_mng_id+""+rent_l_cd+""+rent_st+""+"18";

	attach_vt = c_db.getAcarAttachFileListEqual(content_code, content_seq, 0);
	attach_vt_size = attach_vt.size();

	if(attach_vt_size > 0){
		for (int j = 0 ; j < 1 ; j++){
        	Hashtable ht = (Hashtable)attach_vt.elementAt(j); 					
%>
	<div align="center" style="vertical-align: middle; margin-top: 50px;">
		<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
			<tr valign="middle">
				<td align="center">
					<img src="https://fms3.amazoncar.co.kr<%=ht.get("SAVE_FOLDER")%><%=ht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
				</td>
			</tr>
		</table>
	</div>
<%		}
	}
%>
</body>
</html>

	