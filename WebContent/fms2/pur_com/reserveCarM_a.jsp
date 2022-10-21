<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.secondhand.*, acar.car_office.*" %>
<jsp:useBean id="shDb"  class="acar.secondhand.SecondhandDatabase" scope="page"/>
<jsp:useBean id="shBn"  class="acar.secondhand.ShResBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	CarOfficeDatabase cod = CarOfficeDatabase.getInstance();

	String auth_rw 		= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String com_con_no = request.getParameter("com_con_no")==null?"":request.getParameter("com_con_no");
	String seq 				= request.getParameter("seq")==null?"":request.getParameter("seq");
	String damdang_id = request.getParameter("damdang_id")==null?"":request.getParameter("damdang_id");
	String situation 	= request.getParameter("situation")==null?"":request.getParameter("situation");
	String memo 			= request.getParameter("memo")==null?"":request.getParameter("memo");	
	String ret_dt 		= request.getParameter("ret_dt")==null?"":AddUtil.ChangeString(request.getParameter("ret_dt"));	
	String reg_dt 		= request.getParameter("reg_dt")==null?"":AddUtil.ChangeString(request.getParameter("reg_dt"));	
	String gubun 			= request.getParameter("gubun")==null?"":request.getParameter("gubun");
	String cust_nm 		= request.getParameter("cust_nm")==null?"":request.getParameter("cust_nm");	
	String cust_tel 	= request.getParameter("cust_tel")==null?"":request.getParameter("cust_tel");	
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String o_situation = situation;
	
	int result = 0;
	
	Hashtable sr_ht = cod.getSucRes(com_con_no, seq);
	
	shBn.setCar_mng_id	(com_con_no);
	shBn.setSeq					(seq);
	shBn.setDamdang_id	(damdang_id);
	shBn.setSituation		(situation);
	shBn.setMemo				(memo);
	shBn.setCust_nm			(cust_nm);
	shBn.setCust_tel		(cust_tel);
	
	result = shDb.sucRes_u(shBn);

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
