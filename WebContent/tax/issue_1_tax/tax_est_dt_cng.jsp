<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	String tax_out_dt = request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	String vid[] 			= request.getParameterValues("ch_l_cd");
	String vid_num		= "";
	String item_id		= "";
	int vid_size 			= 0;
	int flag 					= 0;
	
	vid_size = vid.length;
	
	out.println("선택건수="+vid_size+"<br><br>");
	out.println("tax_out_dt="+tax_out_dt+"<br><br>");


	for(int i=0;i < vid_size;i++){
		vid_num = vid[i];
		
		item_id 		= vid_num;
		
		//거래명세서 조회
		TaxItemBean ti_bean 	= IssueDb.getTaxItemCase(item_id);
		ti_bean.setTax_est_dt(tax_out_dt);
		if(!IssueDb.updateTaxItem(ti_bean)) flag += 1;
		
	}
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		fm.action = 'issue_1_sc.jsp';
		fm.target = 'c_foot';
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
</form>
<a href="javascript:go_step()">2단계로 가기</a>
<script language='javascript'>
<!--	
	go_step();
	self.close();
//-->
</script>
</body>
</html>
