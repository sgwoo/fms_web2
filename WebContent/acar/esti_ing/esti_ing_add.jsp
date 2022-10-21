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
	String s_year = request.getParameter("s_year")==null?"":request.getParameter("s_year");
	String s_mon = request.getParameter("s_mon")==null?"":request.getParameter("s_mon");
	String s_day = request.getParameter("s_day")==null?"":request.getParameter("s_day");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String mode = request.getParameter("mode")==null?"":request.getParameter("mode");
	
	int count = 0;
	boolean flag = true;
	
	EstiListBean bean = new EstiListBean();
	bean.setEst_id	(est_id);
	bean.setSeq		(request.getParameter("seq")==null?"":AddUtil.addZero(request.getParameter("seq")));
	bean.setA_a		(request.getParameter("a_a")==null?"":request.getParameter("a_a"));
	bean.setA_b		(request.getParameter("a_b")==null?"":request.getParameter("a_b"));
	bean.setFee_amt	(request.getParameter("fee_amt")==null?0:AddUtil.parseDigit(request.getParameter("fee_amt")));
	bean.setPp_amt	(request.getParameter("pp_amt")==null?0:AddUtil.parseDigit(request.getParameter("pp_amt")));
	bean.setRo_13	(request.getParameter("ro_13")==null?"":request.getParameter("ro_13"));
	bean.setGu_yn	(request.getParameter("gu_yn")==null?"":request.getParameter("gu_yn"));
	
	flag = EstiMngDb.insertEstiList(bean);
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
    <input type="hidden" name="s_year" value="<%=s_year%>">
    <input type="hidden" name="s_mon" value="<%=s_mon%>">
    <input type="hidden" name="s_day" value="<%=s_day%>">	
  <input type="hidden" name="est_id" value="<%=est_id%>">          
</form>
<script>
<%	if(flag==true){%>
		alert("정상적으로 처리되었습니다.");
		document.form1.target='d_content';
		document.form1.submit();		
<%	}else{%>
		alert("에러발생!");
<%	}%>
</script>
</body>
</html>

