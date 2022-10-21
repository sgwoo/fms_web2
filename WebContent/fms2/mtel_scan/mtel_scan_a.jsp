<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cost.CostDatabase"/>

<%
	

	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차대상자
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String st_year 	= request.getParameter("st_year")==null?"":request.getParameter("st_year");
	String st_mon 	= request.getParameter("st_mon")==null?"":request.getParameter("st_mon");
	String sch_file 	= request.getParameter("mtel_scan_file")==null?"":request.getParameter("mtel_scan_file");
	String cmd		= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	//한글이 깨지는 문제 -multipartrequest

	int count = 0;
	count = ac_db.InsertMtel_Scan(st_year, st_mon, user_id, "8", "1", 100000, sch_file);
			
%>
<html>
<head>
<title>FMS</title>
<%@ include file="/acar/getNaviCookies.jsp" %>
</head>
<script language="JavaScript">
<!--

	function go_parent_list(){
		var fm = document.form1;
		fm.action = "./mtel_scan_frame.jsp";
		fm.target='d_content';
		fm.submit();
	}

//-->
</script>
<body>
<form name='form1' action='' method="POST" enctype="">
<input type='hidden' name='user_id' value='<%=user_id%>'>
<input type='hidden' name="s_width" value="<%=s_width%>">   
<input type='hidden' name="s_height" value="<%=s_height%>">  
<input type='hidden' name="ck_acar_id" value="<%=ck_acar_id%>"> 

</form>
<script language="JavaScript">
<!--
	var fm = document.form1;

<%if(count==1){	%>
		alert("정상적으로 등록되었습니다.");
		go_parent_list();
		parent.close();	
<%}else{ %>
	alert("오류입니다!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>
