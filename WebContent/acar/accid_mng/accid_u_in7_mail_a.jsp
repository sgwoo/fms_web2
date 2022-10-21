<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, tax.*, cust.member.*,acar.user_mng.*"%>
<jsp:useBean id="IssueDb" scope="page" class="tax.IssueDatabase"/>
<%@ include file="/tax/cookies_base.jsp" %>

<%	
	String item_id 	= request.getParameter("item_id")==null?"":request.getParameter("item_id");
	String from_page 	= request.getParameter("from_page")==null?"":request.getParameter("from_page");
	String reg_code = request.getParameter("reg_code")==null?"":request.getParameter("reg_code");

	String con_agnt_nm			= request.getParameter("con_agnt_nm")==null?"":request.getParameter("con_agnt_nm");
	String con_agnt_email		= request.getParameter("con_agnt_email")==null?"":request.getParameter("con_agnt_email");
	String con_agnt_m_tel		= request.getParameter("con_agnt_m_tel")==null?"":request.getParameter("con_agnt_m_tel");

	int flag5 = 0;
	//거래명세서 조회
	TaxItemBean ti_bean 		= IssueDb.getTaxItemCase(item_id);
	//거래명세서 리스트 조회
	Vector tils	            = IssueDb.getTaxItemScdListCase(item_id);
	int til_size            = tils.size();
	
	UserMngDatabase 	umd 	= UserMngDatabase.getInstance();
		//사용자
	UsersBean sender_bean 	= umd.getUsersBean(user_id);
	
	if(!item_id.equals("")){
		
		//프로시저 호출
		
		String  d_flag2 =  IssueDb.call_sp_tax_ebill_itemmail("r", sender_bean.getId(), reg_code, item_id, con_agnt_nm, con_agnt_email, con_agnt_m_tel);
		System.out.println(d_flag2);
		if (!d_flag2.equals("0")) flag5 = 1;
		System.out.println(" 거래명세서 메일 프로시저 재등록"+item_id + ","+ sender_bean.getUser_nm() +","+ con_agnt_nm + "," + con_agnt_email);
	}
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
</head>
<body>
<form action="./issue_3_sc_a.jsp" name="form1" method="POST">
<%@ include file="/include/search_hidden.jsp" %>
  <input type="hidden" name="idx" value="<%=idx%>">
  <input type="hidden" name="item_id" value="<%=item_id%>">  
  <input type="hidden" name="item_size" value="<%=til_size%>">
  <input type="hidden" name="client_id" value="<%=ti_bean.getClient_id()%>">  
  <input type="hidden" name="seq" value="<%=ti_bean.getSeq()%>">    
  <input type="hidden" name="from_page" value="accid_u_in7_mail.jsp">
  <input type="hidden" name="item_hap_num" value="">
<script language="JavaScript">
<!--
	function go_step(){	  
		var fm = document.form1;
		fm.action = 'accid_u_in7_mail.jsp';
		fm.target = 'TaxItem';
		fm.submit();
	}
	<%	if(flag5 > 0){//에러발생%>
		alert("메일 발송중 에러가 발생하였습니다.");
<%	}else{//정상%>
		alert("발송완료");
		go_step();
<%	}%>
//-->
</script>  
<input type="hidden" name="reg_code" value="<%=reg_code%>">
</form>	
<iframe src="about:blank" name="i_no" width="0" height="0" frameborder="0" noresize></iframe>
</body>
</html>