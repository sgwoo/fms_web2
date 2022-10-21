<%@ page language="java" contentType="text/html;charset=euc-kr" %>
<%@ page import="java.util.*, acar.util.*, acar.estimate_mng.*"%>
<%@ include file="/acar/cookies.jsp" %>

<%
	String auth_rw = request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id = request.getParameter("user_id")==null?"":request.getParameter("user_id");//로그인-ID
	String br_id = request.getParameter("br_id")==null?"":request.getParameter("br_id");//로그인-영업소
	
	
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
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=800,height=500,left=50,top=50');		
		fm.action = "/tax/pop_search/s_client.jsp";
		fm.target = "search_open";
		fm.submit();		
	}			
//-->
</script>

</head>
<body onload="javascript:document.form1.t_wd.focus()">
<form action="" name="form1" method="POST">
  <input type='hidden' name='auth_rw' value='<%=auth_rw%>'>
  <input type='hidden' name='br_id' value='<%=br_id%>'>
  <input type='hidden' name='user_id' value='<%=user_id%>'>    
<input type="hidden" name="type" value="search">  
<input type="hidden" name="go_url" value="/acar/settle_doc_reg/settle_doc_reg_sc.jsp">      
<table border=0 cellspacing=0 cellpadding=0 width=100%>
	<tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>채권관리 > <span class=style5>최고장등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
      <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_gsjg.gif align=absmiddle>&nbsp;
        <select name="s_kd">
          <option value='1'>상호</option>
          <option value='2'>차량번호</option>
      </select>
	  &nbsp;<input type="text" name="t_wd" size="20" value="" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>
	  &nbsp;<a href="javascript:SearchopenBrWindow();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>  
      </td>
    </tr>
  </table>
</form>
</body>
</html>
