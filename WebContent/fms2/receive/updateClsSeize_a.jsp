<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*,  acar.receive.*, acar.doc_settle.*"%>
<jsp:useBean id="re_db" scope="page" class="acar.receive.ReceiveDatabase"/>
<jsp:useBean id="d_db" scope="page" class="acar.doc_settle.DocSettleDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
		
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id	= request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id 	= request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	String rent_mng_id = request.getParameter("rent_mng_id")==null?"":request.getParameter("rent_mng_id");
	String rent_l_cd = request.getParameter("rent_l_cd")==null?"":request.getParameter("rent_l_cd");
	
	String seize_dt	 	= request.getParameter("seize_dt")==null?"":request.getParameter("seize_dt"); //압류일 
	int  seize_amt =      request.getParameter("seize_amt")==null?0:AddUtil.parseDigit(request.getParameter("seize_amt")); //압류비용 
	
	String cmd	 	= request.getParameter("cmd")==null?"":request.getParameter("cmd"); //1:삭제 (초기화), 2:수정
	
	
	int count = 0;
	int flag = 0;
	
	boolean flag1 = true;	
	int result = 0;
		
	if (cmd.equals("1"))  {
		seize_amt =  0;
		seize_dt =  "";
	}
	
	if(!re_db.updateClsSeize(rent_mng_id, rent_l_cd , seize_dt , seize_amt))	flag += 1;	
	
%>
<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css"></link>
<script language="JavaScript">
<!--
//-->
</script>
</head>
<body>
<script>

<%	if(flag != 0){ 	//채권추심테이블에 저장 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//채권추심테이블에 저장 성공.. %>
	
   	 alert('처리되었습니다');		
   	 parent.opener.location.reload();
     parent.window.close();			
<%	
	} %>

</script>
</body>
</html>

