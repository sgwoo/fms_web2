<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, card.*, acar.bill_mng.*"%>
<%@ include file="/tax/cookies_base.jsp" %>

<%
	NeoErpUDatabase neoe_db = NeoErpUDatabase.getInstance();
	
	String cardno 		= request.getParameter("cardno")==null?"":request.getParameter("cardno");
	String acct_code 	= request.getParameter("acct_code")==null?"":request.getParameter("acct_code");
	String acct_code_g 	= request.getParameter("acct_code_g")==null?"":request.getParameter("acct_code_g");
	String ven_st 		= request.getParameter("ven_st")==null?"1":request.getParameter("ven_st");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");	
	String buy_id = "";
	int flag = 0;
	
	//네오엠 거래처 처리-------------------------------
	
	TradeBean t_bean = new TradeBean();
	
	t_bean.setCust_code	(request.getParameter("cust_code")==null?"":request.getParameter("cust_code"));
	t_bean.setCust_name	(request.getParameter("cust_name")==null?"":request.getParameter("cust_name"));
	t_bean.setS_idno	(request.getParameter("s_idno")==null?"":request.getParameter("s_idno"));
	t_bean.setDname		(request.getParameter("dname")==null?"":request.getParameter("dname"));
	t_bean.setMail_no	(request.getParameter("t_zip")==null?"":request.getParameter("t_zip"));
	t_bean.setS_address	(request.getParameter("t_addr")==null?"":request.getParameter("t_addr"));
	t_bean.setMd_gubun	(request.getParameter("md_gubun")==null?"Y":request.getParameter("md_gubun"));
	t_bean.setDc_rmk	(request.getParameter("dc_rmk")==null?"":request.getParameter("dc_rmk"));
	t_bean.setUser_id	(user_id);
	
	
	if(AddUtil.lengthb(t_bean.getCust_name()) > 30){
		t_bean.setCust_name	(AddUtil.substringb(t_bean.getCust_name(),30));
		t_bean.setDname		(t_bean.getCust_name());
	}
	
	if(!neoe_db.updateTrade(t_bean)) flag += 1;  //-> neoe_db 변환
	
	
	//거래처이력관리
	t_bean.setVen_st	(ven_st);

	if(!neoe_db.insertTradeHis(t_bean)) flag += 1;  //-> neoe_db 변환없이 그대로 씀
	
	out.println("flag="+flag+"<br><br>");
%>

<html>
<head><title>FMS</title>
<script language='JavaScript' src='/include/common.js'></script>
<script language='javascript'>
<!--
	function go_step(){
		parent.opener.form1.ven_code.value = '<%=t_bean.getCust_code()%>';
		parent.opener.form1.ven_name.value = '<%=t_bean.getCust_name()%>';
		parent.opener.form1.ven_nm_cd.value = '<%=t_bean.getS_idno()%>';		
		
	    parent.opener.form1.ven_st[0].checked = false;
	    parent.opener.form1.ven_st[1].checked = false;
	    parent.opener.form1.ven_st[2].checked = false;
	    parent.opener.form1.ven_st[3].checked = false;
		
		if ('<%=ven_st%>' == '1') {		
		    parent.opener.form1.ven_st[0].checked = true;
		}else if ('<%=ven_st%>' == '2') {		
		    parent.opener.form1.ven_st[1].checked = true;
		}else if ('<%=ven_st%>' == '3') {		
		    parent.opener.form1.ven_st[2].checked = true;
		}else if ('<%=ven_st%>' == '4') {		
		    parent.opener.form1.ven_st[3].checked = true;
		}else{
		    parent.opener.form1.ven_st[0].checked = true;		
		}
				
		var ven_name = '<%=t_bean.getCust_name()%>';
		if(ven_name.indexOf('우체국') != -1 || ven_name.indexOf('시설관리공단') != -1) parent.opener.form1.ven_st[3].checked = true;
		
		parent.window.close();		
	}
	
	function go_step2(){
		var fm = document.form1;
		fm.target = "_parent";		
		fm.action = "vendor_list2.jsp";
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
<input type='hidden' name='cardno' 	value='<%=cardno%>'>
<input type='hidden' name='from_page' value='<%=from_page%>'>
</form>
<a href="javascript:go_step()">다음으로</a>
<script language='javascript'>
<!--
<%		if(flag > 0){//에러발생%>
		alert("에러가 발생하였습니다.");
<%		}else{//정상%>
			alert("등록되었습니다.");
<%			if(from_page.equals("/fms2/pay_mng/off_list.jsp")){%>
				parent.opener.location.reload();
				parent.window.close();
<%			}else if(from_page.equals("/fms2/pay_mng/pay_excel_reg.jsp")){%>
				go_step2();
<%			}else{%>		
				go_step();
<%			}%>
<%		}%>
//-->
</script>
</body>
</html>
