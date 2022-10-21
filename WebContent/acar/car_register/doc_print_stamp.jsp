<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*"%>
<%@ include file="/acar/cookies.jsp" %>
	
<%
	String file_st = request.getParameter("file_st")==null?"":request.getParameter("file_st");
	String file_info = request.getParameter("file_info")==null?"":request.getParameter("file_info");
	
	double img_width 	= 690;
	double img_height 	= 1009;		
	
	//인감
	String stamp_file = "stamp.png";
	
	//직인
	if(file_st.equals("55")){
		stamp_file = "stamp_sq.jpg";
	}
	
	//튜닝승인신청서 직인 위치
	double stamp_top 	= 600;
	double stamp_left 	= 510;
%>
<html>
<head><title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<script language='JavaScript' src='/include/common.js'></script>
<style>
</style>
</head>
<body leftmargin="15" topmargin="1"  >
<div>
	<div style="position: absolute;">
		<div style="position: relative; top: <%=stamp_top%>px; left: <%=stamp_left%>px;"><img src="https://fms1.amazoncar.co.kr/acar/images/<%=stamp_file%>"></img></div>
	</div>
	<img src="https://fms3.amazoncar.co.kr<%=file_info%>" width=<%=img_width%> height=<%=img_height%>><br style="page-break-before:always;">
</div>
</body>
</html>
