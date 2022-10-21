<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.bank_mng.*, acar.util.*"%>
<jsp:useBean id="abl_db" scope="page" class="acar.bank_mng.AddBankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String s_kd 	= request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null?"":request.getParameter("t_wd");
	String gubun = request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cont_bn = request.getParameter("cont_bn")==null?"":request.getParameter("cont_bn");
	String lend_int = request.getParameter("lend_int")==null?"":request.getParameter("lend_int");
	String max_cltr_rat = request.getParameter("max_cltr_rat")==null?"":request.getParameter("max_cltr_rat");

	String m_id = request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd = request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	String car_id = request.getParameter("car_id")==null?"":request.getParameter("car_id");
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String pay_dt = request.getParameter("h_pay_dt")==null?"":request.getParameter("h_pay_dt");
	
	//car_bank update, car_pur update
	boolean flag = abl_db.updateBankMapping_pay(gubun, m_id, l_cd, car_id, lend_id, pay_dt);
	
%>
<form action="bank_mapping_frame_s.jsp" name="form1" method="POST" targer="MAPPING">
<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>
<input type='hidden' name='gubun' value='<%=gubun%>'>
<input type='hidden' name='lend_id' value='<%=lend_id%>'>
<input type='hidden' name='cont_bn' value='<%=cont_bn%>'>
<input type='hidden' name='lend_int' value='<%=lend_int%>'>
<input type='hidden' name='max_cltr_rat' value='<%=max_cltr_rat%>'>
</form>
<script language='javascript'>
<!--
<%	if(!flag){%>
		alert('에러입니다.\n\n은행대출이 수정되지 않았습니다');
		location='about:blank';
<%	}else{%>		
		alert('수정되었습니다');
		document.form1.submit();
<%	}%>
-->
</script>
</body>
</html>
