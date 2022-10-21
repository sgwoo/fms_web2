<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String gubun1 = request.getParameter("gubun1")==null?"":request.getParameter("gubun1");
	String gubun2 = request.getParameter("gubun2")==null?"":request.getParameter("gubun2");
	String gubun3 = request.getParameter("gubun3")==null?"":request.getParameter("gubun3");
	String gubun4 = request.getParameter("gubun4")==null?"":request.getParameter("gubun4");
	String gubun5 = request.getParameter("gubun5")==null?"":request.getParameter("gubun5");
	String gubun6 = request.getParameter("gubun6")==null?"":request.getParameter("gubun6");
	String s_dt = request.getParameter("s_dt")==null?"":request.getParameter("s_dt");
	String e_dt = request.getParameter("e_dt")==null?"":request.getParameter("e_dt");
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	int count = 0;
	boolean flag = true;
	
	EstiRegBn = EstiMngDb.getEstiReg(est_id);
	
	EstiRegBn.setCar_type	(request.getParameter("car_type")==null?"":request.getParameter("car_type"));
	EstiRegBn.setEst_dt		(request.getParameter("est_dt")==null?"":request.getParameter("est_dt"));
	EstiRegBn.setEst_nm		(request.getParameter("est_nm")==null?"":request.getParameter("est_nm"));
	EstiRegBn.setEst_mgr	(request.getParameter("est_mgr")==null?"":request.getParameter("est_mgr"));
	EstiRegBn.setEst_tel	(request.getParameter("est_tel")==null?"":request.getParameter("est_tel"));
	EstiRegBn.setEst_fax	(request.getParameter("est_fax")==null?"":request.getParameter("est_fax"));
	EstiRegBn.setCar_comp_id(request.getParameter("car_comp_id")==null?"":request.getParameter("car_comp_id"));
	EstiRegBn.setCar_name	(request.getParameter("car_name")==null?"":request.getParameter("car_name"));
	EstiRegBn.setCar_amt	(request.getParameter("car_amt")==null?0:AddUtil.parseDigit(request.getParameter("car_amt")));
	EstiRegBn.setOpt_amt	(request.getParameter("opt_amt")==null?0:AddUtil.parseDigit(request.getParameter("opt_amt")));
	EstiRegBn.setO_1		(request.getParameter("o_1")==null?0:AddUtil.parseDigit(request.getParameter("o_1")));
	EstiRegBn.setCar_no		(request.getParameter("car_no")==null?"":request.getParameter("car_no"));
	EstiRegBn.setCar_mng_id	(request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id"));
	EstiRegBn.setMng_id		(request.getParameter("mng_id")==null?user_id:request.getParameter("mng_id"));
	EstiRegBn.setUpd_id		(user_id);
	EstiRegBn.setEmp_id		(request.getParameter("emp_id")==null?"":request.getParameter("emp_id"));
	
	flag = EstiMngDb.updateEstiReg(EstiRegBn);
	
	String seq[] = request.getParameterValues("seq");
	String a_a[] = request.getParameterValues("a_a");
	String a_b[] = request.getParameterValues("a_b");
	String fee_amt[] = request.getParameterValues("fee_amt");
	String pp_amt[] = request.getParameterValues("pp_amt");
	String ro_13[] = request.getParameterValues("ro_13");
	String gu_yn[] = request.getParameterValues("gu_yn");
	int list_size = request.getParameter("list_size")==null?0:AddUtil.parseDigit(request.getParameter("list_size"));
	
	for(int i=0; i<list_size; i++){
		EstiListBn = EstiMngDb.getEstiList(est_id, seq[i]);
		EstiListBn.setA_a		(a_a[i]);
		EstiListBn.setA_b		(a_b[i]);
		EstiListBn.setFee_amt	(AddUtil.parseDigit(fee_amt[i]));
		EstiListBn.setPp_amt	(AddUtil.parseDigit(pp_amt[i]));
		EstiListBn.setRo_13		(ro_13[i]==null?"":ro_13[i]);
		EstiListBn.setGu_yn		(gu_yn[i]);
		
		flag = EstiMngDb.updateEstiList(EstiListBn);
	}
%>
<html>
<head>

<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<form action="esti_ing_u.jsp" name="form1" method="POST">
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
</form>
<script>
<%	if(flag==true){%>
		alert("정상적으로 처리되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();	
		parent.window.close();	
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

