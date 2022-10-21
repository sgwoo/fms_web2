<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.esti_mng.*" %>
<jsp:useBean id="EstiMngDb" class="acar.esti_mng.EstiMngDatabase" scope="page" />
<jsp:useBean id="EstiRegBn" class="acar.esti_mng.EstiRegBean" scope="page"/>
<jsp:useBean id="EstiListBn" class="acar.esti_mng.EstiListBean" scope="page"/>
<jsp:useBean id="EstiContBn" class="acar.esti_mng.EstiContBean" scope="page"/>
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
	String cmd = request.getParameter("cmd")==null?"i":request.getParameter("cmd");
	
	String est_id = request.getParameter("est_id")==null?"":request.getParameter("est_id");
	String est_st = request.getParameter("est_st")==null?"":request.getParameter("est_st");
	String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
	String sub_st = request.getParameter("sub_st")==null?"":request.getParameter("sub_st");
	
	int count = 0;
	boolean flag = true;
	
	//견적관리번호 생성
	EstiContBn = EstiMngDb.getEstiCont(est_id, seq);
	
	EstiContBn.setReg_dt	(request.getParameter("reg_dt")==null?"":request.getParameter("reg_dt"));
	EstiContBn.setReg_id	(request.getParameter("reg_id")==null?"":request.getParameter("reg_id"));
	EstiContBn.setTitle		(request.getParameter("title")==null?"":request.getParameter("title"));
	EstiContBn.setCont		(request.getParameter("cont")==null?"":request.getParameter("cont"));
	if(sub_st.equals("3")){
		EstiContBn.setEnd_type	(request.getParameter("end_type")==null?"":request.getParameter("end_type"));
		EstiContBn.setNend_st	(request.getParameter("nend_st")==null?"":request.getParameter("nend_st"));
		EstiContBn.setNend_cau  (request.getParameter("nend_cau")==null?"":request.getParameter("nend_cau"));
	}
	
	if(seq.equals("")){//등록
		EstiContBn.setEst_id	(est_id);
		flag = EstiMngDb.insertEstiCont(EstiContBn);
	}else{//수정
		flag = EstiMngDb.updateEstiCont(EstiContBn);
	}
	
	String est_cng = request.getParameter("est_cng")==null?"":request.getParameter("est_cng");
	if(sub_st.equals("2") || sub_st.equals("3") || (sub_st.equals("1") && est_cng.equals("1"))){//보류||마감으로 상태수정 혹은 보류해제
		flag = EstiMngDb.updateEstiReg(est_id, sub_st, user_id);
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

