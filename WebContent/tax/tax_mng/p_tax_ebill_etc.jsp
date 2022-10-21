<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, acar.fee.*, acar.forfeit_mng.*, acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
	MaMenuDatabase nm_db = MaMenuDatabase.getInstance();	

	out.println("세금계산서 발행하기 3단계"+"<br><br>");
	
	String reg_st 		= request.getParameter("reg_st")==null?"":request.getParameter("reg_st");//all-전체발행,select선택발행
	String reg_gu 		= request.getParameter("reg_gu")==null?"":request.getParameter("reg_gu");//1-일괄발행,2-통합발행,3-개별발행
	String reg_code 	= request.getParameter("reg_code")==null?"":request.getParameter("reg_code");
	String ebill_yn 	= request.getParameter("ebill_yn")==null?"N":request.getParameter("ebill_yn");//트러스빌사용여부
	String tax_out_dt2 	= request.getParameter("tax_out_dt2")==null?"":request.getParameter("tax_out_dt2");
	
	String go_url 		= request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	String tax_no	 		= request.getParameter("tax_no")==null?"":request.getParameter("tax_no");
	String tax_bigo 		= request.getParameter("tax_bigo")==null?"":request.getParameter("tax_bigo");
	String con_agnt_nm 		= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_dept 	= request.getParameter("con_agnt_dept")==null?"":request.getParameter("con_agnt_dept");
	String con_agnt_title 	= request.getParameter("con_agnt_title")==null?"":request.getParameter("con_agnt_title");
	String con_agnt_email 	= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel 	= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");
	
	String target_id = nm_db.getWorkAuthUser("세금계산서담당자"); 
	
	//사용자
	UsersBean sender_bean 	= umd.getUsersBean(target_id);
	
		
	out.println("reg_st  ="+reg_st+"<br>");
	out.println("reg_gu  ="+reg_gu+"<br>");
	out.println("reg_code="+reg_code+"<br><br>");
	out.println("sender_bean="+sender_bean.getUser_nm()+"<br><br>");
	
	int flag = 0;
	
	//기타 전자세금계산서 처리는 보통 거래처코드 문제이므로 처리전 초기화 하고 보낸다.
	//세금계산서 조회
	tax.TaxBean t_bean 		= IssueDb.getTax(tax_no);
	t_bean.setVen_code("");
	if(!IssueDb.updateTax(t_bean)) flag += 1;
	
	//프로시저 호출
	int flag4 = 0;
	String  d_flag1 =  IssueDb.call_sp_tax_ebill_etc(sender_bean.getSa_code(), reg_code);
	System.out.println(" 세금계산서 프로시저 등록=" + d_flag1);
	if (!d_flag1.equals("0")) flag4 = 1;
	System.out.println(" 세금계산서 프로시저 [기타] 등록 "+sender_bean.getSa_code());
	System.out.println(" 세금계산서 프로시저 [기타] 등록 "+reg_code);
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		var fm = document.form1;
		
		if(fm.action == '')				fm.action = '/tax/tax_mng/tax_mng_c.jsp';
		
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
<input type='hidden' name='tax_no' 		value='<%=tax_no%>'>

<a href="javascript:go_step()">4단계로 가기</a>
<script language='javascript'>
<!--
<%	if(flag4 > 0){//에러발생%>
		alert("세금계산서 작성중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("정상발급!!");
//		go_step();
<%	}%>
//-->
</script>
</form>
</body>
</html>
