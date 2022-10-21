<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*,  acar.cms.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cms.CmsDatabase"/>

<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun1 	= request.getParameter("gubun1")==null?"":request.getParameter("gubun1");

	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
	
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String req_dt =  request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	
	int count = 0;
	
	count = ac_db.delCmsCng(rent_mng_id, rent_l_cd, req_dt);

	
%>


<html>
<head><title>FMS</title>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
<form name='form1' action='' method="POST" enctype="">
  <input type='hidden' name='auth_rw' 	value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 	value='<%=user_id%>'>
  <input type='hidden' name='br_id' 	value='<%=br_id%>'>

  <input type='hidden' name='s_kd' 		value='<%=s_kd%>'>
  <input type='hidden' name='t_wd' 		value='<%=t_wd%>'>  
       
  <input type='hidden' name='sh_height' value='<%=sh_height%>'>    
</form>

<script language="JavaScript">
<!--
	var fm = document.form1;
	
<%	if(count>0){%>
		alert("정상적으로 삭제되었습니다.");		
		parent.opener.location.reload();
		parent.window.close();				
				
<%	}else{%>
		alert("에러발생!!");
<%	}%>
//-->
</script>

</body>
</html>