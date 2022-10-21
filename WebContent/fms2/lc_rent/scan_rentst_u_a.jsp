<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.cont.*"%>
<jsp:useBean id="LcScanDb" class="acar.cont.LcScanDatabase" scope="page"/>
<jsp:useBean id="LcScanBn" class="acar.cont.LcScanBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String m_id 	= request.getParameter("m_id")==null?"":request.getParameter("m_id");
	String l_cd 	= request.getParameter("l_cd")==null?"":request.getParameter("l_cd");
	int    size	 	= request.getParameter("size")==null?0:AddUtil.parseInt(request.getParameter("size"));
	String fee_size = request.getParameter("fee_size")==null?"":request.getParameter("fee_size");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	
	int result = 0;
	
	String file_rent_st	[] 		= request.getParameterValues("file_rent_st");
	String file_seq	    [] 		= request.getParameterValues("file_seq");
	String file_cont	[] 		= request.getParameterValues("file_cont");
	
	for(int i = 0 ; i < size ; i++){
		
		LcScanBn = LcScanDb.getLcScan(m_id, l_cd, file_seq[i]);
		
		LcScanBn.setRent_st		(file_rent_st[i]);
		LcScanBn.setFile_cont	(file_cont[i]);
		
		result = LcScanDb.updateLcScanEtc(LcScanBn);
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<script language='javascript'>
<%	if(result > 0){	%>
		alert('해당 파일이 수정되었습니다.');
		parent.opener.location='scan_view.jsp?m_id=<%=m_id%>&l_cd=<%=l_cd%>';		
		parent.window.close();
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n수정되지 않았습니다');		
<%	}	%>
</script>
<body>
</body>
</html>
