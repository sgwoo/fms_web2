<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<jsp:useBean id="FineDocDb" scope="page" class="acar.forfeit_mng.FineDocDatabase"/>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	String go_url = request.getParameter("go_url")==null?"":request.getParameter("go_url");
	
	
%>

<html>
<head>
<%@ include file="/acar/getNaviCookies.jsp" %>
<title>FMS</title>

<meta http-equiv="content-type" content="text/html; charset=euc-kr">
<link rel="stylesheet" type="text/css" href="/include/table_t.css">
<script language="JavaScript" src="/include/common.js"></script>
<script language="JavaScript">
<!--

	//수신처검색하기
	function find_gov_search(){
		var fm = document.form1;	
		window.open("find_gov_search.jsp", "SEARCH_FINE_GOV", "left=100, top=100, width=450, height=550, scrollbars=yes");
	}
	
	
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "/tax/pop_search/s_cont.jsp";
		fm.target = "search_open";
		fm.submit();		
	}
	
		//청구금액대비 입금액이 5만원이상 차이 휴/대차료 검색하기
	function find_accid_search(){
		var fm = document.form1;
		if(fm.gov_nm.value == '') { alert('보험사를 확인하십시오.'); return; }
		window.open("find_myaccid_search.jsp?auth_rw=<%=auth_rw%>&user_id=<%=user_id%>&br_id=<%=br_id%>&gov_id="+fm.gov_id.value+"&t_wd="+fm.gov_nm.value, "SEARCH_FINE", "left=50, top=50, width=850, height=700, scrollbars=no");
	}	
	
				
//-->
</script>

</head>
<body style="height: 33px !important; margin-bottom: 0;">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type="hidden" name="type" value="search">  
<input type="hidden" name="go_url" value="<%=go_url%>">      
  <table border=0 cellspacing=0 cellpadding=0 width=100%>
     <tr>
         <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
         <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>과태료관리 > <span class=style5>과태료등록</span></span></td>
         <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
     </tr>
    
  </table>
</form>
</body>
</html>
