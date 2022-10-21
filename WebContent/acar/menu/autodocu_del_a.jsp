<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.bill_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	//자동전표 삭제 처리 페이지
	
	String write_date 	= request.getParameter("write_date")==null?"":request.getParameter("write_date");
	String data_no 		= request.getParameter("data_no")==null?"":request.getParameter("data_no");
	String data_gubun 	= request.getParameter("data_gubun")==null?"":request.getParameter("data_gubun");
	
	String d_write_date = request.getParameter("d_write_date")==null?"":request.getParameter("d_write_date");
	String d_data_no 	= request.getParameter("d_data_no")==null?"":request.getParameter("d_data_no");
	String d_data_gubun = request.getParameter("d_data_gubun")==null?"":request.getParameter("d_data_gubun");
	String d_taxrela 	= request.getParameter("d_taxrela")==null?"":request.getParameter("d_taxrela");
	int flag = 0;
	
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
//	if(!neoe_db.deleteAutodocu(d_write_date, d_data_no, d_data_gubun, d_taxrela)) flag += 1;	//-> neoe_db 변환 -사용안함.
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<script language='javascript'>
<%	if(flag == 0){	%>
		alert('삭제되었습니다.');
		parent.location='autodocu_del.jsp?write_date=<%=write_date%>&data_no=<%=data_no%>&data_gubun=<%=data_gubun%>';		
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n삭제되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>
