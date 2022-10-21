<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.bill_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	
	out.println("거래명세서 수정"+"<br><br>");
	
	String item_id	 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String item_size	= request.getParameter("item_size")==null?"":request.getParameter("item_size");
	
	int flag = 0;
	int vid_size = 0;
	
	String item_dt			= request.getParameter("item_dt")==null?"":request.getParameter("item_dt");
	String item_man			= request.getParameter("item_man")==null?"":request.getParameter("item_man");
	
	
	if(!item_id.equals("")){
		
//		vid_size = item_seq.length;
		
		//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		
		ti_bean.setItem_dt		(item_dt);
		ti_bean.setItem_man		(item_man);
		
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
		
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
		fm.target = 'DocModify';
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
