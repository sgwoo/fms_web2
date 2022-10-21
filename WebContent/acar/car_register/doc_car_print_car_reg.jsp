<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_register.*"%>
<jsp:useBean id="ch_bean" class="acar.car_register.CarHisBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	
	//차량번호 이력
	CarRegDatabase crd = CarRegDatabase.getInstance();
	CarHisBean ch_r [] = crd.getCarHisAll(c_id);
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	double img_width 	= 690;
	double img_height 	= 1009;		
	
	if(ch_r.length > 0){
		for(int i=ch_r.length-1; i>=0; i--){
			ch_bean = ch_r[i];		
			//ch_bean = ch_r[ch_r.length-1];
			String content_code = "CAR_CHANGE";
			String content_seq  = ch_bean.getCar_mng_id()+""+ch_bean.getCha_seq();
		
			Vector attach_vt = c_db.getAcarAttachFileList(content_code, content_seq, 0);		
			int attach_vt_size = attach_vt.size();
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
<body leftmargin="15" topmargin="1"  >
<object id="factory" style="display:none" classid="clsid:1663ed61-23eb-11d2-b92f-008048fdd814" codebase="/smsx.cab#Version=6,4,438,06"> 
</object> 
<%
			if(attach_vt_size >0){
				//for(int y=(attach_vt.size()-1); y< attach_vt.size(); y++){
				Hashtable aht = (Hashtable)attach_vt.elementAt(attach_vt_size-1);   
%>
<table width='<%=img_width%>' border="0" cellpadding="0" cellspacing="0" class="a4">
	<tr valign="middle">
		<td align="center">
			<img src="https://fms3.amazoncar.co.kr<%=aht.get("SAVE_FOLDER")%><%=aht.get("SAVE_FILE")%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
		</td>
	</tr>
</table>
<%	//}
			}	%>
</body>
</html>
<%		if(attach_vt_size>0){		break;		}
		}
	}%>