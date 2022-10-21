<%@ page language="java" contentType="text/html;charset=euc-kr"%>
<%@ page import="java.util.*,acar.util.*"%>
<%@ include file="/agent/cookies.jsp" %>

<%
	String auth_rw 	= request.getParameter("auth_rw")==null?"":request.getParameter("auth_rw");
	String user_id 	= request.getParameter("user_id")==null?"":request.getParameter("user_id");
	String br_id 		= request.getParameter("br_id")==null?"":request.getParameter("br_id");
	
	String s_kd 	= request.getParameter("s_kd")==null? "":request.getParameter("s_kd");
	String t_wd 	= request.getParameter("t_wd")==null? "" :request.getParameter("t_wd");
	String andor 	= request.getParameter("andor")==null?"":request.getParameter("andor");
	String from_page = request.getParameter("from_page")==null?"":request.getParameter("from_page");
%>

<html>
<head>
<title>FMS</title>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr">
<%@ include file="/acar/getNaviCookies.jsp" %>
<link rel=stylesheet type="text/css" href="/include/table_t.css">
<script language='JavaScript' src='/include/common.js'></script>
<script language="JavaScript">
<!--
	function enter() {
		var keyValue = event.keyCode;
		if (keyValue =='13') SearchopenBrWindow();
	}
	//팝업윈도우 열기
	function SearchopenBrWindow() { //v2.0
		fm = document.form1;
		fm.go_target.value = "c_foot";
		if(fm.t_wd.value == ''){ alert("검색단어를 입력하십시오."); fm.t_wd.focus(); return; }
		window.open("about:blank",'search_open','scrollbars=yes,status=no,resizable=yes,width=850,height=600,left=50,top=50');		
		fm.action = "/tax/pop_search/s_cont_client_cng_agent.jsp";		
		fm.target = "search_open";
		fm.submit();		
	}
	function Search(){
		var fm = document.form1;
		fm.action="lc_cng_client_c.jsp";
		fm.target="c_foot";		
		fm.submit();
	}	
//-->
</script> 
<style type="text/css">
<!--
.style1 {color: #666666}
-->
</style>
</head>
<body onLoad="javascript:document.form1.t_wd.focus();">
<form action='lc_cng_client_c.jsp' name="form1" method='post'>
  <input type='hidden' name='auth_rw' 		value='<%=auth_rw%>'>
  <input type='hidden' name='user_id' 		value='<%=user_id%>'>
  <input type='hidden' name='br_id' 		value='<%=br_id%>'>
  <input type='hidden' name='andor'	 		value='<%=andor%>'>
  <input type='hidden' name="from_page" 		value="<%=from_page%>">  
  <input type="hidden" name="go_url" value="/agent/lc_rent/lc_cng_client_c.jsp">      
  <input type="hidden" name="type" value="search">  
  <input type="hidden" name="go_target" value="">            
<table border='0' cellspacing='0' cellpadding='0' width='100%'>
    <tr>
    	<td>
    	    <table width=100% border=0 cellpadding=0 cellspacing=0>
                <tr>
                    <td width=7><img src=/acar/images/center/menu_bar_1.gif width=7 height=33></td>
                    <td class=bar>&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/menu_bar_dot.gif width=4 height=5 align=absmiddle>&nbsp;<span class=style1>Agent > 계약관리 > <span class=style5>계약승계등록</span></span></td>
                    <td width=7><img src=/acar/images/center/menu_bar_2.gif width=7 height=33></td>
                </tr>
            </table>
    	</td>
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr> 
        <td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<img src=/acar/images/center/arrow_search.gif align=absmiddle>&nbsp;
        <select name="s_kd">
          <option value="1" <%if(s_kd.equals("1")){%> selected <%}%>>상호</option>
          <option value="2" <%if(s_kd.equals("2")){%> selected <%}%>>차량번호</option>
        </select>
	    &nbsp;<input type="text" name="t_wd" size="20" value="<%=t_wd%>" class="text" onKeyDown="javasript:enter()" style='IME-MODE: active'>
	    &nbsp;<a href="javascript:SearchopenBrWindow();"><img src=/acar/images/center/button_search.gif border=0 align=absmiddle></a>
        </td>      
    </tr>
    <tr>
        <td class=h></td>
    </tr>
    <tr>
        <td> <b>※ 계약승계 등록전 반드시 승계 받는 고객에 대한 심사를 영업팀장님께 받으시기 바랍니다.</b></td>
    </tr>        
</table>
</form>
</body>
</html>
