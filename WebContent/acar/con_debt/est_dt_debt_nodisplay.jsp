<%@ page language="java" import="java.util.*, acar.common.*, acar.util.*" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title></head>
<body>
<%
	int tot_amt_tm	= request.getParameter("t_tot_amt_tm").equals("")?0:Integer.parseInt(request.getParameter("t_tot_amt_tm"));//ȸ��
	int cng_tm		= request.getParameter("cng_tm").equals("")?0:Integer.parseInt(request.getParameter("cng_tm"));//ȸ��
	String est_dt	= request.getParameter("set_dt");//������
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	int cnt = 0;
%>

<script language='javascript'>
<%	for(int i = cng_tm ; i <=tot_amt_tm ; i++){
		String set_dt = c_db.addMonth(est_dt, cnt);//1ȸ��������+1������ ����
%>
	parent.i_in.form1.t_est_dt[<%=i%>].value = '<%=set_dt%>';
<%		cnt++;
	}%>
</script>
</body>
</html>
