<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, java.text.*, acar.util.*, acar.insa_card.*"%>
<%@ include file="/tax/cookies_base.jsp" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>   

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>

</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
</head>
<body>
	<%
	
	String rc_gubun = request.getParameter("rc_gubun")==null?"":request.getParameter("rc_gubun");
	String rc_code = request.getParameter("rc_code")==null?"":request.getParameter("rc_code");
	String rc_nm = request.getParameter("rc_nm")==null?"":request.getParameter("rc_nm");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	
	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	if ( gubun.equals("d")) { //삭제면 
		
		 	res=icd.InsaCodeDelete(rc_gubun, rc_code);
	} else {
		if(AddUtil.parseInt(rc_code)==0){
			
			Vector vt_job = icd.getList(rc_gubun);
			int vt_size = vt_job.size();
			
			rc_code = AddUtil.addZero2(vt_size+1);
			
			res=icd.CodeInsert(rc_gubun, rc_code, rc_nm);
	
		}else{
			res=icd.CodeUpdate(rc_gubun, rc_code, rc_nm);		   
		}
	}
	
	   if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_code_sc.jsp"
	      close();
	   </script>
	<%
	   }else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_code_sc.jsp"
		  close();
	   </script>
	<%
	   }
	%>
</body>
</html>
