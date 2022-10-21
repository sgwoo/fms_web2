<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.common.*, acar.car_office.* "%>
<jsp:useBean id="ce_bean" class="acar.common.CommonEtcBean" scope="page"/>
<jsp:useBean id="cop_db" scope="page" class="acar.car_office.CarOffPreDatabase"/>
<%@ include file="/acar/cookies.jsp" %>
<%
	String mode 				= request.getParameter("mode")					==null?"":request.getParameter("mode");
	
	boolean flag = false;
	
	CommonDataBase c_db = CommonDataBase.getInstance();
	
	if(mode.equals("jg_code")){
		String jg_codes			= request.getParameter("jg_codes")				==null?"":request.getParameter("jg_codes");
		ce_bean.setEtc_content(jg_codes);
		ce_bean.setReg_id(ck_acar_id);
		ce_bean.setTable_nm("set_msg");
		ce_bean.setCol_1_nm(mode);
		ce_bean.setCol_1_val("사전계약관리메세지수신코드설정");
		int result = c_db.updateCommonEtc(ce_bean);
		if(result==1){		flag = true;		}
	}
	
%> 

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr ">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script type="text/javascript" src='/include/common.js'></script>
</head>
<body>
<script>
if(<%=flag%>){
	alert("정상 처리되었습니다.");
}else{
	alert("에러발생!");
}
opener.location.reload();
self.close();
</script>
</body>
</html>