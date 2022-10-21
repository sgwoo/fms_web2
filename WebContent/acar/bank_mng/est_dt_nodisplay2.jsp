<%@ page language="java" import="java.util.*, acar.common.*" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	int tot_amt_tm		= request.getParameter("t_tot_amt_tm").equals("")?0:Integer.parseInt(request.getParameter("t_tot_amt_tm"));
	String est_dt		= request.getParameter("t_fst_pay_dt");
	String rtn_est_dt	= request.getParameter("rtn_est_dt");

	CommonDataBase c_db = CommonDataBase.getInstance();
%>

<script language='javascript'>
<%	for(int i = 0 ; i < tot_amt_tm ; i++){
		String set_dt = c_db.addMonth(est_dt, i);
		if(!rtn_est_dt.equals("¸»ÀÏ") && !set_dt.substring(8,10).equals("28")){
			set_dt=set_dt.substring(0,8)+est_dt.substring(8,10);
		}
%>
	parent.i_in.form1.t_est_dt[<%=i%>].value = '<%=set_dt%>';
<%	}%>
</script>
</body>
</html>
