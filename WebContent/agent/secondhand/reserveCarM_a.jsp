<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.secondhand.*, acar.res_search.*" %>
<%@ page import="acar.user_mng.*, acar.car_sche.*, acar.car_register.*"%>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String car_mng_id 	= request.getParameter("car_mng_id")==null?"":request.getParameter("car_mng_id");
	String seq 		= request.getParameter("seq")==null?"":request.getParameter("seq");
	String damdang_id 	= request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 		= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 		= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 		= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String sr_size 		= request.getParameter("sr_size")==null?"":request.getParameter("sr_size");
	String o_situation	= situation;
	
	int result = 0;
		
	shBn.setCar_mng_id	(car_mng_id);
	shBn.setSeq		(seq);
	shBn.setMemo		(memo);
		
	result = shDb.shRes_u_M(shBn);
	

%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
</head>

<body>
<script language="JavaScript">
<!--

<%	if(result >= 1){%>		
		alert("수정되었습니다.");
		parent.opener.location.reload();
		parent.window.close();	
<%	}else{%>
		alert("데이터베이스에 문제가 발생하였습니다.\n 관리자님께 문의하세요 !");
		window.close();				
<%	}%>
//-->
</script>
</body>
</html>
