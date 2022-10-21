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

	String rc_type = request.getParameter("rc_type")==null?"":request.getParameter("rc_type");	
	int rc_hire_per=Integer.parseInt(request.getParameter("rc_hire_per")==null?"0":request.getParameter("rc_hire_per"));
	String rc_branch = request.getParameter("rc_branch")==null?"":request.getParameter("rc_branch");
	String rc_edu = request.getParameter("rc_edu")==null?"":request.getParameter("rc_edu");
	String rc_apl_ed_dt = request.getParameter("rc_apl_ed_dt")==null?"":request.getParameter("rc_apl_ed_dt");
	String rc_pass_dt = request.getParameter("rc_pass_dt")==null?"":request.getParameter("rc_pass_dt");
	String rc_apl_mat = request.getParameter("rc_apl_mat")==null?"":request.getParameter("rc_apl_mat");
	String rc_manager = request.getParameter("rc_manager")==null?"":request.getParameter("rc_manager");
	String rc_tel = request.getParameter("rc_tel")==null?"":request.getParameter("rc_tel");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	if ( gubun.equals("d")) { //삭제면 
		//	System.out.println("gubun="+ gubun + ":rc_no="+ rc_no);
		
		 	res=icd.InsaDelete(rc_no, "INSA_RC_RECRUIT");
	} else {
		if(rc_no==0){
			
			List<Insa_Rc_rcBean> list=icd.selectInsaRcAll();
			
			rc_no = list.size()+1;
			
			Insa_Rc_rcBean infoBean =new Insa_Rc_rcBean(ck_acar_id, rc_no, rc_branch, rc_type, rc_hire_per, rc_apl_ed_dt, rc_pass_dt, rc_apl_mat, rc_manager, rc_tel, rc_edu);
			
		   	res=icd.RcInsert(infoBean);
	
		}else{
			
		
			Insa_Rc_rcBean infoBean =new Insa_Rc_rcBean(ck_acar_id, rc_no, rc_branch, rc_type, rc_hire_per, rc_apl_ed_dt, rc_pass_dt, rc_apl_mat, rc_manager, rc_tel, rc_edu);
			
		   	res=icd.RcUpdate(infoBean);
		   
		}
	}   
	   
	   if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_notice_sc.jsp";
	      close();
	   </script>
	<%
	   }else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_notice_sc.jsp";
		  close();
	   </script>
	<%
	   }
	%>
</body>
</html>
