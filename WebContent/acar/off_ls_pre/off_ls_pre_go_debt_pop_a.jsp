<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="ad_db" scope="page" class="acar.debt.AddDebtDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String c_id = request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	
	Hashtable debt = ad_db.getAllotScdListWithParam(c_id);
	String l_cd 	= (String)debt.get("RENT_L_CD");
	String m_id 	= (String)debt.get("RENT_MNG_ID");
%>
	<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
	<script language="javascript">
	function autoProcess(){
		var fm = document.form1;
		fm.action = '/acar/con_debt/debt_reg_u.jsp';
		fm.target = "_self";
		fm.method = 'POST';
		fm.submit();
	}
	</script>
<html>
<head><title>FMS</title>
</head>
<body>
<form name="form1" action="">
<input type="hidden" name="c_id" value="<%=c_id%>">
<input type="hidden" name="l_cd" value="<%=l_cd%>">
<input type="hidden" name="m_id" value="<%=m_id%>">
<input type="hidden" name="from_page" value="/off_ls_pre_go_debt_pop_a.jsp">
</form>
<script type="text/javascript">
$(document).ready(function(){
	autoProcess();
});
</script>
</body>
</html>