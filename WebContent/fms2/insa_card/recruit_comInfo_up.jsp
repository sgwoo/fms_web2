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
	String rc_cur_dt = request.getParameter("rc_cur_dt")==null?"":request.getParameter("rc_cur_dt");
	
    int rc_tot_capital	= request.getParameter("rc_tot_capital")==null?0:AddUtil.parseDigit(request.getParameter("rc_tot_capital"));
	int rc_tot_asset	= request.getParameter("rc_tot_asset")	==null?0:AddUtil.parseDigit(request.getParameter("rc_tot_asset"));
	int rc_sales		= request.getParameter("rc_sales")		==null?0:AddUtil.parseDigit(request.getParameter("rc_sales"));
	int rc_per_off		= request.getParameter("rc_per_off")	==null?0:AddUtil.parseDigit(request.getParameter("rc_per_off"));
	int rc_per_off_per	= request.getParameter("rc_per_off_per")==null?0:AddUtil.parseDigit(request.getParameter("rc_per_off_per"));
	int rc_num_com		= request.getParameter("rc_num_com")	==null?0:AddUtil.parseDigit(request.getParameter("rc_num_com"));
	int rc_busi_rank	= request.getParameter("rc_busi_rank")	==null?0:AddUtil.parseDigit(request.getParameter("rc_busi_rank"));

	InsaRcDatabase icd = new InsaRcDatabase();
	
	int res= 0;
	
	if(rc_no==0){
		
		List<Insa_Rc_InfoBean> list=icd.selectInsaAll();
		
		rc_no = list.size()+1;
		
		Insa_Rc_InfoBean infoBean =new Insa_Rc_InfoBean(
				ck_acar_id,
				rc_no,
				rc_cur_dt,
				rc_tot_capital,
				rc_tot_asset,
				rc_sales,
				rc_per_off,
				rc_per_off_per,
				rc_num_com,
				rc_busi_rank);
		
		res=icd.infoInsert(infoBean);
		
	}else{
		
		Insa_Rc_InfoBean infoBean =new Insa_Rc_InfoBean(
				rc_no,
				rc_cur_dt,
				rc_tot_capital,
				rc_tot_asset,
				rc_sales,
				rc_per_off,
				rc_per_off_per,
				rc_num_com,
				rc_busi_rank);
				
		res=icd.infoUpdate(infoBean);
		
	}	
	
	   
	if(res>0){
	%>
	   <script type="text/javascript">
	      alert("성공");
	      opener.window.location = "recruit_comInfo_sc.jsp"
	      close();
	   </script>
	<%
	}else{
	%>
	   <script type="text/javascript">
	      alert("실패");
	      opener.window.location = "recruit_comInfo_sc.jsp"
		  close();
	   </script>
	<%
	}
	%>

</body>
</html>
