<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*" %>
<jsp:useBean id="bean" class="acar.estimate_mng.EstimateBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"1":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"1":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String set_code = request.getParameter("set_code")==null?"":request.getParameter("set_code");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String cng_est_id 	= request.getParameter("cng_est_id")	==null?"":request.getParameter("cng_est_id");
	
	int count = 0;
	
	EstiDatabase e_db = EstiDatabase.getInstance();
	
	bean = e_db.getEstimateCase(cng_est_id);
		
	bean.setCtr_s_amt	(request.getParameter("ctr_s_amt")==null?0:AddUtil.parseDigit(request.getParameter("ctr_s_amt")));
	bean.setCtr_v_amt	(request.getParameter("ctr_v_amt")==null?0:AddUtil.parseDigit(request.getParameter("ctr_v_amt")));		
	bean.setAgree_dist	(request.getParameter("ctr_agree_dist")==null?0:AddUtil.parseDigit(request.getParameter("ctr_agree_dist")));
	bean.setRo_13_amt	(request.getParameter("ctr_opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("ctr_opt_amt")));
	
	
	bean.setUpdate_id	(user_id);
		
	//count = e_db.updateEstimate(bean);
	
	
	if(1==1) return;

%>
<html>
<head>

<title>FMS</title>
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="" name="form1" method="POST">
  <input type="hidden" name="auth_rw" value="<%=auth_rw%>">
  <input type="hidden" name="br_id" value="<%=br_id%>">  
  <input type="hidden" name="user_id" value="<%=user_id%>">
  <input type="hidden" name="gubun1" value="<%=gubun1%>">
  <input type="hidden" name="gubun2" value="<%=gubun2%>">
  <input type="hidden" name="gubun3" value="<%=gubun3%>">
  <input type="hidden" name="gubun4" value="<%=gubun4%>">  
  <input type="hidden" name="gubun5" value="<%=gubun5%>">
  <input type="hidden" name="gubun6" value="<%=gubun6%>">  
  <input type="hidden" name="s_dt" value="<%=s_dt%>">
  <input type="hidden" name="e_dt" value="<%=e_dt%>">
  <input type="hidden" name="s_kd" value="<%=s_kd%>">          
  <input type="hidden" name="t_wd" value="<%=t_wd%>">     
  <input type="hidden" name="est_id" value="<%=est_id%>">          
  <input type="hidden" name="set_code" value="<%=set_code%>">            
</form>
<script>
<%	if(count==1){%>
		alert("?????????? ??????????????.");
		<%if(!from_page.equals("")){%>
		document.form1.action = "<%=from_page%>";
		<%}else{%>
		document.form1.action = "esti_mng_atype_u.jsp";
		<%}%>		
		document.form1.target='d_content';
		document.form1.submit();
		
		parent.window.close();
	
<%	}else{%>
		alert("????????!");
<%	}%>
</script>
</body>
</html>

