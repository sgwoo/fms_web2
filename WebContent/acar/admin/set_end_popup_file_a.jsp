<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.admin.*"%>
<%@ page import="acar.asset.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.admin.AdminDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	
	String ck_acar_id = request.getParameter("ck_acar_id")==null?"":request.getParameter("ck_acar_id");
	String s_width = request.getParameter("s_width")==null?"":request.getParameter("s_width");
	String s_height = request.getParameter("s_height")==null?"":request.getParameter("s_height");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id"); //연차대상자
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	
    String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");	
	String s_month = request.getParameter("s_month")==null?"":request.getParameter("s_month");	
		
	String gubun 	= request.getParameter("gubun")==null? "":request.getParameter("gubun");
	String s_type 	= request.getParameter("s_type")==null? "":request.getParameter("s_type"); //3:파일등록 
	String s_chk 	= request.getParameter("s_chk")==null? "":request.getParameter("s_chk");
	
	String sch_file 	= request.getParameter("scan_file")==null?"":request.getParameter("scan_file");
		
	//한글이 깨지는 문제 -multipartrequest
	int count = 0;
	count = ad_db.InsertStatCmp_Scan(s_year, s_month, gubun, s_type , s_chk);
	             			
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
	//	go_parent_list();
		parent.close();	
<%}else{ %>
	alert("오류입니다!!!!!!!!!!!!!!!");
<%}%>
//-->
</script>
</body>

</html>

