<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String cmd = request.getParameter("cmd")==null?"":request.getParameter("cmd");
	String h_paid_no = request.getParameter("h_paid_no")==null?"":request.getParameter("h_paid_no");
	String h_vio_dt = request.getParameter("h_vio_dt")==null?"":request.getParameter("h_vio_dt");
	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String c_id = request.getParameter("c_id")==null?"":request.getParameter("c_id");
	String seq_no = request.getParameter("seq_no")==null?"1":request.getParameter("seq_no");
	String ch_gu = request.getParameter("ch_gu")==null?"":request.getParameter("ch_gu");
	int count = 0;
	
	AddForfeitDatabase afdb = AddForfeitDatabase.getInstance();
	
	if(ch_gu.equals("paid_no"))		count = afdb.getPaidNo(h_paid_no);
	else 							count = afdb.getVioDt(AddUtil.replace(h_vio_dt, "-", ""));
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
function NullAction(){
<%	if(count==0){%>

<%	}else{
		if(ch_gu.equals("paid_no")){%>
			alert("'<%=h_paid_no%>' 납부고지서번호가 존재합니다.");
<%		}else{%>
			alert("'<%=h_vio_dt%>' 위반일시가 존재합니다.");		
<%		}
	}%>
}
//-->
</script>
</head>
<body onLoad="javascript:NullAction()">
</body>
</html>