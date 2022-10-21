<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*"%>
<%@ page import="acar.bank_mng.*"%>
<%@ page import="acar.util.*"%>
<jsp:useBean id="bl_db" scope="session" class="acar.bank_mng.BankLendDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html>
<head><title>FMS</title>
</head>
<body>
<%
	boolean flag = true;
	String lend_id = request.getParameter("lend_id")==null?"":request.getParameter("lend_id");
	String submit_gubun = request.getParameter("submit_gubun")==null?"":request.getParameter("submit_gubun");
	String page_gubun = request.getParameter("page_gubun")==null?"":request.getParameter("page_gubun");
	
	if(submit_gubun.equals("R"))	//등록
	{
		BankAgntBean ba = new BankAgntBean();
		ba.setLend_id(lend_id);
		ba.setBa_nm(request.getParameter("ba_nm")==null?"":request.getParameter("ba_nm"));
		ba.setBa_title(request.getParameter("ba_title")==null?"":request.getParameter("ba_title"));
		ba.setBa_tel(request.getParameter("ba_tel")==null?"":request.getParameter("ba_tel"));
		ba.setBa_email(request.getParameter("ba_email")==null?"":request.getParameter("ba_email"));
		flag = bl_db.insertBankAgnt(ba);
	}
	else	//수정
	{
		String seq = request.getParameter("seq")==null?"":request.getParameter("seq");
		BankAgntBean ba = bl_db.getBankAgnt(lend_id, seq);
		ba.setBa_nm(request.getParameter("ba_nm")==null?"":request.getParameter("ba_nm"));
		ba.setBa_title(request.getParameter("ba_title")==null?"":request.getParameter("ba_title"));
		ba.setBa_tel(request.getParameter("ba_tel")==null?"":request.getParameter("ba_tel"));
		ba.setBa_email(request.getParameter("ba_email")==null?"":request.getParameter("ba_email"));
		flag = bl_db.updateBankAgnt(ba);
	}
%>
<script language='javascript'>
<!--
<%
	if(flag)
	{
%>		alert('처리되었습니다');
		parent.location='/acar/bank_mng/bank_agnt_i.jsp?lend_id=<%=lend_id%>&page_gubun=<%=page_gubun%>';
<%
	}
	else
	{
%>		alert('오류발생');
<%
	}
%>
-->
</script>
</body>
</html>
