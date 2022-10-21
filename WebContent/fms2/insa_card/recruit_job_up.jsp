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
	int rc_no=Integer.parseInt(request.getParameter("rc_no")==null?"0":request.getParameter("rc_no"));
	String reg_id = request.getParameter("reg_id")==null?"":request.getParameter("reg_id");
	String rc_job = request.getParameter("rc_job")==null?"":request.getParameter("rc_job");	
	String rc_job_cont = request.getParameter("rc_job_cont")==null?"":request.getParameter("rc_job_cont");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	if ( gubun.equals("d")) { //삭제면 
	//	System.out.println("gubun="+ gubun + ":rc_no="+ rc_no);
	
	 	res=icd.InsaDelete(rc_no, "insa_rc_job");
	} else {
		if(rc_no==0){
			
			List<Insa_Rc_JobBean> list=icd.selectInsaRcJobAll();
			
			rc_no = list.size()+1;
		
			Insa_Rc_JobBean infoBean =new Insa_Rc_JobBean(ck_acar_id,rc_no,rc_job,rc_job_cont);
			
		   	res=icd.jobInsert(infoBean);
	
		}else{
			
		
			Insa_Rc_JobBean infoBean =new Insa_Rc_JobBean(rc_no,rc_job,rc_job_cont);
			
		   	res=icd.jobUpdate(infoBean);		   
		}
	}  
	   
	if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_job_sc.jsp";
	      close();
	   </script>
	<%
	   }else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_job_sc.jsp";
		  close();
	   </script>
	<%
	   }
	%>
</body>
</html>
