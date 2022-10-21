<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.io.*, java.util.*, acar.util.*, acar.off_anc.*"%>

<%
	//스캔관리 등록/삭제 처리 페이지
	
	String seq = "";
	int result = 0;
	
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");

	int prop_id			= request.getParameter("prop_id")==null?0:Util.parseInt(request.getParameter("prop_id"));
	String idx 			= request.getParameter("idx")  ==null?"":request.getParameter("idx");
	String remove_idx 	= request.getParameter("remove_idx")  ==null?"":request.getParameter("remove_idx");
		
	OffPropDatabase p_db = OffPropDatabase.getInstance();	
		
//	System.out.println("prop reg file_name="+file_name);

	String file_name 	= "";
	String re_file_name = "";	
	
	re_file_name = p_db.getProScan(prop_id, remove_idx);
	
	file_name = "";
				
	File drop_file = new File("D:\\Inetpub\\wwwroot\\data\\prop\\"+re_file_name);
			//선택 파일 삭제
	drop_file.delete();		
		
				
	result = p_db.updatePropScan(prop_id, remove_idx, file_name);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<title></title>
</head>
<form name='form1' method='post'>
  <input type="hidden" name="auth_rw" 			value="<%=auth_rw%>">
  <input type="hidden" name="user_id" 			value="<%=user_id%>">
 
  <input type="hidden" name="prop_id" 			value="<%=prop_id%>">
  <input type="hidden" name="idx" 			value="<%=idx%>">
  <input type="hidden" name="remove_idx" 			value="<%=remove_idx%>">
</form>
<script language='javascript'>
<%	if(result > 0){	%>		
		alert('해당 파일이 삭제되었습니다. 확인하시려면 새로고침을 하세요.');
<%	}else{	%>
		alert('데이터베이스 에러입니다.\n\n등록되지 않았습니다');		
<%	}	%>

</script>
<body>
</body>
</html>