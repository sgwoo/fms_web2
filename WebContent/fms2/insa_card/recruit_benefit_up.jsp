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
	String rc_bene_cont = request.getParameter("rc_bene_cont")==null?"":request.getParameter("rc_bene_cont");
	String rc_bene_st = request.getParameter("rc_bene_st")==null?"":request.getParameter("rc_bene_st");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	 if ( gubun.equals("d")) { //삭제면 
		//	System.out.println("gubun="+ gubun + ":rc_no="+ rc_no);		
		 	res=icd.InsaDelete(rc_no, "insa_rc_benefit");
	 } else {
				
		if(rc_no==0){
			
			List<Insa_Rc_BnBean> list = icd.selectInsaAllBn();
			
			rc_no = list.size()+1;
			
			Insa_Rc_BnBean bnBean =new Insa_Rc_BnBean(ck_acar_id,rc_no,rc_bene_cont,rc_bene_st);
			
			res=icd.bnInsert(bnBean);
			
		}else{
			Insa_Rc_BnBean bnBean=new Insa_Rc_BnBean(rc_no,rc_bene_cont,rc_bene_st);
			
			res=icd.bnUpdate(bnBean); 
		}
	
	}
	
	if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_benefit_sc.jsp";
	      close();
	   </script>
	<%
	   }else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_benefit_sc.jsp";
		  close();
	   </script>
	<%
	   }
	%>
</body>
</html>
