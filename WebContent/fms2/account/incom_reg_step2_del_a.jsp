<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*, acar.util.*, acar.incom.*,  acar.user_mng.*"%>
<jsp:useBean id="in_db" scope="page" class="acar.incom.IncomDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<html><head><title>FMS</title>
</head>
<body>
<%

	String user_id 		= request.getParameter("user_id")		==null?ck_acar_id:request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")			==null?"":request.getParameter("br_id");
			
	String bank_code 	= request.getParameter("bank_code2")	==null?"":request.getParameter("bank_code2");
	String deposit_no 	= request.getParameter("deposit_no2")	==null?"":request.getParameter("deposit_no2");		
	String bank_name 	= request.getParameter("bank_name")	==null?"":request.getParameter("bank_name");
	String incom_dt 		= request.getParameter("incom_dt")	==null?"":request.getParameter("incom_dt");
	int    incom_seq 	 	= request.getParameter("incom_seq")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_seq"));
	int    incom_amt 	 	= request.getParameter("incom_amt")	==null?0 :AddUtil.parseDigit(request.getParameter("incom_amt"));
		
   String gubun 	= request.getParameter("gubun")	==null?"":request.getParameter("gubun");
   		
	int flag = 0;	
	
	String from_page 	= "";
		
	from_page = "/fms2/account/incom_r_frame.jsp";	

	//입금원장삭제 - 대기, 가수금 건만 삭제 가능 -계좌입금인 경우 (일단)
	
	if ( gubun.equals("card") ) {
		from_page = "/fms2/account/incom_d_frame.jsp";
		if(!in_db.deleteIncomCard(incom_dt, incom_seq))	flag += 1;
	} else {
		if(!in_db.deleteIncom(incom_dt, incom_seq))	flag += 1;
   }
	//권한
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw"); 
	String s_kd = request.getParameter("s_kd")==null?"":request.getParameter("s_kd");
	String brch_id = request.getParameter("brch_id")==null?"":request.getParameter("brch_id");

	String t_wd = request.getParameter("t_wd")==null?"":request.getParameter("t_wd");

%>
<form name='form1' action='' target='d_content' method="POST">

<input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
<input type='hidden' name='s_kd' value='<%=s_kd%>'>
<input type='hidden' name='brch_id' value='<%=brch_id%>'>
<input type='hidden' name='t_wd' value='<%=t_wd%>'>

</form>

<script language='javascript'>
	var fm = document.form1;

<%	if(flag != 0){ 	//해지테이블에 삭제 실패%>

	alert('등록 오류발생!');

<%	}else{ 			//해지테이블에 삭제 성공.. %>
	
    alert('처리되었습니다');
   	fm.action ='<%=from_page%>';				
    fm.target='d_content';		
    fm.submit();
<%	
	} %>
</script>
</body>
</html>
