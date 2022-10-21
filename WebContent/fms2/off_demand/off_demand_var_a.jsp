<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<%@ include file="/acar/cookies.jsp" %> 

<%
	EstiDatabase e_db = EstiDatabase.getInstance();

	String vid1[] 	= request.getParameterValues("save_dt");
	String vid2[] 	= request.getParameterValues("var_id");
	String vid3[] 	= request.getParameterValues("var_nm");
	String vid4[] 	= request.getParameterValues("var_cd");
	String vid5[] 	= request.getParameterValues("mode");
	
	int vid_size = vid1.length;
	
	int count = 0;
	
	for(int i=0;i < vid_size;i++){
		if(vid5[i].equals("i")){			
			count = e_db.insertOffDemandVar(vid1[i],vid2[i],vid3[i],vid4[i]);
		}else{
			count = e_db.updateOffDemandVar(vid1[i],vid2[i],vid3[i],vid4[i]);
		}
	}
%>
<html>
<head><title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table.css">
</head>
<body>

<script language="JavaScript">
<!--
<%	if(count==1){%>
		alert("정상적으로 수정되었습니다.");
		parent.opener.location.reload(); 			
<%	}else{%>
			alert("오류발생!");
<%	}%>
//-->
</script>
</body>
</html>
