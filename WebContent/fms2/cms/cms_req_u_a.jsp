<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.cms.*"%>
<jsp:useBean id="ac_db" scope="page" class="acar.cms.CmsDatabase"/>
<jsp:useBean id="bean" class="acar.cms.CmsCngBean" scope="page"/>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String rent_mng_id 	= request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd 	= request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");	
	String req_dt =  request.getParameter("req_dt")==null?"":request.getParameter("req_dt");
	
	int sh_height = request.getParameter("sh_height")==null?0:Util.parseInt(request.getParameter("sh_height"));//상단길이
	
	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cmd 			= request.getParameter("cmd")==null?"":request.getParameter("cmd");
		
	int count = 0;
	boolean flag6 = true;
		
	bean = ac_db.getCmsCng(rent_mng_id, rent_l_cd, req_dt);
	
	bean.setCms_bank	(request.getParameter("cms_bank")==null?"":request.getParameter("cms_bank"));	
	bean.setCms_acc_no	(request.getParameter("cms_acc_no")==null?"":request.getParameter("cms_acc_no"));
	bean.setCms_dep_nm	(request.getParameter("cms_dep_nm")==null?"":request.getParameter("cms_dep_nm"));
	bean.setCms_dep_ssn	(request.getParameter("cms_dep_ssn")==null?"":request.getParameter("cms_dep_ssn"));
	
	if(!ac_db.updateCmsCng(bean))	count += 1;

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
  <input type='hidden' name='from_page' value='<%=from_page%>'>
  
  <input type='hidden' name='rent_mng_id' value='<%=rent_mng_id%>'>
  <input type='hidden' name='rent_l_cd' value='<%=rent_l_cd%>'>
  <input type='hidden' name='req_dt' value='<%=req_dt%>'>
  
</form>


<script language="JavaScript">
<!--
	var fm = document.form1;
<%	if(count==0){%>
	alert("정상적으로 처리되었습니다.");
	fm.action='./cms_req_u.jsp?rent_mng_id=<%=rent_mng_id%>&rent_l_cd=<%=rent_l_cd%>&req_dt=<%=req_dt%>';
	fm.target='CMS_CNG';
	fm.submit();			

<%	}else{%>
	alert("등록 오류입니다.");
<%	}%>
	
//-->

</script>

</body>
</html>