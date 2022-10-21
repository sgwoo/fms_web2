<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	out.println("거래명세서 수정"+"<br><br>");
	
	String item_id	 		= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String reg_code			= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	
	int flag = 0;
	int vid_size = 0;
	
	String con_agnt_nm			= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_email		= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel		= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	
	String con_agnt_nm2			= request.getParameter("con_agnt_nm2")==null?"":request.getParameter("con_agnt_nm2");
	String con_agnt_email2	= request.getParameter("con_agnt_email2")==null?"":request.getParameter("con_agnt_email2");
	String con_agnt_m_tel2	= request.getParameter("con_agnt_m_tel2")==null?"":request.getParameter("con_agnt_m_tel2");
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	if(!item_id.equals("")){
		
		//프로시저 호출
		int flag5 = 0;
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
		
		if(!con_agnt_email2.equals("")){
			d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm2, con_agnt_email2, con_agnt_m_tel2);
		}
		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
//		System.out.println(" 거래명세서 메일 프로시저 등록(재발행) "+item_id);
	}
%>

<html>
<head><title></title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){	  
		var fm = document.form1;
		fm.action = 'tax_item_u.jsp';
		fm.target = 'TaxItem';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body onLoad="javascript:init()">
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="item_id" value="<%=item_id%>">  
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag > 0){//에러발생%>
		alert("거래명세서 수정중 에러가 발생하였습니다.");
<%	}else{//정상%>
		go_step();
<%	}%>
//-->
</script>
</body>
</html>
