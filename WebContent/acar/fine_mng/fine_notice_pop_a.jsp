<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.* "%>
<%@ include file="/acar/cookies.jsp" %>
<%

	String col_1_nm		= 	request.getParameter("col_1_nm")		==null?"":request.getParameter("col_1_nm");
	String col_1_val 		= 	request.getParameter("col_1_val")		==null?"":request.getParameter("col_1_val");
	String col_2_nm 		= 	request.getParameter("col_2_nm")		==null?"":request.getParameter("col_2_nm");
	String col_2_val 		=	request.getParameter("col_2_val")		==null?"":request.getParameter("col_2_val");
	String col_3_nm 		= 	request.getParameter("col_3_nm")		==null?"":request.getParameter("col_3_nm");
	String col_3_val 		= 	request.getParameter("col_3_val")		==null?"":request.getParameter("col_3_val");
	String col_4_nm 		= 	request.getParameter("col_4_nm")		==null?"":request.getParameter("col_4_nm");
	String col_4_val 		= 	request.getParameter("col_4_val")		==null?"":request.getParameter("col_4_val");
	String etc_nm 			= 	request.getParameter("etc_nm")			==null?"":request.getParameter("etc_nm");
	String etc_content		= 	request.getParameter("etc_content")	==null?"":request.getParameter("etc_content");
	String mode		 		=	request.getParameter("mode")				==null?"":request.getParameter("mode");
	
	CommonDataBase c_db 		= CommonDataBase.getInstance();
	CommonEtcBean ce_bean 	= new CommonEtcBean();
	int flag = 0;
	
	ce_bean.setTable_nm		("fine_notice_ment");
	ce_bean.setCol_1_nm		("gubun");
	ce_bean.setEtc_nm			("FINE_NOTICE_MENT");
	ce_bean.setCol_1_val		(col_1_val);
	ce_bean.setEtc_content	(etc_content);
	ce_bean.setReg_id			(ck_acar_id);
	
	if(mode.equals("I")){
		flag = c_db.insertCommonEtc(ce_bean);
		
	}else if(mode.equals("U")){
		flag = c_db.updateCommonEtc(ce_bean);
		
	}else if(mode.equals("D")){
		flag = c_db.deleteCommonEtc(ce_bean);
		
	}else if(mode.equals("VIEW")){
		ce_bean = c_db.getCommonEtc("fine_notice_ment", "gubun", col_1_val, col_2_nm, col_2_val, col_3_nm, col_3_val, col_4_nm, col_4_nm);
		if(!ce_bean.getEtc_content().equals("")){	flag = 1;		}
	}
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src="https://code.jquery.com/jquery-1.12.4.min.js"></script>
<script type="text/javascript" src='/include/common.js'></script>
<script>
	if(<%=flag%>==1){
		if('<%=mode%>'=='VIEW'){
			var ment = '<%=ce_bean.getEtc_content().replaceAll("\r\n","<br>").replaceAll("\r","<br>").replaceAll("\n","<br>")%>';
			$(opener.document).find("#notice_ment").html(ment); 
			opener.msg_modify();
			window.close();
		}else{
			alert("정상적으로 처리되었습니다.");
			location.href = "fine_notice_pop.jsp";
			parent.opener.location.reload();
		}
	}else{
		alert("처리 중 에러 발생!");
	}
</script>
</head>
<body>
</body>
</html>