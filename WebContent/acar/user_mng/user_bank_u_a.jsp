<%@ page language="java" contentType="text/html; charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.user_mng.*, acar.bill_mng.*" %>
<jsp:useBean id="user_bean" class="acar.user_mng.UsersBean" scope="page"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	//사용자별 정보 등록/수정 처리 페이지
	
	String user_id 		= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String ven_code 	= request.getParameter("ven_code")==null?"":request.getParameter("ven_code");
	String auto_vendor 	= request.getParameter("auto_vendor")==null?"N":request.getParameter("auto_vendor");
	
	
	int count = 0;
	int flag2 = 0;
	
	
	UserMngDatabase umd = UserMngDatabase.getInstance();
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	
	user_bean 	= umd.getUsersBean(user_id);
	
	user_bean.setBank_nm		(request.getParameter("bank_nm")==null?"":request.getParameter("bank_nm"));
	user_bean.setBank_no		(request.getParameter("bank_no")==null?"":request.getParameter("bank_no"));
	user_bean.setSa_code		(request.getParameter("sa_code")==null?"":request.getParameter("sa_code"));
	
	
	//네오엠거래처로 등록
	if(!user_bean.getVen_code().equals("") && !user_bean.getVen_code().equals(ven_code)){
		user_bean.setVen_code	(ven_code);
	}
	
	//네오엠거래처로 등록
	if(user_bean.getVen_code().equals("") && ven_code.equals("") && auto_vendor.equals("Y")){
		
		String ven_code2 ="";
		
		ven_code2 = neoe_db.getVenCodeChk("2", user_bean.getUser_nm(), user_bean.getUser_ssn(), "");
		
		if(ven_code2.equals("")){
			
			
			TradeBean t_bean = new TradeBean();
			
			t_bean.setCust_name		(user_bean.getUser_nm());
			t_bean.setS_idno		("8888888888");
			t_bean.setId_no			(user_bean.getUser_ssn());
			t_bean.setDname			(user_bean.getUser_nm());
			t_bean.setMail_no		(user_bean.getZip());
			t_bean.setS_address		(user_bean.getAddr());
			t_bean.setUptae			("");
			t_bean.setJong			("");
			
			if(!neoe_db.insertTrade(t_bean)) flag2 += 1;	//-> neoe_db 변환
			
			ven_code2 = neoe_db.getVenCodeChk("2", user_bean.getUser_nm(), user_bean.getUser_ssn(), "");
			
			user_bean.setVen_code	(ven_code2);
			
		}else{	
			user_bean.setVen_code	(ven_code2);
		}
	}
	
	
	//네오엠거래처로 등록
	if(user_bean.getVen_code().equals("") && !ven_code.equals("") && auto_vendor.equals("N")){
		user_bean.setVen_code	(ven_code);
	}
	
	
	count = umd.updateUserBank(user_bean);
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
<%	if(count==1){%>
	alert("정상적으로 수정되었습니다.");
	parent.location.reload();
<%	}else{%>
	alert("에러발행!");
<%	}%>

</script>
</body>
</html>