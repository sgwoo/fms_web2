<%@ page language="java" import="java.util.*, acar.common.*, acar.util.*" contentType="text/html;charset=euc-kr"%>
<%@ include file="/acar/cookies.jsp" %>
<html>
<head><title>FMS</title></head>
<body>
<%
	int cont_term	= request.getParameter("cont_term").equals("")?0:Integer.parseInt(request.getParameter("cont_term"));//회차
	int cng_tm		= request.getParameter("cng_tm").equals("")?0:Integer.parseInt(request.getParameter("cng_tm"));//회차
	String est_dt	= request.getParameter("set_dt");//약정일
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	int cnt = 0;
	
%>

<script language='javascript'>
<%	for(int i = cng_tm ; i <=cont_term ; i++){
		String set_dt = c_db.addMonth(est_dt, cnt);//1회차납입일+1개월씩 증가
%>
	parent.i_in.form1.alt_est_dt[<%=i%>].value = '<%=set_dt%>';
<%		cnt++;
	}%>
</script>
</body>
</html>
