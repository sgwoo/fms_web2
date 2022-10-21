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
	String rc_edu = request.getParameter("rc_edu")==null?"":request.getParameter("rc_edu");
	
	String rc_qf_var1 = request.getParameter("rc_qf_var1")==null?"":request.getParameter("rc_qf_var1");
	String rc_qf_var2 = request.getParameter("rc_qf_var2")==null?"":request.getParameter("rc_qf_var2");
	String rc_qf_var3 = request.getParameter("rc_qf_var3")==null?"":request.getParameter("rc_qf_var3");
	String rc_qf_var4 = request.getParameter("rc_qf_var4")==null?"":request.getParameter("rc_qf_var4");
	String rc_qf_var5 = request.getParameter("rc_qf_var5")==null?"":request.getParameter("rc_qf_var5");
	String rc_qf_var6 = request.getParameter("rc_qf_var6")==null?"":request.getParameter("rc_qf_var6");
	String rc_qf_var7 = request.getParameter("rc_qf_var7")==null?"":request.getParameter("rc_qf_var7");
	String rc_qf_var8 = request.getParameter("rc_qf_var8")==null?"":request.getParameter("rc_qf_var8");
	String rc_qf_var9 = request.getParameter("rc_qf_var9")==null?"":request.getParameter("rc_qf_var9");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	
	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	if ( gubun.equals("d")) { //삭제면 
		//	System.out.println("gubun="+ gubun + ":rc_no="+ rc_no);
		
		 	res=icd.InsaDelete(rc_no, "INSA_RC_QF");
	} else {
		if(rc_no==0){
			
			List<Insa_Rc_QfBean> list=icd.selectInsaAllQf();
			
			rc_no = list.size()+1;
		
			Insa_Rc_QfBean infoBean =new Insa_Rc_QfBean(ck_acar_id,rc_no,rc_edu,rc_qf_var1,rc_qf_var2,rc_qf_var3,rc_qf_var4,rc_qf_var5,rc_qf_var6,rc_qf_var7,rc_qf_var8,rc_qf_var9);
			
		   	res=icd.QfInsert(infoBean);
	
		}else{
			
		
			Insa_Rc_QfBean infoBean =new Insa_Rc_QfBean(rc_no,rc_edu,rc_qf_var1,rc_qf_var2,rc_qf_var3,rc_qf_var4,rc_qf_var5,rc_qf_var6,rc_qf_var7,rc_qf_var8,rc_qf_var9);
			
		   	res=icd.QfUpdate(infoBean);		   
		}
	}   
	   
	   if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_qualification_sc.jsp"
	      close();
	   </script>
	<%
	   }else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_qualification_sc.jsp"
		  close();
	   </script>
	<%
	   }
	%>
</body>
</html>
