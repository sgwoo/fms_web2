<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	
	out.println("세금계산서 발행하기 3단계"+"<br><br>");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String tax_code 	= request.getParameter("tax_code")==null?"":request.getParameter("tax_code");
	String tax_out_dt 	= request.getParameter("tax_out_dt")==null?"":request.getParameter("tax_out_dt");
	
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	out.println("reg_st  ="+reg_st+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");
	out.println("reg_code="+reg_code+"<br><br>");
	out.println("tax_code="+tax_code+"<br><br>");
	
	int flag = 0;
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	//프로시저 호출
	int flag5 = 0;
	String  d_flag2 =  IssueDb.call_sp_tax_ebill_taxmail("o", sender_bean.getUser_nm(), tax_code, "");
	System.out.println(d_flag2);
	if (!d_flag2.equals("0")) flag5 = 1;
	System.out.println(" 세금계산서 프로시저 등록[2] "+tax_code);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		if(fm.reg_gu.value == '1')			fm.action = '/tax/issue_1_tax/issue_1_frame.jsp';		
		else if(fm.reg_gu.value == '2')		fm.action = '/tax/issue_1_item/issue_1_frame.jsp';				
		else 								fm.action = '/tax/issue_1_tax/issue_1_frame.jsp';		
		
		fm.target = 'd_content';
		fm.submit();
	}
//-->
</script>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel=stylesheet type="text/css" href="../../include/table.css">
</head>
<body>
<form name='form1' action='' method='post'>
<%@ include file="/include/search_hidden.jsp" %>
<input type='hidden' name='reg_st' 		value='<%=reg_st%>'>
<input type='hidden' name='reg_gu' 		value='<%=reg_gu%>'>
<input type='hidden' name='reg_code' 	value='<%=reg_code%>'>
<input type='hidden' name='tax_code' 	value='<%=tax_code%>'>
<input type='hidden' name='tax_out_dt'  value='<%=tax_out_dt%>'>
<a href="javascript:go_step()">4단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag4 > 0){//에러발생%>
		alert("세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("정상발급!!");
		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
