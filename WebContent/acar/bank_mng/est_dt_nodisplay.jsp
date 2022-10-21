<%@ page language="java" import="java.util.*, acar.common.*" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	int cont_term = request.getParameter("cont_term").equals("")?0:Integer.parseInt(request.getParameter("cont_term"));
	String est_dt = request.getParameter("fst_pay_dt");
	String rtn_est_dt	= request.getParameter("rtn_est_dt");
	CommonDataBase c_db = CommonDataBase.getInstance();
%>
<script language='javascript'>
<%	for(int i = 0 ; i < cont_term ; i++){
		String set_dt = c_db.addMonth(est_dt, i);
		// if(!rtn_est_dt.equals("31") && !rtn_est_dt.equals("富老") && !set_dt.substring(8,10).equals("28")){
		if(!rtn_est_dt.equals("31") && !rtn_est_dt.equals("富老") && !est_dt.substring(8, 10).equals("31")){
			set_dt=set_dt.substring(0,8)+est_dt.substring(8,10);
		}
%>
		parent.i_in.form1.alt_est_dt[<%=i%>].value = '<%=set_dt%>';
<%	}%>
</script>
</body>
</html>
