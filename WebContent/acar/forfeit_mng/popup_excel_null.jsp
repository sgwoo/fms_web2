<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.forfeit_mng.*" %>
<%@ include file="/acar/cookies.jsp" %>

<%
	String vid[] = request.getParameterValues("v_id");
	String vid_num="";
	String ch_m_id="";
	String ch_l_cd="";
	String ch_c_id="";
	String ch_seq_no="";
	int flag=0;
	
	AddForfeitDatabase afm_db = AddForfeitDatabase.getInstance();
	for(int i=0;i < vid.length;i++){
		vid_num=vid[i];
		ch_m_id = vid_num.substring(0,6);
		ch_l_cd = vid_num.substring(6,19);
		ch_c_id = vid_num.substring(19,25);
		ch_seq_no = vid_num.substring(25);
		if(!afm_db.updateFineExpListExcel(ch_m_id, ch_l_cd, ch_c_id, ch_seq_no)) flag+=1;
	}
%>
<html>
<head>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
	if(flag == 0){
		alert("수정되었습니다.");
	}else{
		alert("에러발생!");
	}
//-->
</script>
</head>
<body>
</body>
</html>
