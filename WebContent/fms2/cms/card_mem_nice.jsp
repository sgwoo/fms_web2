<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*"%>
<jsp:useBean id="rs_db" scope="page" class="acar.res_search.ResSearchDatabase"/>

<%@ include file="/tax/cookies_base.jsp" %>
<%@ include file="/acar/access_log.jsp" %>

<%
	
	if(auth_rw.equals(""))	auth_rw = rs_db.getAuthRw(user_id, "04", "09", "04");
		
	sh_height = sh_line_height*3;
	
	String mode = request.getParameter("mode")==null?"1":request.getParameter("mode");
%>
<html>
<body>
<script language="JavaScript">

	location.href="https://fms.amazoncar.co.kr/card_cms/card_mem.jsp";

</script>
</body>
</html>
